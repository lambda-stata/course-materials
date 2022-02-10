/********************************************************************************
* Título:		  Construcción de datos
* Sesion: 		Sesión 3
* Autor:		  Rony Rodriguez-Ramirez
* Proposito: 	Crear base de datos dummy
*********************************************************************************
	
*** Outline:
	1. Creating the dummy dataset
 	
*********************************************************************************
***	PART 1: CREATING THE DUMMY DATASET
********************************************************************************/

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
				label var 	seed_kg_P`p'S`s'C`c' 	"Seed used: Crop C in Plot P in Season S"
				
				gen 		harv_kg_P`p'S`s'C`c' = runiform(1,50)
				label var 	harv_kg_P`p'S`s'C`c' 	"Harvested quantity: Crop C in Plot P in Season S"
				
				gen 		consum_kg_P`p'S`s'C`c' = runiform(1,50)
				label var 	consum_kg_P`p'S`s'C`c' 	"Consumed quantity: Crop C in Plot P in Season S"				
				replace 	consum_kg_P`p'S`s'C`c' = harv_kg_P`p'S`s'C`c' if consum_kg_P`p'S`s'C`c' > harv_kg_P`p'S`s'C`c'
				
				gen 		sell_kg_P`p'S`s'C`c' = harv_kg_P`p'S`s'C`c' - consum_kg_P`p'S`s'C`c'
				label var 	sell_kg_P`p'S`s'C`c'	"Sold quantity: Crop C in Plot P in Season S"
				
				format 		seed_kg_P`p'S`s'C`c'  	%10.2f
				format 		harv_kg_P`p'S`s'C`c'  	%10.2f
				format 		consum_kg_P`p'S`s'C`c'  %10.2f	
				format 		sell_kg_P`p'S`s'C`c'  	%10.2f
			}
		}
	}
	
	// A.1.4 Generate price at the crop level
	forvalues c = 1/2 {
	    gen	price_`c' =  runiform(1,15)
		
		label var price_`c' "Price Sold for Crop C"
	}
	
	// A.1.5 Create treatment
	gen 			rand = runiform()
	egen 			treatment = cut(rand), group(4)
	label var 		treatment "Treatment Status"
	label define 	treatment 0"Control" 1"Contracts" 2"Information" 3"Info + Contracts"
	label values 	treatment treatment
	
	// A.1.5 Villages
	egen village = cut(rand), group(12)
	label var 	 village "Village Code"
	label define village 	0"Argirópolis" 			///
							1"Gotham City" 			          ///
							2"Kahndaq" 				            ///
							3"Suicide Slum" 		          ///
							4"Temiscira (cómic)" 	        ///
							5"Midway City" 			          ///
							6"Ciudad Costera" 	    	    ///
							7"Ciudad Central" 		        ///
							8"Wakanda" 				            ///
							9"Macondo" 				            ///
							10"Mango Seco" 			          ///
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


