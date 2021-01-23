/********************************************************************************
* Título:		Construcción de datos
* Sesion: 		Sesión 3b
* Autor:		Rony Rodriguez-Ramirez
* Proposito:	Cleaning
*********************************************************************************
	
*** Outline:
	2. Cleaning variables
		2.1 Cultivated and Irrigation
		2.2 Cultivated and Seed
	
*********************************************************************************
***	PART 2: Cleaning variables
********************************************************************************/

*** 2.0 Cargar base de datos
	use "${data_2_1}/agr_wide_nodup.dta", clear
	
	
	/*
	NIVEL 1 DE INFORMACION
	
	HOUSEHOLD (HOGAR)
	PLOT (1-2)
	SEASON (1-2-3)
	
	NIVEL 2 DE INFORMACION
	HOUSEHOLD (HOGAR)
	PLOT (1-2)
	SEASON (1-2-3)
	CROP (1-2)
	*/ 
	
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
				replace sell_kg_P`p'S`s'C`c' 	= . if cult_P`p'S`s' == 0
			}
		}
	}
	
*** 2.3 Assert que si sean missings cuando cultivado es 0 		
	forvalues p = 1/2 {
		forvalues s = 1/3 {
			forvalues c = 1/2 {
				capture assert missing(seed_kg_P`p'S`s'C`c') if cult_P`p'S`s' == 0
				
				if (_rc != 9) {
					display "Variable seed_kg_P`p'S`s'C`c' está configurada correctamente."
				}
			}
		}
	}	

*** 2.3 Guardar base de datos
	save "${data_2_1}/agr_wide_nodup_cleaned.dta", replace 
	
