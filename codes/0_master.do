/********************************************************************************
* PROJECTO: Stata avanzado LAMBDA                           
* TITULO: 	Master Do File
* YEAR:		2020
*********************************************************************************
	
*** Outline:
	0. Set initial configurations and globals
	1. Cleaning 
	2. Construction of key variables
	3. Balance tables
	4. Panel data set: append follow up to the baseline
	5. Figures

*********************************************************************************
*	PART 0: Set initial configurations and globals
********************************************************************************/

*** 0.1 Install required packages
	local install_packages 	0
	
	if `install_packages' {
		ssc install tabout, 	replace
		ssc install ietoolkit, 	replace
		ssc install egenmore, 	replace 
		ssc install winsor, 	replace 
		ssc install estout, 	replace
		ssc install outreg2, 	replace 
	}

	ieboilstart, version(14.0)
	`r(version)'
	
*** 0.1 Setting up users	
	if inlist("`c(username)'","maximiliano","WB559559", "wb559559"){
		global project				"D:/Documents/RA Jobs/LAMBDA/Stata Avanzado/course-materials"
	} 
	
*** 0.2 Setting up folders
	global codes					"${project}/codes"
	global programming				"${codes}/01-programming-intro"
		
********************************************************************************
***	Week 1:  
********************************************************************************

********************************************************************************
***	Week 2: 
********************************************************************************

********************************************************************************
***	Week 3: 
********************************************************************************


	
	
	