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

*** 0.0 Install required packages:
	local packages ietoolkit iefieldkit winsor estout outreg2 wbopendata asdoc
		
	foreach pgks in `packages' {	
	  				
		capture which `pgks'
		
		if (_rc != 111) {
			display as text in smcl "Paquete {it:`pgks'} está instalado "
		}
		
		else {
			display as error in smcl `"Paquete {it:`pgks'} necesita instalarse."'
			
			capture ssc install `pgks', replace
			
			if (_rc == 601) {
				display as error in smcl `"Package `pgks' is not found at SSC;"' _newline ///
				`"Please check if {it:`pgks'} is spelled correctly and whether `pgks' is indeed a user-written command."'
			}
			
			else {
				display as result in smcl `"Paquete `pgks' ha sido instalado."'
			}
		}
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
	global outputs 					"${project}/outputs"
	
	// Semana 1
	global codes_1_1				"${codes}/01-programming-intro"
	global codes_1_2				"${codes}/02-manejo-limpieza-datos"
	global data_1_1					"${data}/01-programming-intro"
	global data_1_2					"${data}/02-manejo-limpieza-datos"
	
	// Semana 2
	global codes_2_1				"${codes}/03-construccion-datos"
	global codes_2_2				"${codes}/04-analisis-datos-1"
	global data_2_1					"${data}/03-construccion-datos"
	global data_2_2					"${data}/04-analisis-datos-1"	
	global outputs_2_1				"${outputs}/03-construccion-datos"
	global outputs_2_2				"${outputs}/04-analisis-datos-1"
	
	// Semana 3

*** 0.3 Setting up execution 
	global primera_semana 0
	global segunda_semana 1
	global tercera_semana 0
		

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
	if (${segunda_semana} == 1) {
		do "${codes_2_1}/sesion_3.do"					// Crear base de dummy
		do "${codes_2_1}/sesion_3_nodup.do"				// Creat base de datos sin duplicados
		do "${codes_2_1}/sesion_3_clean.do"				// Crear base de datos limpia	
		do "${codes_2_1}/sesion_3_hps.do"				// Crear HPS level dataset
		do "${codes_2_2}/sesion_4_hpsc.do"				// Crear HPSC level dataset
		do "${codes_2_2}/sesion_4_merge_hps_hpsc.do"
	} 

********************************************************************************
***	PART 3: Tercera Semana 
********************************************************************************
	if (${tercera_semana} == 1) {
		do "${codes_1_1}/sesion_5.do"
		do "${codes_1_2}/sesion_6.do"
	} 
	