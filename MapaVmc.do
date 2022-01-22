sc install spmap
ssc install shp2dta
ssc install mif2dta
cd C:\Users\eliot\Documents\MapGeo\conjunto_de_datos
clear
shp2dta using 00mun, database(dbMex) coordinates(coMex) genid(id) genc(c)
use dbMex, clear
spmap using coMex, id(id)

import excel "C:\Users\eliot\Documents\ProbabilidadyEst 2021-2022\VMC.xlsx", sheet("VMC") firstrow

destring TT, g(T_T) force
destring AT, g(A_T) force
destring CP, g(C_P) force
destring CCC, g(C_CC) force
destring M, g(M_M) force
browse 

rename CVE_MUN CVEGEO
sa vmc.dta, replace
use dbMex, clear
mer 1:1 CVEGEO using "vmc.dta", nogen force

* Mapa: Autompoviles en Circulación  
spmap A_T using coMex, id(id) title("México: Autompoviles en Circulación , 2020", size(*0.7) position(1)) subtitle (" ""Autompoviles" " ", size(*0.6) position(1)) note("Fuente: elaboración propia con datos de Censo Económico, 2019", size(*.5)) fcolor (Greens2) legend(ring(1) position(3)) legstyle(2) legend(ring(1) position(3)) plotregion(icolor(none)) graphregion(icolor(none))

* Mapa: Autompoviles en Circulación CDMX  
spmap A_T using coMex, id(id) title("México: Automóviles en Circulación , 2020", size(*0.7) position(1)) note("Fuente: elaboración propia con datos de INEGI, 2020", size(*.5)) fcolor (Blues2) legend(ring(1) position(3)) legstyle(2) legend(ring(1) position(3)) plotregion(icolor(none)) graphregion(icolor(none))

* Mapa: Camiones de pasajeros en Circulación  
spmap C_P using coMex, id(id) title("México: Camiones para pasajeros en Circulación, 2020", size(*0.7) position(1)) note("Fuente: elaboración propia con datos de INEGI, 2020", size(*.5)) fcolor (Reds2) legend(ring(1) position(3)) legstyle(2) legend(ring(1) position(3)) plotregion(icolor(none)) graphregion(icolor(none))

* Mapa: Camiones de pasajeros en Circulación CDMX
spmap C_P if CVE_ENT=="09" using coMex, id(id) title("Ciudad de México: Camiones para pasajeros en Circulación , 2020", size(*0.5) position(1)) note("Fuente: elaboración propia con datos de INEGI 2020", size(*.3)) fcolor (Blues) legend(ring(1) position(3)) legstyle(2) legend(ring(1) position(3)) plotregion(icolor(none)) graphregion(icolor(none))

* Mapa: Motocicletas en Circulación 
spmap M_M using coMex, id(id) title("México: Motocicletas en Circulación, 2020", size(*0.7) position(1)) note("Fuente: elaboración propia con datos de INEGI, 2020", size(*.5)) fcolor (Greens) legend(ring(1) position(3)) legstyle(2) legend(ring(1) position(3)) plotregion(icolor(none)) graphregion(icolor(none))

* Mapa: Motocicletas en Circulación CDMX
spmap M_M if CVE_ENT=="09" using coMex, id(id) title("Ciudad de México: Motocicletas en Circulación , 2020", size(*0.5) position(1)) note("Fuente: elaboración propia con datos de INEGI 2020", size(*.3)) fcolor (Reds) legend(ring(1) position(3)) legstyle(2) legend(ring(1) position(3)) plotregion(icolor(none)) graphregion(icolor(none))



