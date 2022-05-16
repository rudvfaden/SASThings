data _null_;
	declare hash H(); *iniitaliser hash objektet;
	h.definekey('k'); *Definere nøgler;
	h.definedata('d'); *definer data;
	put _all_; *output er _ERROR_=0 _N_=1. Fortæller at hverken 'k' eller 'd' er i DPV.; 
run;

data _null_;
	declare hash H(); *iniitaliser hash objektet;
	h.definekey('k'); *Definere nøgler;
	h.definedata('d'); *definer data;
	rc = h.check(key:1); * Ser om værdien 1 er i hash table nøglen. 
							Giver fejl da vi mangler defineDone;
run;

data _null_;
	declare hash H(); *iniitaliser hash objektet;
	h.definekey('k'); *Definere nøgler;
	h.definedata('d'); *definer data;
	h.defineDone();
	rc = h.check(key:1); * Ser om værdien 1 er i hash table nøglen. 
							Giver fejl da 'k' ikke er declared;
	*hash table key og data er først skabt i compiler symboel 
		table når definedone er kørt. ;
run;


data _null_;
	declare hash H(); *iniitaliser hash objektet;
	h.definekey('k'); *Definere nøgler;
	h.definedata('d'); *definer data;
	h.defineDone();
/*	k=1;*/
/*	d=2;*/
	retain k 1 d 2;
	rc = h.check(key:1); 
	put _all_;
run;

/*K og d kaldes Host variable.
Skabelse af host variable kaldes pramater type matching*/

*********************************************************;
data _null_;
	declare hash H(); *iniitaliser hash objektet;
	h.definekey('k'); *Definere nøgler;
	h.definedata('d'); *definer data;
	h.defineDone();
 	
	do k=1 to 3;
		d= put(k,z2.);
		h.add();
		put _all_;
	end;

	rc = h.check(key:1); 
	put _all_;
run;

**************;
data hash;
	do k=1 to 3;
	d = put(k,z2.);
	output;
end;
run;
data _null_;
	declare hash H(); *iniitaliser hash objektet;
	h.definekey('k'); *Definere nøgler;
	h.definedata('d'); *definer data;
	h.defineDone();
 	
	do until(lr);
		set hash end=lr;
		h.add();
	end;

	rc = h.check(key:1); 
	put _all_;
run;

**************;
data hash;
	do k=1 to 3;
	d = put(k,z2.);
	output;
end;
run;
data _null_;
	if 0 then set hash;
	declare hash H(dataset:'hash'); *iniitaliser hash objektet;
	h.definekey('k'); *Definere nøgler;
	h.definedata('d'); *definer data;
	h.defineDone();
 	
	rc = h.check(key:1); 
	stop;

run;

**************;
data hash;
	do k=1 to 3;
	d = put(k,z2.);
	output;
end;
run;
data _null_;
	if 0 then set hash;
	declare hash H(dataset:'hash'); *iniitaliser hash objektet;
	h.definekey('k'); *Definere nøgler;
	h.definedata('k','d'); *definer data;
	h.defineDone();
 	
	h.replace(key:1, data:1,data:'11');
	h.replace(key:4, data:4,data:'04');

	call missing(k,d);
	do kv = 1,2,3,4;
		rc = h.find(key:kv); 
		put rc= k= d=;
	end;
	stop;

run;


**************;
*num_items viser antal obs i hash tabellen;
data hash;
	do k=1 to 3;
	d = put(k,z2.);
	output;
end;
run;
data _null_;

	declare hash H( ordered:'A');

	*iniitaliser hash objektet;
	h.definekey('k');

	*Definere nøgler;
	h.definedata('k','d');

	*definer data;
	h.defineDone();
	ni = h.num_items;
	put ni=;

	do until(lr);
		set hash end=lr;
		h.add();
		ni = h.num_items;
		put ni=;
	end;

	rc = h.remove(key:2);
		ni = h.num_items;
		put ni=;
	stop;
run;

**************;
*eksempel med dynamiske arugmenter;

data _null_;
	declare hash h(ordered:char('AD',2));
	h.definekey(byte(107));
	h.definedata('k','d');
	h.definedone();

	do k=1 to 3;
		d= put(k,z2.);
		h.add();
	end;

	h.output(dataset: catx('_','hashout',_n_));
	rc = h.find(key:2**2-2*_n_);
	put k= d=;
	stop;
run;


