/*******************************************************************************
* PROJECTO: 	Stata avanzado LAMBDA                           
* TITULO: 		Master Do File
* YEAR:			2021
* Author: 		Rony Rodríguez-Ramírez
********************************************************************************
	
*** Outline:
	0. Set initial configurations and globals
	1. Primera Semana
	2. Segunda Semana
	3. Tercera Semana
	4. Cuarta  Semana

********************************************************************************
*** PART 0: Set initial configurations and globals
*******************************************************************************/

*** 0.1 Settings user's paths
	if ("`c(username)'" == "maximiliano") {
		global project 				"D:/Documents/RA Jobs/LAMBDA/Stata Avanzado/course-materials"
	}	
	
	if ("`c(username)'" == "bchai") {
		global project				"D:/Estudiando/Stata/Stata Avanzado/course-materials-jan-2020"
	}

	if ("`c(username)'" == "Toshiba") {
		global project 				"C:/Users/Toshiba/Documents/STATA_AVANZADO"
	}
	
	if ("`c(username)'" == "Gabriela") {
		global project 				"C:/Users/Gabriela/Downloads/course-materials-jan-2020/course-materials-jan-2020"
	}	
 
	if ("`c(username)'" == "elmer") {
		global project 				"C:/Users/elmer/Desktop/Clases de Stata/Stata Avanzado/course-materials-jan-2020"
	}	

*** 0.2 Setting folder structure
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
	global codes_3_1				"${codes}/05-analisis-datos-2"
	global codes_3_2				"${codes}/06-papers-1"
	global data_3_1					"${data}/05-analisis-datos-2"
	global data_3_2					"${data}/06-papers-1"
	global outputs_3_1				"${outputs}/05-analisis-datos-2"
	global outputs_3_2				"${outputs}/06-papers-1"

	// Semana 4 
	global codes_4_1				"${codes}/07-papers-2"
	global codes_4_2				"${codes}/08-papers-3"
	global data_4_1					"${data}/07-papers-2"
	global data_4_2					"${data}/08-papers-3"
	global outputs_4_1				"${outputs}/07-papers-2"
	global outputs_4_2 				"${outputs}/08-papers-3"	
	
*** 0.3 Install required packages:	
	local packages ietoolkit iefieldkit winsor estout outreg2 reghdfe 
		
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
	
	ieboilstart, version(15.0)
		
*** 0.4 Setting up execution 
	global primera_semana 0
	global segunda_semana 0
	global tercera_semana 0
	global cuarta_semana  0
		
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
		do "${codes_2_1}/sesion_3.do"					// Crear base dummy
		do "${codes_2_1}/sesion_3a_nodup.do"			// Crear base de datos sin duplicados
		do "${codes_2_1}/sesion_3b_clean.do"			// Crear base de datos limpia	
		do "${codes_2_1}/sesion_3c_hps.do"				// Crear HPS level dataset
		do "${codes_2_2}/sesion_4_hpsc.do"				// Crear HPSC level dataset
		do "${codes_2_2}/sesion_4_merge_hps_hpsc.do"	// Merge HPS and HPSC datasets
	} 

********************************************************************************
***	PART 3: Tercera Semana 
********************************************************************************
	if (${tercera_semana} == 1) {
		do "${codes_3_1}/sesion_5_hpsc_constructed.do"
		do "${codes_3_1}/sesion_5_hpsc_bal_tab.do"
		do "${codes_3_1}/sesion_5_excel-tables.do"
		do "${codes_3_2}/sesion_6_esttab.do"
		do "${codes_3_2}/sesion_6_rct_tab_1.do"
		do "${codes_3_2}/sesion_6_rct_tab_3.do"
	} 

********************************************************************************
***	PART 4: Cuarta Semana 
********************************************************************************
	if (${cuarta_semana} == 1) {
		do "${codes_4_1}/sesion_7_did.do"
		do "${codes_4_2}/sesion_8_rdd.do"
		do "${codes_4_2}/sesion_8_program.do"
	}
	
