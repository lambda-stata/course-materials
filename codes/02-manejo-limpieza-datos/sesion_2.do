/********************************************************************************
* Título:	Manejo y Limpieza de Datos
* Sesion: 	Sesión 2
* Autor:	Rony Rodriguez-Ramirez	
*********************************************************************************
	
*** Outline:
	1. Variable ID y Duplicados
		1.1 Cargar datos
		1.2 Duplicates and ID variable 
	2. Glimpse de algunas variables
		2.1 Variables demográficas
		2.2 Una mejor manera de ver los missings
		2.3 Recoding 
	
*********************************************************************************
***	PART 1: Variable ID y Duplicados
********************************************************************************/

*** 1.1 Cargar data
	use "${data_1_2}/webstart.dta", clear 
		
*** 1.2 Duplicates and ID variable
	isid newid 
	duplicates report newid 
	
	// Expandimos para tener duplicados 
	expand 2 
	capture isid newid 

	// Drop los duplicados 
	duplicates report newid 
	duplicates drop newid, force 
	
*********************************************************************************
***	PART 2: Glimpse de algunas variables
*********************************************************************************
	
*** 2.1 Variables demográficas (missings)
	count 
	local obs = r(N)
	
	local demo ssex srace sbirthy sesk

	foreach var in `demo' {
		tab `var'
		if (r(N) == `obs') {
			display "Las observaciones en la tabla es igual al número total de observaciones"
		}
		else {
			display "El número de observaciones en la tabla es diferente al número total de observaciones"
		}
	}

*** 2.2 Una mejor manera de ver los missings
	local ejemplo ssex star1 star2 star3 
	
	foreach var in `ejemplo' {
		capture assert !missing(`var')
		if _rc == 9 {
			display "Variable `var' has missings"
			replace `var' = 0 if missing(`var')
		}
		else {
			display "Variable `var' didn't have missings"
		}		
	}
	
*** 2.2 Recoding	
	gen ssex2 = ssex 
	gen ssex3 = ssex 
	
	local sex ssex ssex2 ssex3

	foreach var in `sex' {
		capture assert `var' == 2 
		if _rc == 9 {
			recode `var' (2=0)
		}
	}