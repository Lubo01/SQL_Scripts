
--2. den
--poddotazy

--uloha 41
--subquery musi vratit len jednu hodnotu, ak je where podmienka = , inak vyhodi chybu
select * from ZAKAZNICI
where ZAK_PREDAJCA=
(select CISLO_ZAM from PREDAJCI where MENO='Bill Adams')

--moze byt viac vysledkov subquery ak je where podmienka in
select * from ZAKAZNICI
where ZAK_PREDAJCA in
(select CISLO_ZAM from PREDAJCI where MENO like '%ll%')

--42
select * 
from 
PRODUKTY
where POCET_SKLADOM>
--(subquery)
(select POCET_SKLADOM 
from 
PRODUKTY
where VYR_ID = 'ACI' and PRODUKT_ID = '41004')

--uvedie subquery aj v select a zobrazi sa vo vystupe
select * , (select POCET_SKLADOM 
from 
PRODUKTY
where VYR_ID = 'ACI' and PRODUKT_ID = '41004') as [skladom ACI]
from 
PRODUKTY
where POCET_SKLADOM>
--(subquery)
(select POCET_SKLADOM 
from 
PRODUKTY
where VYR_ID = 'ACI' and PRODUKT_ID = '41004')

--43

select * 
from PREDAJCI PE
where PE.PRED_POB in
(select PO.POBOCKA from POBOCKY PO
where PO.PREDAJ > PO.PLAN_PREDAJ)

--zoznam zamestnancov, ktori maju na starosti viac ako 3 zakaznikov
--subquery sa dotazuje na hodnotu z hlavneho query (PE.CISLO_ZAM), tj subquery sa neda samostatne spustit len cela query spolu
select * 
from PREDAJCI PE
where 
(select count(*) from ZAKAZNICI ZA
where ZA.ZAK_PREDAJCA = PE.CISLO_ZAM)>=3

--45
select *
from PREDAJCI PE
where PE.PRED_POB in
(select POBOCKA 
from POBOCKY PO
where PO.VED<>108)

--47

select * from PRODUKTY PR
where 0<
(select COUNT(*) from OBJEDNAVKY OB 
where OB.CIASTKA > 25000 and
OB.VYR=PR.VYR_ID and
OB.PRODUKT = PR.PRODUKT_ID)

--alternativa s prikazom 'exists', rychlejsi vyber vysledkov, da pouzit aj 'not exists'
select * from PRODUKTY PR
where exists
(select * from OBJEDNAVKY OB 
where OB.CIASTKA > 25000 and
OB.VYR=PR.VYR_ID and
OB.PRODUKT = PR.PRODUKT_ID)

--vyber vyrobkov pre ktore neexistuje ziadna objednavka
select * from PRODUKTY PR
where not exists
(select * from OBJEDNAVKY OB 
where 
OB.VYR=PR.VYR_ID and
OB.PRODUKT = PR.PRODUKT_ID)

--50

select * from PREDAJCI PE
where exists(
select * from OBJEDNAVKY OB
where OB.PREDAJCA=PE.CISLO_ZAM and
OB.CIASTKA>PE.PLAN_PREDAJ*0.1)

--alternativa s 'any' , realne any nepotrebujem pretoze da sa nahradit so subquery a exists ako vyssie uvedene
select * from PREDAJCI PE
where PE.PLAN_PREDAJ*0.1<any (
select OB.CIASTKA from OBJEDNAVKY OB
where OB.PREDAJCA=PE.CISLO_ZAM) 

--alternativa s 'all' kedy vsetky objednavky su nad 10 percent planu, pozor zoberie aj hodnoty kedy nevie subquery vyhodnotit
select * from PREDAJCI PE
where PE.PLAN_PREDAJ*0.1<all (
select OB.CIASTKA from OBJEDNAVKY OB
where OB.PREDAJCA=PE.CISLO_ZAM) 

--neexistuje ziadna objednavka mensia ako 10 percent planu
select * from PREDAJCI PE
where not exists(
select * from OBJEDNAVKY OB
where OB.PREDAJCA=PE.CISLO_ZAM and
OB.CIASTKA<PE.PLAN_PREDAJ*0.1)

--plus osetrime k tomu predajcov ktori nemaju plan
select * from PREDAJCI PE
where not exists(
select * from OBJEDNAVKY OB
where OB.PREDAJCA=PE.CISLO_ZAM and
OB.CIASTKA<PE.PLAN_PREDAJ*0.1) and
PE.PLAN_PREDAJ is not null

--ktory predaj nesedi s objednavkami, plus union

select PE.MENO, PE.PREDAJ,
(select SUM(CIASTKA) from OBJEDNAVKY OB 
where  OB.PREDAJCA=PE.CISLO_ZAM)  as [obj]
from PREDAJCI PE
where PE.PREDAJ <> 
(select sum(ciastka) from OBJEDNAVKY OB 
where  OB.PREDAJCA=PE.CISLO_ZAM)
union
select PE.MENO, PE.PREDAJ,0 from PREDAJCI PE
where not exists (select * from OBJEDNAVKY OB
where  OB.PREDAJCA=PE.CISLO_ZAM)

--alternativa s group by namiesto where potrebuje join, 
-- subquery sa priradi T ako nova 'tabulka', tabulka vsak musi mat nazov stlpca (predajca, obj)
select PE.MENO, PE.PREDAJ, T.obj from PREDAJCI PE
left join
(select ob.PREDAJCA as predajca, sum(ciastka) obj from OBJEDNAVKY OB 
group by OB.PREDAJCA) T
on T.predajca=PE.cislo_zam

--case - rozvrstvi tabulku na viac vrstiev, kategorii, case funguje zhora nadol a pri splneni podmienky skonci kategoriu
--vyber meno zamestnanca a kategoriu
--do case je mozne vnorit poddotazy
select PE.MENO, PE.VEK,
case when VEK<=30 then 'A'
	 when VEK<=50 then 'B'
else 'C'
end
from PREDAJCI PE
order by VEK

select PE.MENO, PE.VEK,
case when VEK<=30 then 'A'
	 when (VEK<=50 and VEK>30) then 'B'
else 'C'
end as kategoria
from PREDAJCI PE
order by VEK

select PE.MENO, PE.VEK,
kategoria =
case when VEK<=30 then 'A'
	 when (VEK<=50 and VEK>30) then 'B'
else 'C'
end 
from PREDAJCI PE
order by VEK

--alternativa bez case
select meno,vek, 'A'
from predajci where vek<=30
union
select meno, vek, 'B'
from PREDAJCI where VEK between 30 and 50
union
select meno, vek, 'C'
from PREDAJCI where VEK > 50

--48
--dva priklady s predpokladom rovnakeho vysledku, pricom davaju rozdielne vysledky kvoli zakaznikom ktori nemaju objednavky
select * from ZAKAZNICI ZA
where ZA.ZAK_PREDAJCA =
(select PE.CISLO_ZAM from PREDAJCI PE
where PE.MENO like '%Sue%') 
and not exists (select * from OBJEDNAVKY OB where OB.CIASTKA>3000 and ZA.CISLO_ZAK=ob.ZAKAZNIK)

--alternativa s inym vysledkom
select ZA.* from ZAKAZNICI ZA
inner join OBJEDNAVKY OB on ZA.CISLO_ZAK = OB.ZAKAZNIK
inner join PREDAJCI PE on PE.CISLO_ZAM=ZA.ZAK_PREDAJCA
where OB.CIASTKA<=3000 and PE.MENO like '%Sue%'


select * from ZAKAZNICI ZA
where ZA.ZAK_PREDAJCA =
(select PE.CISLO_ZAM from PREDAJCI PE
where PE.MENO like '%Sue%') 
and not exists (select * from OBJEDNAVKY OB where OB.CIASTKA>3000 and ZA.CISLO_ZAK=ob.ZAKAZNIK)
UNION
select * from ZAKAZNICI ZA
where 
exists (select * from OBJEDNAVKY OB where OB.CIASTKA<3000 and ZA.CISLO_ZAK=ob.ZAKAZNIK
and  OB.PREDAJCA= (select PE.CISLO_ZAM from PREDAJCI PE
where PE.MENO like '%Sue%') )


--spajanie retazcov (string-ov) je cez +
select 'aa'+'bb'

--64
select OB.VYR, MONTH(OB.DATUM_OBJ),SUM (ciastka) as predaj from OBJEDNAVKY OB
group by OB.VYR,MONTH(OB.DATUM_OBJ)
order by 1,2

--alternativa s mesiacmi v stlpcoch, nie je preferovane pre databazu len na citanie
select vyr,
sum(case when MONTH(OB.DATUM_OBJ)=1 then ciastka end) 'I',
sum(case when MONTH(OB.DATUM_OBJ)=2 then ciastka end)'II',
sum(case when MONTH(OB.DATUM_OBJ)=3 then ciastka end)'III',
sum(case when MONTH(OB.DATUM_OBJ)=4 then ciastka end)'IV',
sum(case when MONTH(OB.DATUM_OBJ)=5 then ciastka end)'V',
sum(case when MONTH(OB.DATUM_OBJ)=6 then ciastka end)'VI'
from OBJEDNAVKY OB
group by OB.VYR
--order by 1,2

--coalesce funkcia nahradi null v priklade nulou
select vyr,
coalesce (sum(case when MONTH(OB.DATUM_OBJ)=1 then ciastka end),0) 'I',
coalesce (sum(case when MONTH(OB.DATUM_OBJ)=2 then ciastka end),0)'II',
coalesce (sum(case when MONTH(OB.DATUM_OBJ)=3 then ciastka end),0)'III',
coalesce (sum(case when MONTH(OB.DATUM_OBJ)=4 then ciastka end),0)'IV',
coalesce (sum(case when MONTH(OB.DATUM_OBJ)=5 then ciastka end),0)'V',
coalesce (sum(case when MONTH(OB.DATUM_OBJ)=6 then ciastka end),0)'VI'
from OBJEDNAVKY OB
group by OB.VYR


select meno, coalesce(PLAN_PREDAJ, 0) as [plan] from PREDAJCI


--convert datatype, dolezity aj style
select meno, 'rokov: '+CONVERT(varchar(3),vek)
, CONVERT(varchar, DATUM_NASTUP,104), 
convert (varchar,Dateadd(m,14,DATUM_NASTUP),104)
from PREDAJCI

--datediff funkcia na rozdiel datumov
select meno, 'rokov: '+CONVERT(varchar(3),vek)
, CONVERT(varchar, DATUM_NASTUP,104), 
convert (varchar,Dateadd(m,14,DATUM_NASTUP),104),
datediff(mm,datum_nastup,getdate())
from PREDAJCI


--59
select * from PREDAJCI PE
where PE.VEK>40
and exists (select * from PREDAJCI PE2 where PE2.VEDUCI=PE.CISLO_ZAM
and (PE2.PREDAJ>PE2.PLAN_PREDAJ or PE2.PLAN_PREDAJ is null))