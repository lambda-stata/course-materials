/********************************************************************************
* Título:	Construcción de datos
* Sesion: 	Sesión 5
* Autor:	Rony Rodriguez-Ramirez
* Proposito: Crear base al nivel HPSC constructed (construída)
*********************************************************************************
	
*** Outline:
	1. 	Reshaping variables
		1.1 Cargar base de datos
		1.2 Income variables.
		1.3 Save
	
	Input: 	agr_merge_hps_hpsc
	Output: agr_merge_hps_hpsc_constructed
	
*********************************************************************************
***	PART 1: Reshaping variables
********************************************************************************/
	
*** 1.1 Cargar base de datos
	use "${data_2_2}/agr_merge_hps_hpsc.dta", clear 

*** 1.2 Income variables: ¿Cuál sería el merge enfoque para hacer la variable ingreso? 

	/* Nota: 
	Variable ingreso es construída a nivel de HH Plot Season, y es la multiplicación 
	de venta y el precio que es constante por cada crop
	
	Hemos mandado a missing los ingresos cuando no hubo venta (o intención de venta).
	*/ 
	
	// El primer income es el que utilizaremos para nuestras tablas
	bys hhid plot season: gen income = sell_kg * price
	replace income = . if sell_kg == 0
	
	/* Otros ejemplos de income (sus niveles de observación son diferentes)
	bys hhid plot season: egen income_total = total(income)
	bys hhid: egen income_hh = total(income)
	
	// Collapse 
	tempfile 	dataset
	save 		`dataset'

	collapse (sum) income, by(hhid)
	
	merge 1:m hhid using `dataset', keepusing(treatment village)
	*/
	
	label var income "Ingreso por plot season crop"
	
	// 1.3 Save 
	save "${data_3_1}/agr_merge_hps_hpsc_constructed.dta", replace

