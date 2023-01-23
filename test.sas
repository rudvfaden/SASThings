
data test;
    set test2;
run;
/* Test */
proc sql;
    create table test;
    as select *
    from test2;
    ;
quit;