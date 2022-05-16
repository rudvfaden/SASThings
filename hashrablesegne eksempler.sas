/*proc copy in=sd out=work;*/
/*select SD_DIM_INST SD_DIM_PERIODE;*/
/*run;*/

data test;
set sd.sd_person;
where afd='F500' and inst='2F';* and today() between start and slut;
*length antal antalunique 5.0;
run;
data _null_;
/*	dcl hash instk(ordered:'A');*/
/*	instk.definekey('inst');*/
/*	instk.definedata('inst','navn','aarmd');*/
/*	instk.definedone();*/

/*	if 0 then*/
/*		set test;*/
	dcl hash periode();
	periode.definekey('tjnr');
	periode.definedata('tjnr','antal', 'antalUnique');
	periode.definedone();
	do until(lr);
		set work.test end=lr;
		call missing(antal, antalUnique);
		rc=periode.find();
		antal + 1;
		antalUnique + (periode.add()=0);
		periode.replace();
	end;
	periode.output(dataset:'work.inst');
run;