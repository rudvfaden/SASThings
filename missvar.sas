/*<pre><b>
/ Program   : missvars.sas
/ Version   : 2.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 11-Nov-2009
/ Purpose   : To create a list of all-missing variables
/ SubMacros : %nvarsc %nvarsn
/ Notes     : It is not possible to implement this as a function-style macro due
/             to the data step boundary so the results will be written out to a
/             global macro variable. What you do with the list created is
/             up to you. You might report them as errors or warnings or you
/             could drop the variables from a dataset as shown in the usage
/             notes below.
/ Usage     : %missvars(dsname);
/             run;
/             data dsname;
/               set dsname(drop=&_miss_);
/             run;
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                Dataset (pos) (must be pure dataset name and have no keep,
/                   drop, where or rename associated with it).
/===============================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description------------------------
/ rrb  13Feb07         "macro called" message added
/ rrb  11Nov09         Name of global macro variables _miss_ and _nonmiss_ now
/                      fixed. All-missing variable name list written to _miss_
/                      and other variables names written to _nonmiss_ (v2.0)
/===============================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/=============================================================================*/

%put MACRO CALLED: missvars v2.0;

%macro missvars(ds);

%local nvarsn nvarsc;
%global _miss_ _nonmiss_;
%let _miss_=;
%let _nonmiss_=;

%let nvarsn=%nvarsn(&ds);
%let nvarsc=%nvarsc(&ds);

data _null_;
  %if &nvarsn GT 0 %then %do;
    array _nmiss {&nvarsn} $ 1 _temporary_ (&nvarsn*'1');
  %end;
  %if &nvarsc GT 0 %then %do;
    array _cmiss {&nvarsc} $ 1 _temporary_ (&nvarsc*'1');
  %end;
  set &ds end=last;
  %if &nvarsn GT 0 %then %do;
    array _num {*} _numeric_;
  %end;
  %if &nvarsc GT 0 %then %do;
    array _char (*) _character_;
  %end;
  length _miss_ _nmiss_ $ 32767;
  retain _miss_ _nmiss_ " ";
  %if &nvarsn GT 0 %then %do;
    do i=1 to &nvarsn;
      if _num(i) NE . then _nmiss(i)='0';
    end;
  %end;
  %if &nvarsc GT 0 %then %do;
    do i=1 to &nvarsc;
      if _char(i) NE ' ' then _cmiss(i)='0';
    end;
  %end;
  if last then do;
    %if &nvarsn GT 0 %then %do;
      do i=1 to &nvarsn;
        if _nmiss(i) EQ '1' then _miss_=trim(_miss_)||" "||vname(_num(i));
        else _nmiss_=trim(_nmiss_)||" "||vname(_num(i));
      end;
    %end;
    %if &nvarsc GT 0 %then %do;
      do i=1 to &nvarsc;
        if _cmiss(i) EQ '1' then _miss_=trim(_miss_)||" "||vname(_char(i));
        else _nmiss_=trim(_nmiss_)||" "||vname(_char(i));
      end;
    %end;
    call symput('_miss_',left(trim(_miss_)));
    call symput('_nonmiss_',left(trim(_nmiss_)));
  end;
run;

%mend;

/*<pre><b>
/ Program   : nvarsc.sas
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 30-Jul-2007
/ Purpose   : Function-style macro to return the number of character variables
/             in a dataset.
/ SubMacros : %varlistc %words
/ Notes     : 
/ Usage     : %let nvarsc=%nvarsc(dsname);
/ 
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                Dataset name
/===============================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description------------------------
/ rrb  13Feb07         "macro called" message added
/ rrb  30Jul07         Header tidy
/===============================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/=============================================================================*/

%put MACRO CALLED: nvarsc v1.0;

%macro nvarsc(ds);
%words(%varlistc(&ds))
%mend;

/*<pre><b>
/ Program   : varlistn.sas
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : 30-Jul-2007
/ Purpose   : Function-style macro to return a list of numeric variables in a
/             dataset.
/ SubMacros : none
/ Notes     : Variable names will be in uppercase.
/ Usage     : %let varlistn=%varlistn(dsname);
/ 
/===============================================================================
/ PARAMETERS:
/-------name------- -------------------------description------------------------
/ ds                (pos) Dataset name
/===============================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description------------------------
/ rrb  13Feb07         "macro called" message added
/ rrb  30Jul07         Header tidy
/===============================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/=============================================================================*/

%put MACRO CALLED: varlistn v1.0;

%macro varlistn(ds);

%local dsid rc nvars i varlist;

%let dsid=%sysfunc(open(&ds,is));
%if &dsid EQ 0 %then %do;
  %put ERROR: (varlistn) Dataset &ds not opened due to the following reason:;
  %put %sysfunc(sysmsg());
%end;
%else %do;
  %let nvars=%sysfunc(attrn(&dsid,nvars));
  %if &nvars LT 1 %then %put ERROR: (varlistn) No variables in dataset &ds;
  %else %do;
    %do i=1 %to &nvars;
      %if "%sysfunc(vartype(&dsid,&i))" EQ "N" %then %do;
        %if %length(&varlist) EQ 0 %then %let varlist=%sysfunc(varname(&dsid,&i));
        %else %let varlist=&varlist %sysfunc(varname(&dsid,&i));
      %end;
    %end;
  %end;
  %let rc=%sysfunc(close(&dsid));
%end;
&varlist
%mend;
