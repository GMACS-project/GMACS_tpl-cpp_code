#  EAG22_1e2 Update
#  ——————————————————————————————————————————————————————————————————————————————————————  #
#  Controls  for  leading  parameter  vector  theta
#  LEGEND  FOR  PRIOR:
#  0 = uniform, 1 = normal, 2 = lognormal, 3 =  beta, 4 =  gamma
#  ——————————————————————————————————————————————————————————————————————————————————————  #

# Blocks to be used in the model (block 0 is the year range)
2
# Number of blocks per group (after the first block, i.e. 1 means two blocks)
2 1
# Block definitions  (first block always start with syr; year 0 is last year)
2005 2010 2018 2022
2005 2023

##  ———————————————————————————————————————————————————————————————————————————————————— ##
##  GENERAL  CONTROLS
##  ———————————————————————————————————————————————————————————————————————————————————— ##
# 
1960       # First year of recruitment estimation,rec_dev. There is a difference in timing between Gmacs and my model, EAG 21_1a first rec_dev is 1961 and last rec_dev 2022
2022       # last year of recruitment estimation, rec_dev
   0       # Terminal molting (0 = off, 1 = on). If on, the calc_stock_recruitment_relationship() isn't called in the procedure
   1       # phase for recruitment estimation,earlier -1. rec_dev estimation phase, BBRKC uses 2
  -2       # phase for recruitment sex-ratio estimation
  0.5      # Initial value for Expected sex-ratio
   0       # Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters, 3 = Free parameters (revised))
   1       # Reference size-class for initial conditons = 3
   1       # Lambda (proportion of mature male biomass for SPR reference points).
   0       # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)
  1       # Use years specified to computed average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)
    200     ### Year to compute equilibria
   5       # Devpar phase (!!)
 1940      # First year of bias-correction
 1950      # First full bias-correction
 2050      # Last full bias-correction
 2051      # Last year of bias-correction

# —————————————————————————————————————————————————————————————————————————————————————— #
# ival      lb     ub       phz   prior   p1      p2      # parameter         #
# —————————————————————————————————————————————————————————————————————————————————————— #
 7.790339494  -10.0 20.0   1    0    -10.0    20.0      # ln R0, logarithm of unfished recruits, from my model
 
 12.0       -10.0   20.0     -3    0    -10.0    20.0      # ln Rini, logarithm of initial recruitment(syr)

   8.0       -10.0  20.0     -1    0    -10.0    20.0       # One par freed, ln Rbar, logarithm of average recruits(syr+1,nyr)

 110.0      103.0  165.0     -2    1     72.5    7.25      # (earlier estimated)recruitment expected value, ra, Expected value of recruitment distribution 
 
 1.616126657  0.001  20.0    3    0     0.1     5.0        # recruitment scale (variance component), rbeta, rate parameter for recruitment distribution
 
  -0.693147181 -10.0   0.75   -1    0   -10.0     0.75      # ln (SigmaR), where sigmaR is 0.5,standard deviation of recruitment deviations, used in the LH of rec_dev
 
 0.73       0.2    1.0       -2    3     3.0     2.0       # steepness (only used if R is constrained by a S-R relationship)
  0.001      0.0    1.0      -3    3     1.01    1.01      # recruitment autocorrelation (only used if R is constrained by a S-R relationship)
#——————————————————————————————————————————————————————————————————————————————————————

# weight-at-length input  method  (1 = allometry  [w_l = a*l^b],  2 = vector by sex)
2
#a, in kg
# 1.445E-07
#b
# 3.281126995
# Male weight-at-length
 0.581515707	0.679328169	0.788032347	0.908278308	1.040724257	1.186036294	1.344888179	1.517961114	1.705943543	1.90953096	2.129425732	2.366336933	2.620980182	2.894077494	3.186357141	3.498553516	3.993657581
#  
# Proportion mature by sex, males
  0.  0.  0.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.
# Proportion legal by sex, males
  0.  0.  0.  0.  0.  0.  0.  1.  1.  1.  1.  1.  1.  1.  1.  1.  1.

5 # Maximum size-class for recruitment(males then females)
0   # Use functional maturity for terminally molting animals (0=no; 1=Yes)?


## General inputs
# Block: Block number for time-varying growth   
# Block_fn: 0:absolute values; 1:exponential
# Env_L: Environmental link - options are 1:additive; 2:multiplicative; 3:exponential
# EnvL_var: Environmental variable
# RW: 0 for not random walk changes; 1 otherwise
# RW_blk: Block number for random walks
# Sigma_RW: Sigma for the random walk parameters
#
# Growth transition
# Type1: Options for the growth matrix
# 1: Pre-specified growth transition matrix (requires molt probability)
# 2: Pre-specified size transition matrix (molt probability is ignored)
# 3: Growth increment is gamma distributed (requires molt probability)
# 4: Post-molt size is gamma distributed (requires molt probability)
# 5: Von Bert.: kappa varies among individuals (requires molt probability)
# 6: Von Bert.: Linf varies among individuals (requires molt probability)
# 7: Von Bert.: kappa and Linf varies among individuals (requires molt probability)
# 8: Growth increment is normally distributed (requires molt probability)
## Type2: Options for the growth increment model matrix
# 1: Linear
# 2: Individual
# 3: Individual (Same as 2)
## Type1 Type2   Block  
       8     1       0   # Growth-transition Males
#  Molt probability
# Options for the molt probability function
# 0: Pre-specified
# 1: Constant at 1
# 2: Logistic
# 3: Individual
## Type Block  
      2     0    # Molt probability Males


## ———————————————————————————————————————————————————————————————————————————————————— ##
# ival        lb        ub     phz   prior      p1      p2         # parameter         #
# —————————————————————————————————————————————————————————————————————————————————————— #
25.28904795	10	50	0	0	20	7	0	0	0	0	0	0	0.3	#	alpha,	a-b,
0.090568482	-0.4	20	0	0	10	7	0	0	0	0	0	0	0.3	#	beta,	b/meanL,
3.68086767	0.01	5	0	0	3	7	0	0	0	0	0	0	0.3	#	growth	scale,
141.4655935	65	165	0	0	999	7	0	0	0	0	0	0	0.3	#	moult	mu,
0.089802727	-0.1	2	0	0	2	7	0	0	0	0	0	0	0.3	#	moult	cv,
 # ———————————————————————————————————————————————————————————————————————————————————— ##

# The custom growth-increment matrix

# custom molt probability matrix

## ==================================================================================== ##
## NATURAL MORTALITY RATES                                                              ##
## ==================================================================================== ##


## Relative? Type Extra SizeBrkpts Mirror  Block Block_fn Env_L EnvL_Var  RW RW_blk Sigma_RW Mirror_RW
#           0    1     5          0      0      0        0     0        0   0      0       0.3        0  # Base model
           0    0     0          0      0      0        0     0        0   0      0       0.3        0  # Base model

## Size breakpoints 
#2 3
##          
## ival    lb       ub     prior   p1       p2    phz      
   0.22     0       0.5        0    0      0.2     -1                    # Base M
#   1960     0       0.5        0    0      0.2     -1                    # Base M
#   1980     0       0.5        0    0      0.2     -1                    # Base M
#   1990     0       0.5        0    0      0.2     -1                    # Base M
#   2010     0       0.5        0    0      0.2     -1                    # Base M
#   2020     0       0.5        0    0      0.2     -1                    # Base M
#      0    -1       1.0        0    0      0.2     -1                    # Base M
#    0.1    -1 	    1.0        0    0      0.2      1                    # Base M
#    0.0    -1       1.0        0    0      0.2      1                    # Base M
#    0.1    -1       1.0        0    0      0.2      1                    # Base M
#   -0.1    -1       1.0        0    0      0.2      1                    # Base M


##  ————————————————————————————————————————————————————————————————————————————————————  ##
## SELECTIVITY CONTROLS                                                                   ##
##     Selectivity P(capture of all sizes). Each gear must have a selectivity and a       ##
##     retention selectivity. If a uniform prior is selected for a parameter then the     ##
##     lb and ub are used (p1 and p2 are ignored)                                         ##
## LEGEND                                                                                 ##
##     sel type: 0 = parametric (nclass), 1 = indiviudal parameter for each class(nclass),##
##               2 = logistic (2, inflection point and slope), 3 = logistic95 (2, 50% and 95% selection), 4 = double normal (3 parameters),             ##
##             
##    5: Flat equal to zero (1 parameter; phase must be negative), UNIFORM1
##    6: Flat equal to one (1 parameter; phase must be negative), UNIFORM0                                    ##
##    7: Flat-topped double normal selectivity (4 parameters)
##    8: Declining logistic selectivity with initial values (50% and 95% selection plus extra) 
##  Extra (type 1): number of selectivity parameters to be estimated
##     gear index: use +ve for selectivity, -ve for retention                             ##
##     sex dep: 0 for sex-independent, 1 for sex-dependent                                ##
##  ————————————————————————————————————————————————————————————————————————————————————  ##
##  ivector  for  number  of  year  blocks  or  nodes  ##
##    Gear-1   Gear-2   
## PotFishery    Trawl Byc
        0         0                     # set 0 for male only fishery, sex specific selectivity, 0 for sex independent selectivity
#        9         5                     # male selectivity type model (flat equal to zero, 1 parameter) or logistic or  double normal etc.
        2         5                     # male selectivity type model (flat equal to zero, 1 parameter) or logistic or  double normal etc.
        0         0                     # within another gear insertion of fleet in another
#        4         0                     # extra parameters for each pattern
        0         0                     # extra parameters for each pattern
        1         1                     # determines if maximum selectivity at size if forced to equal 1 or not
        0         0                     # size-class at which selectivity is 1 males
## Gear-1    Gear-2   
       0         0                      # sex specific retention, 0 male only fishery
       2         6                      # male retention type model (flat equal to one, 1 parameter)
       1         0                      # male retention flag (0 = no, 1 = yes)
       0         0                      # extra
       0         0                      # estimate asymtotic retention (males)

#Initial	Lower_bound	Upper_bound	Prior_type	Prior_1	Prior_2	Phase	Block	Block_fn	Env_L	EnvL_var	RW	RW_Block	Sigma
#Selectivity
#Gear-1													
#108	0	200	0	0	200	-3	0	0	0	0	0	0	0.3
#144	0	200	0	0	200	-3	0	0	0	0	0	0	0.3
#153	0	200	0	0	200	-3	0	0	0	0	0	0	0.3
#178	0	200	0	0	200	-3	0	0	0	0	0	0	0.3
#0.2	0.01	1	0	0	1	 3	0	0	0	0	0	0	0.3
#0.4	0.01	1	0	0	1	 3	0	0	0	0	0	0	0.3
#0.6	0.01	1	0	0	1	 3	0	0	0	0	0	0	0.3
#0.9999	0.01	1	0	0	1	-3	0	0	0	0	0	0	0.3


121.2664438	105	180	0	100	190	3	2	0	0	0	0	0	0.3
23.51431146	0.01	40	0	0.1	50	3	2	0	0	0	0	0	0.3
136.6281955	105	180	0	100	190	3	0						
8.21588572	0.01	20	0	0.1	50	3	0						
#Retention												
#Gear-1												
136.4712813	105	180	0	100	190	3	0	0	0	0	0	0	0.3
2.196854457	0.0001	20	0	0.1	50	3	0	0	0	0	0	0	0.3


## ———————————————————————————————————————————————————————————————————————————————————— ##
## PRIORS FOR CATCHABILITY
##     If a uniform prior is selected for a parameter then the lb and ub are used (p1   ##
##     and p2 are ignored). ival must be > 0                                            ##
## only allowed to use uniform or lognormal prior
## if anlytic q estimation step is chosen, turn off estimating q by changing the estimation phase to be -ve
## LEGEND                                                                               ##
##     prior: 0 = uniform, 1 = normal, 2 = lognormal, 3 = beta, 4 = gamma               ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
# 
## SURVEYS/INDICES ONLY    

## Analytic? LAMBDA Emphasis Mirror  block Env_L EnvL_Var  RW RW_blk Sigma_RW
           0      1        1      0      0     0        0   0      0       0.3          # observer cpue index 1995-2004
           0      1        1      0      0     0        0   0      0       0.3          # observer cpue index 2005-2022
           0      1        1      0      0     0        0   0      0       0.3          # fishery cpue index 1985-1998
#           0      1        1      0       0     0        0   0      0       0.3          # observer cpue index 1995-2004
#           0      1        1      0       0     0        0   0      0       0.3          # observer cpue index 2005-2022
#           0      1        1      0       0     0        0   0      0       0.3          # fishery cpue index 1985-1998

## fishery and observer CPUE 
## Analytic (0=not analytically solved q, use uniform or lognormal prior; 
## 1= analytic), 
## Lambda =multilier for iput CV, Emphasis = multiplier for likelihood 
##  ival       lb         ub      prior   p1         p2     phz
 0.000625639  0.0000001   0.01       0      0.0     1.0      1          # observer cpue index 1995-2004
 0.00053595   0.0000001   0.01       0      0.0     1.0      1          # observer cpue index 2005-2022 
 0.000446726   0.0000001  0.01       0      0.0     1.0      1          # fishery cpue index 1985-1998
    
## if a uniform prior is specified then use lb and ub rather than p1 and p2
##  ————————————————————————————————————————————————————————————————————————————————————##
## ADDITIONAL CV FOR SURVEYS/INDICES
##     If a uniform prior is selected for a parameter then the lb and ub are used (p1   ##
##     and p2 are ignored). ival must be > 0, lb should be>0                                            ##
## LEGEND                                                                               ##
##     prior type: 0 = uniform, 1 = normal, 2 = lognormal, 3 = beta, 4 = gamma          ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## ADDITIONAL CV CONTROLS
## Mirror Block Env_L EnvL_Var  RW RW_blk Sigma_RW
        0     0     0        0   0      0      0.3  # observer cpue index 1995-2004
        0     0     0        0   0      0      0.3  # observer cpue index 2005-2022
        0     0     0        0   0      0      0.3  # fishery cpue index 1985-1998

##  ival          lb        ub    prior       p1    p2   phz  
 0.000196205   0.0000001    0.5       0      0.5   100    6   # observer cpue index 1995-2004
 0.000225602   0.0000001    0.5       0      0.5   100    6   # observer cpue index 2005-2022 
 0.000240102   0.0000001    0.5       0      0.5   100    6   # fishery cpue index 1985-1998

####
## if a uniform prior is specified then use lb and ub rather than p1 and p2
## ———————————————————————————————————————————————————————————————————————————————————— ##
##  ————————————————————————————————————————————————————————————————————————————————————##
##PENALTIES  FOR  AVERAGE  FISHING  MORTALITY  RATE  FOR  EACH  GEAR
##
##  ————————————————————————————————————————————————————————————————————————————————————##
##  Trap  Trawl  
## Male F, Female F, early_phasepenalty_sd, later_phasepenalty_sd, meanmaleF_phase, meanfemaleF_phase,
## lb meanF, ub meanF,lbannualmaleF(F_dev), ubannual maleF(F_dev),lbannualfemaleF(F_dev), ubannual femaleF(F_dev)
## BBRKC uses STD_PHZ1=0.5 STD_PHZ2=45.5
## Mean_F    Fema-Offset   STD_PHZ1 STD_PHZ2 PHZ_M PHZ_F    Lb      Ub     Lb     Ub      Lb    Ub
    0.366136439       0.0        3.0    15.0     2    -1     -12      4    -10     10     -10    10   # 
    0.00021797       0.0        4.0    15.0     2    -1     -12      4    -10     10     -10    10   # 
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
##  ——————————————————————————————————————————————————————————————————————————————————  ##
#  ret tot    
# 
   1   1          # Type of likelihood
   0   0          # Auto tail compression (pmin)
 #  1   1          # Initial value for effective sample size multiplier
 # -4  -4        # Phz for estimating effective sample size (if appl.)
   1   2         # Composition splicer if you put 1 for each it will merge, do not merge (why merge)
   # AEPAEP
   1   1          # Set to 2 for survey-like predictions; 1 for catch-like predictions
   # AEPAEP
   0.737596721   0.528124418  # Emphasis AEP for Dritchlet (Ret, Tot, multiplier of stage1 ESS)

   1   1         # LAMBDA 0 to ignore the length comp   
  ##  ——————————————————————————————————————————————————————————————————————————————————  ##

#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 



##  ———————————————————————————————————————————————————————————————————————————————————— ##
##  TAGGING controls  CONTROLS
##  ———————————————————————————————————————————————————————————————————————————————————— ##
 1          # emphasis on tagging data (1 =use tag LH, 0=ignore)
## ———————————————————————————————————————————————————————————————————————————————————— ##	
#
## EMPHASIS FACTORS (CATCH)
#ret_male  tot_male   Groundfish 
        4       2          1
## EMPHASIS FACTORS (Priors) by fleet: fdev_total, Fdov_total, Fdev_year, Fdov_year
0 0 0.001 0 # Pot fishery
0 0 0.001 0 # Groundfish


## EMPHASIS FACTORS (Priors)
##                                                             
# Log_fdevs   meanF       Mdevs  Rec_devs Initial_devs Fst_dif_dev Mean_sex-Ratio  Fvecs Fdovs
#         0       0         0.0         2            0         0           0          1     0       #
# AEP
# Log_fdevs   meanF       Mdevs  Rec_devs Initial_devs Fst_dif_dev Mean_sex-Ratio  Molt_prob	Free selectivity	Init_n_at_len Fvecs Fdovs
#	  0       0         0.0         2            0         0           0                0                   0                    0     1     0       #
0           # Log_fdevs
0           # meanF 
0           # Mdevs
2           # Rec_devs 
0           # Initial_devs
0           # Fst_dif_dev
0           # Mean_sex-Ratio
0           # Molt_prob
0           # Free selectivity
0           # Init_n_at_len
1           # Fdevs
0           # Fdovs
1           # Sel_devs


##  EOF
9999

