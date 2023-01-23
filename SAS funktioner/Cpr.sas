proc fcmp outlib=funk.function.funcs;
    function isCpr(cpr $);
  /* prxmatch (perl regular expresion) bruges til validering af cpr nummer.

*/
        if prxmatch("/(?:(?:31(?:0[13578]|1[02])|(?:30|29)(?:0[13-9]|1[0-2])|(?:0[1-9]|1[0-9]|2[0-8])(?:0[1-9]|1[0-2]))[0-9]{3}|290200[4-9]|2902(?:(?!00)[02468][048]|[13579][26])[0-3])[0-9]{3}/",cpr) then retur=1;
        else retur=0;

        return(retur);
    endsub;


    function CprtoBirthdate(cpr $);
        %* Beregner fødselsdato ud fra cpr numerets opbygning. https://www.cpr.dk/media/9345/personnummeret-i-cpr.pdf;

        pos0102 = input(substr(cpr,1,2),best8.);
        pos0304 = input(substr(cpr,3,2),best8.);
        pos0506 = input(substr(cpr,5,2),best8.);
        pos07   = input(substr(cpr,7,1),best8.);


        if isCpr(cpr) then do;
                if            pos07   <= 3 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+1900);
                else if 0  <= pos0506 and pos0506 <=36 and pos07=4 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                else if 37 <= pos0506 and pos0506 <=99 and pos07=4 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+1900);
                else if 0  <= pos0506 and pos0506 <=57 and pos07=5 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                else if 58 <= pos0506 and pos0506 <=99 and pos07=5 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+1800);
                else if 0  <= pos0506 and pos0506 <=57 and pos07=6 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                else if 58 <= pos0506 and pos0506 <=99 and pos07=6 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+1800);
                else if 0  <= pos0506 and pos0506 <=57 and pos07=7 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                else if 58 <= pos0506 and pos0506 <=99 and pos07=7 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+1800);
                else if 0  <= pos0506 and pos0506 <=57 and pos07=8 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                else if 58 =  pos0506 and pos0506 <=99 and pos07=8 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+1800);
                else if 0  <= pos0506 and pos0506 <=36 and pos07=9 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                else if 37 <= pos0506 and pos0506 <=99 and pos07=9 then
                    fodselsdag=mdy(pos0304,pos0102,pos0506+1900);
        end;
        else do:
            put 'WARNING: cpr ' cpr ' is invalid';
        end;
    return(fodselsdag);
endsub;

function age(dato);
    if dato ne . then do;
        age=yrdif(dato,today(),'AGE');
    end;
    return(age);
endsub;
run;