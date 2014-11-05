* S7_5c.sas
*
* Using CALL DEFINE;

proc format;
   value $regname
     '1','2','3' = 'No. East'  
     '4'         = 'So. East'
     '5' - '8'   = 'Mid West' 
     '9', '10'   = 'Western';
   value $gender
     'M'='Male' 
     'F'='Female';
   run;
   
title1 'Extending Compute Blocks';
title2 'Mean Weight';
title3 'DEFINE Statements for Individual Statistics';

proc report data=rptdata.clinics nowd;
   column region sex,wt,(n mean);
   define region / group   format=$regname.;
   define sex    / across  format=$gender6. 'Gender' ;
   define wt     / analysis ' ';
   define n      /              format=3.;
   define mean   /              format=5.1;
   run;