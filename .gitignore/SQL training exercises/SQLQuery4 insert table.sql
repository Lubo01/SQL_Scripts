USE [Priklad]
GO

/****** Object:  Table [dbo].[ZAKAZNICI]    Script Date: 06/30/2015 14:19:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ZAKAZNICI1](
	[CISLO_ZAK] [int] NULL,
	[SPOLOCNOST] [nvarchar](20) NULL,
	[ZAK_PREDAJCA] [int] NULL,
	[MAX_UVER] [money] NULL
) ON [PRIMARY]

GO


--pri vytvoreni novej tabulky sa da skopirovat struktura z inej tabulky napr.
-- cez Insert into zakaznici1
--select * from zakaznici

--insert into zakaznici1 (st1,st2,st3),value(10, 'abc',15)
--update zakaznici1 set stl1=10,stl2='abc'
update ZAKAZNICI1 set ZAK_PREDAJCA=106
where MAX_UVER<=50000

update PREDAJCI set DATUM_NASTUP=DATEADD(m,2, DATUM_NASTUP)
where POZICIA='sales rep'

--jednoducha zaloha tabulky do novej tabulky
select * into new_predajci1 from predajci

--zaloha s novou tabulkou aj s presunom do inej databazy
select * into cvicenie.dbo.new_predajci1 from predajci

--do novej databazy, avsak po jej zalozeni cez new Database... (prave tlacitko na databaze)
select * into nova.dbo.new_predajci1 from predajci

