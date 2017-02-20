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
run;

/* Legg på DRGtypeHastegrad fra parvus */
%varFraParvus(dsnMagnus = off_tot, var_som = DRGtypeHastegrad)

data tabell_alle;
set priv_tot off_tot;
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


*data npr_utva.ahs_tabellverk_avd;
*set tabell_alle;
*run;

/* Unik pasient på behf? besh? */
/*%unik_pasient(datasett = tabell_2010_2014, variabel = kontakt);*/

/*
lagre datasett for senere bruk
*/

/*data skde_arn.tabell_2011_2014;*/
/*set tabell_2011_2014;*/
/*run;*/

%let datasett = tabell_alle;


%tilrettelegg(datasett = tabell_alle);


data tabell_alle_ut;
set tabell_alle_ut;
format behandlende_sykehus behSh.;
format boomr_HF BoHF_kort.;
format boomr_sykehus boshHN.;
format behandlingsniva BEHANDLINGSNIVA3F.;
run;


data skde_arn.tabellverk_test;
set tabell_alle_ut;
run;

proc export data=tabell_alle_ut
outfile="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Prosjekter\ahs_dynamisk_tabellverk\csv_filer\kjonnaldersjustert.csv"
dbms=csv
replace;
run;
