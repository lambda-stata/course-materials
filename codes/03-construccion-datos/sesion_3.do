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
	// 1.2.1 Chequear si hay duplicados
	capture isid hhid  
	if (_rc == 459) {
	    duplicates report hhid
	}
	
*** 1.3 Export duplicates
	// 1.3.1 Exportar a excel los duplicados
	gen key = _n 
	capture ieduplicates hhid using "${outputs_2_1}/duplicates/duplicates.xlsx", uniquevars(key) keepvars(*)
	
	// 1.3.2 Ver las diferencias entre los valores con los mismo IDs
	iecompdup hhid, id(121782) didifference
	iecompdup hhid, id(121978) didifference
	
	// 1.3.2 Replace HHID con el valor correcto
	replace hhid = 122035 if hhid == 121782 & key == 2035 
	
	// 1.3.4 Exportar a excel los nuevos duplicados y dropear duplicados
	capture ieduplicates hhid using "${outputs_2_1}/duplicates/duplicates.xlsx", uniquevars(key) keepvars(*) force
			
	// 1.3.5 Chequear si HHID es única y completa
	capture isid hhid  
	if (_rc == 459) {
	    duplicates report hhid
		
		drop key
	}
	
	// 1.3.6 Guardar base de datos sin duplicados
	save "${data_2_1}/agr_wide_nodup.dta", replace 

*********************************************************************************
***	PART 2: Cleaning variables
*********************************************************************************

*** 2.1 Cultivated and Irrigation (Plot Season)
	forvalues p = 1/2 {
		forvalues s = 1/3 {
			replace irr_P`p'S`s' = 0 if cult_P`p'S`s' == 0
		}
	}

*** 2.2 Cultivated and Seed (Semilla) and Harv (Cosecha) and Crop (Cultivo)
	forvalues p = 1/2 {
		forvalues s = 1/3 {
			forvalues c = 1/2 {
				replace seed_kg_P`p'S`s'C`c' 	= . if cult_P`p'S`s' == 0
				replace harv_kg_P`p'S`s'C`c' 	= . if cult_P`p'S`s' == 0
				replace consum_kg_P`p'S`s'C`c' 	= . if cult_P`p'S`s' == 0
			}
		}
	}
	
*** 2.3 Assert que si sean missings cuando cultivado es 0 		
	forvalues p = 1/2 {
		forvalues s = 1/3 {
			forvalues c = 1/2 {
				capture assert missing(seed_kg_P`p'S`s'C`c') if cult_P`p'S`s' == 0
			}
		}
	}	
	
*** 2.3 Guardar base de datos
	save "${data_2_1}/agr_wide_nodup_cleaned.dta", replace 
	
*********************************************************************************
***	PART 3: Reshaping variables
*********************************************************************************
	
*** 3.1 Reshaping data to plot season level	
	// Snapshot
	snapshot erase _all 
	snapshot save, label("Complete Dataset")

	// Keep variables relevantes
	keep 	hhid 		///
			cult_* 		///
			irr_* 	

	// Reshape
	reshape long cult_ irr_, i(hhid) j(rshp_id) string
	
	// Rename 
	rename *_ *
	
	// Label vars
	label var cult 	"Cultivated: Plot P in Season S "
	label var irr 	"Irrigation: Plot P in Season S "
	
	// Gen ID as number
	gen plot    = substr(rshp_id, 2, 1)
	gen season  = substr(rshp_id, 4, 1)	
	
	// Eliminar variables no necesarias
	drop rshp_id
	
	// Destring variables
	foreach var in plot season {
		destring `var', replace
	}	
	
	// Order dataset
	order hhid plot season 
	
	duplicates report hhid plot season
	
	// Save
	save "${data_2_1}/agr_hps.dta", replace

*********************************************************************************
*** APPENDIX: CREATING THE DUMMY VARIABLE
*********************************************************************************	

*** A.1 Creating dummy data using 2 plots, 3 seasons, and 2 crops and assigning random values 
	// A.1.1 Observaciones
	clear all
	set obs 2034
	gen hhid = .
	label var hhid "Household ID"
	
	// A.1.2 Crear HHID
	forvalues h = 1/2034 {
		replace hhid = 120000 + `h' in `h'
	}
	
	// A.1.3 Seed, Harvest, Consum, 2 Plots 3 Seasons 2 Crops
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
				
				format seed_kg_P`p'S`s'C`c'  %10.2f
				format harv_kg_P`p'S`s'C`c'  %10.2f
				format consum_kg_P`p'S`s'C`c'  %10.2f
			}
		}
	}
	
	// A.1.4 Create treatment
	gen 			rand = runiform()
	egen 			treatment = cut(rand), group(4)
	label var 		treatment "Treatment Status"
	label define 	treatment 0"Control" 1"Contracts" 2"Information" 3"Info + Contracts"
	label values 	treatment treatment
	
	// A.1.5 Villages
	egen village = cut(rand), group(12)
	label var 	 village "Village Code"
	label define village 	0"Argirópolis" 			///
							1"Gotham City" 			///
							2"Kahndaq" 				///
							3"Suicide Slum" 		///
							4"Temiscira (cómic)" 	///
							5"Midway City" 			///
							6"Ciudad Costera" 		///
							7"Ciudad Central" 		///
							8"Wakanda" 				///
							9"Macondo" 				///
							10"Mango Seco" 			///
							11"Vetusta"		
	label values village village 
		
	// A.1.6 Expand para errores
	expand 2 in 1782
	expand 2 in 1978
	
	// A.1.7 Crear errores
	forvalues p = 1/2 {
		forvalues s = 1/3 {
			forvalues c = 1/2 {
				replace seed_kg_P`p'S`s'C`c' = runiform(1,20) if hhid != 121978
			}
		}
	}
	
	// A.1.8 Order 
	order hhid treatment village 
		
	// A.1.9 Drop 
	drop rand
	
	// A.1.10 Guardar base as wide
	save "${data_2_1}/agr_wide.dta", replace


