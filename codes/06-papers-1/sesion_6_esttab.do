/********************************************************************************
* Título:		Análisis de Datos (ESTTAB)
* Sesion: 		Sesión 6
* Autor:		Rony Rodriguez-Ramirez
* Proposito: 	Uso de Esttab
*********************************************************************************
	
*** Outline:
	1. 	Analisis
		1.1 Load data
		1.2 Correr regresiones
	
	Input: 	census.dta
	Output: tablas
	
*********************************************************************************
***	PART 1: Analisis
********************************************************************************/

***	1.1 Load the data	
	sysuse census.dta, clear
	xtset region

***	1.2 Correr regresiones

	// Regression 1: nothing interesting
	reg death marriage pop
	
	est sto reg1
	estadd local region	"No"

	// Regression 2: a different regression
	reg death popurban
	
	est sto reg2
	estadd local region "No"

	// Regression 3: indicator expansion
	reg divorce marriage pop
	
	est sto reg3
	estadd local region "No"

	// Regression 4: categorical control
	reg divorce marriage pop i.region
	
	est sto reg4
	estadd local region "Yes"
	
	// South region only
	reg death marriage if region == 3
	est sto s1
	
	reg death marriage pop if region == 3
	est sto s2
	
	// West region only
	reg death marriage if region == 4
	est sto w1
	
	reg death marriage pop if region == 4
	est sto w2

*** 1.3 Exportar tables 

	local regressions reg1 reg2 reg3 reg4

	*---------------------------------------------------------------------------
	* Regresión simple
	*---------------------------------------------------------------------------
	esttab `regressions' using "${outputs_3_2}/tablas/t1_esttab_basic.csv", ///
		replace
	
	*---------------------------------------------------------------------------
	* Regresión agregando las etiquetas a las variables
	*---------------------------------------------------------------------------
	esttab `regressions' using "${outputs_3_2}/tablas/t2_esttab_label.csv", ///
		label	///	Add variable labels
		se		/// Display standard errors instead of t-statistics 
		replace	
			
	*---------------------------------------------------------------------------
	* Removiendo variable omitida de las categoricas 
	*---------------------------------------------------------------------------
	esttab `regressions' using "${outputs_3_2}/tablas/t3_esttab_omitted.csv",	///
		ci 																		/// Muestra los intervalos de confianza
		noomit nobaselevels														/// Remueve variables omitidas por multicollinearity y variables categoricas (nivel base)
		refcat(_cons "Omitted category: NE region", nolabel)					/// Agrega nota con información de la región omitida -- refcat() tiene más funcionalidades
		addnotes("Add a note here." "Other custom note here.")  				/// Cada nota se agregará en una nueva linea
		label 																	///
		replace		

	*---------------------------------------------------------------------------
	* La opción 'drop' le permite eliminar variables de la tabla final.
	* Utilice nombres de variables para enumerar todas las variables que se eliminarán. Si quieres
	* eliminar categorías específicas dentro de variables categóricas, escriba
	* 'mat list r (table)' para ver cómo se refiere Stata a cada categoría (en el
	* nombres de columna)
	* La opción 'keep' haría lo contrario, manteniendo solo las variables enumeradas.
	* La opción 'order' le permite especificar el orden o las filas.
	*---------------------------------------------------------------------------
	
	esttab `regressions' using "${outputs_3_2}/tablas/t4_esttab_scalar.csv", 	///
		ci 																		/// Muestra los confidence intervals
		drop(*.region*)															///	Remueve los efectos fijos														
		scalars("region Region controls")  										/// Agrega una nueva fila que indica donde están los efectos fijos
		addnotes("Add a note here." "Other custom note here.")  				/// Cada nota se agregará en una nueva linea
		label 																	///
		replace	
		
	
	*---------------------------------------------------------------------------
	* Add custom model titles and table notes
	*---------------------------------------------------------------------------
	esttab `regressions' using "${outputs_3_2}/tablas/t5_esttab_titles.csv", 	///
		mtitles("Title 1" "Title 2" "Title 3" "Title 4") 						/// Muestra títlos de las columnas
		se																		/// Display standard errors en vez de of t-statistics 
		drop(*.region*) 														///																
		scalars("region Region controls") 										/// 
		addnotes("Add a note here." "Other custom note here.")  				/// Cada nota se agregará en una nueva linea
		label 																	///
		replace
	