/********************************************************************************
* Título:		Análisis de Datos (ESTTAB)
* Sesion: 		Sesión 7
* Autor:		Rony Rodriguez-Ramirez
* Proposito: 	Replicación del paper Card and Krueger (1994)
*********************************************************************************
	
*** Outline:
	1. 	Analisis
		1.1 Load data
		1.2 Correr regresiones
	
	Input: 	census.dta
	Output: tablas
	
********************************************************************************
***	PART 1: Analisis
*******************************************************************************/

***	1.1 Load the data	
	use "${data_4_1}/Card and Krueger 1994.dta", clear 

*** 1.2 Componer labels y tipo de variables
	label var bk 		"Burger King"
	label var kfc 		"KFC"
	label var roys 		"Roy Rogers"
	label var wendys 	"Wendy's "
	label var co_owned 	"Company-owned"
	label var emptot 	"FTE employment"
	label var wage_st 	"Starting Wage"
	label var pmeal 	"Price of full meal"
	label var hrsopen 	"Hours open (weekday)" 
	label var emptot2 	"FTE employment"
	label var wage_st2 	"Starting Wage"
	label var pmeal2 	"Price of full meal"
	label var hrsopen2 	"Hours open (weekday)" 

***	1.3 Tabla 2: Mean of key variables
	global 	tab2_1 		///
			bk 			///
			kfc 		///
			roys 		///
			wendys 		///	
			co_owned
	
	global 	tab2_2		///
			emptot 		///
			wage_st 	///
			pmeal 		///
			hrsopen 	///
	
	global 	tab2_3		///
			emptot2 	///
			wage_st2 	///
			pmeal2 		///
			hrsopen2		
			
***	1.4 Fix the variables
	foreach var in $tab2_1 {
		replace `var' = 100 * `var'
	}
	
********************************************************************************
***	PART 2: TABLA 2
********************************************************************************	

*** 2.1 Esttab the variables
	//	------------------------------------------------------------------------
	//	2.1.1 Distribution of Store Type (percentages)
	//	------------------------------------------------------------------------
	eststo clear 
	estpost ttest $tab2_1, by(pa) uneq 
	
	//	Excel
	esttab using "${outputs_4_1}/tablas/tab2_1.csv", 	///
		cells("mu_1(fmt(1)) mu_2(fmt(1)) t(fmt(1))") 	///
		wide nonumber noobs nomtitle label replace
		
	// 	Latex
	esttab using "${outputs_4_1}/tablas/tab2_1.tex", 	///
		cells("mu_1(fmt(1)) mu_2(fmt(1)) t(fmt(1))") 	///
		wide nonumber fragment noobs nogaps				///
		nofloat collabels(none) noline label replace
	
	//	------------------------------------------------------------------------
	//	2.1.2 Means in Wave 1
	//	------------------------------------------------------------------------
	eststo clear 
	estpost ttest $tab2_2, by(pa) uneq
	
	//	Excel
	esttab using "${outputs_4_1}/tablas/tab2_2.csv", 	///
		cells("mu_1(fmt(1)) mu_2(fmt(1)) t(fmt(1))") 	///
		wide nonumber nomtitle noobs label replace		
		
	//	Latex
	matrix m1 = J(8,4,.)
	matrix list m1 

	local i = 1 
	local j = 2
	foreach var in $tab2_2 {
		ttest `var', by(pa) uneq
		
		matrix m1[`i',2] = round(`r(mu_1)', .01)
		matrix m1[`i',3] = round(`r(mu_2)', .01)
		matrix m1[`i',4] = round(`r(t)', .01)
		
		matrix m1[`j',2]	= round(`r(sd_1)' / sqrt(`r(N_1)'), .01) 
		matrix m1[`j',3]	= round(`r(sd_2)' / sqrt(`r(N_2)'), .01) 
		
		local i = `i' + 2
		local j = `j' + 2
	}

	matrix list m1
	
	preserve 
		clear
		svmat m1, names(col) 
		
		tostring *, format("%2.1f") replace force
		
		foreach var of varlist c2 c3 {
			forvalues x = 2(2)8 {
				replace `var' = "(" + `var' + ")" if _n == `x' 
			}
		}
		
		//	Variables Column 1
		replace c1 = "FTE employment" 				if _n == 1
		replace c1 = "Starting wage" 				if _n == 3
		replace c1 = "Price of full meal" 			if _n == 5 
		replace c1 = "Hours open (weekday)" 		if _n == 7
		
		replace c1 = "" if c1 == "." 
		replace c4 = "" if c4 == "."
				
		// Excel
		outsheet using "${outputs_4_1}/tablas/tab2_2.csv", 		////
				 comma nonames noquote nolabel replace		
				
		replace c`c(k)' =  c`c(k)' + "\\"
		replace c`c(k)' =  "" + "\\" if c`c(k)' == ".\\"
	
		foreach col of varlist c1-c3 {
			replace `col' = "" if `col' == "."
			replace `col' = `col' + "&"
		}

		// Export to TeX
		outsheet using "${outputs_4_1}/tablas/tab2_2.tex", 		////
				 nonames noquote nolabel replace
		
	restore 
	
	//	------------------------------------------------------------------------
	//	2.1.3 Means in Wave 2
	//	------------------------------------------------------------------------
	eststo clear 
	estpost ttest $tab2_3, by(pa) uneq
	
	//	Excel
	esttab using "${outputs_4_1}/tablas/tab2_3.csv", 	///
		cells("mu_1(fmt(1)) mu_2(fmt(1)) t(fmt(1))") 	///
		wide nonumber nomtitle noobs label replace		
	
	//	Latex
	matrix m1 = J(8,4,.)
	matrix list m1 

	local i = 1 
	local j = 2
	foreach var in $tab2_3 {
		ttest `var', by(pa) uneq
		
		matrix m1[`i',2] = round(`r(mu_1)', .01)
		matrix m1[`i',3] = round(`r(mu_2)', .01)
		matrix m1[`i',4] = round(`r(t)', .01)
		
		matrix m1[`j',2]	= round(`r(sd_1)' / sqrt(`r(N_1)'), .01) 
		matrix m1[`j',3]	= round(`r(sd_2)' / sqrt(`r(N_2)'), .01) 
		
		local i = `i' + 2
		local j = `j' + 2
	}

	matrix list m1
	
	preserve
		clear
		svmat m1, names(col) 
		
		tostring *, format("%2.1f") replace force
		
		foreach var of varlist c2 c3 {
			forvalues x = 2(2)8 {
				replace `var' = "(" + `var' + ")" if _n == `x' 
			}
		}
		
		//	Variables Column 1
		replace c1 = "FTE employment" 				if _n == 1
		replace c1 = "Starting wage" 				if _n == 3
		replace c1 = "Price of full meal" 			if _n == 5 
		replace c1 = "Hours open (weekday)" 		if _n == 7
		
		
		replace c`c(k)' =  c`c(k)' + "\\"
		replace c`c(k)' =  "" + "\\" if c`c(k)' == ".\\"

		foreach col of varlist c1-c3 {
			replace `col' = "" if `col' == "."
			replace `col' = `col' + "&"
		}

		// Exrpot to TeX
		outsheet using "${outputs_4_1}/tablas/tab2_3.tex", 		////
				 nonames noquote nolabel replace	
	restore
	
********************************************************************************
***	PART 3: TABLA 3
********************************************************************************		

	//	------------------------------------------------------------------------
	//	3.1 Generar variables necesarias para el análisis
	//	------------------------------------------------------------------------
		
	// Change and Gap
	gen 	d_emp	= emptot2 - emptot
	gen 	gap 	= (5.05-wage_st) / wage_st
	replace gap 	= 0 if pa==1
	replace gap 	= 0 if wage_st>=5.05

	// Drop vars con missings y que no estuvieron cerradas
	drop if missing(wage_st)	& closed!=1
	drop if missing(wage_st2) 	& closed!=1
	drop if missing(d_emp) 		& closed!=1
	
	// Componer labels
	label var gap "Intitial wage gap"
	label var nj "New Jersey dummy"
	label var gap "Initial wage gap" 

	global chains_owned "kfc roys wendys co_owned"
	global regions 		"southj centralj pa1 pa2"
	
	//	------------------------------------------------------------------------
	// 3.2 Exportar resultados utilizando outreg2 
	//	------------------------------------------------------------------------
	#delimit ; 
	qui reg d_emp nj 												/* Col 1 */; 
			outreg2 using "${outputs_4_1}/tablas/tab4.xls",  
			bdec(2) sdec(2) e(rmse) nocons noobs nor2 label keep(nj) 
			title(Table 4: Reduced-Form Models for Change in Employment)
			ctitle("i") 
			addtext(Controls for chain and ownership, no, Controls for region, no)
			replace;  
			
	qui reg d_emp nj $chains_owned 									/* Col 2 */;
	test (kfc=roys=wendys=co_owned=0); 
	local test1=r(p); 
			outreg2 using "${outputs_4_1}/tablas/tab4.xls", 
			bdec(2) sdec(2) e(rmse) addstat(Probability value for controls, `test1')
			addtext(Controls for chain and ownership, yes, Controls for region, no)
			nocons noobs nor2 label keep(nj) 
			ctitle("ii") ;  
	
	qui reg d_emp gap 												/* Col 3 */;
			outreg2 using "${outputs_4_1}/tablas/tab4.xls",  
			bdec(2) sdec(2) e(rmse) nocons noobs nor2 label keep(gap)
			addtext(Controls for chain and ownership, no, Controls for region, no)
			ctitle("iii") ;  
	
	qui reg d_emp gap $chains_owned  								/* Col 4 */;
	test (kfc=roys=wendys=co_owned=0); 
	local test2=r(p); 
			outreg2 using "${outputs_4_1}/tablas/tab4.xls",  
			bdec(2) sdec(2) e(rmse) addstat(Probability value for controls, `test2')
			addtext(Controls for chain and ownership, yes, Controls for region, no)
			nocons noobs nor2 label keep(gap) 
			ctitle("iv") ;
	
	qui reg d_emp gap $chains_owned $regions 						/* Col 5 */; 
	test (kfc=roys=wendys=co_owned==southj=centralj=pa1=pa2=0); 
	local test3 = r(p) ; 
			outreg2 using "${outputs_4_1}/tablas/tab4.xls",   
			bdec(2) sdec(2) e(rmse) addstat(Probability value for controls, `test3')
			addtext(Controls for chain and ownership, yes, Controls for region, yes)
			nocons noobs nor2 label keep(gap)
			ctitle("v") ;
	#delimit cr 	
		
	//	------------------------------------------------------------------------	
	// 3.3 Exportar resultados utilizando esttab
	//	------------------------------------------------------------------------
	eststo clear 
	
	// Col 1
	eststo reg1: reg d_emp nj
		estadd local controls	"no"
		estadd local regions	"no"

	// Col 2
	eststo reg2: reg d_emp nj $chains_owned 
		estadd local controls	"yes"	
		estadd local regions	"no"	
		
		test (kfc=roys=wendys=co_owned=0)
		estadd scalar test = r(p)	

	// Col 3 
	eststo reg3: reg d_emp gap
		estadd local controls	"no"
		estadd local regions	"no"

	// Col 4
	eststo reg4: reg d_emp gap $chains_owned  
		estadd local controls	"yes"
		estadd local regions	"no"	
		
		test (kfc=roys=wendys=co_owned=0)
		estadd scalar test = r(p)
		
	// Col 5
	eststo reg5: reg d_emp gap $chains_owned $regions 
		estadd local controls	"yes"	
		estadd local regions	"yes"
	
		test (kfc=roys=wendys=co_owned==southj=centralj=pa1=pa2=0)
		estadd scalar test = r(p) 
	
	local regressions reg1 reg2 reg3 reg4 reg5
	
	esttab `regressions'						///
		using "${outputs_4_1}/tablas/tab4.tex", ////
		keep(nj gap)							///
		cells("b(fmt(2))" "se(par fmt(2))")		///
		stat(controls regions rmse test, 		///
			labels("Controls for chain and ownership" "Controls for region" "Standard error of regression" "Probability value for controls"))	///
		label nogaps fragment nomtitle nonumbers nodep nolines	///
		replace collabels(none)
	

	
	
	