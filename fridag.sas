/**
 * This SAS code snippet defines a function named 'fridag' that takes a date as input and returns a string indicating whether the date is a holiday or a regular workday in Denmark.
 * The function uses a series of calculations to determine the date of Easter Sunday for the input year and compares the input date to a set of predefined dates that are either holidays or weekends in Denmark.
 * If the input date matches any of the predefined dates, the function returns a corresponding string indicating the type of day.
 * If the input date does not match any of the predefined dates, the function returns 'Hverdag' (which means 'weekday' in Danish) to indicate a regular workday.
 *
 * Inputs:
 * - Dato: A SAS date value representing the input date.
 *
 * Outputs:
 * - A string indicating whether the input date is a holiday or a regular workday in Denmark.
 *
 * Additional Functions:
 * - This code snippet also defines two other functions named 'arbdage' and 'hdagnum'.
 *   - 'arbdage' calculates the number of workdays between two dates.
 *   - 'hdagnum' calculates the number of workdays from the beginning of the current year to the current date.
 *
 * Notes:
 * - The code snippet uses the SAS FCMP (Function Compiler) procedure to define the custom functions.
 * - The predefined dates for holidays and weekends in Denmark are based on the calculation of Easter Sunday for each year.
 * - The code snippet includes comments to explain the purpose and logic of each calculation step.
 */

proc fcmp outlib=funk.function.funcs;
    /**
     * Function to determine if a given date is a holiday or a regular workday in Denmark.
     *
     * @param Dato A SAS date value representing the input date.
     * @return A string indicating whether the input date is a holiday or a regular workday in Denmark.
     */
    function fridag(Dato) $15;
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
        if Dato = paaske-3 then retur = "Skærtorsdag";
        else if Dato = paaske-2 then retur = "Langfredag";
        else if Dato = paaske+1 then retur = "2.Påskedag";
        else if Dato = paaske then retur = "Påskedag";
        else if Dato = paaske+26 then retur = "Store bededag";
        else if Dato = paaske+39 then retur = "Kr. himmelfart";
        else if Dato = paaske+49 then retur = "pinsedag";
        else if Dato = paaske+50 then retur = "2. pinsedag";
        else if Dato = mdy(05,01,aar) then retur = "1. Maj";
        else if Dato = mdy(12,24,aar) then retur = "Juleaftensdag";
        else if Dato = mdy(12,25,aar) then retur = "Juledag";
        else if Dato = mdy(12,26,aar) then retur = "2. juledag";
        else if Dato = mdy(01,01,aar) then retur = "Nytårsdag";
        else if weekday(Dato) = 7 then retur = "Lørdag";
        else if weekday(Dato) = 1 then retur = "Søndag";
        else retur = "Hverdag";
        return(retur);
    endsub;

    /**
     * Function to calculate the number of workdays between two dates.
     *
     * @param fraDato The starting date.
     * @param TilDato The ending date.
     * @return The number of workdays between the starting and ending dates.
     */
    function arbdage(fraDato,TilDato);
        if fraDato > TilDato then do;
            put "ERROR: Value from > value to";
            retur = .;
        end;
        else do;
            count=0;
            do i=fradato to TilDato;
                if fridag(i)='Hverdag' then do;
                    count=count+1;
                end;
            end;
            return(count);
        end;
    endsub;

    /**
     * Function to calculate the number of workdays from the beginning of the current year to the current date.
     *
     * @return The number of workdays from the beginning of the current year to the current date.
     */
    function hdagnum();
        count=0;
        do i=mdy(month(today()),01,year(today())) to today();
            if fridag(i)='Hverdag' then do;
                count=count+1;
            end;
        end;
        return(count);
    endsub;
run;
quit;