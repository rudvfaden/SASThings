%MACRO CHECKDATA(INPUTDSN);
OPTIONS NONOTES NOSYMBOLGEN NOMPRINT NOMLOGIC;
DATA _NULL_; FILE LOG;
PUT "----------------------------------------";
PUT "RUNNING DATA CHECK ON DATASET &INPUTDSN.";
PUT "----------------------------------------";
RUN;
%LET DATEVARS=;
%IF "&INPUTDSN." = "" %THEN %LET INPUTDSN=_LAST_;
proc contents data=&INPUTDSN. noprint out=datevars ;
proc sort data=datevars; by varnum; run;
data datevars; set datevars;
if _N_=1 then call symput("INPUTDSN",TRIM(LEFT(TRIM(LEFT(LIBNAME))!!"."!!TRIM(LEFT(MEMNAME)))));
data datevars
charvars (keep=name length)
numvars (keep=name);
set datevars;
if type=2 then output charvars; else
if (index(upcase(informat),"DATE") or index(upcase(format),"DATE") or
index(upcase(format),"DAY") or index(upcase(format),"DOW") or
(index(upcase(format),"Y") and index(upcase(format),"M") and index(upcase(format),"D")))
then output datevars; else
if type=1 then output numvars;
RUN;
data dum; dum=1; run;
data dum; set dum numvars; run;
data _null_; set dum nobs=nobs;
call symput('nobs',nobs); stop; run;
%if %eval(&nobs.) > 1 %then %do;
data datevars; set datevars end=last;
LENGTH DATEVARS OLDDATEVARS $200;
RETAIN OLDDATEVARS;
if _N_=1 then datevars=TRIM(LEFT(NAME));
ELSE DATEVARS=TRIM(LEFT(OLDDATEVARS))!!" "!!TRIM(LEFT(NAME));
OLDDATEVARS=DATEVARS;
IF LAST THEN CALL SYMPUT("DATEVARS",DATEVARS);
RUN;
proc delete data=datevars; run;
data _NULL_; set &INPUTDSN. NOBS=NOBS; CALL SYMPUT("NOBS",TRIM(LEFT(NOBS))); STOP; RUN;
%IF "&DATEVARS." NE "" %THEN %DO;
DATA CHECKDSN; SET &INPUTDSN.;
FORMAT &DATEVARS. MMDDYY10.; RUN;
%END;
%ELSE %DO;
DATA CHECKDSN; SET &INPUTDSN.;
%END;

proc means data=CHECKDSN min max mean n nmiss sum noprint; *maxdec=2;
var _numeric_;
output out=M5a (drop=_type_ _freq_ rename=(_stat_=STAT));
proc means data=CHECKDSN noprint maxdec=2;
var _numeric_;
output out=M5b (drop=_type_ _freq_) sum=;
data m5b; set m5b; stat="SUM";
data m5c; set CHECKDSN (keep=_NUMERIC_);
array vars _Numeric_;
do over vars; if ((-1)*vars) > 0 then vars=1; else vars=0; end;
proc means data=m5c noprint maxdec=2;
var _numeric_;
output out=M5c (drop=_type_ _freq_) sum=;
data m5c; set m5c; stat="NUMNEG";
data m5d; set CHECKDSN (keep=_NUMERIC_);
array vars _Numeric_;
do over vars; if vars>0 then vars=1; else vars=0; end;
proc means data=m5d noprint maxdec=2;
var _numeric_;
output out=M5d (drop=_type_ _freq_) sum=;
data m5d; set m5d; stat="NUMPOS";
data m5e; set CHECKDSN (keep=_NUMERIC_);
array vars _Numeric_;
do over vars; if vars=0 then vars=1; else vars=0; end;
proc means data=m5e noprint maxdec=2;
var _numeric_;
output out=M5e (drop=_type_ _freq_) sum=;
data m5e; set m5e; stat="NUMZERO";
data m5f; set CHECKDSN (keep=_NUMERIC_);
array vars _Numeric_;
do over vars; if vars=. then vars=1; else vars=0; end;
proc means data=m5f noprint maxdec=2;
var _numeric_;
output out=M5f (drop=_type_ _freq_) sum=;
data m5f; set m5f; stat="NUMMISS";
data dum; set CHECKDSN (keep=_NUMERIC_);
array vars _Numeric_;
do over vars; if vars LE 0 THEN vars=.; end;
proc means data=dum noprint maxdec=2;
var _numeric_;
output out=M5g (drop=_type_ _freq_) min=;
data m5g; set m5g; stat="MINPOS";
proc means data=dum noprint maxdec=2;
var _numeric_;
output out=M5h (drop=_type_ _freq_) mean=;
data m5g; set m5g; stat="MEANPOS";
%IF "&DATEVARS." NE "" %THEN %DO;
data M5a; Set M5a M5b M5c M5d M5e M5f M5g M5h; IF STAT="STD" THEN DELETE;
format _numeric_ best.;
FORMAT &DATEVARS. MMDDYY10.; RUN;
%END;
%ELSE %DO;
data M5a; Set M5a M5b M5c M5d M5e M5f M5g M5h; IF STAT="STD" THEN DELETE;
format _numeric_ best.;
RUN;
%END;
proc transpose data=M5a out=m5a; var _all_;

data m5a; format COL5 $16.; set m5a; _label_=""; drop _label_; run;
data m5a; set _last_ (firstobs=2 rename=(_NAME_=FIELD
COL1=N COL2=MIN COL3=MAX COL4=MEAN COL5=SUM
COL6=NUMNEG COL7=NUMPOS COL8=NUMZERO COL9=NUMMISS COL10=MINPOS COL11=MEANPOS));
data m5a (drop=charn cnummiss cnumneg cnumpos cnumzero);
set m5a (rename=(N=CHARN
NUMNEG=CNUMNEG
NUMPOS=CNUMPOS
NUMZERO=CNUMZERO
NUMMISS=CNUMMISS
));
IF INDEX(UPCASE("&DATEVARS."),UPCASE(TRIM(LEFT(FIELD)))) THEN DO;
SUM="----------------";
NON_MISS=INPUT(TRIM(LEFT(CHARN)),MMDDYY10.);
NUMNEG=INPUT(TRIM(LEFT(CNUMNEG)),MMDDYY10.);
NUMMISS=INPUT(TRIM(LEFT(CNUMMISS)),MMDDYY10.);
NUMZERO=INPUT(TRIM(LEFT(CNUMZERO)),MMDDYY10.);
NUMPOS=INPUT(TRIM(LEFT(CNUMPOS)),MMDDYY10.);
END;
ELSE DO;
NON_MISS=INPUT(TRIM(LEFT(CHARN)),BEST.);
NUMNEG=INPUT(TRIM(LEFT(CNUMNEG)),BEST.);
NUMMISS=INPUT(TRIM(LEFT(CNUMMISS)),BEST.);
NUMZERO=INPUT(TRIM(LEFT(CNUMZERO)),BEST.);
NUMPOS=INPUT(TRIM(LEFT(CNUMPOS)),BEST.);
ARRAY VARS MIN MINPOS MAX MEAN;
DO OVER VARS;
VARS=PUT(INPUT(TRIM(LEFT(VARS)),BEST.),BEST10.4);
end;
SUM=PUT(INPUT(TRIM(LEFT(SUM)),BEST.),COMMA16.2);
END;
ARRAY VARS2 NON_MISS NUMNEG NUMMISS NUMZERO NUMPOS;
DO OVER VARS2; IF VARS2="0" THEN VARS2="."; END;
label FIELD="Field *Name *"
Min =" Minimum* Value"
MinPos =" Min Pos* Value"
Max =" Maximum* Value"
Mean =" Mean* Value"
MeanPos =" Mean of* Pos Values"
Sum =" Numeric* Sum"
NumMiss="Number*Missing"
NumNeg ="Number*Negative"
NumZero="Number*of Zeroes"
NumPos ="Number*Positive"
Non_Miss="Number*Populated";
RUN;
proc print data=m5a label split="*" noobs uniform;
VAR FIELD MIN MINPOS MEAN MEANPOS MAX SUM NUMMISS NUMNEG NUMZERO NUMPOS NON_MISS;
title3 "ENHANCED SUMMARY OF NUMERIC VARIABLES IN &INPUTDSN. (&NOBS. OBS)";
run; TITLE3;
PROC DELETE DATA=WORK.m5a; RUN;
PROC DELETE DATA=WORK.m5b; RUN;
PROC DELETE DATA=WORK.m5c; RUN;
PROC DELETE DATA=WORK.m5d; RUN;
PROC DELETE DATA=WORK.m5e; RUN;
PROC DELETE DATA=WORK.m5f; RUN;
PROC DELETE DATA=WORK.m5g; RUN;
PROC DELETE DATA=WORK.m5h; RUN;
proc delete data=work.dum; run;
proc delete data=work.numvars; run;

proc delete data=work.checkdsn; run;
%end;
data dum; dum=1; run;
data dum; set dum charvars; run;
data _null_; set dum nobs=nobs;
call symput('nobs',nobs-1); stop; run;
%if %eval(&nobs.) > 0 %then %do;
DATA CHECKDSN; SET &INPUTDSN. (keep=_char_);
%do loop=1 %to &nobs.;
data dum; dum=&loop.; set charvars point=dum;
call symput('charvar',trim(left(name)));
call symput('charlen',trim(left(put(max(length,20),best3.))));
stop; run;
proc freq data=checkdsn order=freq noprint; tables &charvar./missing out=TEMPCHAR; run;
data _null_; set TEMPCHAR end=last;
retain maxlen 0;
if &charvar. ne ' ' then thislen=length(trim(&charvar.)); else thislen=0;
if thislen > maxlen then maxlen = thislen;
if last then call symput('MAXLEN',trim(left(put(maxlen,best3.))));
run;
data TEMPCHAR (drop=NumOthers ocount opercent);
length &charvar. $&charlen.; format &charvar. $char&charlen..;
set TEMPCHAR (rename=(count=ocount percent=opercent)) end=last;
if &charvar.='' then &charvar.='***Missing***';
retain ncount npercent;
if _n_<44 then do; COUNT=ocount; PERCENT=opercent; end;
else do; COUNT+ocount; PERCENT+opercent;
NumOthers+1;
If NumOthers>1 Then &CharVar.=trim(left(Put(NumOthers,Best9.)))!!" other values";
end;
if _n_<43 or last then do;
CCOUNT+COUNT;
CPERCENT+PERCENT;
output;
end;
run;
proc print data=TEMPCHAR noobs uniform label split="*";
var &charvar. COUNT CCOUNT PERCENT CPERCENT;
title3 "FREQUENCY ANALYSIS OF FIELD &charvar. (Max. length: &MaxLen.) IN DATASET &INPUTDSN."; sum count percent; run; TITLE3;
%end;
proc delete data=work.dum; run;
proc delete data=work.charvars; run;
proc delete data=work.TEMPCHAR; run;
proc delete data=work.checkdsn; run;
%end;
OPTIONS _LAST_=&INPUTDSN.;
%LET INPUTDSN=; %LET NOBS=;
OPTIONS NOTES SYMBOLGEN MPRINT MLOGIC;
%MEND CHECKDATA;
