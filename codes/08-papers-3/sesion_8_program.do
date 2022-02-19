/********************************************************************************
* Título:		  Análisis de Datos (ESTTAB)
* Sesion: 		Sesión 8
* Autor:		  Rony Rodriguez-Ramirez
* Proposito: 	Programando códigos en Stata
*********************************************************************************
	
*** Outline:
	1. 	Programación
		1.0 Global settings
		1.1 Load the data
		1.2 Ejempos de programas
			1.2.1 Ejemplo sencillo 1: Pikachu
			1.2.2 Ejemplo sencillo 2: Obteniendo la fecha actual pero como oración
			1.2.3 Ejemplo utilizando RClass type
			1.2.4 Mean SE
			1.2.5 Combinando regresiones y demás 	
			1.2.6 Ejemplo utilizando EClass type	
			
	Input: 	census.dta
	
********************************************************************************
***	PART 1: Programación
*******************************************************************************/

*** 1.0 Global settings
	global stars "label nolines nogaps nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01) collabels(none)"
	
***	1.1 Load the data	
	sysuse census.dta, clear 
	
	// 1.1.1 Generar variable treatment (tratamiento) para uso en los ejemplos
	set seed 19950124
	
	gen rand = runiform()
	gen treatment = (rand > 0.5) 
	
*** 1.2 Ejemplos de programs

	//	1.2.1 Ejemplo sencillo 1: Pikachu
	 
  // Program sin argumentos  
	capture program drop pikachu 
	program define pikachu 
		display as result "⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⣠⣤⣶⣶"
		display as result "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⢰⣿⣿⣿⣿"
		display as result "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣀⣀⣾⣿⣿⣿⣿"
		display as result "⣿⣿⣿⣿⣿⡏⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿"
		display as result "⣿⣿⣿⣿⣿⣿⠀⠀⠀⠈⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠁⠀⣿"
		display as result "⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠙⠿⠿⠿⠻⠿⠿⠟⠿⠛⠉⠀⠀⠀⠀⠀⣸⣿"
		display as result "⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿"
		display as result "⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣴⣿⣿⣿⣿"
		display as result "⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⢰⣹⡆⠀⠀⠀⠀⠀⠀⣭⣷⠀⠀⠀⠸⣿⣿⣿⣿"
		display as result "⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠈⠉⠀⠀⠤⠄⠀⠀⠀⠉⠁⠀⠀⠀⠀⢿⣿⣿⣿"
		display as result "⣿⣿⣿⣿⣿⣿⣿⣿⢾⣿⣷⠀⠀⠀⠀⡠⠤⢄⠀⠀⠀⠠⣿⣿⣷⠀⢸⣿⣿⣿"
		display as result "⣿⣿⣿⣿⣿⣿⣿⣿⡀⠉⠀⠀⠀⠀⠀⢄⠀⢀⠀⠀⠀⠀⠉⠉⠁⠀⠀⣿⣿⣿"
		display as result "⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿"
		display as result "⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿"
	end 

	pikachu
	
	// 1.2.2 Ejemplo sencillo 2: Obteniendo la fecha actual pero como oración
	capture program drop mifecha
	
	program define mifecha
		display as result "Hoy es " c(current_date) " y son las " c(current_time)
	end 
	
	mifecha
	
	// 1.2.3 Ejemplo utilizando RClass type	
	// My sum	
	capture program drop mysum
	program define mysum, rclass
		version 14
		syntax varname
		return local varname `varlist'
		
		tempvar new
		quietly {
			count if !missing(`varlist')
			return scalar N = r(N)
			gen double `new' = sum(`varlist')
			return scalar sum = `new'[_N]
			return scalar mean = return(sum)/return(N)
		}
	end	

	mysum pop
	ret list 
		
	// 1.2.4 Mean SE (Promedio / Error Estándar)
	capture program drop meanse
	program meanse, rclass
		version 14
		
		syntax varname 
		return local varname `varlist'
		
		quietly summarize `varlist'
		local mean = r(mean)
		local sem = sqrt(r(Var)/r(N))
		display as result "Media = " `mean'
		display as result "Error St. de la media = " `sem'
		return scalar mean = `mean'
		return scalar se = `sem'
	end
  
	foreach var of varlist * {
		display as result "`var'"
		meanse `var'
	}
	
	// 1.2.5 Combinando regresiones y demás (eclass)	
	capture program drop regmultiple 
	
	program define regmultiple, eclass
		syntax varlist, by(varname)
		
		marksample touse
		markout `touse' `by'

		foreach var of local varlist {
		    eststo: reg `var' `by'
		}
	end
  
  eststo clear
  regmultiple pop*, by(treatment)
	

	// 1.2.6 Ejemplo utilizando EClass type	
	capture program drop tvsc
	
	program tvsc, eclass
		syntax varlist [aw pw] [if] [in], by(varname)           ///
      clus_id(varname numeric) strat_id(varlist fv) [ * ]

		marksample 	touse
		markout 	`touse' `by'
		tempname 	mu_1 mu_2 mu_3 mu_4 ///
              se_1 se_2 se_3 se_4 ///
              d_p d_p2            ///
              N_C N_T S_C S_T N_S N_FE S_S S_FE
		
		capture drop TD*
		tab `by' , gen(TD)
		
		foreach var of local varlist {
			reg `var' TD1 TD2  [`weight' `exp'] `if', nocons vce(cluster `clus_id')
			mat `N_S' = nullmat(`N_S'), e(N)
			mat `S_S' = nullmat(`S_S'), e(N_clust)
			test (_b[TD1] - _b[TD2] == 0)
			mat `d_p'  = nullmat(`d_p'), r(p)
			matrix A = e(b)
			lincom (TD1 - TD2)

			mat `mu_3' = nullmat(`mu_3'), A[1,2]-A[1,1]
			mat `se_3' = nullmat(`se_3'), r(se)

			sum `var' [`weight' `exp'] if TD1==1 & e(sample)==1
			mat `mu_1' = nullmat(`mu_1'), r(mean)
			mat `se_1' = nullmat(`se_1'), r(sd)/sqrt(r(N))
			mat `N_C' = nullmat(`N_C'), r(N)
			qui tab `clus_id' if TD1==1 & e(sample)==1
			mat `S_C' = nullmat(`S_C'),  r(r)

			sum `var' [`weight' `exp'] if TD2==1 & e(sample)==1
			mat `mu_2' = nullmat(`mu_2'),r(mean)
			mat `se_2' = nullmat(`se_2'), r(sd)/sqrt(r(N))
			mat `N_T' = nullmat(`N_T'), r(N)
			qui tab `clus_id' if TD2==1 & e(sample)==1
			mat `S_T' = nullmat(`S_T'),  r(r)

			reghdfe `var' TD1 TD2 [`weight' `exp'] `if',  vce(cluster `clus_id') absorb(`strat_id')
			mat `N_FE' = nullmat(`N_FE'), e(N)
			mat `S_FE' = nullmat(`S_FE'), e(N_clust)
			test (_b[TD1]- _b[TD2]== 0)
			mat `d_p2'  = nullmat(`d_p2'),r(p)
			matrix A = e(b)
			lincom (TD1 - TD2)
			
			mat `mu_4' = nullmat(`mu_4'), A[1,2]-A[1,1]
			mat `se_4' = nullmat(`se_4'), r(se)
		}
		
		foreach mat in mu_1 mu_2 mu_3 mu_4 se_1 se_2 se_3 se_4 d_p d_p2 N_C N_T S_C S_T N_S N_FE S_S S_FE {
			mat colnames ``mat'' = `varlist'
		}
		
		local cmd "tvsc"
		foreach mat in mu_1 mu_2 mu_3 mu_4  se_1 se_2 se_3 se_4 d_p d_p2 N_C N_T S_C S_T N_S N_FE S_S S_FE {
			eret mat `mat' = ``mat''
		}
		
		drop TD*
	end
	
	// Modificar variables de acuerdo a nuestro comando (e.g., Factor Variables)
	drop state2
	encode state, gen(state2)
	
	// Run tvsc
	eststo clear 
	tvsc medage divorce marriage death, by(treatment) clus_id(state2) strat_id(region)
	
	// Esttab
	esttab,						///
		$stars 					///
		cells("mu_2(fmt(2)) mu_1(fmt(2)) mu_3(fmt(2)) mu_4(fmt(2))" "se_2(par) se_1(par) se_3(par) se_4(par)") 
