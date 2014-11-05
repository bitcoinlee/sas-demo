* S7_4.sas
*
* Working with SUMMARY line text;

* Changing Summary Line Text;
proc format;
   value $regname
     '1','2','3' = 'No. East'  
     '4'         = 'So. East'
     '5' - '8'   = 'Mid West' 
     '9', '10'   = 'Western';
   run;

title1 'Extending Compute Blocks';
title2 'RBREAK Does not Create Summary Text';

proc report data=rptdata.clinics nowd split='*';
  column region edu ht wt;
  define region  / group width=10 'Region'
                   format=$regname. order=formatted;
  define edu     / analysis mean 'Years of*Education' 
                   format=9.2 ;
  define ht      / analysis mean format=6.2 'Height';
  define wt      / analysis mean format=6.2 'Weight';
  rbreak after   / summarize dol;
  run;