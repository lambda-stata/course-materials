/********************************************************************************
* Título:		Construcción de datos
* Sesion: 		Sesión 4
* Autor:		Rony Rodriguez-Ramirez
* Proposito: 	Crear base al nivel de crop
*********************************************************************************
	
*** Outline:
	1. 	Reshaping variables
		1.1 Cargar base de datos
		1.2 Keep variables
		1.3 Reshape
		1.4 Rename
		1.5 Label variables
		1.6 Save dataset
	
	Input: 	agr_wide_nodup_cleaned
	Output: agr_hc_price
	
*********************************************************************************
***	PART 1: Reshaping variables
********************************************************************************/

	
*** 1.1 Load data
	use "${data_2_1}/agr_wide_nodup_cleaned.dta", clear 
	
*** 1.2 Keep variables
	keep 	hhid 	    ///
        price_* 
			
*** 1.3 Reshape
	reshape long price_, i(hhid) j(crop)

*** 1.4 Rename
	rename *_ *
	
*** 1.5 Label var
	label var crop 	"Crop code"
	label var price "Price of crop"
	
*** 1.6 Save dataset
	save "${data_2_1}/agr_hc_price.dta", replace
	

	
	
	