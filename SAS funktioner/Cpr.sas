proc fcmp outlib=funk.function.funcs;
    /**********************************************************************************************
    * Function: isCpr
    * Description: Checks if the input CPR is valid by verifying its length and converting it to a numeric value.
    * Input: cpr - a character string representing a Danish personal identification number (CPR)
    * Output: retur - a binary value indicating if the input CPR is valid or not
    ***********************************************************************************************/
    function isCpr(cpr $) $;
        if missing(cpr) then return(0);

        if length(cpr) = 10 and input(cpr, 10.) then retur = 1;
        else retur = 0;
        return(retur);
    endsub;


    /**********************************************************************************************
    * Function: CprtoBirthdate
    * Description: Converts a Danish personal identification number (CPR) into a birthdate.
    * Input: cpr - a character string representing a Danish personal identification number (CPR)
    * Output: fodselsdag - a SAS date value representing the birthdate calculated from the input CPR
    ***********************************************************************************************/
    function CprtoBirthdate(cpr $) date;
        /* Beregner fødselsdato ud fra cpr numerets opbygning. https://www.cpr.dk/media/9345/personnummeret-i-cpr.pdf */

        pos0102 = input(substr(cpr,1,2),best8.);
        pos0304 = input(substr(cpr,3,2),best8.);
        pos0506 = input(substr(cpr,5,2),best8.);
        pos07   = input(substr(cpr,7,1),best8.);

        if isCpr(cpr) then do;
            select;
                when (pos07 <= 3) then fodselsdag=mdy(pos0304,pos0102,pos0506+1900);
                when (pos0506 <= 36 and pos07 = 4) then fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                when (pos0506 <= 99 and pos07 = 4) then fodselsdag=mdy(pos0304,pos0102,pos0506+1900);
                when (pos0506 <= 57 and pos07 = 5) then fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                when (pos0506 <= 99 and pos07 = 5) then fodselsdag=mdy(pos0304,pos0102,pos0506+1800);
                when (pos0506 <= 57 and pos07 = 6) then fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                when (pos0506 <= 99 and pos07 = 6) then fodselsdag=mdy(pos0304,pos0102,pos0506+1800);
                when (pos0506 <= 57 and pos07 = 7) then fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                when (pos0506 <= 99 and pos07 = 7) then fodselsdag=mdy(pos0304,pos0102,pos0506+1800);
                when (pos0506 <= 57 and pos07 = 8) then fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                when (pos0506 <= 99 and pos07 = 8) then fodselsdag=mdy(pos0304,pos0102,pos0506+1800);
                when (pos0506 <= 36 and pos07 = 9) then fodselsdag=mdy(pos0304,pos0102,pos0506+2000);
                when (pos0506 <= 99 and pos07 = 9) then fodselsdag=mdy(pos0304,pos0102,pos0506+1900);
                otherwise put 'WARNING: cpr ' cpr ' is invalid';
            end;
            put 'WARNING: cpr ' cpr ' is invalid';
        end;
        return(fodselsdag);
    endsub;


    /**********************************************************************************************
    * Function: age
    * Description: Calculates the age based on the input birthdate and the current date.
    * Input: dato - a SAS date value representing a birthdate
    * Output: age - a numeric value representing the age calculated from the input birthdate and the current date
    ***********************************************************************************************/
    function age(dato) num;
        if dato ne . then do;
            age=yrdif(dato,today(),'AGE');
        end;
        return(age);
    endsub;
endsub;
run;    end;
    return(fodselsdag);
endsub;

function age(dato);
    if dato ne . then do;
        age=yrdif(dato,today(),'AGE');
    end;
    return(age);
endsub;
run;