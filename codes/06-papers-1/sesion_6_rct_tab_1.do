/********************************************************************************
* Título:		Análisis de Datos
* Sesion: 		Sesión 5
* Autor:		Rony Rodriguez-Ramirez
* Proposito: 	Exportar tablas
*********************************************************************************
	
*** Outline:
	1. 	Analisis
		1.1 Load dataset
		1.2 Crear matrix vacia
		1.3 Panel A
		1.4 Panel B
		1.5 Matrix to dataset and export to excel
		1.6 Outsheet
	
	Input: 	Burde and Linden 2013_HH
	Output: tablas
	
*********************************************************************************
***	PART 1: Analisis
********************************************************************************/

***	1.1 Load dataset
	use "${data_3_2}/Burde and Linden 2013_HH.dta", clear
		
*** 1.2 Crear matrix vacia

	matrix m1 = J(9,9,.)
	matrix list m1
	
*** 1.3 Panel A: Household Surveyed	
	// Identified
		// Fall 2007 Survey (Row 1 - Col 1 / 4)    
		sum f07_hh_observed if f07_hh_covered == 1 & treatment == 1
		matrix m1[2, 2] = `r(N)'		
		matrix m1[4, 2] = round(`r(mean)', .001) 	// Percent (Row 3)
    
		sum f07_hh_observed if f07_hh_covered == 1 & treatment == 0
		matrix m1[2, 3] = `r(N)'
		matrix m1[4, 3] = round(`r(mean)', .001)	// Percent (Row 3)
		
		matrix m1[2,4] = m1[2,2] - m1[2,3]			  // Difference 	(Col 3) 
		matrix m1[2,5] = m1[2,2] + m1[2,3]			  // Total		(Col 4)

		// Spring 2008 Survey (Row 1 - Col 5/9)
		sum s08_hh_observed if s08_hh_covered == 1 & treatment == 1
		matrix m1[2, 6] = `r(N)'
		matrix m1[4, 6] = round(`r(mean)', .001) 	// Percent (Row 3)

		sum s08_hh_observed if s08_hh_covered == 1 & treatment == 0
		matrix m1[2, 7] = `r(N)'
		matrix m1[4, 7] = round(`r(mean)', .001) 	// Percent (Row 3)
		
		matrix m1[2,8] = m1[2,6] - m1[2,7]			// Difference 	(Col 7)
		matrix m1[2,9] = m1[2,6] + m1[2,7]			// Total 		(Col 8)
		
	// Surveyed
		// Fall 2007 Survey (Row 2 - Col 1 / 4)
		sum f07_hh_observed if f07_hh_observed == 1 & treatment == 1
		matrix m1[3, 2] = `r(N)'
		
		sum f07_hh_observed if f07_hh_observed == 1 & treatment == 0
		matrix m1[3, 3] = `r(N)'
		
		matrix m1[3,4] = m1[3,2] - m1[3,3]
		matrix m1[3,5] = m1[3,2] + m1[3,3]
		
		// Sprin 2008 Survey (Row 1 - Col 5/9)
		sum s08_hh_observed if s08_hh_observed == 1 & treatment == 1
		matrix m1[3, 6] = `r(N)'

		sum s08_hh_observed if s08_hh_observed == 1 & treatment == 0
		matrix m1[3, 7] = `r(N)'
		
		matrix m1[3,8] = m1[3,6] - m1[3,7]
		matrix m1[3,9] = m1[3,6] + m1[3,7]	
		
	//	Percent of households surveyed (Col 3 and 4)   
		reg f07_hh_observed treatment if f07_hh_covered == 1, cluster(clustercode)

		matrix m1[4,4] = round(_b[treatment], 	.001)
		matrix m1[5,4] = round(_se[treatment], 	.001)
			
		sum f07_hh_observed if f07_hh_covered == 1
		matrix m1[4,5] = round(`r(mean)', .001) 	// Percent (row 3)
		
	//	Percent of households surveyed (Col 8 and 9)		
		reg s08_hh_observed treatment if s08_hh_covered == 1, cluster(clustercode)
		matrix m1[4,8] = round(_b[treatment], 	.001)
		matrix m1[5,8] = round(_se[treatment], 	.001)
		
		sum s08_hh_observed if s08_hh_covered == 1
		matrix m1[4,9] = round(`r(mean)', .001) 	// Percent (row 3)
		
		mat list m1
			
*** 1.4 Panel B: Household with eligible children
		// Household with children
		sum f07_with_kids if f07_with_kids == 1 & treatment == 1
		matrix m1[7,2] = `r(N)'
		
		sum f07_with_kids if f07_with_kids == 1 & treatment == 0
		matrix m1[7,3] = `r(N)'
		
		matrix m1[7,4] = m1[7,2] - m1[7,3]
		matrix m1[7,5] = m1[7,2] + m1[7,3]
		
		// Percentage with Children
		sum f07_with_kids if f07_hh_observed == 1 & treatment == 1
		matrix m1[8,2] = round(`r(mean)', .001)
		
		sum f07_with_kids if f07_hh_observed == 1 & treatment == 0
		matrix m1[8,3] = round(`r(mean)', .001)
		
		reg f07_with_kids treatment if f07_hh_observed == 1, cluster(clustercode)
		matrix m1[8,4] = round(_b[treatment], 	.001)
		matrix m1[9,4] = round(_se[treatment], 	.001)
		
		sum f07_with_kids if f07_hh_observed == 1
		matrix m1[8,5] = round(`r(mean)', .001) 	
		
		// Household with children (Spring 2008)
		sum s08_with_kids if s08_with_kids == 1 & treatment == 1
		matrix m1[8,6] = `r(N)'
		
		sum s08_with_kids if s08_with_kids == 1 & treatment == 0
		matrix m1[7,7] = `r(N)'		
		
		matrix m1[7,8] = m1[7,6] - m1[7,7]
		matrix m1[7,9] = m1[7,6] + m1[7,7]
		
		// Percentage with Children (Spring 2008)
		sum s08_with_kids if s08_hh_observed == 1 & treatment == 1
		matrix m1[8,6] = round(`r(mean)', .001)
		
		sum s08_with_kids if s08_hh_observed == 1 & treatment == 0
		matrix m1[8,7] = round(`r(mean)', .001)
		
		reg s08_with_kids treatment if s08_hh_observed == 1, cluster(clustercode)
		matrix m1[8,8] = round(_b[treatment], 	.001)
		matrix m1[9,8] = round(_se[treatment], 	.001)
		
		sum s08_with_kids if s08_hh_observed == 1
		matrix m1[8,9] = round(`r(mean)', .001) 	
		
	mat list m1
	
*** 1.5 Matrix to dataset and export to excel  
	clear
	svmat m1, names(col) 
	
	tostring c1, replace 
	
	//	Variables Column 1
	replace c1 = "Panel A. Households surveyed" if _n == 1
	replace c1 = "Identified" 					        if _n == 2
	replace c1 = "Surveyed" 					          if _n == 3 
	replace c1 = "Percent of households" 		    if _n == 4
	replace c1 = "surveyed" 					          if _n == 5
	
	replace c1 = "Panel B. Households with eligible children" if _n == 6
	replace c1 = "Households with children" 	  if _n == 7
	replace c1 = "Percentage with children" 	  if _n == 8
	replace c1 = ""								              if _n == 9 

*** Outsheet
  outsheet using "${outputs_3_2}/tablas/tab_1.csv",   ///
    comma nonames noquote nolabel replace 

	
	
 	