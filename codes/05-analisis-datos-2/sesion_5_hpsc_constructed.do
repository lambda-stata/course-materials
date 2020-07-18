/********************************************************************************
* Título:	Construcción de datos
* Sesion: 	Sesión 5
* Autor:	Rony Rodriguez-Ramirez
* Proposito: Crear base al nivel HPSC constructed (construída)
*********************************************************************************
	
*** Outline:
	1. 	Reshaping variables
		1.1 Cargar base de datos
		1.1 Reshaping data to plot season level		
	
	Input: 	agr_merge_hps_hpsc
	Output: agr_merge_hps_hpsc_constructed
	
*********************************************************************************
***	PART 1: Reshaping variables
********************************************************************************/
	
*** 1.1 Cargar base de datos
	use "${data_2_2}/agr_merge_hps_hpsc.dta", clear 

*** 1.2 Income variables: ¿Cuál sería el merge enfoque para hacer la variable ingreso? 
	bys 	hhid plot season: gen income = sell_kg * price_1 if crop == 1
	replace income = sell_kg * price_2 if crop == 2
	replace income = . if sell_kg == 0 
	
	bys 	hhid plot season: egen income_total = total(income)
	bys 	hhid: egen income_hh = total(income)
	
	collapse (sum) income, by(hhid)
	
	// 1.1.6 Save 
	save "${data_3_1}/agr_merge_hps_hpsc_constructed.dta", replace

