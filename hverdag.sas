/* Beregner danske hverdage/fridage */
/* Eksempel:
   data test;
     do dato = mdy(1,1,year(today()) to today();
        dagtype = fridag(dato);
        output;
     end;
   run;
*/

options cmplib=work.function;

proc fcmp outlib=work.function.funcs;
  function Hverdag(Dato) $15;
    length retur $15;
        aar = year(Dato);
        a = mod(aar,19);
        b = int(aar/100);
        c = mod(aar,100);
        d = int(b/4);
        e = mod(b,4);
        f = int((b+8)/25);
        g = int((b-f+1)/3);
        h = mod((19*a+b-d-g+15),30);
        i = int(c/4);
        k = mod(c,4);
        l = mod((32+2*e+2*i-h-k),7);
        m = int((a+11*h+22*l)/451);
        n = int((h+l-7*m+114)/31);
        p = mod((h+l-7*m+114),31);
        paaske = mdy(n,p+1,aar);
        if Dato               = paaske-3        then retur = "Skærtorsdag";
        else if Dato          = paaske-2        then retur = "Langfredag";
        else if Dato          = paaske+1        then retur = "2.Påskedag";
        else if Dato          = paaske          then retur = "Påskedag";
        else if Dato          = paaske+26       then retur = "Store bededag";
        else if Dato          = paaske+39       then retur = "Kr. himmelfart";
        else if Dato          = paaske+49       then retur = "pinsedag";
        else if Dato          = paaske+50       then retur = "2. pinsedag";
        else if Dato          = mdy(06,05,aar)  then retur = "Grundlovsdag";
        else if Dato          = mdy(12,24,aar)  then retur = "Juleaftensdag";
        else if Dato          = mdy(12,25,aar)  then retur = "Juledag";
        else if Dato          = mdy(12,26,aar)  then retur = "2. juledag";
        else if Dato          = mdy(01,01,aar)  then retur = "Nytårsdag";
        else if weekday(Dato) = 7               then retur = "Lørdag";
        else if weekday(Dato) = 1               then retur = "Søndag";
        else retur = "Hverdag";
	return(retur);
  endsub;
run;
quit;
