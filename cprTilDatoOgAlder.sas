/*
COMMENT:	[Makroen beregner fødselsdag ud fra CPR-nummer]
PARAMETERS:	[InputDS: Inputdataset
,OutputDS: Outputdataset
,CPRKolonne: Kolonne i InputDS, som indeholder det CPR-nummer der skal beregnes på
,FoedselsdatoKolonne: navnet på den kolonne der skal indeholde fødselsdatoen (Kolonnen er en SASdato med formatet date9.).
]
EXAMPLE: [%BeregnFodselsdatoFraCPR(InputDS=test,OutputDS=test2,CPRKolonne=CPR,FoedselsdatoKolonne=dag);]
VARIABLE:	[Makroen returnerer datasettet &OutputDS., som er lig &InputDS. tilføjet kolonnen &FoedselsdatoKolonne.]
HISTORY:	[

Dato	Hvem	Hvad
----------	----------	---------------------------------------------------------------------------------------------
2012-07-31	SWJ	Initial coding
]
*/
%MACRO UWT_BeregnFodselsdatoFraCPR(InputDS,OutputDS,CPRKolonne,FoedselsdatoKolonne);
data &OutputDS.(drop=POS0102 POS0304 POS0506 POS07 POS10);
set &InputDS.;
length &FoedselsdatoKolonne. 8;
POS0102 = input(substr(&CPRKolonne.,1,2),best8.);
POS0304 = input(substr(&CPRKolonne.,3,2),best8.);
POS0506 = input(substr(&CPRKolonne.,5,2),best8.);
POS07   = input(substr(&CPRKolonne.,7,1),best8.);
POS10   = input(substr(&CPRKolonne.,10,1),best8.);
if POS07    <= 3                                    then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+1900);
else if 0   <= POS0506 and POS0506 <=36 and POS07=4 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+2000);
else if 37  <= POS0506 and POS0506 <=99 and POS07=4 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+1900);
else if 0   <= POS0506 and POS0506 <=57 and POS07=5 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+2000);
else if 58  <= POS0506 and POS0506 <=99 and POS07=5 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+1800);
else if 0   <= POS0506 and POS0506 <=57 and POS07=6 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+2000);
else if 58  <= POS0506 and POS0506 <=99 and POS07=6 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+1800);
else if 0   <= POS0506 and POS0506 <=57 and POS07=7 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+2000);
else if 58  <= POS0506 and POS0506 <=99 and POS07=7 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+1800);
else if 0   <= POS0506 and POS0506 <=57 and POS07=8 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+2000);
else if 58  =  POS0506 and POS0506 <=99 and POS07=8 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+1800);
else if 0   <= POS0506 and POS0506 <=36 and POS07=9 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+2000);
else if 37  <= POS0506 and POS0506 <=99 and POS07=9 then &FoedselsdatoKolonne.=MDY(POS0304,POS0102,POS0506+1900);
format &FoedselsdatoKolonne. date9.;
run;
%MEND UWT_BeregnFodselsdatoFraCPR;


*Debug-/eksempeldataset;
data test;
CPR='0101995214';output;
CPR='0202994852';output;
CPR='0303000123';output;
CPR='0404004741';output;
run;
%UWT_BeregnFodselsdatoFraCPR(InputDS=test,OutputDS=test2,CPRKolonne=CPR,FoedselsdatoKolonne=dag);

%macro age(date,birth);
floor((intck('month',&birth,&date)
- (day(&date) < day(&birth))) / 12)
%mend age;

data test2;
set test2;
age = %age('14aug2012'd, dag);
put age=;
run;