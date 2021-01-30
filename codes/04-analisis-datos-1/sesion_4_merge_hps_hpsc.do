/********************************************************************************
* Título:		Construcción de datos
* Sesion: 		Sesión 4
* Autor:		Rony Rodriguez-Ramirez
* Proposito: 	Merge entre HPS y HPSC
*********************************************************************************
	
*** Outline:
	1. Merge
		1.1 Cargar bases de datos
		1.2 Merge
		1.3 Second merge
	
	Input: 	
	Output: 
	
*********************************************************************************
***	PART 1: Merge
********************************************************************************/

*** 1.1 Cargar bases de datos
	use "${data_2_1}/agr_hps.dta", clear 
	
	capture isid hhid plot season 
	if (_rc == 459) {
	    display "Esta base de datos no está a nivel de hogar plot season"
	}
	
*** 1.2 Merge 		
	merge 1:m hhid plot season using "${data_2_1}/agr_hpsc.dta", assert(3)
	drop _merge 
	
	// Sort
	sort hhid plot season crop 
	
	// Order
	order hhid plot season crop, first 

	/* 
	Notes: Todas las observaciones fueron unidas exitosamente
	
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                            24,408  (_merge==3)
    -----------------------------------------
	*/ 
	
*** 1.3 Merge
	merge m:1 hhid using "${data_2_1}/agr_wide_nodup_cleaned.dta", ///
		keepusing(treatment village) assert(3)
	drop _merge 
	
	/* 
	Notes: Todas las observaciones fueron unidas exitosamente
	Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                            24,408  (_merge==3)
    -----------------------------------------
	*/
		
*** 1.4 Order and keep
	order hhid plot season crop treatment village 
	
	
*** 1.5 Merge with prices
	merge m:1 hhid crop using "${data_2_1}/agr_hc_price.dta",		///
		assert(3)
	drop _merge
	
	
*** 1.5 Guardar base de datos
	save "${data_2_2}/agr_merge_hps_hpsc.dta", replace
	


