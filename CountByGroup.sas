/**Macro til tællning af antal personer i en gruppe*/
%macro countPrGroup(dsnIn, dsn, ByVar, firstVar, countVar);
proc sort data=&dsnIn out=&dsn;
  by &byVar;
run;

data &dsn;
  set &dsn;
  count + 1;
  by &byVar;
  if first.&firstVar then count = 1;
run;

proc sort;
by &byVar descending count;
run;

data &dsn;
  set &dsn;
  by &byVar;
	retain &countVar;
	if first.&firstVar then &countVar=count;
	drop count;
run;
%mend countPrGroup;

