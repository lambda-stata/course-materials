/********************************************************************************
* Título:	Construcción de datos
* Sesion: 	Sesión 5
* Autor:	Rony Rodriguez-Ramirez
* Proposito: Crear base al nivel HPSC constructed (construída)
*********************************************************************************
	
*** Outline:
	1. 	Analisis
	
	Input: 	agr_merge_hps_hpsc_constructed
	Output: tablas
	
*********************************************************************************
***	PART 1: Analisis
********************************************************************************/
	
*** 1.1 Cargar base de datos
	use "${data_3_1}/agr_merge_hps_hpsc_constructed.dta", clear 

	
*** 1.2 Tablas
	preserve 
		local 	vars		///
				cult 		///
				irr 		///
				seed_kg 	///
				harv_kg 	///
				consum_kg	///
				sell_kg
		
		iebaltab `vars', 			///
			grpvar(treatment)		///
			vce(cluster village)	///
			rowvarlabels 			///
			save("${outputs_3_1}/tablas/balance_tables.xlsx") replace
	
	restore 
	
	preserve 
		iebaltab `vars', 			///
			grpvar(treatment)		///
			vce(cluster village)	///
			rowvarlabels 			///
			savetex("${outputs_3_1}/tablas/balance_tables.tex")	replace 
	
	restore 
	
	
	