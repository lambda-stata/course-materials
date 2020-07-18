// Use each of the packages to create a basic regression table with different features
	set seed 474747
	sysuse census.dta , clear

// Run regressions ********************************
	estimates clear 
	
	// Regression 1: nothing interesting
	reg divorce marriage pop
		est sto reg1

	// Regression 2: a different regression
	reg medage popurban
		est sto reg2

	// Regression 3: indicator expansion
	reg divorce marriage pop i.region
		est sto reg3

	// Regression 4: interaction
	gen binary = rnormal() > 0
		lab def binary 0 "No" 1 "Yes"
		lab val binary binary
		label var binary "Indicator"

	reg divorce marriage pop i.region#i.binary
		est sto reg4

// Export tables: Excel ********************************

	global regressions reg1 reg2 reg3 reg4

	// outreg2
	outreg2 [${regressions}] 							///
		using "${outputs_3_1}/tablas/outreg.xls" 		///
		, replace excel
	
	// estout
	estout ${regressions} 								///
		using "${outputs_3_1}/tablas/estout.xls" 		///
		, replace c(b & _star se) label

	// xml_tab
	xml_tab ${regressions} 								///
		, save("${outputs_3_1}/tablas/xml_tab.xls") 	///
			replace below

	// outwrite
	outwrite ${regressions} 							///
		using "${outputs_3_1}/tablas/outwrite.xlsx" 	///
		, replace
	
