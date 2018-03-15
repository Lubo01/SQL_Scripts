--toto je komentar

--prikaz select

-- vyberie vsetky stlpce/riadky cez *, from vybera z tabulky x
select * from dbo.PREDAJCI
select MENO,PREDAJ,PLAN_PREDAJ,PREDAJ*1.03 as novy from dbo.PREDAJCI

--stlpce sa daju manipulovat cez vypocty, pridavat nove stlpce cez uvodzovky a pod.
select 
--*,
 CENA*POCET_SKLADOM,
  'logosinfo' 
  from dbo.PRODUKTY

select MENO,
 Month(DATUM_NASTUP) as [mesiac nastupu],
 Year(DATUM_NASTUP) as [rok nastupu]
 from PREDAJCI

select *from PREDAJCI
 where not (DATUM_NASTUP<'19900101')
 
 select * from POBOCKY
 where VED<>108
 
 select * from PREDAJCI
 where PLAN_PREDAJ<=PREDAJ
 
 select * from PREDAJCI
 where PLAN_PREDAJ>PREDAJ
 
 ----nema stanoveny plan tj is null
  select * from PREDAJCI
 where PLAN_PREDAJ is null
 
 select * from OBJEDNAVKY
 where DATUM_OBJ >= '20021001' and DATUM_OBJ<='20021231'
 
 --between uzavrety rozsah, zahrna aj udanu hodnotu
 select * from OBJEDNAVKY
 where DATUM_OBJ between '20021001' and '20021231'
 
  select * from PRODUKTY
 where CENA between 100 and 200
 
 --IN najde hodnoty ktore obsahuju udaje v zatvorke, aj s malymi pismenami, nerozlisuje velke a male pismena
 select * from PRODUKTY
 where VYR_ID in ('ACI','BIC', 'IMM')
 
 select * from PRODUKTY
 where POCET_SKLADOM not in (3,0,24,50,12)
 
 --zastupny znak % namiesto * v exceli tj vsetky znaky -> zacina na s: s%, konci na s: %s, obsahuje s: %s%
 select * from ZAKAZNICI
 where SPOLOCNOST like '%s%'
 
 --zastupny znak _ namiesto jedneho znaku, tj druh pismeno je a: _a%
 select * from ZAKAZNICI
 where SPOLOCNOST like '_a%'
 
 --escape sekvencia pre zmena zastupneho znaku na realny znak, casto sa pouziva /, moze byt aj iny znak pre escape
 select * from ZAKAZNICI
 where SPOLOCNOST like '/_%' escape'/'
 
 --hladam nazvy ktore zacinaju rozsahom [a-d] alebo [abcd]
  select * from ZAKAZNICI
 where SPOLOCNOST like '[a-d]%'
 
 --hlada prve aj druhe pismeno
  select * from ZAKAZNICI
 where SPOLOCNOST like '[abcd][abd]%'
 
 --znak ^ neguje rozsah teda ten ktory nezacina na a: ^a
  select * from ZAKAZNICI
 where SPOLOCNOST like '[^a][abd]%'
 
 select * from PREDAJCI
 where PRED_POB in (22,11,12)
 or (VEDUCI is null
 and DATUM_NASTUP <'20020801')
 or (PREDAJ> PLAN_PREDAJ and PREDAJ<600000)
 
 --union je zjednotenie viacerych prikazov, avsak musim na zobrazenie z viacerych tabuliek dodrzat rovnaky pocet stlpcov a rovnake datove typy
 --priznak union all ne/zobrazi duplicity?
 select VYR_ID,PRODUKT_ID,'produkty' from  dbo.PRODUKTY
 where CENA>2000
 union all
 select VYR,PRODUKT, 'objednavky' from OBJEDNAVKY
 where CIASTKA >=30000
 
 select VYR_ID,PRODUKT_ID,'produkty' from  dbo.PRODUKTY
 where CENA>2000
 intersect
 select VYR,PRODUKT, 'objednavky' from OBJEDNAVKY
 where CIASTKA >=30000
 
 --definuje tabulku.stlpec, da sa aj bez stlpca ale potom moze byt skresleny vysledok ak su rovnake nazvy stlpcov
 select * from ZAKAZNICI, OBJEDNAVKY
 where OBJEDNAVKY.ZAKAZNIK=ZAKAZNICI.CISLO_ZAK
 
 --alias je skratka tabulky pre dalsie pouzitie
 select O.CISLO_OBJ, Z.SPOLOCNOST from ZAKAZNICI Z, OBJEDNAVKY O
 where O.ZAKAZNIK=Z.CISLO_ZAK
 
 --cez prikaz select ... from atd sa predlzuje vypocet, najprv urobi pc vsetky kombinacie potom zuzuje vyber podla prikazu
 --rychlejsia metoda je cez Join:
 select O.CISLO_OBJ, Z.SPOLOCNOST
 from ZAKAZNICI Z inner join OBJEDNAVKY O on Z.CISLO_ZAK=O.ZAKAZNIK
 
 --spojenie inner join potrebuje zaznamy z oboch tabuliek, vytiahne len tie pary ktore maju hodnotu v oboch tabulkach
 --outer join moze byt left, right alebo full, pricom outer nepiseme  
 --spojenie left join vytiahne vsetkych predajcov, priradi pary a tie ktore nemaju pary tym priradi null,
 -- right join vytiahne vsetky pobocky a priradi pary pripadne null z predajcov
 --full join zoberie vsetky pary aj hodnoty z oboch tabuliek bez paru
 --cross join sparuje vsetko so vsetkym, rovnako ako prikaz from bez join
   
   select PE.MENO,PO.MESTO
  from PREDAJCI PE inner join POBOCKY PO on PE.PRED_POB=PO.POBOCKA
  
  select PE.MENO,PO.MESTO
  from PREDAJCI PE left join POBOCKY PO on PE.PRED_POB=PO.POBOCKA
 
 select PE.MENO,PE.POZICIA, PO.MESTO
  from POBOCKY PO inner join PREDAJCI PE  on PO.VED=PE.CISLO_ZAM
  
  select PE.MENO,PE.POZICIA, PO.MESTO
  from POBOCKY PO inner join PREDAJCI PE  on PO.VED=PE.CISLO_ZAM
  where PO.PREDAJ>600000
  
  --vyber join s tabulkou s dvojitym primarnym klucom cez and
  select PR.POPIS,OB.CIASTKA 
  from OBJEDNAVKY OB inner join PRODUKTY PR on OB.VYR=PR.VYR_ID and OB.PRODUKT=PR.PRODUKT_ID
  
  --vyber vyrobku ktory nie je na ziadnej objednavke
  select PR.POPIS,OB.CIASTKA 
  from OBJEDNAVKY OB right join PRODUKTY PR on OB.VYR=PR.VYR_ID and OB.PRODUKT=PR.PRODUKT_ID
  where OB.CIASTKA is null
  
  --ak pouzivame jednu tabulku viackrat, je vhodne pouzit iny alias pre tu istu tabulku, tak mozeme vyuzivat vazby na viacero stlpcov
  select OB.CIASTKA,PE.MENO,ZA.SPOLOCNOST, PE2.MENO
  from 
  OBJEDNAVKY OB 
  inner join ZAKAZNICI ZA on OB.ZAKAZNIK=ZA.CISLO_ZAK
  inner join PREDAJCI PE on PE.CISLO_ZAM=OB.PREDAJCA
  inner join PREDAJCI PE2 on PE2.CISLO_ZAM=ZA.ZAK_PREDAJCA
  where OB.CIASTKA>25000
  
  select PE.MENO as zamestnanec, PE2.MENO as veduci
  from PREDAJCI PE
  inner join PREDAJCI PE2 on PE.VEDUCI=PE2.CISLO_ZAM
  --where PE.VEDUCI=PE.CISLO_ZAM
  
  select PE.MENO, PE.PREDAJ, PO.MESTO,PE.PREDAJ-PE.PLAN_PREDAJ
  from PREDAJCI PE
  inner join POBOCKY PO on PE.PRED_POB=PO.POBOCKA
  where not PE.PREDAJ<PE.PLAN_PREDAJ
  
 select PE.MENO, PE.PREDAJ, PO.MESTO,PE.PREDAJ-PE.PLAN_PREDAJ as odchylka
  from PREDAJCI PE
  inner join POBOCKY PO on PE.PRED_POB=PO.POBOCKA
  where PO.PREDAJ<PO.PLAN_PREDAJ
  and PE.PREDAJ-PE.PLAN_PREDAJ<0
  
  select AVG (PE.PREDAJ) as [priemerny predaj] , AVG(PE.PLAN_PREDAJ) as [priemerny plan predaja] 
  from PREDAJCI PE
  where PE.PLAN_PREDAJ is not null
  
  select AVG (PE.VEK) from PREDAJCI PE
  
  select sum (PE.PREDAJ) as [celkom predaj] , sum(PE.PLAN_PREDAJ) as [celkom plan predaja] 
  from PREDAJCI PE
  
  select sum (OB.CIASTKA) as [celkom predaj] , COUNT (OB.CIASTKA)
  from 
  PREDAJCI PE
  inner join OBJEDNAVKY OB on OB.PREDAJCA=PE.CISLO_ZAM
  where PE.MENO like '%bill adams%'
  
    select COUNT (*)  from PREDAJCI PE
  
  --distinct vyberie jedinencne hodnoty, pocet alebo nazvy:
    select COUNT (distinct POZICIA)  from PREDAJCI PE
	select distinct pozicia from PREDAJCI
  
    select COUNT (distinct oblast)  from POBOCKY
	select distinct OBLAST from POBOCKY

 --najstarsia (min) a najmladsia (max datum) objednavka
select MIN(DATUM_OBJ),Max(DATUM_OBJ)  from OBJEDNAVKY

select max (predaj-plan_predaj) from PREDAJCI

--jeden prikaz select nam vypocita hodnotu ktoru dosadime do dalsieho prikazu vyberu (vnorime do vyberu):
select * from PREDAJCI PE
where pe.PREDAJ -pe.PLAN_PREDAJ= (select max (pe2.predaj-pe2.plan_predaj) from PREDAJCI PE2)

select COUNT(distinct ZAKAZNIK) from OBJEDNAVKY

select * from ZAKAZNICI
where CISLO_ZAK not in (select distinct zakaznik from OBJEDNAVKY)

--suma objednavok podla zakaznika, cez group by zhrnie podla zakaznika
select zakaznik, SUM(ciastka) as celkom, COUNT(*) as pocet
from OBJEDNAVKY
group by ZAKAZNIK
--having vyberie len tie hodnoty ktore splnaju podmienku, avsak vyber vykona az po group by cize vybera zo zoskupenych riadkov,
--pricom where vybera este pred zoskupenim
having COUNT(*)>=2
--zoradi vyber podla stlpca cislo 3 (pocet), potom podla stlpca 2 (celkom)
--order by 3,2
--order zoradi desc (zostupne) alebo asc (vzostupne)
order by pocet desc,celkom desc

--select top vyberie len top 2 zakaznikov, dava vsak zmysel len ked je vyber zoradeny teda spolu s order by
select top 2 zakaznik, SUM(ciastka) as celkom, COUNT(*) as pocet
from OBJEDNAVKY
group by ZAKAZNIK
having COUNT(*)>=2
order by pocet desc,celkom desc

--celkova hodnota objednavok pre dvojicu zakaznik predajca
select OB.ZAKAZNIK,ob.PREDAJCA,sum(OB.CIASTKA) as [celkova hodnota objednavok] 
from 
OBJEDNAVKY OB
group by OB.ZAKAZNIK, OB.PREDAJCA

--vo vystupe zobrazi len hodnoty s funkciou alebo podla zoskupenia, teda kazdy stlpec musi byt aj v group by aby ho zobrazilo
select OB.ZAKAZNIK,ZA.SPOLOCNOST,OB.PREDAJCA,PE.MENO,sum(OB.CIASTKA) as [celkova hodnota objednavok] 
from 
OBJEDNAVKY OB
inner join ZAKAZNICI ZA on OB.ZAKAZNIK=ZA.CISLO_ZAK
inner join	PREDAJCI PE on OB.PREDAJCA=PE.CISLO_ZAM
group by OB.ZAKAZNIK, OB.PREDAJCA,ZA.SPOLOCNOST,PE.MENO 

select PO.POBOCKA,PO.MESTO,PO.PLAN_PREDAJ,PO.PREDAJ
from
POBOCKY PO
inner join PREDAJCI PE on PO.POBOCKA=PE.PRED_POB
group by PO.POBOCKA,PO.PLAN_PREDAJ,PO.PREDAJ,PO.MESTO
having count(PE.CISLO_ZAM) >=2

--------------------------------------------------------------------------
--2.den nove query



