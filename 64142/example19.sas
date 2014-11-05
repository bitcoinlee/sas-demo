%let name=example19;
filename odsout '.';

/*
http://www.census.gov/popest/counties/files/CO-EST2004-ALLDATA.csv 
*/

/* This code was generated by sas' File->Import GUI */
/* This code must be run on a pc - I ran it on my desktop pc, in the
   /u/realliso/public_html/proj/census/jd/ directory... */
PROC IMPORT OUT=pop_data
            DATAFILE="CO-EST2004-ALLDATA.csv"
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2;
     GUESSINGROWS=1000; /* works for csv - see S0233818 */
RUN;

data pop_data; set pop_data;
length state_html $300;
state_html=
 'title='||quote(trim(left(stname))||'0d'x||trim(left(put(census2000pop,comma20.0))))||
 ' href='||quote('#'||trim(left(stname)));
length county_html $300;
county_html=
 'title='||quote(trim(left(ctyname))||'0d'x||trim(left(put(census2000pop,comma20.0))));
run;

proc sql;
create table state_data as
 select * from pop_data
 where sumlev=40;
create table county_data as
 select * from pop_data
 where sumlev=50;
quit; run;


%macro do_state(stname);
ods html anchor="&stname";

/* re-project this state's map, so it will be "straight" */
proc gproject data=maps.counties (where=(fipnamel(state)="&stname")) out=state_map 
 project=robinson nodateline;
 id state county;
run;

title1 ls=1.5 "Year 2000 &stname Census";

proc gmap data=county_data (where=(stname="&stname")) map=state_map all;
format census2000pop comma20.0;
id state county;
 choro census2000pop / levels=5
 coutline=black
 legend=legend1
 html=county_html
 des='' name="&name._&stname";
run;

%mend do_state;


goptions device=png;
goptions cback=white;
goptions noborder;

ODS LISTING CLOSE;
ODS HTML path=odsout body="&name..htm" (title="2000 Census Population") style=sasweb;

goptions gunit=pct htitle=4.75 ftitle="albany amt/bold" htext=2.5 ftext="albany amt";

legend1 position=(right middle) label=(position=top font="albany amt/bold" "Population") 
 shape=bar(.15in,.15in) value=(justify=center) across=1;

pattern1 v=s c=cxEDF8FB;
pattern2 v=s c=cxB3CDE3;
pattern3 v=s c=cx8C96C6;
pattern4 v=s c=cx8856A7;
pattern5 v=s c=cx810F7C;


title1 ls=1.5 "Year 2000 U.S. Census";
proc gmap data=state_data map=maps.us;
format census2000pop comma20.0;
id state;
 choro census2000pop / levels=5
 coutline=black
 legend=legend1
 html=state_html
 des='' name="&name";
run;


/* Loop through, and make a plot for each manufacturer */
proc sql noprint;
create table loopdata as 
select unique stname
from state_data;
quit; run;
data _null_; set loopdata;
   call execute('%do_state('|| stname ||');');
run;

quit;
ODS HTML CLOSE;
ODS LISTING;