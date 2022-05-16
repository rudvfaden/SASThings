proc fcmp outlib=funk.function.funcs;
    function SenesteMd(antalMd,md,aar);
        if md ne 99 then do;
            if mdy(md,1,aar)>=intnx('month',input("&aarmd.01",yymmdd8.),-(antalMd-1)) then retur=1;
            else retur=0;
        end;
        else do;
            retur=0;
        end;
        return(retur);
    endsub;

    function aarMdToPeriode(aar,md);
        dato=mdy(md,1,aar);
        return(intnx('month',dato,0,'E'));
    endsub;
run;
quit;

