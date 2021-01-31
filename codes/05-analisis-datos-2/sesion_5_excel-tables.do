/********************************************************************************
* Título:		Análisis de Datos
* Sesion: 		Sesión 5
* Autor:		Rony Rodriguez-Ramirez
* Proposito: 	Crear tablas y exportar a excel
*********************************************************************************
	
*** Outline:
	1. 	Exportar tablas a excel
		1.1 Cargar base de datos
		1.2 Correr regressiones
		1.3 Exportar tablas: Excel
	
	Input: 	census.dta
	Output: tablas
	
*********************************************************************************
***	PART 1: Exportar tablas a excel
********************************************************************************/

***	1.1 Cargar base de datos
	set seed 474747
	sysuse census.dta , clear

*** 1.2 Correr regresiones
	estimates clear 
	
	// Regression 1: nothing interesting
	reg divorce marriage pop
		est sto reg1

	// Regression 2: una regresion diferente
	reg medage popurban
		est sto reg2

	// Regression 3: incluir una variable dummy
	reg divorce marriage pop i.region
		est sto reg3

	// Regression 4: interacciones 
	gen binary = rnormal() > 0
		lab def binary 0 "No" 1 "Yes"
		lab val binary binary
		label var binary "Indicator"

	reg divorce marriage pop i.region#i.binary
		est sto reg4

*** 1.3 Exportar tables: Excel
	global regressions reg1 reg2 reg3 reg4

	// outreg2
	outreg2 [${regressions}] 							///
		using "${outputs_3_1}/tablas/outreg.xls" 		///
		, replace excel label
	
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
	
	
	
	
	
