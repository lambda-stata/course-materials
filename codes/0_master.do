/********************************************************************************
* PROJECTO: 	Stata avanzado LAMBDA                           
* TITULO: 		Master Do File
* YEAR:			2020
* Author: 		Rony Rodríguez-Ramírez
*********************************************************************************
	
*** Outline:
	0. Set initial configurations and globals
	1. Primera Semana
	2. Segunda Semana
	3. Tercera Semana

*********************************************************************************
*** PART 0: Set initial configurations and globals
********************************************************************************/

*** 0.1 Install required packages: MACRO: Global - Local 	
	local install_packages 0 
	
	if `install_packages' {
		ssc install ietoolkit, 	replace
		ssc install winsor, 	replace 
		ssc install estout, 	replace
		ssc install outreg2, 	replace 
		ssc install wbopendata, replace 
	}
	
	ieboilstart, version(14.0)
	
*** 0.1 Setting up users	
	if ("`c(username)'" == "maximiliano") {
		// Absoluto
		global project 				"D:/Documents/RA Jobs/LAMBDA/Stata Avanzado/course-materials"
	}
	
	if ("`c(username)'" == "USERNAME") { 
		global project 				""
	}
	
*** 0.2 Setting up folders
	// Dinámicos 
	global codes					"${project}/codes"
	global data						"${project}/data"
	
	// Semana 1
	global codes_1_1				"${codes}/01-programming-intro"
	global codes_1_2				"${codes}/02-manejo-limpieza-datos"
	global data_1_1					"${data}/01-programming-intro"
	global data_1_2					"${data}/02-manejo-limpieza-datos"
	
	// Semana 2

	
	// Semana 3
	
	
*** 0.3 Setting up execution 
	global primera_semana 0
	
********************************************************************************
***	PART 1: Primera Semana  
********************************************************************************
	if (${primera_semana} == 1) {
		do "${codes_1_1}/sesion_1.do"
		do "${codes_1_2}/sesion_2.do"
	} 
	
********************************************************************************
***	PART 2: Segunda Semana  
********************************************************************************



********************************************************************************
***	PART 3: Tercera Semana 
********************************************************************************


	
	
	