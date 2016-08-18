/*Macro til tællning af antal personer i en gruppe*/
%macro countPrGroup(lib, dsnIn, dsn, ByVar, firstVar, countVar);
proc sort data=&lib..&dsnIn out=&lib..&dsn;
  by &byVar;
run;

data &lib..&dsn;
  set &lib..&dsn;
  count + 1;
  by &byVar;
  if first.&firstVar then count = 1;
run;

proc sort;
by &byVar descending count;
run;

data &lib..&dsn;
  set &lib..&dsn;
  by &byVar;
	retain &countVar;
	if first.&firstVar then &countVar=count;
	drop count;
run;
%mend;