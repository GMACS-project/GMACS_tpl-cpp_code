## GMACS Version 2.11.05; ** AEP **; Compiled 2024-03-13

# Block structure
# Number of blocks
2
# Block structure
2 1 
# The blocks
2005 2010 2018 2022 
2005 2023 

# Extra controls
1960 # First year of recruitment estimation
2022 # Last year of recruitment estimation
   0 # Consider terminal molting (0 = off, 1 = on). If on, the calc_stock_recruitment_relationship() isn't called in the procedure
   1 # Phase for recruitment estimation
  -2 # Phase for recruitment sex-ratio estimation
0.50 # Initial value for recruitment sex-ratio
   0 # Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters, 3 = Free parameters (revised))
1.00 # Lambda (proportion of mature male biomass for SPR reference points)
   0 # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)
   1 # Use years specified to computed average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)
 200 # Years to compute equilibria
   5 # Phase for deviation parameters

# Expecting 8 theta parameters
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
     7.79033949   -10.00000000    20.00000000     1          0   -10.00000000    20.00000000
    12.00000000   -10.00000000    20.00000000    -3          0   -10.00000000    20.00000000
     8.00000000   -10.00000000    20.00000000    -1          0   -10.00000000    20.00000000
   110.00000000   103.00000000   165.00000000    -2          1    72.50000000     7.25000000
     1.61612666     0.00100000    20.00000000     3          0     0.10000000     5.00000000
    -0.69314718   -10.00000000     0.75000000    -1          0   -10.00000000     0.75000000
     0.73000000     0.20000000     1.00000000    -2          3     3.00000000     2.00000000
     0.00100000     0.00000000     1.00000000    -3          3     1.01000000     1.01000000
# lw_type
2
 0.58151571 0.67932817 0.78803235 0.90827831 1.04072426 1.18603629 1.34488818 1.51796111 1.70594354 1.90953096 2.12942573 2.36633693 2.62098018 2.89407749 3.18635714 3.49855352 3.99365758
# Proportion mature by sex and size
 0.00000000 0.00000000 0.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000
# Proportion legal by sex and size
 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000

## ==================================================================================== ##
## GROWTH PARAMETER CONTROLS                                                            ##
## ==================================================================================== ##
## 
# Maximum number of size-classes to which recruitment must occur
 5
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
        8      1      0 
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

# Inputs for sex * type 1
# MAIN PARS: Initial  Lower_bound  Upper_bound Prior_type       Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
            25.289048    10.000000    50.000000          0     0.000000    20.000000      7      0      0      0      0      0      0   0.3000 # Alpha_male_period_1
             0.090568    -0.400000    20.000000          0     0.000000    10.000000      7      0      0      0      0      0      0   0.3000 # Beta_male_period_1
             3.680868     0.010000     5.000000          0     0.000000     3.000000      7      0      0      0      0      0      0   0.3000 # Gscale_male_period_1
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1      Prior_2  Phase Reltve 
# Inputs for sex * type 2
# MAIN PARS: Initial  Lower_bound  Upper_bound Prior_type       Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           141.465594    65.000000   165.000000          0     0.000000   999.000000      7      0      0      0      0      0      0   0.3000 # Molt_probability_mu_male_period_1
             0.089803    -0.100000     2.000000          0     0.000000     2.000000      7      0      0      0      0      0      0   0.3000 # Molt_probability_CV_male_period_1
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1      Prior_2  Phase Reltve 


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
          0       0       0       0       0       0       0       0       0       0       0   0.3000       0

#     Initial     Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    0.22000000     0.00000000     0.50000000           0     0.00000000     0.20000000     -1 

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
# #  Pot_Fishery Trawl_Bycatch
 0 0 # is selectivity sex=specific? (1=Yes; 0=No)
 2 5 # male selectivity type
 0 0 # selectivity within another gear
 0 0 # male extra parameters for each pattern
 1 1 # male: is maximum selectivity at size forced to equal 1 (1) or not (0)
 0 0 # size-class at which selectivity is forced to equal 1 (ignored if the previous input is 1)
## Retention specifications --
 0 0 # is retention sex=specific? (1=Yes; 0=No)
 2 6 # male retention type
 1 0 # male retention flag (0 = no, 1 = yes)
 0 0 # male extra parameters for each pattern
 0 0 # male - should maximum retention be estimated for males (1=Yes; 0=No)

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
           121.266444   105.000000   180.000000          0   100.000000   190.000000      3      2      0      0      0      0      0   0.3000 # Sel_Pot_Fishery_male_period_1_par_1
            23.514311     0.010000    40.000000          0     0.100000    50.000000      3      2      0      0      0      0      0   0.3000 # Sel_Pot_Fishery_male_period_1_par_2
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1     Prior_2  Phase Reltve 
           136.628196   105.000000   180.000000          0     0.000000     0.000000      3      0 # Sel_Pot_Fishery_male_period_2_par_1
             8.215886     0.010000    20.000000          0     0.000000     0.000000      3      0 # Sel_Pot_Fishery_male_period_2_par_2

# Inputs for type*sex*fleet: retention male Pot_Fishery
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           136.471281   105.000000   180.000000          0   100.000000   190.000000      3      0      0      0      0      0      0   0.3000 # Ret_Pot_Fishery_male_period_1_par_1
             2.196854     0.000100    20.000000          0     0.100000    50.000000      3      0      0      0      0      0      0   0.3000 # Ret_Pot_Fishery_male_period_1_par_2


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
          0       1       1       0       0       0       0       0       0   0.3000 
# Catchability (parameters)
#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    0.00062564     0.00000010     0.01000000           0     0.00000000     1.00000000      1 
    0.00053595     0.00000010     0.01000000           0     0.00000000     1.00000000      1 
    0.00044673     0.00000010     0.01000000           0     0.00000000     1.00000000      1 

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
          0       0       0       0       0       0   0.3000 
## Mirror Block Env_L EnvL_Var  RW RW_blk Sigma_RW
# Additional variance (parameters)
#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    0.00019620     0.00000010     0.50000000           0     0.50000000   100.00000000      6 
    0.00022560     0.00000010     0.50000000           0     0.50000000   100.00000000      6 
    0.00024010     0.00000010     0.50000000           0     0.50000000   100.00000000      6 

## ==================================================================================== ##
## CONTROLS ON F                                                                        ##
## ==================================================================================== ##
## 
# Controls on F
#   Initial_male_F Initial_fema_F Pen_SD (early) Pen_SD (later) Phz_mean_F_mal Phz_mean_F_fem   Lower_mean_F   Upper_mean_F Low_ann_male_F  Up_ann_male_F    Low_ann_f_F     Up_ann_f_F
          0.366136       0.000000       3.000000      15.000000       2.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Pot_Fishery
          0.000218       0.000000       4.000000      15.000000       2.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Trawl_Bycatch

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

#  Pot_Fishery Pot_Fishery
#  male male
#  retained total
#  all_shell all_shell
#  immature+mature immature+mature
      1      1 # Type of likelihood
      0      0 # Auto tail compression (pmin)
 1.0000 1.0000 # Initial value for effective sample size multiplier
     -4     -4 # Phz for estimating effective sample size (if appl.)
      1      2 # Composition aggregator codes
      1      1 # Set to 1 for catch-based predictions; 2 for survey or total catch predictions
 0.7376 0.5281 # Lambda for effective sample size
 1.0000 1.0000 # Lambda for overall likelihood

## ==================================================================================== ##
## EMPHASIS FACTORS                                                                     ##
## ==================================================================================== ##

1.0000 # Emphasis on tagging data

 4.0000 2.0000 1.0000 # Emphasis on Catch: (by catch dataframes)

#AEP AEP AEP AEP
   0.0000   0.0000   0.0010   0.0000 # Pot_Fishery
   0.0000   0.0000   0.0010   0.0000 # Trawl_Bycatch
# 
## Emphasis Factors (Priors/Penalties: 13 values) ##
     0.0000	#--Log_fdevs
     0.0000	#--MeanF
     0.0000	#--Mdevs
     2.0000	#--Rec_devs
     0.0000	#--Initial_devs
     0.0000	#--Fst_dif_dev
     0.0000	#--Mean_sex_ratio
     0.0000	#--Molt_prob
     0.0000	#--free selectivity
     0.0000	#--Init_n_at_len
     1.0000	#--Fvecs
     0.0000	#--Fdovss
     1.0000	#--Random walk in selectivity

# eof_ctl
9999
