libname dw '/sasfolders/user/rfad0001/SasHashObject/DW';

data _null_;
	dcl hash slashline(ordered:'A');
	slashline.definekey('Batter_ID');
	slashline.definedata('Batter_ID','PAs','AtBats','Hits','_Bases',
		'_Reached_Base','BA','OBP','SLG','OPS');
	slashline.definedone();
	format BA obp slg ops 5.3;

	do until(lr);
		set dw.atbats end=lr;
		call missing(pas,atbats,hits,_bases,_reached_base);
		rc = slashline.find();
		pas +1;
		atbats + is_an_ab;
		hits + is_a_hit;
		_bases + bases;
		_reached_base + is_an_onbase;
		ba=divide(_reached_base,pas);
		OBP = divide(_reached_base,atbats);
		slg=divide(_bases,atbats);
		ops=sum(obp,slg);
		slashline.replace();
	end;

	slashline.output(dataset:'Batter_slash_line(drop=_:)');
run;

************;
data _null_;
	dcl hash slashline(ordered:'A');
	slashline.definekey('last_name','first_name','Batter_ID');
	slashline.definedata('Batter_ID','last_name','first_name','Team_sk','PAs','AtBats','Hits','_Bases',
		'_Reached_Base','BA','OBP','SLG','OPS');
	slashline.definedone();

	if 0 then
		set dw.players(rename=(player_id=batter_id));
	dcl hash players(dataset:'dw.players(rename=(player_id=batter_id))'
		,duplicate:'replace');
	players.definekey('batter_id');
	players.definedata('batter_id','last_name','first_name',
		'Team_sk');
	players.definedone();
	format BA obp slg ops 5.3;

	do until(lr);
		set dw.atbats end=lr;
		call missing(last_name,first_name,Team_sk,pas,atbats,hits,_bases,_reached_base);
		players.find();
		rc=slashline.find();
		pas +1;
		atbats + is_an_ab;
		hits + is_a_hit;
		_bases + bases;
		_reached_base + is_an_onbase;
		ba=divide(_reached_base,pas);
		OBP = divide(_reached_base,atbats);
		slg=divide(_bases,atbats);
		ops=sum(obp,slg);
		slashline.replace();
	end;

	slashline.output(dataset:'Batter_slash_line(drop=_:)');
run;

data _null_;
	dcl hash slashline(ordered:'A');
	slashline.definekey('league','team_name','last_name'
		,'first_name','Batter_ID');
	slashline.definedata('league','team_name','Batter_ID','last_name','first_name','Team_sk','PAs','AtBats','Hits','_Bases',
		'_Reached_Base','BA','OBP','SLG','OPS');
	slashline.definedone();

	if 0 then
		set dw.players(rename=(player_id=batter_id)) dw.teams dw.LEAGUES;
	dcl hash players(dataset:'dw.players(rename=(player_id=batter_id))'
		,duplicate:'replace');
	players.definekey('batter_id');
	players.definedata('batter_id','last_name','first_name',
		'Team_sk');
	players.definedone();
	dcl hash teams(dataset:'dw.teams');
	teams.definekey('team_sk');
	teams.definedata('League_SK','team_name');
	teams.definedone();
	dcl hash leagues(dataset:'dw.leagues');
	leagues.definekey('League_SK');
	leagues.definedata('league');
	leagues.definedone();
	format BA obp slg ops 5.3;

	do until(lr);
		set dw.atbats end=lr;
		call missing(last_name,first_name,Team_sk,pas,atbats,hits,_bases,_reached_base);
		players.find();
		teams.find();
		leagues.find();
		link slashline;
		call missing(batter_id,last_name,first_name);
		link slashline;
		call missing(team_name);
		link slashline;
	end;

	slashline.output(dataset:'Batter_slash_line(drop=_:)');
	return;
slashline:
	rc=slashline.find();
	pas +1;
	atbats + is_an_ab;
	hits + is_a_hit;
	_bases + bases;
	_reached_base + is_an_onbase;
	ba=divide(_reached_base,pas);
	OBP = divide(_reached_base,atbats);
	slg=divide(_bases,atbats);
	ops=sum(obp,slg);
	slashline.replace();
	return;
run;

data _null_;
	dcl hash slashline(ordered:'A');
	slashline.definekey('league','team_name','last_name'
		,'first_name','Batter_ID');
	slashline.definedata('league','team_name','Batter_ID','last_name','first_name','Team_sk','PAs','AtBats','Hits','_Bases',
		'games','_Reached_Base','BA','OBP','SLG','OPS');
	slashline.definedone();

	if 0 then
		set dw.players(rename=(player_id=batter_id)) dw.teams dw.LEAGUES;
	dcl hash players(dataset:'dw.players(rename=(player_id=batter_id))'
		,duplicate:'replace');
	players.definekey('batter_id');
	players.definedata('batter_id','last_name','first_name',
		'Team_sk');
	players.definedone();
	dcl hash teams(dataset:'dw.teams');
	teams.definekey('team_sk');
	teams.definedata('League_SK','team_name');
	teams.definedone();
	dcl hash leagues(dataset:'dw.leagues');
	leagues.definekey('League_SK');
	leagues.definedata('league');
	leagues.definedone();
	dcl hash u();
	u.definekey('league','team_name','last_name'
		,'first_name','game_sk');
	u.definedone();
	format BA obp slg ops 5.3;

	do until(lr);
		set dw.atbats end=lr;
		call missing(last_name,first_name,Team_sk,games,pas,atbats,hits,_bases,_reached_base);
		players.find();
		teams.find();
		leagues.find();
		link slashline;
		call missing(batter_id,last_name,first_name,games);
		link slashline;
		call missing(team_name,games);
		link slashline;
	end;

	slashline.output(dataset:'Batter_slash_line(drop=_:)');
	return;
slashline:
	rc=slashline.find();
	games + (u.add()=0);
	pas +1;
	atbats + is_an_ab;
	hits + is_a_hit;
	_bases + bases;
	_reached_base + is_an_onbase;
	ba=divide(_reached_base,pas);
	OBP = divide(_reached_base,atbats);
	slg=divide(_bases,atbats);
	ops=sum(obp,slg);
	slashline.replace();
	return;
run;

data _null_;
	/*define lookup hash object tables*/
	dcl hash players(dataset:'dw.players(rename=(player_id=batter_id))'
		,multidata:'Y');
	players.definekey('batter_id');
	players.definedata('batter_id','Team_sk','last_name','first_name',
		'start_date','end_date');
	players.definedone();
	dcl hash teams(dataset:'dw.teams');
	teams.definekey('team_sk');
	teams.definedata('team_name');
	teams.definedone();
	dcl hash games(dataset:'dw.games');
	games.definekey('game_SK');
	games.definedata('date','month','dayofweek');
	games.definedone();

	/*define result object tables*/
	dcl hash h_pointer;
	dcl hash byPlayer(ordered:'A');
	byPlayer.definekey('last_name','first_name','batter_id');
	byPlayer.definedata('last_name','first_name','batter_id',
		'PAs','AtBats','Hits','_Bases',
		'_Reached_Base','BA','OBP','SLG','OPS');
	byPlayer.definedone();
	dcl hash byTeam(ordered:'A');
	byTeam.definekey('team_sk','team_name');
	byTeam.definedata('team_sk','team_name',
		'PAs','AtBats','Hits','_Bases',
		'_Reached_Base','BA','OBP','SLG','OPS');
	byTeam.definedone();
	dcl hash byMonth(ordered:'A');
	byMonth.definekey('month');
	byMonth.definedata('month',
		'PAs','AtBats','Hits','_Bases',
		'_Reached_Base','BA','OBP','SLG','OPS');
	byMonth.definedone();

	dcl hash ByDayOfWeek(ordered:'A');
	ByDayOfWeek.definekey('DayOfWeek');
	ByDayOfWeek.definedata('DayOfWeek',
		'PAs','AtBats','Hits','_Bases',
		'_Reached_Base','BA','OBP','SLG','OPS');
	ByDayOfWeek.definedone();

	dcl hash byPlayerMonth(ordered:'A');
	byPlayerMonth.definekey('Last_name','first_name','batter_id'
							,'month');
	byPlayerMonth.definedata('Last_name','first_name','batter_id'
				,'month', 'PAs','AtBats','Hits','_Bases',
		'_Reached_Base','BA','OBP','SLG','OPS');
	byPlayerMonth.definedone();

	if 0 then
		set dw.players(rename=(player_id=batter_id)) 
			dw.teams dw.games;
	format PAs AtBats Hits comma6. BA obp slg ops 5.3;

	do until(lr);
		set dw.atbats end=lr;
		call missing(last_name,first_name,Team_sk,team_name,date,
				month,dateOfWeek);
		games.find();
		player_rc=players.find();
		do while (player_rc=0);
			if start_date le end_date then leave;
			player_rc = players.find_next();
		end;
		if player_rc ne 0 then call missing(last_name,first_name,Team_sk);
		teams.find();
		h_pointer=byPlayer;
		link slashline;
		h_pointer=byTeam;
		link slashline;
		h_pointer=byMonth;
		link slashline;
		h_pointer=ByDayOfWeek;
		link slashline;
		h_pointer=byPlayerMonth;
		link slashline;
	end;

	byPlayer.output(dataset:'byPlayer(drop=_:)');
	byTeam.output(dataset:'byTeam(drop=_:)');
	byMonth.output(dataset:'byMonth(drop=_:)');
	ByDayOfWeek.output(dataset:'ByDayOfWeek(drop=_:)');
	byPlayerMonth.output(dataset:'byPlayerMonth(drop=_:)');
	stop;
slashline:
	call missing(PAs,AtBats,Hits,_Bases,
		_Reached_Base);
	rc=h_pointer.find();
	pas +1;
	atbats + is_an_ab;
	hits + is_a_hit;
	_bases + bases;
	_reached_base + is_an_onbase;
	ba=divide(_reached_base,pas);
	OBP = divide(_reached_base,atbats);
	slg=divide(_bases,atbats);
	ops=sum(obp,slg);
	h_pointer.replace();
	return;
run;