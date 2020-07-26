/********************************************************************************
* Título:		Análisis de Datos (ESTTAB)
* Sesion: 		Sesión 8
* Autor:		Rony Rodriguez-Ramirez
* Proposito: 	Replicación del paper Pop-Eleches and Urquiola (2013)
*********************************************************************************
	
*** Outline:
	1. 	Analisis
		1.0 Global settings
		1.1 Load data
		1.2 Componer labels
		1.3 Drop observaciones y collapsar data
		1.4 Regresiones a cada lado del cutoffs
		1.5 Figure (scatter plot)
		1.6 Exportar figura
	
	Input: 	pop-eleches-urquiola-2013
	Output: figuras
	
********************************************************************************
***	PART 1: Analisis
*******************************************************************************/

*** 1.0 Global settings
	global 	fig legend(off) 												///
			mcolor(black red green)  clcolor(black red green)  				///
			scheme(s1color) msymbol(Oh p p) xline(0) sort connect(. l l)
			
***	1.1 Load the data	
	use "${data_4_2}/pop-eleches-urquiola-2013.dta", clear 

*** 1.2	Componer labels
	label var relativescore "transition scores relative to the cutoffs"
	label var score 		"transition scores"
	label var bexam_grade 	"the baccalaureate exam grade"

*** 1.3 Drop observaciones y collapssar data
	drop if relativescore>=.2 | relativescore<=-.2
	sum score bexam_grade relativescore

	collapse (mean) score bexam_grade, by(relativescore) 
	
*** 1.4 Regresiones a cada lado del cutoff
	qui: reg score relativescore if relativescore<0 & relativescore!=0 
	predict panela1 if relativescore<0
	
	qui: reg score relativescore if relativescore>0 & relativescore!=0
	predict panela2 if relativescore>0

*** 1.5 Figure (scatter plot)
	twoway 	scatter score panela1 panela2 relativescore 		///
			if relativescore!=0, $fig							///
			ytitle(School level score) 							///
			xtitle(Score distance to cutoff) 					///
			title(Panel A: Average transition score, position(11) size(medium))
	
*** 1.6 Exportar figura
	graph export "${outputs_4_2}/fig1.pdf", replace 

		
		