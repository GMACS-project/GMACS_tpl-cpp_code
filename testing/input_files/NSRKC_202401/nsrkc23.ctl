#
#  ——————————————————————————————————————————————————————————————————————————————————————  #
#  Controls  for  leading  parameter  vector  theta
#  LEGEND  FOR  PRIOR:
#  0 = uniform, 1 = normal, 2 = lognormal, 3 =  beta, 4 =  gamma
#  ——————————————————————————————————————————————————————————————————————————————————————  #
#  ntheta
24
# —————————————————————————————————————————————————————————————————————————————————————— #
# ival        lb        ub        phz   prior     p1      p2         # parameter         #
# —————————————————————————————————————————————————————————————————————————————————————— #
  0.18      0.10         1         -3       1   0.18    0.2         # M
  7.0        -10        20         -1       0   -10       20         # logR0
  9.111      -10        20          1       0   -10       20         # logRini, to estimate if NOT initialized at unfished
    8  	    -10        20           1       0   -10       20         # logRbar, to estimate if NOT initialized at unfished    
  72.5        65       130          3       1   72.5    7.25         # recruitment expected value (males or combined)
  0.75       0.3       1.6          3       0    0.1       5         # recruitment scale (variance component) (males or combined)
 -0.10       -10      0.75         -2       0    -10    0.75         # ln(sigma_R)
  0.75      0.20      1.00         -4       3    3.0    2.00         # steepness
  0.001     0.00      1.00         -3       3    1.01   1.01         # recruitment autocorrelation
#  0.00     -10         4          2        0   10.0    20.00        # Deviation for size-class 1 (normalization class)
 0.6467     -10         5          2        0   10.0    20.00        # Deviation for size-class 2
 1.0034     -10         5          2        0   10.0    20.00        # Deviation for size-class 3
 1.3604     -10         5          2        0   10.0    20.00        # Deviation for size-class 4
 1.4042     -10         5          2        0   10.0    20.00        # Deviation for size-class 5
 1.4599     -10         5          2        0   10.0    20.00        # Deviation for size-class 6
 1.2657     -10         5          2        0   10.0    20.00        # Deviation for size-class 7
 0.7228     -10         5          2        0   10.0    20.00        # Deviation for size-class 8
 -100.00    -101        5         -2        0   10.0    20.00        # Deviation for size-class 1  (oldshell)
 -100.00    -101        5         -2        0   10.0    20.00        # Deviation for size-class 2
 -100.00    -101        5         -2        0   10.0    20.00        # Deviation for size-class 3
 -100.00    -101        5         -2        0   10.0    20.00        # Deviation for size-class 4
 -100.00    -101        5         -2        0   10.0    20.00        # Deviation for size-class 5
 -100.00    -101        5         -2        0   10.0    20.00        # Deviation for size-class 6
 -100.00    -101        5         -2        0   10.0    20.00        # Deviation for size-class 7
 -100.00    -101        5         -2        0   10.0    20.00        # Deviation for size-class 8


# weight-at-length input  method  (1 = allometry  [w_l = a*l^b],  2 = vector by sex)
 2
# Male weight-at-length
  0.5242037 0.8206743 1.198245 1.701759 2.321254 2.993651 3.688495 4.371395  #lbs
# Proportion mature by sex
 0       0       0      1       1       1       1       1
# Proportion legal by sex
 0       0       0       0       1       1       1      1
# use functional maturity for terminally molting animals?
0

## ———————————————————————————————————————————————————————————————————————————————————— ##
## GROWTH PARAM CONTROLS                                                                ##
##     Two lines for each parameter if split sex, one line if not                       ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
# Use growth transition matrix option (1=read in growth-increment matrix; 2=read in size-transition; 3=gamma distribution for size-increment; 4=gamma distribution for size after increment)
8
# growth increment model (1=alpha/beta; 2=estimated by size-class;3=pre-specified/emprical)
1
# molt probability function (0=pre-specified; 1=flat;2=declining logistic)
2
# Maximum size-class for recruitment(males then females)
3
## number of size-increment periods
1
## Year(s) size-incremnt period changes (blank if no changes)

## number of molt periods
1
## Year(s) molt period changes (blank if no changes)

## Beta parameters are relative (1=Yes;0=no)
1

## ———————————————————————————————————————————————————————————————————————————————————— ##
# ival        lb        ub        phz   prior     p1      p2         # parameter         #
# —————————————————————————————————————————————————————————————————————————————————————— #
   36.99862     0.0     200.0         2       0    0.0    20.0         # alpha males or combined
   0.2430155   -0.2      20.0         2       0    0.0    10.0         # beta males or combined
   3.773156     2.00     10.0         5       0    0.0     3.0         # gscale males or combined
  122.9659  50.0       200            2       0    0.0   170.0         # molt_mu males or combined
 0.1276159     0.0       1.0          2       0    0.0     3.0         # molt_cv males or combined
# ———————————————————————————————————————————————————————————————————————————————————— ##
# The custom growth-increment matrix

# custom molt probability matrix

##  ————————————————————————————————————————————————————————————————————————————————————  ##
## SELECTIVITY CONTROLS                                                                   ##
##     Selectivity P(capture of all sizes). Each gear must have a selectivity and a       ##
##     retention selectivity. If a uniform prior is selected for a parameter then the     ##
##     lb and ub are used (p1 and p2 are ignored)                                         ##
## LEGEND                                                                                 ##
##     sel type: 0 = parametric (nclass), 1 = indiviudal parameter for each class(nclass),##
##               2 = logistic (2), 3 = logistic95 (2), 4 = double normal (3),             ##
##               5 = uniform=1 (1), 6 = uniform=0 (1)                                     ##
##     gear index: use +ve for selectivity, -ve for retention                             ##
##     sex dep: 0 for sex-independent, 1 for sex-dependent                                ##
##  ————————————————————————————————————————————————————————————————————————————————————  ##
##  ivector  for  number  of  year  blocks  or  nodes  ##
## Gear-1   Gear-2   Gear-3   Gear-4   Gear-5
## WinCom Winsub  Sumpot  NMFS  ADFG EBS WinPot
   1      1       1       1     1    1   1         # selectivity periods
   0      0       0       0     0    0   0         # sex specific selectivity
   8     -1      10      10    -4   -4  -1         # male selectivity type
   0      0       0       0     0    0   0         # within another gear
   3      0       0       0     0    0   0         # extra
## WinCom Winsub  Sumpot  NMFS  ADFG EBS WinPot

# FEATURE OF GMACS THAT DOES NOT EXIST - PRE-SPECIFIED for SOMEYEAR AND ESTIMATED FOR OTHERS (wrinter commerial)
   1      1       2       1     1    1   1         # retention periods
   0      0       0       0     0    0   0         # sex specific retention
   2      0       2       6     6    6   6         # male retention type
   1      1       1       0     0    0   0         # male retention flag (0 = no, 1 = yes)
   0      0       0       0     0    0   0         # extra
   0 	  0       1       1     1    1   1  	   # determine if maximum selectivity at size is forced to equal 1 or not
##  ————————————————————————————————————————————————————————————————————————————————————##
##  Selectivity  P(capture  of  all  sizes)
## ———————————————————————————————————————————————————————————————————————————————————— ##
## gear  par   sel                                             phz    start  end        ##
## index index par sex  ival  lb    ub     prior p1     p2     mirror period period     ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
#	Gear-1												
	1	1	1	0	128.8948	40	200	0	10	200	2	0	2024 0 0 0 1976 1976 0
	1	2	2	0	0.1546968	0.01	20	0	0.1	100	2	0	2024 0 0 0 1976 1976 0
	1	3	3	0	0.0455855385663	0.00001	0.99999	0	0.1	100	2	0	2024 0 0 0 1976 1976 0
	1	4	4	0	0.375288488305	0.00001	0.99999	0	0.1	100	2	0	2024 0 0 0 1976 1976 0
	1	5	5	0	0.733786963987	0.00001	0.99999	0	0.1	100	2	0	2024 0 0 0 1976 1976 0
#	Gear-2												
	2	6	1	0	110		40	200	0	10	200	-2	0	2024 0 0 0 1976 1976 0
#	Gear-3												
	3	7	1	0	0.1436397	0.00001	20	0	0.1	100	2	0	2024 0 0 0 1976 1976 0
#	Gear-4												
	4	8	1	0	0.09209419 	0.00001	20	0	0.1	100	2	0	2024 0 0 0 1976 1976 0
#	Gear-5												
	5	9	1	0	110		40	200	0	10	200	-2	0	2024 0 0 0 1976 1976 0
#	Gear-6												
	6	10	1	0	110		40	200	0	10	200	-2	0	2024 0 0 0 1976 1976 0
#	Gear-7												
	7	11	1	0	110		40	200	0	10	200	-2	0	2024 0 0 0 1976 1976 0
##	————————————————————————————————————————————————————————————————————————————————————	##											
## Retained												
## gear	par	sel	phz	start	end		##						
## index	index	par	sex	ival	   	lb	ub	prior	p1	p2	phase	period	period
#	Gear-1												
	-1	12	1	0	104.7655	50	200	0	1	900	2	0	2024 0 0 0 1976 1976 0
	-1	13	2	0	2.523162 	0.001 	20	0	1	900	2	0	2024 0 0 0 1976 1976 0
#	Gear-2												
	-2	16	1	0	0.000001	0	1	0	1	900	-2	0	2024 0 0 0 1976 1976 0
	-2	17	2	0	0.000001	0	1	0	1	900	-2	0	2024 0 0 0 1976 1976 0
	-2	18	3	0	0.000001	0	1	0	1	900	-2	0	2024 0 0 0 1976 1976 0
	-2	19	4	0	0.999999	0	1	0	1	900	-2	0	2024 0 0 0 1976 1976 0
	-2	20	5	0	0.999999	0	1	0	1	900	-2	0	2024 0 0 0 1976 1976 0
	-2	21	6	0	0.999999	0	1	0	1	900	-2	0	2024 0 0 0 1976 1976 0
	-2	22	7	0	0.999999	0	1	0	1	900	-2	0	2024 0 0 0 1976 1976 0
	-2	23	8	0	0.999999	0	1	0	1	900	-2	0	2024 0 0 0 1976 1976 0
#	Gear-3												
	-3	24	1	0	104.3106	50	700	0	1	900	2	0	2007 0 0 0 1976 1976 0
	-3	25	2	0	2.421736	1	20	0	1	900	2	0	2007 0 0 0 1976 1976 0
	-3	24	1	0	105.1509	50	700	0	1	900	2	2008	2024 0 0 0 1976 1976 0
	-3	25	2	0	1.648215 	1	20	0	1	900	2	2008	2024 0 0 0 1976 1976 0
#	Gear-4												
	-4	26	1	0	100		1	700	0	1	900	-3	0	2024 0 0 0 1976 1976 0
#	Gear-5												
	-5	27	1	0	100		1	700	0	1	900	-3	0	2024 0 0 0 1976 1976 0
#	Gear-6												
	-6	28	1	0	100		1	700	0	1	900	-3	0	2024 0 0 0 1976 1976 0
#	Gear-7												
	-7	29	1	0	100		1	700	0	1	900	-3	0	2024 0 0 0 1976 1976 0
## ———————————————————————————————————————————————————————————————————————————————————— ##
# Number of asmyptotic parameters
1
# Fleet   Sex     Year       ival   lb   ub    phz
       1     1     1978   0.000001   0    1     -3
# Deviation parameter phase
-1
## ———————————————————————————————————————————————————————————————————————————————————— ##
## PRIORS FOR CATCHABILITY
##     If a uniform prior is selected for a parameter then the lb and ub are used (p1   ##
##     and p2 are ignored). ival must be > 0                                            ##
## LEGEND                                                                               ##
##     prior: 0 = uniform, 1 = normal, 2 = lognormal, 3 = beta, 4 = gamma               ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## SURVEYS/INDICES ONLY
## NMFS:ADFG:NBS:STCPUE
## ival     lb       ub    phz   prior  p1        p2     Analytic?   LAMBDA   Emphasis
   0.777     0.1      2      2   0      0.1      1.0     0           1             1                 # Phase 2
   1.0       0.1      2      -2    0      0.1      1.0     0           1             1                  
   0.777     0.1      2      2    0      0.1      1.0     0           1             1                # Phase 2 
   0.0015    0.0      2      1    0      0.0      1.00    0           1             1
   0.0015    0.0      2      1    0      0.0      1.00    0           1             1
   0.0015    0.0      2      1    0      0.0      1.00    0           1             1

##  ————————————————————————————————————————————————————————————————————————————————————##
## ADDITIONAL CV FOR SURVEYS/INDICES
##     If a uniform prior is selected for a parameter then the lb and ub are used (p1   ##
##     and p2 are ignored). ival must be > 0                                            ##
## LEGEND                                                                               ##
##     prior type: 0 = uniform, 1 = normal, 2 = lognormal, 3 = beta, 4 = gamma          ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## ival                lb        ub        phz   prior     p1      p2
   0.0001      0.00000001       2.0      -4     0         1.0     100   # NMFS
   0.0001      0.00000001       2.0      -4     0         1.0     100   # ADFG
   0.0001      0.00000001       2.0      -4     0         1.0     100   # NBS
  0.1          0.00000001       2.0       4     0         1.0     100   # CPUE                         # phase 4
   0.0001      0.00000001       2.0      -4     0         1.0     100   # CPUE
   0.0001      0.00000001       2.0      -4     0         1.0     100   # CPUE
 ## ———————————————————————————————————————————————————————————————————————————————————— ##
##  ————————————————————————————————————————————————————————————————————————————————————##
### Pointers to how the the additional CVs are used (0 ignore; >0 link to one of the parameters
 0 0 0 4 4 4
##  PENALTIES  FOR  AVERAGE  FISHING  MORTALITY  RATE  FOR  EACH  GEAR
##  ————————————————————————————————————————————————————————————————————————————————————##
##  Trap  Trawl  NMFS  BSFRF
## Mean_F   Fema-Offset STD_PHZ1 STD_PHZ2 PHZ_M PHZ_F   Lb    Ub     Lb     Ub      Lb     Ub
   0.02        0.0         0.5    45.50    1    -1     -12      4    -10     10     -10    10   # WPot
   0.02        0.0         0.5    45.50    1    -1     -12      4    -10     10     -10    10   # Wsub
   0.12        0.0         0.5    45.50    1    -1     -12      4    -10     10     -10    10   # Spot
   0.00        0.0         2.00   20.00   -1    -1     -12      4    -10     10     -10    10   # NMFS survey (0 catch)
   0.00        0.0         2.00   20.00   -1    -1     -12      4    -10     10     -10    10   # ADFG survey (0 catch)
   0.00        0.0         2.00   20.00   -1    -1     -12      4    -10     10     -10    10   # EBS survey (0 catch)
   0.00        0.0         2.00   20.00   -1    -1     -12      4    -10     10     -10    10   # Wpot survey (0 catch)
##  ————————————————————————————————————————————————————————————————————————————————————##
## OPTIONS FOR SIZE COMPOSTION DATA                                                     ##
##     One column for each data matrix                                                  ##
## LEGEND                                                                               ##
##     Likelihood: 1 = Multinomial with estimated/fixed sample size                     ##
##                 2 = Robust approximation to multinomial                              ##
##                 3 = logistic normal (NIY)                                            ##
##                 4 = multivariate-t (NIY)                                             ##
##                 5 = Dirichlet                                                        ##
## AUTO TAIL COMPRESSION                                                                ##
##     pmin is the cumulative proportion used in tail compression                       ##
##  ——————————————————————————————————————————————————————————————————————————————————  ##
#  Wcom    Scom    Sdisc   Stot    NMFS    ADFG    EBS    Wpot
   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1  # Type of likelihood
   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0  # Auto tail compression (pmin)
   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1  # Initial value for effective sample size multiplier
  -4  -4  -4  -4  -4  -4  -4  -4  -4  -4  -4  -4  -4  -4  -4  -4  # Phz for estimating effective sample size (if appl.)
   1   1   2   2   3   3   4   4   5   5   6   6   7   7   8   8  # Composition splicer
   1   1   1   1   1   1   1   1   2   2   2   2   2   2   2   2  # Set to 2 for survey-like predictions; 1 for catch-like predictions
   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1  # LAMBDA
   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1  # Emphasis AEP
   #0.00001   0.00001   0.00001   0.00001   0.00001   0.00001   0.00001   0.00001   0.00001   0.00001   0.00001   0.00001   0.00001   0.00001   0.00001   0.00001  # Emphasis AEP
##  ——————————————————————————————————————————————————————————————————————————————————  ##
##  TIME  VARYING  NATURAL  MORTALIIY  RATES  ##
##  ——————————————————————————————————————————————————————————————————————————————————E##
## Type: 0 = constant natural mortality                                                 ##
##       1 = Random walk (deviates constrained by variance in M)                        ##
##       2 = Cubic Spline (deviates constrained by nodes & node-placement)              ##
##       3 = Blocked changes (deviates constrained by variance at specific knots)       ##
##       4 = Changes in pre-specified blocks                                            ##
##       5 = Changes in some knots                                                      ##
##       6 = Changes in Time blocks                                                     ##
  0
## M is relative (YES=1; NO=0)

## Phase of estimation
 3
## STDEV in m_dev for Random walk
 0.25
## Number of nodes for cubic spline or number of step-changes for option 3
 0
## Year position of the knots (vector must be equal to the number of nodes)
 
## number of breakpoints in M by size
 1
# line groups for breakpoint
 7
## Specific initial values for the natural mortality devs (0-no, 1=yes)
 1
## ival        lb        ub        phz    extra
    3.0        0.5       5.0       4        0
    ##  ???????????????????????????????????????????????????????????????????????????????????? ##
##  TAGGING controls  CONTROLS
##  ???????????????????????????????????????????????????????????????????????????????????? ##
1          # emphasis on tagging data
## ???????????????????????????????????????????????????????????????????????????????????? ##
## ???????????????????????????????????????????????????????????????????????????????????? ##	
## Maturity specific natural mortality
## ???????????????????????????????????????????????????????????????????????????????????? ##	
# maturity specific natural mortality? (yes = 1; no = 0; only for use if nmature > 1)
0
## ??????????????????????????????????????????????????????????????????????????????????????????? ##																					
## ival        lb        ub        phz      prior     p1      p2         # parameter     ##																					
## ??????????????????????????????????????????????????????????????????????????????????????????? ##																					
 0.000000      -4          4        -4      	1 		0 		0.05	# offset for immature male natural mortality																		
## ???????????????????????????????????????????????????????????????????????????????????? ##	

##  ———————————————————————————————————————————————————————————————————————————————————— ##
##  OTHER  CONTROLS
##  ———————————————————————————————————————————————————————————————————————————————————— ##
   0       # First rec_dev
2023       # last rec_dev
   0		# consider terminal molting
   2       # Estimated rec_dev phase
  -2       # Estimated sex-ratio phase
  0.5      # Expected sex-ratio
  -3       # Estimated rec_ini phase
   3       # Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters, 3 = Free parameters (revised))
   1       # Lambda (proportion of mature male biomass for SPR reference points).
   0       # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)
   0 			# Use years specified to computed average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)
   200 			# Years to compute equilibria
## EMPHASIS FACTORS (CATCH)
#Wret_male  Subret_male Subtot_male    Sret-male
 #      1            	1     	      1            1
 #       1             0.0001 	 0.0001            1  # (works)
         1          	1     	 0.0000            1  # (does not work)
## ???????????????????????????????????????????????????????????????????????????????????? ##																					
## EMPHASIS FACTORS (Priors) by fleet: fdev_total, Fdov_total, Fdev_year, Fdov_year 																					
## ???????????????????????????????????????????????????????????????????????????????????? ##																					
#
 1 0 0 0 # Wret_male 
 0.1 0 0 0 # Wsub_male
 1 0 0 0 # Sret-male 
 0 0 0 0 # NMFS-male 
 0 0 0 0 # ADFG-male 
 0 0 0 0 # EBS-male 
 0 0 0 0 # WPot-male 
## ???????????????????????????????????????????????????????????????????????????????????? ##																					
## EMPHASIS FACTORS (Priors)																					
## ???????????????????????????????????????????????????????????????????????????????????? ##																					
1   # Log_F
0   # Mean F
0    # Mdevs
1   # Rec_devs
15   #Initial Devs
1   #Fst_dif_dev
3   # Mean sex ratios
60   # Molt prob
0.1   # Free selectivity
1   # Initial_n_at_length
0   # F devs
0   # Fdovs
1   # Sel_devs
#
## EOF																					
9999	

