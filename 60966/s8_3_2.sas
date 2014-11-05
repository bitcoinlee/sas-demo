* S8_3_2.sas
*
* Creating shaded report rows;

ods listing close;
ods html style=default
         path="&path\results"
         body='ch8_3_2.html';

title1;
proc report data=sashelp.prdsale(where=(prodtype='OFFICE')) 
            nowd;
   column region country product,actual totalsales;
   define region  / group;
   define country / group;
   define product / across;
   define actual  / analysis sum 
                    format=dollar8. 
                    'Sales';
   define totalsales / computed format=dollar10.
                       'Total Sales';  
   break after region / summarize suppress;
   rbreak after       / summarize;

   compute totalsales;
      totalsales = sum(_c3_, _c4_, _c5_);
      cnt+1;
      if mod(cnt,2) then call define(_row_,
                                     'style',
                                     'style={background=graydd}');
      else call define(_row_,
                       'style',
                       'style={background=graycc}');
   endcomp;

   compute after region;
      call define(_row_,
                  'style',
                  'style={font_weight=bold
                          background=grayff
                          font_face=arial}');
      cnt=0;
   endcomp; 

   compute after;
      call define(_row_,
                  'style',
                  'style={font_weight=bold
                          background=graybb
                          font_face=arial}');
      cnt=0;
   endcomp; 
   run;
ods html close;
