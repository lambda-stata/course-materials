/********************************************************************************
* Título:	Construcción de datos
* Sesion: 	Sesión 4
* Autor:	Rony Rodriguez-Ramirez
* Proposito: Crear base al nivel HPSC
*********************************************************************************
	
*** Outline:
	1. 	Reshaping variables
		1.1 Cargar base de datos
		1.1 Reshaping data to plot season level		
	
	Input: 	agr_wide_nodup_cleaned
	Output: agr_hpsc
	
*********************************************************************************
***	PART 1: Reshaping variables
********************************************************************************/
	
*** 1.1 Cargar base de datos
	use "${data_2_1}/agr_wide_nodup_cleaned.dta", clear 

*** 1.1 Reshaping data to plot season crop level	

	// 1.1.1 Keep variables relevantes
	keep 	hhid 		    ///
        seed_kg* 	  ///
        harv_kg* 	  ///
        consum_kg* 	///
        sell_kg* 	

	// 1.1.2 Reshape
	reshape long seed_kg harv_kg consum_kg sell_kg, ///
    i(hhid) j(rshp_id) string
		
	// 1.1.3 Label vars
	label var seed_kg 	"Semila: Plot P in Season S of Crop C"
	label var harv_kg 	"Cosecha: Plot P in Season S of Crop C"
	label var consum_kg	"Consumo: Plot P in Season S of Crop C"
	label var sell_kg 	"Venta: Plot P in Season S of Crop C"
	
	// 1.1.4 Generate IDs per plot season crop
	gen plot    = substr(rshp_id, 3, 1)
	gen season  = substr(rshp_id, 5, 1)
	gen crop    = substr(rshp_id, 7, 1)
	
	label var plot 		"Plot Code"
	label var season 	"Season Code"
	label var crop		"Crop Code"
	
	drop rshp_id
	foreach var in plot season crop {
		destring `var', replace
	}
	
	// 1.1.5 Order and Keep
	order hhid plot season crop 
  
  // 1.1.6 Check duplicates
  duplicates report hhid plot season crop
	
	// 1.1.6 Save 
	save "${data_2_1}/agr_hpsc.dta", replace


