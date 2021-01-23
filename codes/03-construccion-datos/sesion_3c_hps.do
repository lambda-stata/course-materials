/********************************************************************************
* Título:		Construcción de datos
* Sesion: 		Sesión 3
* Autor:		Rony Rodriguez-Ramirez
* Proposito: 	Crear HPS Level Dataset
*********************************************************************************
	
*** Outline:
	3. 	Reshaping variables
		3.1 Reshaping data to plot season level	
	
*********************************************************************************
***	PART 3: Reshaping variables (Nivel: Plot Season)
********************************************************************************/
	
*** 3.1 Reshaping data to plot season level	

	// Cargar base de datos
	use "${data_2_1}/agr_wide_nodup_cleaned.dta", clear 
	
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
	label var cult 	"Cultivated: Plot P in Season S"
	label var irr 	"Irrigation: Plot P in Season S"
	
	// Gen ID as number
	gen plot    = substr(rshp_id, 2, 1)
	gen season  = substr(rshp_id, 4, 1)	
	
	// Eliminar variables no necesarias
	drop rshp_id
	
	// Destring variables	
	foreach var in plot season {
		destring `var', replace
	}	
	
	// Label final
	label var plot 		"Plot id"
	label var season 	"Season id"
	
	// Order dataset
	order hhid plot season 
	
	duplicates report hhid plot season
	
	// Save
	save "${data_2_1}/agr_hps.dta", replace
	
	
