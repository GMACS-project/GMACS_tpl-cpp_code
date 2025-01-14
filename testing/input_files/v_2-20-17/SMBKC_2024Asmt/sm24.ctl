## Sept 2024 smbkc model 24.1 version: new base model with M = 0.23
#
## ==================================================================================== ##
# Time Block_Groups to be used in the model (Block_Group 0 is the year range)
## ==================================================================================== ##
# Block_Groups to be used in the model (Block_Group 0 is the model year range)
3
# Number of blocks per group (after the first block, i.e. 1 means two blocks)
1 1 1
# Block_Group definitions  (first block always start with syr; year 0 is last year)
# Block 1: styr endyr #--applies to almost everything (and always defined)
1978 2024 # Block Group 1: M and NMFS survey
# Block Group 2: directed fishery
2009 2024 # Block Group 3: directed fishery
# Block Group 3: natural mortality event
1998 1998

## ==================================================================================== ##
## GENERAL CONTROLS
## ==================================================================================== ##
1978       # First rec_dev
2023       # last rec_dev (updated annually, should be last completed crab year?)
   0       # Terminal molting (0 = off, 1 = on). If on, the calc_stock_recruitment_relationship() isn't called in the procedure
   3       # Estimated rec_dev phase
  -3       # Estimated sex_ratio
 0.5       # initial sex-ratio  
#  -3       # Estimated rec_ini phase
   2       # Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters)
   1       # Reference size-class for initial conditons = 3 only
   1       # Lambda (proportion of mature male biomass for SPR reference points)
   0       # Stock-Recruit-Relationship (0 = None, 1 = Beverton-Holt)
  1        # Use years specified to computed average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)
  200      # Years to compute equilibria
   5 # Phase for deviation parameters
1978 # First year of bias-correction - what is this? Buck had it as 1910.
1978 # First full bias-correction - what is this? Buck had it as 1920.
2050 # Last full bias-correction
2050 # Last year of bias-correction
## ———————————————————————————————————————————————————————————————————————————————————— ##
## RECRUITMENT                                                                          ##                                          
## ival           lb        ub        phz    prior     p1      p2         # parameter   ##                                          
## ———————————————————————————————————————————————————————————————————————————————————— ##                                          
# ival        lb        ub        phz   prior     p1      p2         # parameter         #
  14.3      -7.0        30        -2       0    -7       30          # log(R0)
  10.0      -7.0        20        -1       1   -10.0     20          # log(Rini)
  13.39     -7.0        20         1       0    -7       20          # log(Rbar) (MUST be PHASE 1)
  80.0      30.0       310        -2       1    72.5    7.25         # Recruitment size distribution expected value
  0.25       0.1         7        -4       0    0.1     9.0          # Recruitment size scale (variance component)
  0.2      -10.0      0.75        -4       0  -10.0    0.75          # log(sigma_R)
  0.75      0.20      1.00        -2       3    3.0    2.00          # steepness
  0.01      0.00      1.00        -3       3    1.01   1.01          # recruitment autocorrelation
## ———————————————————————————————————————————————————————————————————————————————————— ##
## Initial abundance                                                                    ##
## ival           lb        ub        phz    prior     p1      p2         # parameter   ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
  14.5       5.00     20.00         1       0    5.00  20.00         # logN0 vector of initial numbers at length
  14.0       5.00     20.00         1       0    5.00  20.00         # logN0 vector of initial numbers at length
  13.5       5.00     20.00         1       0    5.00  20.00         # logN0 vector of initial numbers at length

## ———————————————————————————————————————————————————————————————————————————————————— ##
# weight-at-length input method (1 = allometry i.e. w_l = a*l^b, 2 = vector by sex, 3 = matrix by sex)
## ———————————————————————————————————————————————————————————————————————————————————— ##
3
# Male weight-at-length
0.000748427    0.001165731    0.001930510
0.000748427    0.001165731    0.001688886
0.000748427    0.001165731    0.001922246
0.000748427    0.001165731    0.001877957
0.000748427    0.001165731    0.001938634
0.000748427    0.001165731    0.002076413
0.000748427    0.001165731    0.001899330
0.000748427    0.001165731    0.002116687
0.000748427    0.001165731    0.001938784
0.000748427    0.001165731    0.001939764
0.000748427    0.001165731    0.001871067
0.000748427    0.001165731    0.001998295
0.000748427    0.001165731    0.001870418
0.000748427    0.001165731    0.001969415
0.000748427    0.001165731    0.001926859
0.000748427    0.001165731    0.002021492
0.000748427    0.001165731    0.001931318
0.000748427    0.001165731    0.002014407
0.000748427    0.001165731    0.001977471
0.000748427    0.001165731    0.002099246
0.000748427    0.001165731    0.001982478
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001891628
0.000748427    0.001165731    0.001795721
0.000748427    0.001165731    0.001823113
0.000748427    0.001165731    0.001807433
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001894627
0.000748427    0.001165731    0.001850611
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932
0.000748427    0.001165731    0.001930932 # (updated - should this change?)
0.000748427    0.001165731    0.001930932 # (add line here each year - 4-14-22)
0.000748427    0.001165731    0.001930932 # (add line here each year - 8-25-22)
0.000748427    0.001165731    0.001930932 # (add line here each year - 2-14-24)
0.000748427    0.001165731    0.001930932 # (add line here each year - 8-14-24)
# Proportion mature by sex
0 1 1
# Proportion legal by sex
0 0 1
## ==================================================================================== ##
## GROWTH PARAMETER CONTROLS                                                            ##
## ==================================================================================== ##
1   # Maximum size-class for recruitment(males then females)
0   # use functional maturity for terminally molting animals?
## ———————————————————————————————————————————————————————————————————————————————————— ##
#--General inputs
# ———————————————————————————————————————————————————————————————————————————————————— ##         
# Block: Block number for time-varying growth   
# Block_fn: 0:absolute values; 1:exponential
# Env_L: Environmental link - options are 1:additive; 2:multiplicative; 3:exponential
# EnvL_var: Environmental variable
# RW: 0 for not random walk changes; 1 otherwise
# RW_blk: Block number for random walks
# Sigma_RW: Sigma for the random walk parameters
## ———————————————————————————————————————————————————————————————————————————————————— ##         
#--Growth transition
# ———————————————————————————————————————————————————————————————————————————————————— ##         
## Type_1: Options for the growth matrix
#  1: Pre-specified growth transition matrix             (requires molt probability)
#  2: Pre-specified size transition matrix               (molt probability is ignored)
#  3: Growth increment is gamma distributed              (requires molt probability)
#  4: Post-molt size is gamma distributed                (requires molt probability)
#  5: Von Bert.: kappa varies among individuals          (requires molt probability)
#  6: Von Bert.: Linf varies among individuals           (requires molt probability)
#  7: Von Bert.: kappa and Linf varies among individuals (requires molt probability)
#  8: Growth increment is normally distributed           (requires molt probability)
## Type_2: Options for the growth increment model matrix (if Type_1 in 3-8)
#  1: Linear
#  2: Individual
#  3: Individual (Same as 2)
#  4: Power law for mean post-molt size
#  Block: Block number for time-varying growth   
## Type_1 Type_2  Block
      1     -1      0    # Growth-transition Males
# ———————————————————————————————————————————————————————————————————————————————————— ##         
#--Molt probability
# ———————————————————————————————————————————————————————————————————————————————————— ##         
## Options for the molt probability function
#  0: Pre-specified
#  1: Constant at 1
#  2: Logistic
#  3: Individual
## Type Block  
    2     0    # Molt probability Males
##--the following is no longer necessary:
# molt probability function (0=pre-specified; 1=flat;2=declining logistic)
#2
# Maximum size-class for recruitment(males then females)
#1
## number of size-increment periods
#1
## Year(s) molt period changes (blank if no change)
#
## Two lines for each parameter if split sex, one line if not                           ##
## number of molt periods
#1
## Year(s) molt period changes (blank if no changes)
#
## Beta parameters are relative (1=Yes;0=no)
#1   
##--end "no longer necessary"
# ———————————————————————————————————————————————————————————————————————————————————— ##         
## General parameter specificiations 
##  Initial: Initial value for the parameter (must lie between lower and upper)
##  Lower & Upper: Range for the parameter
##  Prior type:
##   0: Uniform   - parameters are the range of the uniform prior
##   1: Normal    - parameters are the mean and sd
##   2: Lognormal - parameters are the mean and sd of the log
##   3: Beta      - parameters are the two beta parameters [see dbeta]
##   4: Gamma     - parameters are the two gamma parameters [see dgamma]
##  Phase: Set equal to a negative number not to estimate
##  Relative: 0: absolute; 1 relative 
##  Block: Block number for time-varying selectivity   
##  Block_fn: 0:absolute values; 1:exponential
##  Env_L: Environmental link - options are 0:none; 1:additive; 2:multiplicative; 3:exponential
##  EnvL_var: Environmental variable
##  RW: 0 for no random walk changes; 1 otherwise
##  RW_blk: Block number for random walks
##  Sigma_RW: Sigma used for the random walk
# Inputs for sex * type 2
## MAIN PARS: 
# Initial  Lower_bound  Upper_bound Prior_type   Prior_1  Prior_2  Phase  Block Blk_fn  Env_L Env_vr   RW RW_Blk RW_Sigma
    121.5      65.0     145.0           0         0.0      999.0    -4      0      0      0     0       0    0     300    # molt_mu males or combined
    0.060       0.0       1.0           0         0.0      999.0    -3      0      0      0     0       0    0     300    # molt_cv males or combined

# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1      Prior_2  Phase Reltve 
#----no extra pars
#--following is no longer necessary:
## ———————————————————————————————————————————————————————————————————————————————————— ##         
## AEP Growth parameters
### ———————————————————————————————————————————————————————————————————————————————————— ##
## ival        lb        ub     phz   prior      p1      p2         # parameter         #
## —————————————————————————————————————————————————————————————————————————————————————— #
##  14.1      10.0      30.0         -3       0    0.0   999.0         # alpha males or combined
##   0.0001    0.0       0.01        -3       0    0.0   999.0         # beta males or combined
##   0.45      0.01      1.0         -3       0    0.0   999.0         # gscale males or combined
#   121.5      65.0     145.0       -4       0    0.0   999.0         # molt_mu males or combined
#   0.060     0.0       1.0         -3       0    0.0   999.0         # molt_cv males or combined
#--end of "no longer necessary"

# The custom growth matrix (if not using just fill with zeros)
# Alternative TM (loosely) based on Otto and Cummiskey (1990)
#  Size1....Size2....Size3
   0.1761   0.0000   0.0000
   0.7052   0.2206   0.0000
   0.1187   0.7794   1.0000

# custom molt probability matrix


## ==================================================================================== ##
## NATURAL MORTALITY PARAMETER CONTROLS                                                ##
## ==================================================================================== ##
## baseline M: immature crab; mature M's: sex-specfic ln-scale offsets
# Relative: 0 - absolute values; 1+ - based on another M-at-size vector (indexed by ig)
# Type: 0 for standard; 1: Spline
#  For spline: set extra to the number of knots, the parameters are the knots (phase -1) and the log-differences from base M
# Extra: control the number of knots for splines
# Brkpts: number of changes in M by size
# Mirror: Mirror M-at-size over to that for another partition (indexed by ig)
# Block: Block number for time-varying M-at-size
# Block_fn: 0:absolute values; 1:exponential
# Env_L: Environmental link - options are 0: none; 1:additive; 2:multiplicative; 3:exponential
# EnvL_var: Environmental variable
# RW: 0 for no random walk changes; 1 otherwise
# RW_blk: Block number for random walks
# Sigma_RW: Sigma for the random walk parameters
# Mirror_RW: Should time-varying aspects be mirrored (Indexed by ig)
#--control info by group (ig)
#----group 1: males
## Relative? Type   Extra  Brkpts  Mirror   Block  Blk_fn Env_L   EnvL_Vr   RW  RW_blk Sigma_RW Mirr_RW
     0        0       0       0      0         3     0      0       0       0       0   0.3000     0


#----parameter values
# Initial  Lower_bound Upper_bound  Prior_type    Prior_1    Prior_2    Phase 
    0.23      0.01         1             2         0.23        0.02      -4   # M for males
    1.6        0.0         2             0         0           0          3   # M for males
#    0.23      0.01         1             2         0.23        0.02      -4   # M for males

## ==================================================================================== ##
## SELECTIVITY PARAMETERS CONTROLS                                                      ##
## ==================================================================================== ##
## 
# ## Selectivity parameter controls
# ## Selectivity (and retention) types
# ##  <0: Mirror selectivity
# ##   0: Nonparametric selectivity (one parameter per class)
# ##   1: Nonparametric selectivity (one parameter per class, constant from last specified class)
# ##   2: Logistic selectivity (inflection point and width (i.e. 1/slope))
# ##   3: Logistic selectivity (50% and 95% selection)
# ##   4: Double normal selectivity (3 parameters)
# ##   5: Flat equal to zero (1 parameter; phase must be negative)
# ##   6: Flat equal to one (1 parameter; phase must be negative)
# ##   7: Flat-topped double normal selectivity (4 parameters)
# ##   8: Declining logistic selectivity with initial values (50% and 95% selection plus extra)
# ##   9: Cubic-spline (specified with knots and values at knots)
# ##      Inputs: knots (in length units); values at knots (0-1) - at least one should have phase -1
# ##  10: One parameter logistic selectivity (inflection point and slope)
# ##  11: Pre-specified selectivity (matrix by year and class)

## Selectivity specifications --
# ## Extra (type 1): number of selectivity parameters to estimated
# #  Pot_Fishery      Trawl_Bycatch Fixed_bycatch NMFS_Trawl ADFG_Pot
          0                 0             0           0         0 # is selectivity sex=specific? (1=Yes; 0=No)
          0                 3             3           0         0 # male selectivity type
          0                 0             0           0         0 # selectivity within another gear
          0                 0             0           0         0 # male extra parameters for each pattern
          1                 1             1           1         1 # male: is maximum selectivity at size forced to equal 1 (1) or not (0)
          3                 3             3           3         3 # size-class at which selectivity is forced to equal 1 (ignored if the previous input is 1)

## Retention specifications --
# #  Pot_Fishery  Trawl_Bycatch Fixed_bycatch NMFS_Trawl ADFG_Pot
          0                0             0           0         0 # is retention sex=specific? (1=Yes; 0=No)
          3                6             6           6         6 # male retention type
          1                0             0           0         0 # male retention flag (0 = no, 1 = yes)
          0                0             0           0         0 # male extra parameters for each pattern
          0                0             0           0         0 # male - should maximum retention be estimated for males (1=Yes; 0=No)

## ==================================================================================== ##
## SELECTIVITY/RETENTION PARAMETER VALUES                                               ##
## ==================================================================================== ##
# Inputs for type*sex*fleet: 
# Selectivity male Pot_Fishery block 2
#Initial  Lower_bound  Upper_bound  Prior_type  Prior_1  Prior_2  Phase  Block  Block_fn  Env_L  EnvL_var  RW  RW_Block  Sigma
  0.4        0.001         1.0           0        0         1       3       2      0        0       0       0     0        1    #--directed fishery, block 2 (1978-2008)
  0.7        0.001         1.0           0        0         1       3       2      0        0       0       0     0        1    #--directed fishery, block 2 (1978-2008)
  1.0        0.001         2.0           0        0         1      -2       2      0        0       0       0     0        1    #--directed fishery, block 2 (1978-2008)

# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1     Prior_2  Phase Reltve 
  0.4        0.001         1.0           0        0         1       3      0     #--directed fishery, (2009-2023)
  1.0        0.001         1.0           0        0         1      3      0     #--directed fishery, (2009-2023) 
  1.0        0.001         2.0           0        0         1      -2      0     #--directed fishery, (2009-2023). Upper bound must = 2.0

# Selectivity male trawl bycatch groundfish
  20           10.0         200           0        10       200     -3       0      0        0       0       0     0        1    #--block 1 (1978-2023)
  60          10.0         200           0        10       200     -3       0      0        0       0       0     0        1    #--block 1 (1978-2023)

# Selectivity male trawl fixed gear groundfish
  40          0.0          200           0        10       200     -3       0      0        0       0       0     0        1    #--block 1 (1978-2023)
  60         10.0          200           0        10       200     -3       0      0        0       0       0     0        1    #--block 1 (1978-2023)

# Selectivity NMFS trawl survey
  0.7        0.001         1.0           0         0         1      4       0      0        0       0       0     0        1    #--block 1 (1978-2023)
  1.0        0.001         1.0           0         0         1      4       0      0        0       0       0     0        1    #--block 1 (1978-2023)
  0.9        0.001         1.0           0         0         1     -5       0      0        0       0       0     0        1    #--block 1 (1978-2023)

# Selectivity ADFG pot survey
  0.4        0.001         1.0           0         0         1      4       0      0        0       0       0     0        1    #--block 1 (1978-2023)
  1.0        0.001         1.0           0         0         1      4       0      0        0       0       0     0        1    #--block 1 (1978-2023)
  1.0        0.001         2.0           0         0         1     -2       0      0        0       0       0     0        1    #--block 1 (1978-2023)

# Inputs for type*sex*fleet: 
# Retention male Pot_Fishery
#Initial  Lower_bound  Upper_bound  Prior_type  Prior_1  Prior_2  Phase  Block  Block_fn  Env_L  EnvL_var  RW  RW_Block  Sigma
  120         50           200           0        1        900      -7       0      0        0       0       0     0        1    #--directed fishery, block 2 (1978-2008)
  123        110           200           0        1        900      -7       0      0        0       0       0     0        1    #--directed fishery, block 2 (1978-2008)

# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1     Prior_2  Phase Reltve 
#  120         50           200           0        1        900      -7      0   #--directed fishery (2009 - 2023)
#  123        110           200           0        1        900      -7      0   #--directed fishery (2009 - 2023)

## ==================================================================================== ##
## PRIORS FOR CATCHABILITY
##     If a uniform prior is selected for a parameter then the lb and ub are used (p1   ##
##     and p2 are ignored). ival must be > 0                                            ##
## only allowed to use uniform or lognormal prior                                       ##
## if analytic q estimation step is chosen, turn off estimating q by changing the estimation phase to be -ve ##
## LEGEND                                                                               ##
##     prior: 0 = uniform, 1 = normal, 2 = lognormal, 3 = beta, 4 = gamma               ##
## ==================================================================================== ##
##  LAMBDA: Arbitrary relative weights for each series, 0 = do not fit.
## SURVEYS/INDICES ONLY
## Analytic (0 = not analytically solved q, use uniform or lognormal prior; 1 = anaylytic) ##
## Lambda = multiplier for input CV, Emphasis = multiplier for likelihood                  ##

## Analytic? LAMBDA Emphasis Mirror  block Env_L EnvL_Var  RW RW_blk Sigma_RW
0      1        1      0      0     0        0   0      0       0.3          # NMFS trawl
0      1        1      0      0     0        0   0      0       0.3          # ADF&G pot

##  ival       lb         ub      prior    p1         p2     phz
    1.0        0.5        1.2       0      0.0        9.0     -4          # NMFS trawl
    0.003      0          5         0      0.0        9.0      3          # ADF&G pot

 
## ==================================================================================== ##
## if uniform prior is specified then use lb and ub rather than p1 and p2
## ==================================================================================== ##
## ADDITIONAL CV FOR SURVEYS/INDICES                                                    ##
##     If a uniform prior is selected for a parameter then the lb and ub are used (p1   ##
##     and p2 are ignored). ival must be > 0                                            ##
## LEGEND                                                                               ##
##     prior: 0 = uniform, 1 = normal, 2 = lognormal, 3 = beta, 4 = gamma               ##
## ==================================================================================== ##

## Mirror Block Env_L EnvL_Var  RW RW_blk Sigma_RW
        0     0     0        0   0      0      0.3  # NMFS
        0     0     0        0   0      0      0.3  # ADF&G


## ival                   lb     ub     prior     p1      p2      phz
   0.0000001      0.000000001   10.0     4        1.0     100     -4  # NMFS (PHASE -4)
   0.0000001      0.000000001   10.0     4        1.0     100     -4  # ADF&G
   
## ==================================================================================== ##

## ==================================================================================== ##
## PENALTIES FOR AVERAGE FISHING MORTALITY RATE FOR EACH GEAR
## ==================================================================================== ##
## Mean_F   Female Offset STD_PHZ1   STD_PHZ2   PHZ_M   PHZ_F Fbar_l Fbar_h Fdev_L Fdev_h Foff_l Foff_h
   0.2              0.0     3.0      50.0        1       -1     -12     4     -10     10    -10     10  # Pot
   0.0001           0.0     4.0      50.0        1       -1     -12     4     -10     10    -10     10  # Trawl
   0.0001           0.0     4.0      50.0        1       -1     -12     4     -10     10    -10     10  # Fixed
   0.00             0.0     2.00     20.00       -1      -1     -12     4     -10     10    -10     10  # NMFS
   0.00             0.0     2.00     20.00       -1      -1     -12     4     -10     10    -10     10  # ADF&G
## ==================================================================================== ##

## ==================================================================================== ##
## OPTIONS FOR SIZE COMPOSTION DATA (COLUMN FOR EACH MATRIX)
## ==================================================================================== ##
## LIKELIHOOD OPTIONS
##   -1) Multinomial with estimated/fixed sample size
##   -2) Robust approximation to multinomial
##   -3) logistic normal (NIY)
##   -4) multivariate-t (NIY)
##   -5) Dirichlet
##   -6) Dirichlet-Alt (Thorson et al 2016 rec'd)
## AUTOTAIL COMPRESSION
##   pmin is the cumulative proportion used in tail compression.
## ==================================================================================== ##
#  Pot_Fishery NMFS_Trawl ADFG_Pot
#   M    M    M  
#  tot  tot  tot 
#  N+S  N+S  N+S 
#  I+M  I+M  I+M 
#  1   1   1  # Type of likelihood
#  5   5   5  # Type of likelihood
  2   2   2   # Type of likelihood
  0   0   0   # Auto tail compression
  0   0   0   # Auto tail compression (pmin)
  1   2   3   # Composition splicer
  1   2   2   # Set to 1 for catch-based predictions; 2 for survey or total catch predictions
  1   1   1   # LAMBDA
  1   1   1   # Emphasis
  0   1   2   # Survey to set Q for this comp
## ———————————————————————————————————————————————————————————————————————————————————— ##

#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 


## ==================================================================================== ##
## EMPHASIS FACTORS                                                                     ##
## ==================================================================================== ##

0 # Emphasis on tagging data

 #Ret_POT Disc_POT Disc_trawl Disc_fixed
       1        1          1          1

## EMPHASIS FACTORS (Priors) by fleet: Fdev_total, Fdov_total, Fdev_year, Fdov_year
1 0 0.000 0 # Pot fishery
1 0 0.000 0 # Trawl bycatch
1 0 0.000 0 # fixed gear bycatch
1 0 0.000 0 # NMFS survey
1 0 0.000 0 # ADF&G survey 

## ==================================================================================== ##
## EMPHASIS FACTORS (Priors)
## ==================================================================================== ##

## Emphasis Factors (Priors/Penalties: 13 values) ##
     10000.0000 #--Penalty on log_fdev (male+combined; female) to ensure they sum to zero
     0.0000 #--Penalty on mean F by fleet to regularize the solution
     0.0000 #--Not used
     0.0000 #--Not used
     0.0000 #--Not used
     0.0000 #--Smoothness penalty on the recruitment devs
     1.0000 #--Penalty on the difference of the mean_sex_ratio from 0.5
     0.0000 #--Smoothness penalty on molting probability
     0.0000 #--Smoothness penalty on selectivity patterns with class-specific coefficients
     0.0000 #--Smoothness penalty on initial numbers at length
     0.0000 #--Penalty on annual F-devs for males by fleet
     0.0000 #--Penalty on annual F-devs for females by fleet
     0.0000 #--Penalty on deviation parameters

## EOF
9999
