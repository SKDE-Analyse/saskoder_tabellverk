
/* lage sett for tabellverk-generering */

data off_tot;
set npr_skde.magnus_sho_2011 npr_skde.magnus_sho_2012 npr_skde.magnus_sho_2013 npr_skde.magnus_sho_2014 npr_skde.magnus_sho_2015;
where (BehRHF = 1 or BoRHF = 1) and (BoRHF in (1:4));
run;

data priv_tot;
set npr_skde.magnus_avtspes_2011 npr_skde.magnus_avtspes_2012 npr_skde.magnus_avtspes_2013 npr_skde.magnus_avtspes_2014 npr_skde.magnus_avtspes_2015;
where (BoRHF = 1) and (alder ne .); * and (aar ne 2011);
BehHF = 28;
BehRHF = 6;
behSh = 500;
liggetid = 0;
Aktivitetskategori3 = 4;
hastegrad = .;
AvtSpes = 1;
run;

/* Legg på DRGtypeHastegrad fra parvus */
%varFraParvus(dsnMagnus = off_tot, var_som = DRGtypeHastegrad)


data npr_utva.ahs_priv_nord;
set priv_tot;
run;

data npr_utva.ahs_off_nord;
set off_tot;
run;


data tabell_alle;
set npr_utva.ahs_off_nord npr_utva.ahs_priv_nord;
keep aar alder ermann korrvekt liggetid
BoShHN BoHF BoRHF BehSh BehHF BehRHF
Aktivitetskategori3 hastegrad ICD10Kap
DRGtypeHastegrad kontakt hdg;
kontakt = 1;
run;

data tabell_alle;
set tabell_alle;
if drgtypehastegrad = . then drgtypehastegrad = 9;
if Aktivitetskategori3 = 3 then drgtypehastegrad = 9;
run;


%let datasett = tabell_klargjor;

/*
slå sammen sykehus og HF fra sør-norge, og lag aldersgrupper
*/
data &datasett;
set tabell_alle;
  %beh_sor;
  %bo_sor;
  %ald_gr4;
  format BehHF BehHF.;
run;


%tilrettelegg(dsn = &datasett, behandler = 0, grupperinger = 1);

proc export data=&datasett._ut
outfile="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Prosjekter\ahs_dynamisk_tabellverk\csv_filer\sykehusopphold.csv"
dbms=csv
replace;
run;

%tilrettelegg(dsn = &datasett, behandler = 1, grupperinger = 1);

proc export data=&datasett._ut
outfile="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Prosjekter\ahs_dynamisk_tabellverk\csv_filer\behandler.csv"
dbms=csv
replace;
run;

%tilrettelegg(dsn = &datasett, behandler = 1, grupperinger = 0);

proc export data=&datasett._ut
outfile="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Prosjekter\ahs_dynamisk_tabellverk\csv_filer\agg_max.csv"
dbms=csv
replace;
run;


data &datasett._hdg;
set &datasett;
where HDG ne .;
run;

%tilrettelegg(dsn = &datasett._hdg, behandler = 1, grupperinger = 0, hdg = 1);

proc export data=&datasett._hdg_ut
outfile="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Prosjekter\ahs_dynamisk_tabellverk\csv_filer\agg_max_hdg.csv"
dbms=csv
replace;
run;

data &datasett;
set &datasett;
*where icd10kap ne .;
run;

%tilrettelegg(dsn = &datasett, behandler = 1, grupperinger = 0, icd = 1);

proc export data=&datasett._ut
outfile="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Prosjekter\ahs_dynamisk_tabellverk\csv_filer\icd10.csv"
dbms=csv
replace;
run;


data test;
set tabl4;
where borhf ne 1;
run;


proc sql;
   create table test_ut as
   select distinct
      aar,
      Aktivitetskategori3,
	  /*
      %if &grupperinger ne 0 %then %do;
         Ald_gr4,
         Ermann,
         hastegrad, 
         DRGtypeHastegrad,
      %end;
	  */
      BehRHF,
	  /*
      %if &behandler eq 0 %then %do;
         BehHF,
         Behhf_hn,
         BehSh,
		%end;
		%else %do;
	  */
         behandler,
		 /*
		%end;
		 */
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
      (SUM(bosh_rate)) as bosh_rate,
      /* rate bohf */
      (SUM(bohf_rate)) as bohf_rate,
      /* rate bohf */
      (SUM(borhf_rate)) as borhf_rate,
      /* drg-rate bosh */
      (SUM(bosh_drgrate)) as bosh_drgrate,
      /* drg-rate bohf */
      (SUM(bohf_drgrate)) as bohf_drgrate,
      /* drg-rate bohf */
      (SUM(borhf_drgrate)) as borhf_drgrate

from test
   group by 
      aar,
      Aktivitetskategori3,
	  /*
      %if &grupperinger ne 0 %then %do;
         Ald_gr4,
         ermann,
         hastegrad,
         DRGtypeHastegrad,
      %end;
      %if &behandler eq 0 %then %do;
	     BehHF,
         Behhf_hn,
         BehSh,
      %end;
      %else %do;
	  */
         behandler,
		 /*
      %end;
		 */
	  BoRHF,
      BoHF,
      BoShHN;
quit;

data skde_arn.tabellverk_test;
set &datasett._ut;
run;
