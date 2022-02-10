/********************************************************************************
* Título:	  Construcción de datos
* Sesion: 	Sesión 3a
* Autor:	  Rony Rodriguez-Ramirez
*********************************************************************************
	
*** Outline:
	1. Variable ID y Duplicados
		1.1 Cargar datos
		1.2 Duplicates and ID variable 
		1.3 Export duplicates
		
***	Requerimientos: 
	inputs: 	agr_wide
	outputs: 	agr_wide_nodup
	
*** Objetivo: 
	Este do file toma la base de datos de agricultura y elimina los duplicados 
	para tener una base de datos sin duplicados
	
*********************************************************************************
***	PART 1: Variable ID y Duplicados
********************************************************************************/

*** 1.1 Cargar data
	use "${data_2_1}/agr_wide.dta", clear 
		
*** 1.2 Duplicates and ID variable	
	// 1.2.1 Chequear si hay duplicados
	capture isid hhid
  
	if (_rc == 459) {
		display "hhid tiene observaciones duplicadas"
	  duplicates report hhid
	}
	
*** 1.3 Export duplicates
	// 1.3.1 Exportar a excel los duplicados
	gen key = _n
  
	capture ieduplicates hhid using "${outputs_2_1}/duplicates/duplicates.xlsx", ///
		uniquevars(key) keepvars(*) nodaily
	
	// 1.3.2 Ver las diferencias entre los valores con los mismo IDs
	iecompdup hhid, id(121782) didifference
	iecompdup hhid, id(121978) didifference
	
	// 1.3.2 Replace HHID con el valor correcto
	replace hhid = 122035 if hhid == 121782 & key == 2035 
	
	// 1.3.4 Exportar a excel los nuevos duplicados y dropear duplicados
	capture ieduplicates hhid using "${outputs_2_1}/duplicates/duplicates.xlsx", ///
		uniquevars(key) keepvars(*) force
			
	// 1.3.5 Chequear si HHID es única y completa
	capture isid hhid
	if (_rc == 459) {
		display "hhid tiene observaciones duplicadas"
	    duplicates report hhid
	}
  
  else {
    display as result "hhid no tiene observaciones duplicadas"
  }
	
	drop key
	
	// 1.3.6 Guardar base de datos sin duplicados
	save "${data_2_1}/agr_wide_nodup.dta", replace
