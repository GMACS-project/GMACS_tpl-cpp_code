## GMACS Version 2.11.05; ** AEP **; Compiled 2024-03-13

# Block structure
# Number of blocks
5
# Block structure
1 2 1 2 1 
# The blocks
2010 2022 
2010 2017 2018 2022 
1998 1998 
2010 2017 2018 2021 
2009 2022 

# Extra controls
1978 # First year of recruitment estimation
2021 # Last year of recruitment estimation
   0 # Consider terminal molting (0 = off, 1 = on). If on, the calc_stock_recruitment_relationship() isn't called in the procedure
   3 # Phase for recruitment estimation
  -3 # Phase for recruitment sex-ratio estimation
0.50 # Initial value for recruitment sex-ratio
   2 # Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters, 3 = Free parameters (revised))
1.00 # Lambda (proportion of mature male biomass for SPR reference points)
   0 # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)
   1 # Use years specified to computed average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)
 200 # Years to compute equilibria
   5 # Phase for deviation parameters

# Expecting 11 theta parameters
# Core parameters
## Initial: Initial value for the parameter (must lie between lower and upper)
## Lower & Upper: Range for the parameter
## Phase: Set equal to a negative number not to estimate
## Prior type:
## 0: Uniform   - parameters are the range of the uniform prior
## 1: Normal    - parameters are the mean and sd
## 2: Lognormal - parameters are the mean and sd of the log
## 3: Beta      - parameters are the two beta parameters [see dbeta]
## 4: Gamma     - parameters are the two gamma parameters [see dgamma]
# Initial_value    Lower_bound    Upper_bound Phase Prior_type        Prior_1        Prior_2
    14.30000000    -7.00000000    30.00000000    -2          0    -7.00000000    30.00000000
    10.00000000    -7.00000000    20.00000000    -1          1   -10.00000000    20.00000000
    13.39000000    -7.00000000    20.00000000     1          0    -7.00000000    20.00000000
    80.00000000    30.00000000   310.00000000    -2          1    72.50000000     7.25000000
     0.25000000     0.10000000     7.00000000    -4          0     0.10000000     9.00000000
     0.20000000   -10.00000000     0.75000000    -4          0   -10.00000000     0.75000000
     0.75000000     0.20000000     1.00000000    -2          3     3.00000000     2.00000000
     0.01000000     0.00000000     1.00000000    -3          3     1.01000000     1.01000000
    14.50000000     5.00000000    20.00000000     1          0     5.00000000    20.00000000
    14.00000000     5.00000000    20.00000000     1          0     5.00000000    20.00000000
    13.50000000     5.00000000    20.00000000     1          0     5.00000000    20.00000000
# lw_type
3
 0.00074843 0.00116573 0.00193051
 0.00074843 0.00116573 0.00168889
 0.00074843 0.00116573 0.00192225
 0.00074843 0.00116573 0.00187796
 0.00074843 0.00116573 0.00193863
 0.00074843 0.00116573 0.00207641
 0.00074843 0.00116573 0.00189933
 0.00074843 0.00116573 0.00211669
 0.00074843 0.00116573 0.00193878
 0.00074843 0.00116573 0.00193976
 0.00074843 0.00116573 0.00187107
 0.00074843 0.00116573 0.00199830
 0.00074843 0.00116573 0.00187042
 0.00074843 0.00116573 0.00196941
 0.00074843 0.00116573 0.00192686
 0.00074843 0.00116573 0.00202149
 0.00074843 0.00116573 0.00193132
 0.00074843 0.00116573 0.00201441
 0.00074843 0.00116573 0.00197747
 0.00074843 0.00116573 0.00209925
 0.00074843 0.00116573 0.00198248
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00189163
 0.00074843 0.00116573 0.00179572
 0.00074843 0.00116573 0.00182311
 0.00074843 0.00116573 0.00180743
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00189463
 0.00074843 0.00116573 0.00185061
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
 0.00074843 0.00116573 0.00193093
# Proportion mature by sex and size
 0.00000000 1.00000000 1.00000000
# Proportion legal by sex and size
 0.00000000 0.00000000 1.00000000

## ==================================================================================== ##
## GROWTH PARAMETER CONTROLS                                                            ##
## ==================================================================================== ##
## 
# Maximum number of size-classes to which recruitment must occur
 1
# Use functional maturity for terminally molting animals (0=no; 1=Yes)?
0
# Growth transition
##Type_1: Options for the growth matrix
#  1: Pre-specified growth transition matrix (requires molt probability)
#  2: Pre-specified size transition matrix (molt probability is ignored)
#  3: Growth increment is gamma distributed (requires molt probability)
#  4: Post-molt size is gamma distributed (requires molt probability)
#  5: Von Bert.: kappa varies among individuals (requires molt probability)
#  6: Von Bert.: Linf varies among individuals (requires molt probability)
#  7: Von Bert.: kappa and Linf varies among individuals (requires molt probability)
#  8: Growth increment is normally distributed (requires molt probability)
## Type_2: Options for the growth increment model matrix
#  1: Linear
#  2: Individual
#  3: Individual (Same as 2)
#  Block: Block number for time-varying growth   
## Type_1 Type_2  Block
        1      0      0 
# Molt probability
# Type: Options for the molt probability function
#  0: Pre-specified
#  1: Constant at 1
#  2: Logistic
#  3: Individual
#  Block: Block number for time-varying growth   
## Type Block
      2     0 

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
# MAIN PARS: Initial  Lower_bound  Upper_bound Prior_type       Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           121.500000    65.000000   145.000000          0     0.000000   999.000000     -4      0      0      0      0      0      0   0.3000 # Molt_probability_mu_male_period_1
             0.060000     0.000000     1.000000          0     0.000000   999.000000     -3      0      0      0      0      0      0   0.3000 # Molt_probability_CV_male_period_1
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1      Prior_2  Phase Reltve 
# 
# Using custom growth matrix
# 
# Using custom size transition matrix
 0.1761 0.0000 0.0000
 0.7052 0.2206 0.0000
 0.1187 0.7794 1.0000


## ==================================================================================== ##
## NATURAL MORTALITIY PARAMETER CONTROLS                                                ##
## ==================================================================================== ##
## 
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
## Relative?   Type   Extra  Brkpts  Mirror   Block  Blk_fn Env_L   EnvL_Vr      RW  RW_blk Sigma_RW Mirr_RW
          0       0       0       0       0       3       1       0       0       0       0   0.3000       0

#     Initial     Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    0.18000000     0.00000000     0.20000000           0     0.00000000     0.20000000     -1 
    1.60000000     0.00000000     2.00000000           1     0.00000000    10.00000000      3 

## ==================================================================================== ##
## SELECTIVITY PARAMETERS CONTROLS                                                      ##
## ==================================================================================== ##
## 
# ## Selectivity parameter controls
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
# ##      Inputs: knots (in length units); values at knots (0-1) - at least one should have phase -1
# ##  10: One parameter logistic selectivity (inflection point and slope)
## Selectivity specifications --
# ## Extra (type 1): number of selectivity parameters to estimated
# #  Pot_Fishery Trawl_Bycatch Fixed_bycatch NMFS_Trawl ADFG_Pot
 0 0 0 0 0 # is selectivity sex=specific? (1=Yes; 0=No)
 0 3 3 0 0 # male selectivity type
 0 0 0 0 0 # selectivity within another gear
 0 0 0 0 0 # male extra parameters for each pattern
 1 1 1 1 1 # male: is maximum selectivity at size forced to equal 1 (1) or not (0)
 0 0 0 0 0 # size-class at which selectivity is forced to equal 1 (ignored if the previous input is 1)
## Retention specifications --
 0 0 0 0 0 # is retention sex=specific? (1=Yes; 0=No)
 3 6 6 6 6 # male retention type
 1 0 0 0 0 # male retention flag (0 = no, 1 = yes)
 0 0 0 0 0 # male extra parameters for each pattern
 0 0 0 0 0 # male - should maximum retention be estimated for males (1=Yes; 0=No)

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

# Inputs for type*sex*fleet: selectivity male Pot_Fishery
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
             0.400000     0.001000     1.000000          0     0.000000     1.000000      3      5      0      0      0      0      0   0.3000 # Sel_Pot_Fishery_male_period_1_par_1
             0.700000     0.001000     1.000000          0     0.000000     1.000000      3      5      0      0      0      0      0   0.3000 # Sel_Pot_Fishery_male_period_1_par_2
             1.000000     0.001000     2.000000          0     0.000000     1.000000     -2      5      0      0      0      0      0   0.3000 # Sel_Pot_Fishery_male_period_1_par_3
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1     Prior_2  Phase Reltve 
             0.400000     0.001000     1.000000          0     0.000000     1.000000      3      0 # Sel_Pot_Fishery_male_period_2_par_1
             0.999990     0.001000     1.000000          0     0.000000     1.000000      3      0 # Sel_Pot_Fishery_male_period_2_par_2
             1.000000     0.001000     2.000000          0     0.000000     1.000000     -2      0 # Sel_Pot_Fishery_male_period_2_par_3

# Inputs for type*sex*fleet: selectivity male Trawl_Bycatch
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
            40.000000    10.000000   200.000000          0    10.000000   200.000000     -3      0      0      0      0      0      0   0.3000 # Sel_Trawl_Bycatch_male_period_1_par_1
            60.000000    10.000000   200.000000          0    10.000000   200.000000     -3      0      0      0      0      0      0   0.3000 # Sel_Trawl_Bycatch_male_period_1_par_2

# Inputs for type*sex*fleet: selectivity male Fixed_bycatch
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
            40.000000    10.000000   200.000000          0    10.000000   200.000000     -3      0      0      0      0      0      0   0.3000 # Sel_Fixed_bycatch_male_period_1_par_1
            60.000000    10.000000   200.000000          0    10.000000   200.000000     -3      0      0      0      0      0      0   0.3000 # Sel_Fixed_bycatch_male_period_1_par_2

# Inputs for type*sex*fleet: selectivity male NMFS_Trawl
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
             0.700000     0.001000     1.000000          0     0.000000     1.000000      4      0      0      0      0      0      0   0.3000 # Sel_NMFS_Trawl_male_period_1_par_1
             0.999990     0.001000     1.000000          0     0.000000     1.000000      4      0      0      0      0      0      0   0.3000 # Sel_NMFS_Trawl_male_period_1_par_2
             0.900000     0.001000     1.000000          0     0.000000     1.000000     -5      0      0      0      0      0      0   0.3000 # Sel_NMFS_Trawl_male_period_1_par_3

# Inputs for type*sex*fleet: selectivity male ADFG_Pot
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
             0.400000     0.001000     1.000000          0     0.000000     1.000000      4      0      0      0      0      0      0   0.3000 # Sel_ADFG_Pot_male_period_1_par_1
             0.999990     0.001000     1.000000          0     0.000000     1.000000      4      0      0      0      0      0      0   0.3000 # Sel_ADFG_Pot_male_period_1_par_2
             1.000000     0.001000     2.000000          0     0.000000     1.000000     -2      0      0      0      0      0      0   0.3000 # Sel_ADFG_Pot_male_period_1_par_3

# Inputs for type*sex*fleet: retention male Pot_Fishery
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           120.000000    50.000000   200.000000          0     1.000000   900.000000     -7      0      0      0      0      0      0   0.3000 # Ret_Pot_Fishery_male_period_1_par_1
           123.000000   110.000000   200.000000          0     1.000000   900.000000     -7      0      0      0      0      0      0   0.3000 # Ret_Pot_Fishery_male_period_1_par_2


## ==================================================================================== ##
## CATCHABILITY PARAMETER CONTROLS                                                      ##
## ==================================================================================== ##
## 
# Catchability (specifications)
# Analytic: should q be estimated analytically (1) or not (0)
# Lambda: the weight lambda
# Emphasis: the weighting emphasis
# Block: Block number for time-varying M-at-size
# Block_fn: 0:absolute values; 1:exponential
# Env_L: Environmental link - options are 0: none; 1:additive; 2:multiplicative; 3:exponential
# EnvL_var: Environmental variable
# RW: 0 for no random walk changes; 1 otherwise
# RW_blk: Block number for random walks
# Sigma_RW: Sigma for the random walk parameters
## Analytic  Lambda Emphass  Mirror   Block   Env_L EnvL_Vr      RW  RW_blk Sigma_RW
          0       1       1       0       0       0       0       0       0   0.3000 
          0       1       1       0       0       0       0       0       0   0.3000 
# Catchability (parameters)
#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    1.00000000     0.50000000     1.20000000           0     0.00000000     9.00000000     -4 
    0.00300000     0.00000000     5.00000000           0     0.00000000     9.00000000      3 

## ==================================================================================== ##
## ADDITIONAL CV PARAMETER CONTROLS                                                     ##
## ==================================================================================== ##
## 
# Catchability (specifications)
# Mirror: should additional variance be mirrored (value > 1) or not (0)?
# Block: Block number for time-varying M-at-size
# Block_fn: 0:absolute values; 1:exponential
# Env_L: Environmental link - options are 0: none; 1:additive; 2:multiplicative; 3:exponential
# EnvL_var: Environmental variable
# RW: 0 for no random walk changes; 1 otherwise
# RW_blk: Block number for random walks
# Sigma_RW: Sigma for the random walk parameters
##   Mirror   Block   Env_L EnvL_Vr     RW   RW_blk Sigma_RW
          0       0       0       0       0       0   0.3000 
          0       0       0       0       0       0   0.3000 
## Mirror Block Env_L EnvL_Var  RW RW_blk Sigma_RW
# Additional variance (parameters)
#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    0.00000010     0.00000000    10.00000000           4     1.00000000   100.00000000     -4 
    0.00000010     0.00000000    10.00000000           4     1.00000000   100.00000000     -4 

## ==================================================================================== ##
## CONTROLS ON F                                                                        ##
## ==================================================================================== ##
## 
# Controls on F
#   Initial_male_F Initial_fema_F Pen_SD (early) Pen_SD (later) Phz_mean_F_mal Phz_mean_F_fem   Lower_mean_F   Upper_mean_F Low_ann_male_F  Up_ann_male_F    Low_ann_f_F     Up_ann_f_F
          0.200000       0.000000       3.000000      50.000000       1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Pot_Fishery
          0.000100       0.000000       4.000000      50.000000       1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Trawl_Bycatch
          0.000100       0.000000       4.000000      50.000000       1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Fixed_bycatch
          0.000000       0.000000       2.000000      20.000000      -1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # NMFS_Trawl
          0.000000       0.000000       2.000000      20.000000      -1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # ADFG_Pot

## ==================================================================================== ##
## SIZE COMPOSITIONS OPTIONS                                                            ##
## ==================================================================================== ##
## 
# Options when fitting size-composition data
## Likelihood types: 
##  1:Multinomial with estimated/fixed sample size
##  2:Robust approximation to multinomial
##  3:logistic normal
##  4:multivariate-t
##  5:Dirichlet

#  Pot_Fishery NMFS_Trawl ADFG_Pot
#  male male male
#  total total total
#  all_shell all_shell all_shell
#  immature+mature immature+mature immature+mature
      2      2      2 # Type of likelihood
      0      0      0 # Auto tail compression (pmin)
 1.0000 1.0000 1.0000 # Initial value for effective sample size multiplier
     -4     -4     -4 # Phz for estimating effective sample size (if appl.)
      1      2      3 # Composition aggregator codes
      1      2      2 # Set to 1 for catch-based predictions; 2 for survey or total catch predictions
 1.0000 1.0000 1.0000 # Lambda for effective sample size
 1.0000 1.0000 1.0000 # Lambda for overall likelihood

## ==================================================================================== ##
## EMPHASIS FACTORS                                                                     ##
## ==================================================================================== ##

0.0000 # Emphasis on tagging data

 1.0000 1.0000 1.0000 1.0000 # Emphasis on Catch: (by catch dataframes)

#AEP AEP AEP AEP
   1.0000   0.0000   0.0000   0.0000 # Pot_Fishery
   1.0000   0.0000   0.0000   0.0000 # Trawl_Bycatch
   1.0000   0.0000   0.0000   0.0000 # Fixed_bycatch
   1.0000   0.0000   0.0000   0.0000 # NMFS_Trawl
   1.0000   0.0000   0.0000   0.0000 # ADFG_Pot
# 
## Emphasis Factors (Priors/Penalties: 13 values) ##
 10000.0000	#--Log_fdevs
     0.0000	#--MeanF
     1.0000	#--Mdevs
     1.0000	#--Rec_devs
     0.0000	#--Initial_devs
     0.0000	#--Fst_dif_dev
     1.0000	#--Mean_sex_ratio
     0.0000	#--Molt_prob
     0.0000	#--free selectivity
     0.0000	#--Init_n_at_len
     0.0000	#--Fvecs
     0.0000	#--Fdovss
     0.0000	#--Random walk in selectivity

# eof_ctl
9999
