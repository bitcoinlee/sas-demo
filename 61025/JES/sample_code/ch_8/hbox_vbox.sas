



ODS HTML PATH="&JES.SG/S_8_3" (URL=NONE) BODY="hbox_vbox.html";
ODS GRAPHICS ON / RESET IMAGENAME="F8_21_";

TITLE "Box Plot of Resistance by Vendor";
PROC SGPLOT DATA=JES.Results;
	HBOX Resistance / CATEGORY=Vendor
	BOXWIDTH = .75
	SPREAD
	DATALABEL=Delay;
RUN;

ODS GRAPHICS ON / RESET IMAGENAME="F8_22_";
PROC SGPLOT DATA=JES.Results;
	HBOX Resistance / CATEGORY=Vendor
	BOXWIDTH = .25
	EXTREME;
RUN;

ODS GRAPHICS OFF;
ODS HTML CLOSE;