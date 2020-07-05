/********************************************************************************
* Título:	Manejo y Limpieza de Datos
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
	count 
	local obs = r(N)
	display "El número total de observaciones es `obs'"

	isid newid 
	duplicates report newid 
	
	// Expandimos para tener duplicados 
	expand 2 
	
	count 
	local obs = r(N)
	display "El número total de observaciones es `obs'"	
	
	// Drop los duplicados 
	duplicates report 
	duplicates drop 
	
	count 
	local obs = r(N)
	display "El número total de observaciones es `obs'"		
	
*********************************************************************************
***	PART 2: Glimpse de algunas variables
*********************************************************************************
	
*** 2.1 Variables demográficas (missings)

	local demo ssex srace sbirthq sbirthy sesk
	foreach var in `demo' {
		tab `var'
		if (r(n) == `obs') {
			display "Las observaciones en la tabla son diferentes al total de observaciones"
		}
		else {
			display "El número de observaciones en la tabla es igual al número total de observaciones"
		}
	}
		
	
*** 2.2 Una mejor manera de ver los missings
	local demo ssex srace sbirthq sbirthy sesk	
	
	foreach var in `demo' {
		capture assert !missing(`var')
		if _rc == 9 {
			display "Variable `var' has missings"
			* replace `var' = 0 if missing(`var')
		}
		else {
			display "Variable `var' didn't have missings"
		}		
	}

*** 2.2 Recoding
	local star star1 star2 star3 

	foreach var in `star' {
	    di `"`: var label `var''"' 
	    tab `var', missing 
		recode `var' (2=0) 
		replace `var' = 0 if missing(`var')
		replace `var' = 0 if `var'<=0
		tab `var', missing 
	}

	
