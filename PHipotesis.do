********************************************************************
* ENIF 2018
* https://www.inegi.org.mx/programas/enif/2018/#Microdatos

cd "C:\Users\MI04832\Desktop\ENIF 2018"

local datasets "tvivienda tsdem tmodulo tmodulo2"
foreach dataset of local datasets {
	import dbase "`dataset'.dbf", clear
	save "`dataset'", replace
}

use tvivienda.dta, clear
merge 1:m UPM VIV_SEL using tsdem, nogenerate keep(3)
merge m:1 UPM VIV_SEL HOGAR N_REN using tmodulo, nogenerate keep(3)
merge m:1 UPM VIV_SEL HOGAR N_REN using tmodulo2, nogenerate keep(3)
********************************************************************

/* 1 ¿La proporción de hombres que lleva un presupuesto o un registro de sus ingresos y gastos es mayor a la de las mujeres? */
generate ppto = 0 if P4_1 == "2"
replace ppto = 1 if P4_1 == "1"
generate ppto_hom = 0 if ppto == 0 & SEXO == "1"
replace ppto_hom = 1 if ppto == 1 & SEXO == "1"
generate ppto_muj = 0 if ppto == 0 & SEXO == "2"
replace ppto_muj = 1 if ppto == 1 & SEXO == "2"
prtest ppto_hom = ppto_muj
/* Respuesta:
diff = ppto_hom - ppto_muj
H0: diff <= 0
Ha: diff > 0
p-value > 0.05 → No se rechaza H0. La proporción de hombres que lleva un presupuesto o registro de sus ingresos y gastos NO es mayor a las de las mujeres.
*/

/* 2) ¿La proporción de mujeres que tienen y utilizan tarjeta departamental es mayor a la de los hombres? */
generate t_tdc = 0 if P6_8_1 == "2"
replace t_tdc = 1 if P6_8_1 == "1"
destring P6_13, replace
generate tyu_tdc = 0 if P6_8_1 == "1" & P6_13 == 0
replace tyu_tdc = 1 if P6_8_1 == "1" & P6_13 >= 1 & P6_13 <= 88
generate tyu_tdc_hom = 0 if tyu_tdc == 0 & SEXO == "1"
replace tyu_tdc_hom = 1 if tyu_tdc == 1 & SEXO == "1"
generate tyu_tdc_muj = 0 if tyu_tdc == 0 & SEXO == "2"
replace tyu_tdc_muj = 1 if tyu_tdc == 1 & SEXO == "2"
prtest tyu_tdc_muj = tyu_tdc_hom
/* Respuesta:
diff = tyu_tdc_muj - tyu_tdc_hom
H0: diff <= 0
Ha: diff > 0
p-value > 0.05 → No se rechaza H0. La proporción de mujeres que tienen y utilizan tarjeta departamental NO es mayor a la de los hombres.
*/

/* 3) En las zonas rurales, ¿la proporción de personas con cuenta de ahorro o nómina es igual entre hombres y mujeres? */
generate rural = 0 if TLOC == "1" | TLOC == "2" | TLOC == "3"
replace rural = 1 if TLOC == "4"
generate cta = 0 if P5_9_1 == "2" & P5_9_4 == "2"
replace cta = 1 if P5_9_1 == "1" | P5_9_4 == "1"
generate cta_hom = 0 if cta == 0 & SEXO == "1"
replace cta_hom = 1 if cta == 1 & SEXO == "1"
generate cta_muj = 0 if cta == 0 & SEXO == "2"
replace cta_muj = 1 if cta == 1 & SEXO == "2"
prtest cta_hom = cta_muj if rural == 1
/* Respuesta:
diff = cta_hom - cta_muj
H0: diff = 0
Ha: diff != 0
p-value < 0.05 → Se rechaza H0. En las zonas rurales, la proporción de personas con cuenta de ahorro o nómina NO es igual entre hombres y mujeres.
*/

/* 4) ¿La proporción de personas con cuenta de ahorro o nómina en las zonas rurales es menor respecto a la de las zonas urbanas? */
generate cta_rur = 0 if cta == 0 & rur == 1
replace cta_rur = 1 if cta == 1 & rur == 1
generate cta_urb = 0 if cta == 0 & rur == 0
replace cta_urb = 1 if cta == 1 & rur == 0
prtest cta_rur = cta_urb
/* Respuesta:
diff = cta_rur - cta_urb
H0: diff >= 0
Ha: diff < 0
p-value < 0.05 → Se rechaza H0. En las zonas rurales, la proporción de personas con cuenta de ahorro o nómina SÍ es igual entre hombres y mujeres.
*/

/* 5) ¿La media de ingreso de las personas con cuenta de ahorro formal y tarjeta de crédito es mayor respecto a la de las personas con ahorro y crédito informal? Pista: Revisar preguntas de la ENIF 5.1 y 6.1 para la parte informal. */
destring P3_8A, replace
generate ingreso = 0
replace ingreso = P3_8A if P3_8A >= 1 & P3_8A <= 98000
generate formal = 1 if P5_9_4 == "1" & (P6_8_1 == "1" | P6_8_2 == "1")
generate informal = 1 if (P5_1_1 == "1" | P5_1_2 == "1" | P5_1_3 == "1" | P5_1_4 == "1" | P5_1_5 == "1" | P5_1_6 == "1") & (P6_1_1 == "1" | P6_1_2 == "1" | P6_1_3 == "1" | P6_1_4 == "1" | P6_1_5  == "1")
generate ing_formal = ingreso if formal == 1
generate ing_informal = ingreso if informal == 1
ttest ing_formal = ing_informal, unpaired
/* Respuesta:
diff = ing_f
H0: diff <= 0
Ha: diff > 0
p-value < 0.05 → Se rechaza H0. La media de ingreso de las personas con cuenta de ahorro formal y tarjeta de crédito SÍ es mayor respecto a la de las personas con ahorro y crédito informal.
*/

/* 6) ¿El promedio de ingreso de la población bancarizada con banca móvil es más alto en los jóvenes que en los adultos? Pista: Población joven es hasta los 29 años. */
generate bancam = 1 if P5_23 == "1"
destring EDAD, replace
generate joven = 1 if EDAD >= 0 & EDAD < 30
generate adulto = 1 if EDAD > 29 & EDAD <= 97
generate ing_joven = ingreso if joven == 1
generate ing_adulto = ingreso if adulto == 1
ttest ing_joven = ing_adulto if bancam == 1, unpaired
/* Respuesta:
H0: diff <= 0
Ha: diff > 0
p-value > 0.05 → No se rechaza H0. El promedio de ingreso de la población bancarizada con banca móvil NO es más alto en los jóvenes que en los adultos.
*/

/* 7) ¿La proporción de personas que pueden calcular los intereses compuestos y simples de un préstamo es más alto en los de nivel de educación superior respecto a los de menor nivel educativo? */
destring NIV, replace
generate superior = 0
replace superior = 1 if NIV >= 8 & NIV <= 9
generate sabe_ints = 0 if (P12_2 == "1" | P12_2 == "3" | P12_2 == "8" | P12_2 == "9") | (P12_3 == "2" | P12_3 == "3" | P12_3 == "8" | P12_3 == "9")
replace sabe_ints = 1 if P12_2 == "2" & P12_3 == "1"
generate sabe_ints_eb = 0 if sabe_ints == 0 & superior == 0
replace sabe_ints_eb = 1 if sabe_ints == 1 & superior == 0
generate sabe_ints_sup = 0 if sabe_ints == 0 & superior == 1
replace sabe_ints_sup = 1 if sabe_ints == 1 & superior == 1
prtest sabe_ints_sup = sabe_ints_eb
/* Respuesta:
H0: diff <= 0
Ha: diff > 0
p-value < 0.05 → Se rechaza H0. La proporción de personas que pueden calcular los intereses compuestos y simples de un préstamo SÍ es más alto en los de nivel de educación superior respecto a los de menor nivel educativo.
*/

