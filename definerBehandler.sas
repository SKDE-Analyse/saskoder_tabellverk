%macro definerBehandler(dsn=);

data &dsn;
set &dsn;

/*
Kirkenes
*/
If BoSHHN=1 then do;
	If BehSh=11 then Behandler=1;
	else if BehSh=21 then Behandler=2;
	else if BehSh in (30,33) then Behandler=3;
	else if BehSH in (10,12) then Behandler=4;
	else if BehSh in (20,22,23,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

/*
Hammerfest
*/
If BoSHHN=2 then do;
	If BehSh=12 then Behandler=1;
	else if BehSh=21 then Behandler=2;
	else if BehSh in (30,33) then Behandler=3;
	else if BehSH in (10,11) then Behandler=4;
	else if BehSh in (20,22,23,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

/*
Tromsø
*/
If BoSHHN=3 then do;
	If BehSh=21 then Behandler=1;
*	else if BehSh=21 then Behandler=2;
	else if BehSh in (30,33) then Behandler=3;
	else if BehSH in (20,22,23) then Behandler=4;
	else if BehSh in (10,11,12,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

/*
Harstad
*/
If BoSHHN=4 then do;
	If BehSh=22 then Behandler=1;
	else if BehSh=21 then Behandler=2;
	else if BehSh in (30,33) then Behandler=3;
	else if BehSH in (20,23) then Behandler=4;
	else if BehSh in (10,11,12,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

/*
Narvik
*/
If BoSHHN=5 then do;
	If BehSh=23 then Behandler=1;
	else if BehSh=21 then Behandler=2;
	else if BehSh in (30,33) then Behandler=3;
	else if BehSH in (20,22) then Behandler=4;
	else if BehSh in (10,11,12,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

/*
Vesterålen
*/
If BoSHHN=6 then do;
	If BehSh=31 then Behandler=1;
	else if BehSh=21 then Behandler=2;
	else if BehSh in (30,33) then Behandler=3;
	else if BehSH=32 then Behandler=4;
	else if BehSh in (10,11,12,20,22,23,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

/*
Lofoten
*/
If BoSHHN=7 then do;
	If BehSh=32 then Behandler=1;
	else if BehSh=21 then Behandler=2;
	else if BehSh in (30,33) then Behandler=3;
	else if BehSH=31 then Behandler=4;
	else if BehSh in (10,11,12,20,22,23,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

/*
Bodø
*/
If BoSHHN=8 then do;
	If BehSh in (30,33) then Behandler=1;
	else if BehSh=21 then Behandler=2;
/*	else if BehSh=33 then Behandler=3;*/
	else if BehSH in (31,32) then Behandler=4;
	else if BehSh in (10,11,12,20,22,23,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

/*
Rana
*/
If BoSHHN=9 then do;
	If BehSh=41 then Behandler=1;
	else if BehSh=21 then Behandler=2;
	else if BehSh in (30,33) then Behandler=3;
	else if BehSH in (40,42,43) then Behandler=4;
	else if BehSh in (10,11,12,20,22,23,31,32) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

/*
Mosjøen
*/
If BoSHHN=10 then do;
	If BehSh=42 then Behandler=1;
	else if BehSh=21 then Behandler=2;
	else if BehSh in (30,33) then Behandler=3;
	else if BehSH in (40,41,43) then Behandler=4;
	else if BehSh in (10,11,12,20,22,23,31,32) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

/*
Sandnessjøen
*/
If BoSHHN=11 then do;
	If BehSh=43 then Behandler=1;
	else if BehSh=21 then Behandler=2;
	else if BehSh in (30,33) then Behandler=3;
	else if BehSH in (40,41,42) then Behandler=4;
	else if BehSh in (10,11,12,20,22,23,31,32) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

/*
Utenfor Helse Nord
*/
If BoSHHN=12 then do;
	if BehSh=21 then Behandler=2;
	else if BehSh in (30,33) then Behandler=3;
	else if BehSh in (10,11,12,20,22,23,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
end;

format behandler behandler.;

run;

%mend;