/********************************************************************************
* Título:	Construcción de datos
* Sesion: 	Sesión 5
* Autor:	Rony Rodriguez-Ramirez
* Proposito: Crear base al nivel HPSC constructed (construída)
*********************************************************************************
	
*** Outline:
	1. 	Analisis
		1.1 Cargar base de datos
		1.2 Tablas 
		
	Input: 	agr_merge_hps_hpsc_constructed
	Output: balance_tables.xlsx
	
*********************************************************************************
***	PART 1: Analisis
********************************************************************************/
	
*** 1.0 Settings
* Settings
  global style1 "label fragment nomtitle nonumbers nodep star(* 0.10 ** 0.05 *** 0.01) collabels(none) booktabs b(3) se(3)"
    
*** 1.1 Cargar base de datos
	use "${data_3_1}/agr_merge_hps_hpsc_constructed.dta", clear 

*** 1.2 Tablas
	local 	vars		    ///
          cult 		    ///
          irr 		    ///
          seed_kg 	  ///
          harv_kg 	  ///
          consum_kg	  ///
          sell_kg		  ///
          income
          
  estpost summarize `vars'
  esttab using "${outputs_3_1}/tablas/Table-esttab-example.tex", replace          ///
    cells("mean(fmt(%9.2fc)) sd(fmt(%9.2fc)) min(fmt(%9.2fc)) max(fmt(%9.2fc))")  ///
    ${style1}
  
  estpost summarize `vars'
  esttab using "${outputs_3_1}/tablas/Table-esttab-example2.tex", replace         ///
    cells("mean(fmt(%9.2fc)) sd(fmt(%9.2fc)) min(fmt(%9.2fc)) max(fmt(%9.2fc))")  ///
    nonumbers label 
  
 
	iebaltab `vars', 			  ///
		grpvar(treatment)		  ///
		vce(cluster village)	///
		rowvarlabels 			    ///
		save("${outputs_3_1}/tablas/balance_tables.xlsx") replace


	iebaltab `vars', 			  ///
		grpvar(treatment)		  ///
		vce(cluster village)	///
		rowvarlabels 			    ///
		savetex("${outputs_3_1}/tablas/balance_tables.tex")	replace 
	
  
  
  
	
	