/********************************************************************************
* Título:	Análisis de Datos
* Sesion: 	Sesión 5
* Autor:	Rony Rodriguez-Ramirez
* Proposito: Crear base al nivel HPSC constructed (construída)
*********************************************************************************
	
*** Outline:
	1. 	Analisis
		1.1 Load dataset
		1.2 Crear matrix vacia
		1.3 Panel A
		1.4 Panel B
		1.5 Matrix to dataset and export to excel
		1.6 Outsheet
	
	Input: 	census.dta
	Output: tablas
	
*********************************************************************************
***	PART 1: Analisis
********************************************************************************/

***	1.1 Load dataset
	use "${data_3_2}/Burde and Linden 2013.dta", clear
		
*** 1.2 Fix labels
	label define treatment 0"Control" 1"Treatment"
	label values treatment treatment 
	label var f07_heads_child_cnt 	"Household head's child"
	label var f07_girl_cnt			"Girl"
	label var f07_age_cnt 			"Age"
	label var f07_duration_village_cnt "Yers family in village"
	label var f07_farsi_cnt 		"Farsi"
	label var f07_tajik_cnt		 	"Taijik"
	label var f07_farmer_cnt 		"Farmers"
	label var f07_age_head_cnt 		"Age of household head"
	label var f07_yrs_ed_head_cnt  	"Years of education of household head"
	label var f07_num_ppl_hh_cnt  	"Number of people in household"
	label var f07_jeribs_cnt 		"Jeribs of Land" 
	label var f07_num_sheep_cnt 	"Number of Sheep"
	label var f07_nearest_scl 		"Distance to nearest formal school (non village-based school)"

*** 1.2 Crear variable atrición
	gen 		attrition = f07_observed == 1 & s08_observed == 0 
	label var 	attrition "Attrition" 

*** 1.3 Crear variable interacción entre atrición y treatment
	gen 		attrit_treat = attrition * treatment
	label var 	attrit_treat "Interaction Attrit * Treatment"

*** 1.4 Exportar a excel
	// Globals
	global panela 	attrition
	global panelb 	f07_heads_child_cnt 		///
					f07_girl_cnt 				///
					f07_age_cnt 
	global panelc 	f07_duration_village_cnt 	///
					f07_farsi_cnt 				///
					f07_tajik_cnt 				///
					f07_farmer_cnt 				///
					f07_age_head_cnt 			///
					f07_yrs_ed_head_cnt 		///
					f07_num_ppl_hh_cnt 			///
					f07_jeribs_cnt 				///
					f07_num_sheep_cnt 			///
					f07_nearest_scl

	// Table 3
	gen control = 1-treatment
	iebaltab ${panela} ${panelb} ${panelc},	///
		grpvar(control)						///
		rowvarlabels 						///
		save("${outputs_3_2}/tablas/tab_3_bal_tab.xlsx") replace
		
		
	// Table 3: With correct specifications
	est clear 
	eststo reg1: qui reg attrition if treatment==1 & f07_observed==1 					/* Treatment Average		*/ 
	eststo reg2: qui reg attrition if treatment==0 & f07_observed==1 					/* Control Average 			*/ 
	eststo reg3: qui reg attrition treatment if f07_observed==1 , cluster(clustercode) 	/* Estimated Difference 	*/ 

	local regs reg1 reg2 reg3 
	esttab `regs' using "${outputs_3_2}/tablas/tab_3.csv", se replace
	
	
	
	
	
	
	
	