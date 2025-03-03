/* Code to read Sashelp.class table */
data myclass;
    set sashelp.class;
run;

/* Code print Myclass table */
proc print data=myclass;
run;

/* there are 2 steps in sas programs 
   1. Data step:
      - reads data from input source
      - processes it 
      - create a SAS table
      - filter rows
      - compute new  columns
      - join tables
      - perform other data manipulation
   2. Proc step: "procedure step processes"
      - generate reportd and graph
      - manage data
      - perform complex statistical analyses
   steps end run a few proc steps end with a quit statement
*/

/* create new column */
data myclass; 
    set sashelp.class;
    heightcm=height*2.54;
run;

/* print table */
proc print data=myclass;
run;

/* print means of the age and heightcm */
proc means data=myclass;
    var age heightcm;
run;

/* * Access Data *; */

options validvarname=v7; /* Ensures column names follow SAS naming rules */
ods graphics on;         /* Enables graphics for future analysis */


libname pg1 base "/home/u64168505/EPG1V2/data";/* Defines a library (pg1) to manage SAS datasets */

proc import datafile="/home/u64168505/EPG1V2/data/storm.xlsx" 
			dbms=xlsx out=storm_damage replace; /* replace --> Overwrites any existing dataset with the same name */
	sheet="Storm_Damage";   /* Imports data from the "Storm_Damage" sheet in 
	                           storm.xlsx into a SAS dataset (storm_damage) */
run;

/* * Explore Data *; */

title "Explore Basin and Status Codes"; *Sets a title for the output*;
proc freq data=pg1.storm_summary;  *Runs the PROC FREQ procedure, which calculates frequency counts for categorical variables*;
	tables basin type; *helps in understanding the distribution of storm types across different basins*;
run;

title "Summary Statistics for Maximum Wind(MPH) and Minimum Pressure";
proc means data=pg1.storm_summary; *proc means: Computes descriptive statistics (mean, min, max, standard deviation, etc.).*;
	var MaxWindMPH MinPressure;  *means for MaxWindMPH MinPressure *;
run;

title "First 5 Rows from Imported Storm Damage";
proc print data=storm_damage(obs=5); *proc print: Displays data in tabular format 
                                      Displays only the first 5 rows (obs=5) from the storm_damage dataset*;
run;

/***********************************/

data mycars;
	set sashelp.cars;
	*Computes the average miles per gallon (MPG) using the city and highway values*;
	AvgMPG=mean(mpg_city, mpg_highway); *the mean() function ensures missing values are handled correctly*;
run;

title "Cars with Average MPG Over 35";

proc print data=mycars;
	var make model type avgmpg; *Displays only specific columns: make, model, type, and AvgMPG*;
                                *where AvgMPG > 35*;
	where AvgMPG > 35;
run;

title "Average MPG by Car Type";
/*Computes summary statistics:
mean: Average MPG for each car type.
min: Minimum MPG.
max: Maximum MPG.
maxdec=1: Rounds output to 1 decimal place.
*/
proc means data=mycars mean min max maxdec=1;
	var avgmpg; *Specifies AvgMPG as the variable to analyze*;
	class type; *Groups data by type*;
RUN;

TITLE;/*Resets the title to remove any previous headings from the output*/

/**************************************/

