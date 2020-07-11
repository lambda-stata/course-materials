/********************************************************************************
* Título:	Construcción de datos
* Sesion: 	Sesión 3
* Autor:	Rony Rodriguez-Ramirez
*********************************************************************************
	
*** Outline:
	1. Variable ID y Duplicados
		1.1 Cargar datos
		1.2 Duplicates and ID variable 
		1.3 Export duplicates
	2. Cleaning variables
		2.1 Cultivated and Irrigation
		2.2 Cultivated and Seed
	3. 	Reshaping variables
		3.1 Reshaping data to plot season level	
		3.2 Reshaping data to plot season crop level		
	
*********************************************************************************
***	PART 1: Variable ID y Duplicados
********************************************************************************/

*** 1.1 Cargar data
	use "${data_2_1}/agr_wide.dta", clear 
		
*** 1.2 Duplicates and ID variable
	capture isid hhid  
		
*** 1.3 Export duplicates
	duplicates report hhid 
	* duplicates drop hhid, force 
	
	// Soluciones
	gen key = _n 
	capture ieduplicates hhid using "${outputs_2_1}/duplicates/duplicates.xlsx", uniquevars(key) keepvars(*)
	
	iecompdup hhid, id(121978) didifference
	
	capture ieduplicates hhid using "${outputs_2_1}/duplicates/duplicates.xlsx", uniquevars(key) keepvars(*) force 	
		
*********************************************************************************
***	PART 2: Cleaning variables
*********************************************************************************
	
*** 2.1 Cultivated and Irrigation
	forvalues p = 1/2 {
		forvalues s = 1/3 {
			replace irr_P`p'S`s' = 0 if cult_P`p'S`s' == 0
		}
	}

*** 2.2 Cultivated and Seed
	forvalues p = 1/2 {
		forvalues s = 1/3 {
			forvalues c = 1/2 {
				replace seed_kg_P`p'S`s'C`c' = 0 if cult_P`p'S`s' == 0
			}
		}
	}
	
*********************************************************************************
***	PART 3: Reshaping variables
*********************************************************************************

*** 3.1 Reshaping data to plot season level	
	// Snapshot
	snapshot save 
	
	// Keep variables relevantes
	keep 	hhid 		///
			cult_* 		///
			irr_* 		

	// Reshape
	reshape long cult_ irr_, i(hhid) j(rshp_id) string
	
	// Rename 
	rename *_ *
	
	// Label vars
	* label var 
	* label var
	
	// Gen ID as number
	gen plot    = substr(rshp_id, 2, 1)
	gen season  = substr(rshp_id, 4, 1)	
	
	drop rshp_id
	foreach var in  plot season {
		destring `var', replace
	}	
	
	order hhid plot season 
	
	// Save
	save "${data_2_1}/agr_hps.dta", replace
	
*** 3.2 Reshaping data to plot season crop level	
	// Snapshot restore
	snapshot restore 1 
	
	// Keep variabels relevantes
	keep 	hhid 		///
			seed_kg* 	///
			harv_kg* 	///
			consum_kg* 	

	// Reshape
	reshape long seed_kg harv_kg consum_kg, i(hhid) j(rshp_id) string
	
	// Generate IDs per plot season crop
	gen plot    = substr(rshp_id, 3, 1)
	gen season  = substr(rshp_id, 5, 1)
	gen crop    = substr(rshp_id, 7, 1)
	
	drop rshp_id
	foreach var in  plot season crop {
		destring `var', replace
	}
	
	// Order and Keep
	order hhid plot season crop 
	
	// Save 
	save "${data_2_1}/agr_hpsc.dta", replace

*********************************************************************************
*** APPENDIX: CREATING THE DUMMY VARIABLE
*********************************************************************************	

*** Creating dummy data using 2 plots, 3 seasons, and 2 crops and assigning random values 
	clear all
	set obs 2034
	gen hhid = .
	label var hhid "Household ID"
	
	// HHID
	forvalues h = 1/2034 {
		replace hhid = 120000 + `h' in `h'
	}
	
	// Seed, Harvest, Consum, 2 Plots 3 Seasons 2 Crops
	forvalues p = 1/2 {
		forvalues s = 1/3 {
			gen 		cult_P`p'S`s' = cond(runiform() < 0.5, 0, 1)
			label var 	cult_P`p'S`s' "Cultivated: Plot P in Season S "
				
			gen irr_P`p'S`s' = cond(runiform() < 0.5, 0, 1)
			label var irr_P`p'S`s' "Irrigated: Plot P in Season S "
		
			forvalues c = 1/2 {				
				gen 		seed_kg_P`p'S`s'C`c' = runiform(1,20)
				label var 	seed_kg_P`p'S`s'C`c' "Seed used: Crop C in Plot P in Season S "
				
				gen 		harv_kg_P`p'S`s'C`c' = runiform(1,50)
				label var 	harv_kg_P`p'S`s'C`c' "Harvested quantity: Crop C in Plot P in Season S "
				
				gen 		consum_kg_P`p'S`s'C`c' = runiform(1,50)
				label var 	consum_kg_P`p'S`s'C`c' "Consumed quantity: Crop C in Plot P in Season S "
				
				format seed_kg_P`p'S`s'C`c'  %10.2f
				format harv_kg_P`p'S`s'C`c'  %10.2f
				format consum_kg_P`p'S`s'C`c'  %10.2f
			}
		}
	}
	
	// Expand para errores
	expand 2 in 1782
	expand 2 in 1978
	
	// Crear errores
	forvalues p = 1/2 {
		forvalues s = 1/3 {
			forvalues c = 1/2 {
				replace seed_kg_P`p'S`s'C`c' = runiform(1,20)
			}
		}
	}
		
	// Guardar base as wide
	save "${data_2_1}/agr_wide.dta", replace


