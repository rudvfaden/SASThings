         

/* Create macro variables of the library and data set to be modified */

%let lib=WORK;
%let mem=medl;

/* Use SQL dictionary tables to create a list of character variables and a list 
   of numeric variables from the data set and store the result in macro variables
   CLIST (character) and NLIST (numeric).  The count of each type is also captured. 
*/

proc sql noprint;
  select name, put(count(name),5.-L) into :clist separated by ' ' , :charct
  from dictionary.columns
  where libname=upcase("&lib") and memname=upcase("&mem") and type='char';

  select name, put(count(name),5.-L) into :nlist separated by ' ', :numct
  from dictionary.columns
  where libname=upcase("&lib") and memname=upcase("&mem") and type='num';
quit;

%put &nlist;
/* In a DATA _NULL_ create an array for the character variables and an array for the     
   numeric variables.  Create two more arrays, one for character and one for numeric,    
   where the variables will serve as flags.  The values are initially set to 'false'     
   to indicate that they have only missing values.  Any time a non-missing values is     
   found for a variable, the corresponding flag variable is set to 'true'.               
*/

data _null_;
  array char(*) $ &clist;
  array num(*) &nlist;
  array c_allmiss (&charct) $ (&charct*'true');
  array n_allmiss (&numct) $ (&numct*'true');
  set &mem end=done;
  do i=1 to dim(c_allmiss);
    if char(i) ne ' ' then c_allmiss(i)='false';
    end;
  do i=1 to dim(n_allmiss);
    if num(i) ne . then n_allmiss(i)='false';
    end;

  /* Once the entire data set has been processed, loop through the flag arrays and 
	 create a macro variable for any variable that still has a flag set to 'false'.
	 Keep count of how many there are and put that number into a macro variable as well. */
  if done then do;
    cnt=0;
    do i= 1 to dim(c_allmiss);
      if c_allmiss(i) ='true' then do; 
        cnt+1;
        call symput('var'||put(cnt,3.-l),vname(char(i)));
	    end;
      end;
    do i=1 to dim(n_allmiss);
      if n_allmiss(i)='true' then do;
        cnt+1;
        call symput('var'||put(cnt,3.-l),vname(num(i)));
	    end;
      end;
    call symput('cnt',put(cnt,3.-l));
    end;
run;

/* This macro generates the list of variables to be dropped for the DROP statement. */

%macro dropem;
%do i = 1 %to &cnt;
  &&var&i. 
%end;
%mend;

/* Finally, create a new data set similarly named to the original and 
   issue the DROP statement.                                          */

data &lib..&mem._;
  set &lib..&mem.;
  drop %dropem ;
run;

proc print;
run;
%put &cnt;
