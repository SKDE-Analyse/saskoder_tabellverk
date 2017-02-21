
%let filbane=\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Data\SAS\;
options sasautos=("&filbane.Makroer\master" SASAUTOS);

%include "&filbane.Formater\master\SKDE_somatikk.sas";
%include "&filbane.Formater\master\NPR_somatikk.sas";
%include "&filbane.Formater\master\bo.sas";
%include "&filbane.Formater\master\beh.sas";

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
Aktivitetskategori3 hastegrad
DRGtypeHastegrad kontakt;
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

%tilretteleggInnbyggerfil();

%tilrettelegg(dsn = &datasett);


data &datasett._ut;
set &datasett._ut;
format behandlende_sykehus behSh.;
format boomr_HF BoHF_kort.;
format boomr_sykehus boshHN.;
format behandlingsniva BEHANDLINGSNIVA3F.;
run;


data skde_arn.tabellverk_test;
set &datasett._ut;
run;

proc export data=&datasett._ut
outfile="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Prosjekter\ahs_dynamisk_tabellverk\csv_filer\kjonnaldersjustert.csv"
dbms=csv
replace;
run;
