
%macro beh_sor;

behhf_hn = behhf;
if behhf in (5:26) then behhf_hn = 30;
if behhf in (5:26) then behsh = 400; * Andre offentlige sykehus ;
*if behsh = 514 then behsh = 241;

format behhf_hn behhf.;

%mend beh_sor;

%macro bo_sor;

if bohf in (6:23) then bohf = 25;

if BoShHN = . then BoShHN = 12;

%mend bo_sor;

%macro ald_gr4;

if alder in (0:17) then ald_gr4 = 1;
else if alder in (18:49) then ald_gr4 = 2;
else if alder in (50:74) then ald_gr4 = 3;
else if alder in (75:110) then ald_gr4 = 4;

format Ald_gr4 Ald_4Gr.;

%mend ald_gr4;



%macro tilretteleggInnbyggerfil(fil=innbygg.innb_2004_2015_bydel_allebyer);

/*
Returnerer to datasett:
- bohf_innbygg
- bosh_innbygg
- ald_just
*/

/* TODO: kjønnsjustere */
data innbygg;
set innbygg.innb_2004_2015_bydel_allebyer;
  where aar in (2011:2015);
  %boomraader;
run;

data innbygg;
set innbygg;
  %ald_gr4;
  %bo_sor;
run;

/* lage tmp-tabell for aldersjustering */

proc sql;
create table tmp_pop as
select distinct
   aar,
	ald_gr4,
   ermann,
	(SUM(innbyggere)) as innb
from innbygg
group by
   aar,
	ald_gr4,
   ermann;
quit;


proc sql;
create table tmp_pop_tot as
select distinct
    aar,
	(SUM(innbyggere)) as innb_tot
from innbygg
group by
    aar;
quit;

proc sql;
create table ald_just as
select *
from tmp_pop left join tmp_pop_tot
on 
tmp_pop.aar=tmp_pop_tot.aar;
quit;


data ald_just;
set ald_just;
faktor = innb/innb_tot;
drop innb_tot innb;
run;


/* Antall innbyggere i bohf og bosh*/

proc sql;
create table bosh_innbygg as
select distinct
          aar,
          ald_gr4,
          ermann,
          BoRHF, 
          BoHF, 
          BoShHN,
          /* summert innbyggere */
            (SUM(innbyggere)) as bosh_innb
from innbygg
group by
          aar,
          ald_gr4,
          ermann,
          BoRHF, 
          BoHF, 
          BoShHN;
quit;

* ta bort ald_gr4 hvis man ikke vil ha aldersjustering;
proc sql;
create table bohf_innbygg as
select distinct
          aar,
          ald_gr4,
          ermann,
          BoRHF,
          BoHF, 
          /* summert innbyggere */
            (SUM(innbyggere)) as bohf_innb
from innbygg
group by
          aar,
          ald_gr4,
          ermann,
          BoRHF, 
          BoHF;
quit;

%slett_datasett(datasett = tmp_pop);
%slett_datasett(datasett = tmp_pop_tot);
%slett_datasett(datasett = innbygg);

%mend;



%macro tilrettelegg(dsn =, behandler = 1, grupperinger = 0);

/*
Lage datasett med innbyggere
*/
%tilretteleggInnbyggerfil();

data tmp;
set &dsn;
run;


%if &behandler ne 0 %then %do;
   %definerBehandler(dsn=tmp);
%end;

/* Legge inn BOShHN innbyggertall */

proc sql;
create table tabl as
select *
from tmp left join bosh_innbygg
on 
   tmp.aar=bosh_innbygg.aar and 
   tmp.BoRHF=bosh_innbygg.BoRHF and 
   tmp.BoHF=bosh_innbygg.BoHF and 
   tmp.BoShHN=bosh_innbygg.BoShHN and
   tmp.ald_gr4=bosh_innbygg.ald_gr4 and
   tmp.ermann=bosh_innbygg.ermann;
quit;

/* Legge inn BOHF innbyggertall */

proc sql;
create table tabl2 as
select *
from tabl left join bohf_innbygg
on 
   tabl.aar=bohf_innbygg.aar and
   tabl.BoRHF=bohf_innbygg.BoRHF and 
   tabl.BoHF=bohf_innbygg.BoHF and
   tabl.ald_gr4=bohf_innbygg.ald_gr4 and
   tabl.ermann=bohf_innbygg.ermann;
quit;

proc sql;
   create table tabl3 as
   select *
   from tabl2 left join ald_just
   on 
   tabl2.aar=ald_just.aar and
   tabl2.ald_gr4=ald_just.ald_gr4 and
   tabl2.ermann=ald_just.ermann;
quit;

data tabl3;
set tabl3;
   bohf_rate = 1000*faktor/bohf_innb;
   bosh_rate = 1000*faktor/bosh_innb;
   bohf_drgrate = 1000*faktor*korrvekt/bohf_innb;
   bosh_drgrate = 1000*faktor*korrvekt/bosh_innb;

drop bohf_innb bosh_innb;
run;

data tabl3;
set tabl3;
where Ald_gr4 ne . and ermann ne .;
   if (hastegrad eq .) then hastegrad = 9;
format hastegrad innmateHast_2delt.;
format BehSh behSh.;
run;

proc sql;
   create table &dsn._ut as
   select distinct
      aar,
      %if &grupperinger ne 0 %then %do;
         Ald_gr4,
         Ermann,
         Aktivitetskategori3,
         hastegrad, 
         DRGtypeHastegrad,
      %end;
      BehRHF,
      %if &behandler eq 0 %then %do;
         BehHF,
         Behhf_hn,
         BehSh,
		%end;
		%else %do;
         behandler,
		%end;
      BoRHF, 
      BoHF,
      BoShHN, 
      /* summert liggetid */
      (SUM(liggetid)) as liggetid, 
      /* summert korrvekt */
      (SUM(korrvekt)) as drg_poeng, 
      /* antall pasienter */
      (SUM(kontakt)) as kontakter,
      /* rate bosh */
      (SUM(bohf_rate)) as bohf_rate,
      /* rate bohf */
      (SUM(bosh_rate)) as bosh_rate,
      /* rate bosh */
      (SUM(bohf_drgrate)) as bohf_drgrate,
      /* rate bohf */
      (SUM(bosh_drgrate)) as bosh_drgrate

from tabl3
   group by aar,
      %if &grupperinger ne 0 %then %do;
         Ald_gr4,
         ermann,
         Aktivitetskategori3,
         hastegrad,
         DRGtypeHastegrad,
      %end;
      %if &behandler eq 0 %then %do;
         BehHF,
         Behhf_hn,
         BehSh,
      %end;
      %else %do;
         behandler,
      %end;
      BoHF,
      BoShHN;
quit;

/* nye navn */
data &dsn._ut;
set &dsn._ut;
   %if &grupperinger ne 0 %then %do;
      rename Aktivitetskategori3 = behandlingsniva;
      rename Ald_gr4 = alder;
      rename ermann = kjonn;
   %end;
   rename BoRHF = boomr_RHF;
   rename BoHF = boomr_HF;
   rename BoShHN = boomr_sykehus;
   rename BehRHF = behandlende_RHF;
   %if behandler eq 0 %then %do;
      rename Behhf = behandlende_HF;
      rename Behhf_hn = behandlende_HF_HN;
      rename BehSh = behandlende_sykehus;
   %end;
run;


%slett_datasett(datasett = bosh_innbygg);
%slett_datasett(datasett = bohf_innbygg);
%slett_datasett(datasett = tabl);
%slett_datasett(datasett = tabl2);
%slett_datasett(datasett = tabl3);
%slett_datasett(datasett = tmp);
%slett_datasett(datasett = ald_just);
%slett_datasett(datasett = tabl);

%mend;

%macro slett_datasett(datasett =);

Proc datasets nolist;
delete &datasett;
run;

%mend;

%macro unik_pasient(datasett = , variabel =);

/* 
Macro for å markere unike pasienter 

Ny variabel, &variabel._unik, lages i samme datasett
*/

/*1. Sorter på år, aktuell hendelse (merkevariabel), PID, InnDato, UtDato;*/
proc sort data=&datasett;
by aar pid;
run;

/*2. By-statement sørger for at riktig opphold med hendelse velges i kombinasjon med First.-funksjonen og betingelse på hendelse*/
data &datasett;
set &datasett;
&variabel._unik = .;
by aar pid;
if first.pid and &variabel = 1 then &variabel._unik = 1;	
run;

/*proc sort data=&datasett;*/
/*by pid inndato utdato;*/
/*run;*/

%mend;

%macro aggregerMax(dsn = );

proc sql;
   create table &dsn._ut as
   select distinct
          aar, 
          BoRHF, 
          BoHF,
          BoShHN, 
          BehRHF,
	      Behhf_hn,
          BehHF,
          BehSh,
          /* summert liggetid */
            (SUM(liggetid)) as liggetid, 
          /* summert korrvekt */
            (SUM(korrvekt)) as drg_poeng, 
          /* antall pasienter */
            (SUM(kontakt)) as kontakter,
          /* rate bosh */
            (SUM(bohf_rate)) as bohf_rate,
          /* rate bohf */
            (SUM(bosh_rate)) as bosh_rate,
          /* rate bosh */
            (SUM(bohf_drgrate)) as bohf_drgrate,
          /* rate bohf */
            (SUM(bosh_drgrate)) as bosh_drgrate

from &dsn
      group by aar,
               BoShHN,
               BehSh,
               BoHF,
               Behhf_hn,
               BehHF;
quit;

%mend;



