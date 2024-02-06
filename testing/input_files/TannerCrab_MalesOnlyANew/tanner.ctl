## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## LEADING PARAMETER CONTROLS                                                           ##																					
##     Controls for leading parameter vector (theta)                                    ##																					
## LEGEND                                                                               ##																					
##     prior: 0 = uniform, 1 = normal, 2 = lognormal, 3 = beta, 4 = gamma               ##"																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## ntheta																					
72		#<- 9 + 31 + 32 TODO: move M's to M section, move initial N first(?), move expected recruitment value & scale(?)															
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## ival            lb       ub        phz   prior     p1      p2         # parameter       ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
    0.271     	   0.15      0.7        4       1    0.271   0.0154      # M (male)																					
#    0.271     	   0.15      0.7        4       1    0.271   0.0154      # M (female)																					
   16.5   		 -10        20         -2       0  -10.0    20.0         # logR0: estimated if initialized at unfished																				
   15.0    		 -10        30          1       0   10.0    20.0         # logRini, to estimate if NOT initialized at unfished (n68)																					
   13.26245375	 -10        30          1       0   10.0    20.0         # logRbar, to estimate if NOT initialized at unfished      																					
   32.5    		   7.5      42.5       -4       0   32.5     2.25        # recruitment distribution expected value (males or combined)																					
	1.0	   		0.1      10	        -4       0    0.1     5.0         # recruitment distribution scale (variance component) (males or combined)																				
#    0.0    	 	 -10        10         -4       0    0.0    20.00        # recruitment expected value (females)																					
#    0.0    	  	 -10        10 	     -3       0    0.0    20.0         # recruitment scale (variance component) (females)																				
   -0.9    	 	 -10         0.75      -4       0  -10.0     0.75        # ln(sigma_R)																					
    0.75 	      0.20      1.00      -2       3    3.0     2.00        # steepness																					
    0.01    	   0.0001    1.00      -3       3    1.01    1.01        # recruitment autocorrelation																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## ival      lb      ub        phz    prior  p1      p2          # parameter            ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
# immature males	(normalization class)
##	0.0 	-10      25        -1       0   10.0    20.00        # Deviation for size-class 1	# mature males	(normalization class)																
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 2																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 3																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 4																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 5																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 6																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 7																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 8																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 9																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 10																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 11																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 12																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 13																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 14																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 15																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 16																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 17																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 18																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 19																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 20																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 21																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 22																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 23																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 24																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 25																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 26																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 27																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 28																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 29																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 30																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 31																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 32	
# mature males	(normalization class)																		
	0.0 	-10      25         1       0   10.0    20.00        # Deviation for size-class 1																	
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 2																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 3																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 4																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 5																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 6																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 7																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 8																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 9																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 10																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 11																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 12																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 13																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 14																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 15																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 16																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 17																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 18																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 19																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 20																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 21																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 22																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 23																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 24																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 25																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 26																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 27																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 28																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 29																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 30																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 31																		
	0.0 	-20      25         1       0   10.0    20.00        # Deviation for size-class 32																		
## weight-at-length input	method
#--1 = allometry [w_l = a*l^b]
#--2 = vector by sex													
1																					
# Males		
0.00000000027    3.022134   #--in grams TODO: rescale to ??														
0.00000000027    3.022134   #--in grams TODO: rescale to ??														
# maturity (by size, 1 row/sex)
# 25  30  35  40  45  50  55  60  65  70  75  80  85  90  95  100  105  110  115  120  125  130  135  140  145  150  155  160  165  170  175  180
   0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1 
# legal proportion  (by size, 1 row/sex)
# 25  30  35  40  45  50  55  60  65  70  75  80  85  90  95  100  105  110  115  120  125  130  135  140  145  150  155  160  165  170  175  180
0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  1  1  1  1  1  1  1  1  1  1  1
## Use functional maturity
0
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## GROWTH PARAMETER CONTROLS                                                            ##																					
##     Two lines for each parameter if split sex, one line if not                       ##																					
##     Currently if growth parameters change, moltin gprobabilities also must"			##																		
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
# Use growth transition matrix option 
#--1: read in growth-increment matrix; 
#--2: read in size-transition; 
#--3: gamma distribution for size-increment; 
#--4: gamma distribution for size after increment																				
#--5: Von Bert.: kappa varies among individuals
#--6: Von Bert.: Linf varies among individuals
#--7: Von Bert.: kappa and Linf varies among individuals
#--8: Growth increment is normally distributed
4		#--bUseCustomGrowthMatrix
#----------------------------
# Options for the growth increment model matrix
#--1: Linear     (alpha/beta??)
#--2: Individual (estimated by size-class??)
#--3: Individual (Same as 2; pre-specified/emprical??)
1     #--bUseGrowthIncrementModel
#----------------------------
# molt probability function
#--0=pre-specified
#--1=flat
#--2=declining logistic
#--3=free parameters																				
3	# bUseCustomMoltProbability																
#----------------------------
## Maximum size-class for recruitment (1 value/sex)																					
6																				
## number of size-increment periods																					
1        #--nSizeIncVaries																		
## Year(s) size-increment period changes (blank if no changes)																					
         #--iYrsSizeIncChanges
## number of molt periods (1 value/sex)																			
1        #--nMoltVaries												
## Year(s) molt period changes (blank if no changes)																					
         #--iYrsMoltChanges
## Beta parameters are relative (1=Yes;0=no)																					
0																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## ival      lb      ub   phz  prior     p1      p2          # parameter       ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
	 2.049	-5			20		3		1		 2.049		1		# Male alpha  TODO: fix for Tanner
	-0.2258	-1			 0		3		1		-0.2258		0.5	# Male beta   TODO: fix for Tanner
	 0.25	 0.001	 5	  -3		0		 0			 999		# Male scale  TODO: fix for Tanner
## ——————————————————————————————————————————————————————————————————————————————————— ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## MOLTING PROBABILITY CONTROLS                                                         ##																					
##     Two lines for each parameter if split sex, one line if not                       ##																					
##     If free molting probability, list a probability for each size class and sex 	    ##																			
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## ival       lb        ub        phz   prior     p1      p2          # parameter       ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ## 																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## ival     lb    ub    phz prior  p1   p2      # parameter                             ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
0.001			0		1		-3		0		0	999		# Males	25
0.001			0		1		-3		0		0	999		# Males	30
0.001			0		1		-3		0		0	999		# Males	35
0.001			0		1		-3		0		0	999		# Males	40
0.001			0		1		-3		0		0	999		# Males	454
0.001			0		1		-3		0		0	999		# Males	50
0.001			0		1		-3		0		0	999		# Males	55
0.047425873	0		1		-3		0		0	999		# Males	60
0.07585818	0		1		-3		0		0	999		# Males	65
0.119202922	0		1		-3		0		0	999		# Males	70
0.182425524	0		1		-3		0		0	999		# Males	75
0.268941421	0		1		-3		0		0	999		# Males	80
0.377540669	0		1		-3		0		0	999		# Males	85
0.5			0		1		-3		0		0	999		# Males	90
0.622459331	0		1		-3		0		0	999		# Males	95
0.731058579	0		1		-3		0		0	999		# Males	100
0.817574476	0		1		-3		0		0	999		# Males	105
0.880797078	0		1		-3		0		0	999		# Males	110
0.92414182	0		1		-3		0		0	999		# Males	115
0.952574127	0		1		-3		0		0	999		# Males	120
0.970687769	0		1		-3		0		0	999		# Males	125
0.98201379	0		1		-3		0		0	999		# Males	130
0.989013057	0		1		-3		0		0	999		# Males	135
0.993307149	0		1		-3		0		0	999		# Males	140
0.999999989	0		1		-3		0		0	999		# Males	145
0.999999989	0		1		-3		0		0	999		# Males	150
0.999999989	0		1		-3		0		0	999		# Males	155
0.999999989	0		1		-3		0		0	999		# Males	160
0.999999989	0		1		-3		0		0	999		# Males	165
0.999999989	0		1		-3		0		0	999		# Males	170
0.999999989	0		1		-3		0		0	999		# Males	175
0.999999989	0		1		-3		0		0	999		# Males	180
# ———————————————————————————————————————————————————————————————————————————————————— ##																					
##====================================================================
# Read in custom growth transtion matrices (if any)
#====================================================================
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## SELECTIVITY CONTROLS                                                                 ##																					
##     Selectivity P(capture of all sizes).                                             ##
##     Each gear must have a selectivity and a retention selectivity.                   ##																					
##     If a uniform prior is selected for a parameter then the lb and ub are used       ##																					
##       (p1 and p2 are ignored)                                                        ##																					
## LEGEND                                                                               ##																					
##     sel type:   0 = nonparametric, 1 = coefficients (NIY), 2 = logistic,             ##																				
##                 3 = logistic95, 4 = double normal (NIY), more: see below             ##																					
##     gear index: use +ve for selectivity, -ve for retention                           ##																					
##     sex dep:    0 for sex-independent, 1 for sex-dependent                           ##																				
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## Selectivity parameter controls
# ## Selectivity (and retention) types
# ##  <0: Mirror selectivity
# ##   0: Nonparametric selectivity (one parameter per class)
# ##   1: Nonparametric selectivity (one parameter per class, constant from last specified class)
# ##   2: Logistic selectivity (inflection point and slope)
# ##   3: Logistic selectivity (50% and 95% selection)
# ##   4: Double normal selectivity (3 parameters)
# ##   5: Flat equal to zero (1 parameter; phase must be negative)
# ##   6: Flat equal to one (1 parameter; phase must be negative)
# ##   7: Flat-topped double normal selectivity (4 parameters)
# ##   8: Declining logistic selectivity with initial values (50% and 95% selection plus extra)
# ##   9: Cubic-spline (specified with knots and values at knots)
# ##  10: One parameter logistic selectivity (inflection point and slope)
# ## Extra (type 1): number of selectivity parameters to estimated
##--selectivity
## Gear-1	Gear-2	
## TCF_ret	NMFS	
1	1		 # selectivity periods
0	0		 # sex specific selectivity
2   2		 # male selectivity type (slx_type_in, to mirror, make negative and equal to the fleet to be mirrored)
#6	6		 # female selectivity type
0	0		 # within another gear
0	0		 # extra parameters for each pattern by fleet (males)
#0	0		 # extra parameters for each pattern by fleet (females)
##--retention
## Gear-1	Gear-2	
## TCF_ret	NMFS	
1	1		 # retention periods
0	0		 # sex specific retention
2	5		 # male   retention type
#6	6		 # female retention type
1	0		 # male   retention flag (0 = no, 1 = yes)
#0	0		 # female retention flag (0 = no, 1 = yes)
0	0		 # extra parameters for each pattern by fleet (males)
#0	0		 # extra parameters for each pattern by fleet (females)
#--options
1	1		 # determines if maximum selectivity at size is forced to equal 1 or not
## ———————————————————————————————————————————————————————————-------———————————————————————— ##																					
## Selectivity                                                                                ##																					
## gear  par   sel                                                         start  end         ##																					
## index index par sex  ival  		lb    ub     prior   p1   p2     phz   period period      ##																					
## ————————————————————————————————————————————————————————————————————————————————————------ ##																					
# Selectivity parameters
## Fleet: The index of the fleet  (positive for capture selectivity; negative for retention)
## Index: Parameter count (not used)
## Parameter_no: Parameter count within the current pattern (not used)
## Sex: Sex (not used)
## Initial: Initial value for the parameter (must lie between lower and upper)
## Lower & Upper: Range for the parameter
## Phase: Set equal to a negative number not to estimate
## Prior type:
## 0: Uniform   - parameters are the range of the uniform prior
## 1: Normal    - parameters are the mean and sd
## 2: Lognormal - parameters are the mean and sd of the log
## 3: Beta      - parameters are the two beta parameters [see dbeta]
## 4: Gamma     - parameters are the two gamma parameters [see dgamma]
## Start / End block: years to define the current block structure
## Env_Link: Do environmental impact ? (0/1)
## Env_Link_Var: Which environmental variable to consider for tihs parameter ? (column of Env data)
## Rand_Walk: Do a random walk? (0/1)
## Start_year_RW: Start year of the random walk
## End_year_RW: End year of the random walk
## Sigma_RW: Sigma used for the random walk
# Gear-1																					
# Fleet Index Param_no Sex Init_val  Lwr_bnd Upr_bnd Prior_type Prior_1 Prior_2 Phase Start_block End_block Env_Link Env_Link_Var Rand_Walk Start_year_RW End_year_RW Sigma_RW
   1      1       1     1  110.7114    5    	 186       0         1     999      4      1982       2022			0			0				0				0					0        0
   1      2       2     1    4.997241  0.01    20       0         1     999      4      1982       2022			0			0				0				0					0	      0
# Gear-2- NMFS                                                                     																		
# Fleet Index Param_no Sex Init_val  Lwr_bnd Upr_bnd Prior_type Prior_1 Prior_2 Phase Start_block End_block Env_Link Env_Link_Var Rand_Walk Start_year_RW End_year_RW Sigma_RW
   2      3      1      1  42.19018    5    	300          0       1       999     4    1982         2023			0			0				0				0					0        0
   2      4      2      1   4.997241   0.01 	 20          0       1       999     4    1982         2023			0			0				0				0					0        0
## ————————————————————————————————————————————————————————————————————————————————————---- ##																					
## Retained                                                                                 ##																					
## gear  par   sel                                                         start  end       ##																					
## index index par sex  ival  		lb    ub     prior   p1   p2     phz   period period    ##																					
## ————————————————————————————————————————————————————————————————————————————————————---- ##																					
# Gear-1																					
# Fleet Index Param_no Sex Init_val  Lwr_bnd Upr_bnd Prior_type Prior_1 Prior_2 Phase Start_block End_block Env_Link Env_Link_Var Rand_Walk Start_year_RW End_year_RW Sigma_RW
  -1     5       1      1   96.03919    1   	  190        1     125       10     4     1982  		2022			0			0				0				0					0        0
  -1     6       2      1    2.197131   0.001   20        0       1      999     4     1982  		2022			0			0				0				0					0        0																					
# Gear-2                                                                   																					
# Fleet Index Param_no Sex Init_val  Lwr_bnd Upr_bnd Prior_type Prior_1 Prior_2 Phase Start_block End_block Env_Link Env_Link_Var Rand_Walk Start_year_RW End_year_RW Sigma_RW
  -2      7      1      1     0    		 -1   	  1      0         0      999    -3     1982       2023			0			0				0				0					0        0						
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
#_Number of asymptotic retention parameter
0 
#_Asymptotic parameter controls
# ************************************** #
#_Fleet: The index of the fleet (negative for retention)
#_Sex: 0 = both; 1 = male; 2 = female
#_Year: year of interest 
#_Init_val: Initial value for the parameter (must lie between lower and upper bounds)
#_Lower_Bd & Upper_Bd: Range for the parameter
#_Phase: Set equal to a negative number not to estimate
# ************************************** #
#_Fleet_| Sex_| Year_| Init_val_| Lower_Bd_| Upper_Bd_| Phase 

#_Environmental parameters Control
# ************************************** #
#_Init_val: Initial value for the parameter (must lie between lower and upper bounds)
#_Lower_Bd & Upper_Bd: Range for the parameter
#_Phase: Set equal to a negative number not to estimate
#_Init_val_| Lower_Bd_| Upper_Bd_| Phase 
# 
#_One line for each parameter ordered as the parameters are in the
#_control matrices
# ************************************** #

#_Vulnerability impact#_Init_val_| Lower_Bd_| Upper_Bd_| Phase 
# -------------------------------------- #

#_Deviation parameter phase for the random walk in vulnerability parameters
#_Need to be defined
-1 

## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## PRIORS FOR CATCHABILITY																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
# ************************************** #
# Init_val: Initial value for the parameter (must lie between lower and upper bounds)
# Lower_Bd & Upper_Bd: Range for the parameter
# Phase: Set equal to a negative number not to estimate
# Available prior types:
# -> 0 = Uniform   - parameters are the range of the uniform prior
# -> 1 = Normal    - parameters are the mean and sd
# -> 2 = Lognormal - parameters are the mean and sd of the log
# -> 3 = Beta      - parameters are the two beta parameters [see dbeta]
# -> 4 = Gamma     - parameters are the two gamma parameters [see dgamma]
# p1; p2: priors
# Q_anal: Do we need to solve analytically Q? (0 = No; 1 = Yes)
# CV_mult: multiplier ofr the input survey CV
# Loglik_mult: weight for the likelihood
# ************************************** #
# Init_val | Lower_Bd | Upper_Bd | Phase | Prior_type | p1 | p2 | Q_anal | CV_mult | Loglik_mult
   0.6     0.01       1     5      0    0.843136   0.03   	 0           1        1  	# NMFS_TRAWL_1991+ MALES
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## ADDITIONAL CV FOR SURVEYS/INDICES                                                    ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
# ************************************** #
# Init_val: Initial value for the parameter (must lie between lower and upper bounds)
# Lower_Bd & Upper_Bd: Range for the parameter
# Phase: Set equal to a negative number not to estimate
# Available prior types:
# -> 0 = Uniform   - parameters are the range of the uniform prior
# -> 1 = Normal    - parameters are the mean and sd
# -> 2 = Lognormal - parameters are the mean and sd of the log
# -> 3 = Beta      - parameters are the two beta parameters [see dbeta]
# -> 4 = Gamma     - parameters are the two gamma parameters [see dgamma]
# p1; p2: priors
# ************************************** #
# Init_val | Lower_Bd | Upper_Bd | Phase | Prior_type| p1 | p2
   0.0001      0.00001   10.0      -4        0         1.0  100   # NMFS	males era 1																				
 
# Additional variance control for each survey (0 = ignore; >0 = use)
0 
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## PENALTIES FOR AVERAGE FISHING MORTALITY RATE FOR EACH GEAR																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
# ************************************** #
# Mean_F_male: mean male fishing mortality (base value for the fully-selected F) #
# Female_Offset: Offset between female and male fully-selected F  #
# Pen_std_Ph1 & Pen_std_Ph2: penalties on the fully-selected F during the early and later phase, respectively  #
# Ph_Mean_F_male & Ph_Mean_F_female: Phases to estimate the fishing mortality for males and females, respectively #
# Low_bd_mean_F & Up_bd_mean_F: Range for the mean fishing mortality (lower and upper bounds, respectivly) #
# Low_bd_Y_male_F & Up_bd_Y_male_F: Range for the male fishing mortality (lower and upper bounds, respectivly) #
# Low_bd_Y_female_F & Up_bd_Y_female_F: Range for the female fishing mortality (lower and upper bounds, respectivly)#
# ************************************** #
#  Mean_F_male | Female_Offset | Pen_std_Ph1 | Pen_std_Ph2 | Ph_Mean_F_male | Ph_Mean_F_female | Low_bd_mean_F | Up_bd_mean_F | Low_bd_Y_male_F | Up_bd_Y_male_F | Low_bd_Y_female_F | Up_bd_Y_female_F 
   1                 0.0      	   0.5      	  45.50             1                1               -12               4               -10             10               -10                  10   # TCF_ret
#   0.018             0.0   	      0.5      	  45.50             1               -1               -12               4               -10             10               -10                  10   # TCF_tot
   0.00              0.0    	      2.0      	  20.00            -1               -1               -12               4               -10             10               -10                  10   # NMFS trawl survey era 1 (0 catch)
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
# ———————————————————————————————————————————————————————————————————————————————————— ##																					
## OPTIONS FOR SIZE COMPOSTION DATA                                                     ##																					
##     One column for each data matrix                                                  ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
# ************************************** #
# Available types of likelihood:
# -> 0 = Ignore size-composition data in model fitting
# -> 1 = Multinomial with estimated/fixed sample size
# -> 2 = Robust approximation to multinomial
# -> 5 = Dirichlet
# Auto tail compression (pmin):
# -> pmin is the cumulative proportion used in tail compression
# Type-like prediction (1 = catch-like predictions; 2 = survey-like predictions)
# Lambda: multiplier for the effective sample size
# Emphasis: multiplier for weighting the overall likelihood
# ************************************** #
#  ret  tot  NMFS 																					
   2   	2     2   # Type of likelihood																					
   0   	0     0   # option for Auto tail compression (pmin)																					
   1   	1     1   # Initial value for effective sample size multiplier																					
  -4    -4    -4   # Phz for estimating effective sample size (if appl.)																					
   1   	2     3   # Composition appender  (Should data be aggregated?)						
   1     1     2   # Type-like predictions
   1   	1     1   # Lambda: multiplier for the effective sample size																					
   1   	1     1   # Emphasis: multiplier for weighting the overall likelihood																			
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## TIME VARYING NATURAL MORTALIIY RATES                                                 ##																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
# ************************************** #
# Type of M specification
## 1: Time-invariant M
## 2: Default random walk M
## 3: Cubic spline with time M
## 4: Blocked changes in  M
## 5: Blocked changes in  M (type 2)
## 6: Blocked changes in  M (returns to default)
## Type																					
0																					
## Phase of estimation																					
-3																					
## STDEV in m_dev for Random walk																					
0.25																					
## Number of nodes for cubic spline or number of step-changes for option 3																					
0																					
## Year position of the knots (one line/sex, vector must be equal to the number of nodes)																					
0																					
# number of breakpoints in M by size																					
0																					
# 																					
## Natural mortality deviation controls
# ************************************** #
# Init_val: Initial value for the parameter (must lie between lower and upper bounds)
# Lower_Bd & Upper_Bd: Range for the parameter
# Phase: Set equal to a negative number not to estimate
# Size_spec: Are the deviations size-specific ? (integer that specifies which size-class (negative to be considered))
# ************************************** #
# Init_val | Lower_Bd | Upper_Bd | Phase | Size_spec

 
# -------------------------------------- #
## Tagging controls
# -------------------------------------- #
# Emphasis (likelihood weight) on tagging
1 
# -------------------------------------- #

## ———————————————————————————————————————————————————————————————————————————————————— ##	
## Maturity specific natural mortality
## ———————————————————————————————————————————————————————————————————————————————————— ##	
# maturity specific natural mortality? (yes = 1; no = 0; only for use if nmature > 1)
1																				
# immature/mature natural mortality controls
# ************************************** #
# Init_val: Initial value for the parameter (must lie between lower and upper bounds)
# Lower_Bd & Upper_Bd: Range for the parameter
# Phase: Set equal to a negative number not to estimate
# Available prior types:
# -> 0 = Uniform   - parameters are the range of the uniform prior
# -> 1 = Normal    - parameters are the mean and sd
# -> 2 = Lognormal - parameters are the mean and sd of the log
# -> 3 = Beta      - parameters are the two beta parameters [see dbeta]
# -> 4 = Gamma     - parameters are the two gamma parameters [see dgamma]
# p1; p2: priors
# ************************************** #
# Init_val | Lower_Bd | Upper_Bd | Phase | Prior_type| p1 | p2
0.133531392624523 -4       4         4         1        0   0.05
# -------------------------------------- #

## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## OTHER CONTROLS																					
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
1982       # 1: rdv_syr: First rec_dev																					
2022       # 2: rdv_eyr: last rec_dev																					
   1       # 3: Term_molt:      terminal molt flag (0 = off, 1 = on). If on, the calc_stock_recruitment_relationship() isn't called in the procedure
   1       # 4: rdv_phs:        Estimated rec_dev phase	
   2	     # 5: rec_prop_phs:   Estimated sex_ratio phase
   0.5 	  # 6: init_sex_ratio: Initial sex ratio
  -3       # 7: rec_ini_phz:    Estimated rec_ini phase																					
   3       # 9: bInitializeUnfished: Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters, 3 = Free parameters (revised))																					
   1       # 10: spr_lambda:    Lambda (proportion of mature male biomass for SPR reference points).																					
   0       # 11: nSPR_flag:     Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)																			
   0       # 15: BRP_rec_sexR:  Use average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)
 100       # 16: NyrEquil:		  Years to compute equilibria																
## ———————————————————————————————————————————————————————————————————————————————————— ##																					
## EMPHASIS FACTORS																					
## ———————————————————————————————————————————————————————————————————————————————————— ##
###--CATCH: vector w/ factor for each catch dataframe																					
# ret      tot  																					
   1         1     																					
###--Penalties on deviations (nfleet x 4)
#  Fdev_total | Fdov_total | Fdev_year | Fdov_year 
 1 1 0 0 # dir_fish 
 0 0 0 0 # NMFS
###--Priors																					
10000 	#_ Log_fdevs 
0 	#_ meanF 
0 	#_ Mdevs 
0 	#_ Rec_devs 
0 	#_ Initial_devs 
0 	#_ Fst_dif_dev 
0 	#_ Mean_sex-Ratio 
0 	#_ Molt_prob 
0 	#_ Free_selectivity 
0 	#_ Init_n_at_len 
0 	#_ Fvecs 
0 	#_ Fdovs 
0 	#_ Vul_devs 

# -------------------------------------- #

# -------------------------------------- #
## End of control file
# -------------------------------------- #
9999																					
