proc format;

value Ald_4Gr
1='0 - 17 år'
2='18 - 49 år'
3='50 - 74 år'
4='75 år og over';

value erdag
0 = "døgn"
1 = "dag";

value INNMATEHAST_2delt
1='Akutt'
2='Akutt'
3='Akutt'
4='Planlagt'
9='Ukjent'
;

value BEHANDLINGSNIVA3F
1 = 'Døgnopphold'  
2 = 'Dagbehandling'  
3 = 'Poliklinikk'
4 = 'Avtalespesialist';

value DRGtypeHastegrad
1='Planlagt medisin'
2='Akutt medisin' 
3='Planlagt kirurgi'
4='Akutt kirurgi'
9='Ukjent';

Value BehHF 
1='Finnmarkssykehuset HF' 
2='UNN HF' 
3='Nordlandssykehuset HF' 
4='Helgelandssykehuset HF' 
5='Helse Nord-Trøndelag HF' 
6='St. Olavs Hospital HF' 
7='Helse Møre og Romsdal HF' 
9='Helse Førde HF' 
10='Helse Bergen HF' 
11='Helse Fonna HF' 
12='Helse Stavanger HF' 
13='Resterende Helse Vest RHF' 
14='Vestre Viken HF' 
15='Sykehuset Telemark HF' 
16='Akershus universitetssykehus HF' 
17='Sykehuset Innlandet HF' 
18='Oslo universitetssykehus HF' 
19='Sunnaas sykehus HF' 
20='Sykehuset Østfold HF' 
21='Sørlandet sykehus HF' 
22='Sykehuset i Vestfold HF' 
23='Diakonhjemmet sykehus'
24='Lovisenberg diakonale sykehus'
25='Resterende Helse Sør-Øst RHF' 
26='Haraldsplass diakonale sykehus'
27='Private sykehus'
28='Avtalespesialister'
30='HF utenfor Helse Nord RHF'
;

value BehRHF 
1='Helse Nord RHF' 
2='Helse Midt-Norge RHF' 
3='Helse Vest RHF' 
4='Helse Sør-Øst RHF'
5='Private sykehus'
6='Avtalespesialister';

value behSh
10='Finnmarkssykehuset HF'
11='Klinikk Kirkenes'
12='Klinikk Hammerfest'
20='UNN HF'
21='UNN Tromsø'
22='UNN Harstad'
23='UNN Narvik'
30='Nordlandssykehuset HF'
31='Nordlandssykehuset Vesterålen'
32='Nordlandssykehuset Lofoten'
33='Nordlandssykehuset Bodø'
40='Helgelandssykehuset HF'
41='Helgelandssykehuset Mo i Rana'
42='Helgelandssykehuset Mosjøen'
43='Helgelandssykehuset Sandnessjøen'
300='Private sykehus'
400='Andre offentlige sykehus'
500='Avtalespesialister'
;

Value BoHF_kort
	1='Finnmark'
	2='UNN'
	3='Nordland'
	4='Helgeland '
	6='Nord-Trøndelag'
	7='St. Olavs'
	8='Møre og Romsdal'
	10='Førde'
	11='Bergen'
	12='Fonna'
	13='Stavanger'
	14='Østfold'
	15='Akershus'
	16='OUS'
	17='Lovisenberg'
	18='Diakonhjemmet'
	19='Innlandet'
	20='Vestre Viken'
	21='Vestfold'
	22='Telemark'
	23='Sørlandet'
	24='Utlandet/Svalbard'
	25='Bor utenfor Helse Nord'
	99='Ukjent/ugyldig kommunenr';

* Slik som før ;
value BoRHF
1='Boomr Helse Nord RHF' 
2='Boomr Helse Midt-Norge RHF' 
3='Boomr Helse Vest RHF' 
4='Boomr Helse Sør-Øst RHF' 
24='Boomr utlandet/Svalbard' 
99='Ukjent/ugyldig kommunenr';

value BoShHN
1='Boomr Kirkenes'
2='Boomr Hammerfest' 
3='Boomr Tromsø'
4='Boomr Harstad'
5='Boomr Narvik' 
6='Boomr Vesterålen'
7='Boomr Lofoten' 
8='Boomr Bodø' 
9='Boomr Rana' 
10='Boomr Mosjøen' 
11='Boomr Sandnessjøen'
12='Bor utenfor Helse Nord';


run;