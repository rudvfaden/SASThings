*tjekker om en variable fines i et datasæt;
proc fcmp outlib=funk.function.funcs;
function varExists(dsName $, varname $);
    dsid = open(dsName,"i");
    
    if dsid=0 then do;
        put 'ERROR:' dsName= 'does not exist';
        result=0;
    end;
    else if dsid > 0 and varnum(dsid, varname) > 0 then do;
        result = 1;
    end;
    else do;
        result = 0;
    end;

    rc = close(dsid);
    return(result);
endsub;
run;
