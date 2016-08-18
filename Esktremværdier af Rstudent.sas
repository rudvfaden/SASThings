/********************************************************************/
/*																	*/
/* Macro til beregning af ekstremværdier i regression				*/
/*Vidergående statistik summerschool 2011							*/
/*																	*/
/********************************************************************/

%macro tgraense(Rstudent, n, variable, signifikansniveau=0.05);
data a; p1=probt(&Rstudent,&n-1-&variable); /*p1 Tager ikke hensyn til tallet er valgt som det største af 9 tal*/ 
p2=1-( 1 - 2*(1-probt(&Rstudent,&n-1-&variable)) )**&n; /*p2 tager hensyn til tallet er valgt som det største af 9 tal*/ 
tgraense=tinv( 1- ( 1- ( 1 - &signifikansniveau)**(1/&n) )/2, &n-1-&variable); /*tgraense er en kritisk grænse for outliertests for 9 uafhængige tal*/ 
tbonf=tinv( 1- &signifikansniveau/2/&n, &n-1-&variable); /*tbonf er en kritisk grænse for outliertests ud fra Bonferroni uligheden for 9 tal*/ 
run; 
proc print; 
run;
%mend;
%tgraense( 3.83568,343,6);
