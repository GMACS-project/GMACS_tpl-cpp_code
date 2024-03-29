## GMACS Version 2.11.05; ** AEP **; Compiled 2024-03-13

# Block structure
# Number of blocks
1
# Block structure
1 
# The blocks
2008 2025 

# Extra controls
   0 # First year of recruitment estimation
2023 # Last year of recruitment estimation
   0 # Consider terminal molting (0 = off, 1 = on). If on, the calc_stock_recruitment_relationship() isn't called in the procedure
   2 # Phase for recruitment estimation
  -2 # Phase for recruitment sex-ratio estimation
0.50 # Initial value for recruitment sex-ratio
   3 # Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters, 3 = Free parameters (revised))
1.00 # Lambda (proportion of mature male biomass for SPR reference points)
   0 # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)
   0 # Use years specified to computed average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)
 200 # Years to compute equilibria
   5 # Phase for deviation parameters

# Expecting 23 theta parameters
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
     7.00000000   -10.00000000    20.00000000    -1          0   -10.00000000    20.00000000
     9.11100000   -10.00000000    20.00000000     1          0   -10.00000000    20.00000000
     8.00000000   -10.00000000    20.00000000     1          0   -10.00000000    20.00000000
    72.50000000    65.00000000   130.00000000     3          1    72.50000000     7.25000000
     0.75000000     0.30000000     1.60000000     3          0     0.10000000     5.00000000
    -0.10000000   -10.00000000     0.75000000    -2          0   -10.00000000     0.75000000
     0.75000000     0.20000000     1.00000000    -4          3     3.00000000     2.00000000
     0.00100000     0.00000000     1.00000000    -3          3     1.01000000     1.01000000
     0.64670000   -10.00000000     5.00000000     2          0    10.00000000    20.00000000
     1.00340000   -10.00000000     5.00000000     2          0    10.00000000    20.00000000
     1.36040000   -10.00000000     5.00000000     2          0    10.00000000    20.00000000
     1.40420000   -10.00000000     5.00000000     2          0    10.00000000    20.00000000
     1.45990000   -10.00000000     5.00000000     2          0    10.00000000    20.00000000
     1.26570000   -10.00000000     5.00000000     2          0    10.00000000    20.00000000
     0.72280000   -10.00000000     5.00000000     2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
# lw_type
2
 0.52420370 0.82067430 1.19824500 1.70175900 2.32125400 2.99365100 3.68849500 4.37139500
# Proportion mature by sex and size
 0.00000000 0.00000000 0.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000
# Proportion legal by sex and size
 0.00000000 0.00000000 0.00000000 0.00000000 1.00000000 1.00000000 1.00000000 1.00000000

## ==================================================================================== ##
## GROWTH PARAMETER CONTROLS                                                            ##
## ==================================================================================== ##
## 
# Maximum number of size-classes to which recruitment must occur
 3
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
            36.998620     0.000000   200.000000          0     0.000000    20.000000      2      0      0      0      0      0      0   0.3000 # Alpha_male_period_1
             0.243015    -0.200000    20.000000          0     0.000000    10.000000      2      0      0      0      0      0      0   0.3000 # Beta_male_period_1
             3.773156     2.000000    10.000000          0     0.000000     3.000000      5      0      0      0      0      0      0   0.3000 # Gscale_male_period_1
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1      Prior_2  Phase Reltve 
# Inputs for sex * type 2
# MAIN PARS: Initial  Lower_bound  Upper_bound Prior_type       Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           122.965900    50.000000   200.000000          0     0.000000   170.000000      2      0      0      0      0      0      0   0.3000 # Molt_probability_mu_male_period_1
             0.127616     0.000000     1.000000          0     0.000000     3.000000      2      0      0      0      0      0      0   0.3000 # Molt_probability_CV_male_period_1
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
          0       0       0       1       0       0       1       0       0       0       0   0.3000       0
# MaxMbreaks
7  # sex*maturity state: male & 1

#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    0.18000000     0.00000000     0.20000000           0     0.00000000     0.20000000     -1 
    0.50000000     0.05000000     0.54000000           1     0.00000000     0.25000000      3 

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
# #  Winter_Com Subsistence Summer_Com NMFS_Trawl ADFG_Trawl NBS_Trawl Winter_Pot
 0 0 0 0 0 0 0 # is selectivity sex=specific? (1=Yes; 0=No)
 8 -1 10 10 -4 -4 -1 # male selectivity type
 0 0 0 0 0 0 0 # selectivity within another gear
 3 0 0 0 0 0 0 # male extra parameters for each pattern
 0 0 1 1 1 1 1 # male: is maximum selectivity at size forced to equal 1 (1) or not (0)
 0 0 0 0 0 0 0 # size-class at which selectivity is forced to equal 1 (ignored if the previous input is 1)
## Retention specifications --
 0 0 0 0 0 0 0 # is retention sex=specific? (1=Yes; 0=No)
 2 0 2 6 6 6 6 # male retention type
 1 1 1 0 0 0 0 # male retention flag (0 = no, 1 = yes)
 0 0 0 0 0 0 0 # male extra parameters for each pattern
 0 0 0 0 0 0 0 # male - should maximum retention be estimated for males (1=Yes; 0=No)

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

# Inputs for type*sex*fleet: selectivity male Winter_Com
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           128.894800    40.000000   200.000000          0    10.000000   200.000000      2      0      0      0      0      0      0   0.3000 # Sel_Winter_Com_male_period_1_par_1
             0.154697     0.010000    20.000000          0     0.100000   100.000000      2      0      0      0      0      0      0   0.3000 # Sel_Winter_Com_male_period_1_par_2
             0.045586     0.000010     0.999990          0     0.100000   100.000000      2      0      0      0      0      0      0   0.3000 # Sel_Winter_Com_male_period_1_par_3
             0.375288     0.000010     0.999990          0     0.100000   100.000000      2      0      0      0      0      0      0   0.3000 # Sel_Winter_Com_male_period_1_par_4
             0.733787     0.000010     0.999990          0     0.100000   100.000000      2      0      0      0      0      0      0   0.3000 # Sel_Winter_Com_male_period_1_par_5

# Inputs for type*sex*fleet: selectivity male Summer_Com
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
             0.143640     0.000010    20.000000          0     0.100000   100.000000      2      0      0      0      0      0      0   0.3000 # Sel_Summer_Com_male_period_1_par_1

# Inputs for type*sex*fleet: selectivity male NMFS_Trawl
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
             0.092094     0.000010    20.000000          0     0.100000   100.000000      2      0      0      0      0      0      0   0.3000 # Sel_NMFS_Trawl_male_period_1_par_1

# Inputs for type*sex*fleet: retention male Winter_Com
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           104.765500    50.000000   200.000000          0     1.000000   900.000000      2      0      0      0      0      0      0   0.3000 # Ret_Winter_Com_male_period_1_par_1
             2.523162     0.001000    20.000000          0     1.000000   900.000000      2      0      0      0      0      0      0   0.3000 # Ret_Winter_Com_male_period_1_par_2

# Inputs for type*sex*fleet: retention male Subsistence
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
             0.000001     0.000000     1.000000          0     1.000000   900.000000     -2      0      0      0      0      0      0   0.3000 # Ret_Subsistence_male_period_1_par_1
             0.000001     0.000000     1.000000          0     1.000000   900.000000     -2      0      0      0      0      0      0   0.3000 # Ret_Subsistence_male_period_1_par_2
             0.000001     0.000000     1.000000          0     1.000000   900.000000     -2      0      0      0      0      0      0   0.3000 # Ret_Subsistence_male_period_1_par_3
             0.999999     0.000000     1.000000          0     1.000000   900.000000     -2      0      0      0      0      0      0   0.3000 # Ret_Subsistence_male_period_1_par_4
             0.999999     0.000000     1.000000          0     1.000000   900.000000     -2      0      0      0      0      0      0   0.3000 # Ret_Subsistence_male_period_1_par_5
             0.999999     0.000000     1.000000          0     1.000000   900.000000     -2      0      0      0      0      0      0   0.3000 # Ret_Subsistence_male_period_1_par_6
             0.999999     0.000000     1.000000          0     1.000000   900.000000     -2      0      0      0      0      0      0   0.3000 # Ret_Subsistence_male_period_1_par_7
             0.999999     0.000000     1.000000          0     1.000000   900.000000     -2      0      0      0      0      0      0   0.3000 # Ret_Subsistence_male_period_1_par_8

# Inputs for type*sex*fleet: retention male Summer_Com
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           104.310600    50.000000   700.000000          0     1.000000   900.000000      2      1      0      0      0      0      0   0.3000 # Ret_Summer_Com_male_period_1_par_1
             2.421736     1.000000    20.000000          0     1.000000   900.000000      2      1      0      0      0      0      0   0.3000 # Ret_Summer_Com_male_period_1_par_2
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1     Prior_2  Phase Reltve 
           105.150900    50.000000   700.000000          0     0.100000   100.000000      2      0 # Ret_Summer_Com_male_period_2_par_1
             1.648215     1.000000    20.000000          0     0.100000   100.000000      2      0 # Ret_Summer_Com_male_period_2_par_2


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
          0       1       1       0       0       0       0       0       0   0.3000 
          0       1       1       0       0       0       0       0       0   0.3000 
          0       1       1       0       0       0       0       0       0   0.3000 
# Catchability (parameters)
#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    0.77700000     0.10000000     2.00000000           0     0.10000000     1.00000000      2 
    1.00000000     0.10000000     2.00000000           0     0.10000000     1.00000000     -2 
    0.77700000     0.10000000     2.00000000           0     0.10000000     1.00000000      2 
    0.00150000     0.00000000     2.00000000           0     0.00000000     1.00000000      1 
    0.00150000     0.00000000     2.00000000           0     0.00000000     1.00000000      1 
    0.00150000     0.00000000     2.00000000           0     0.00000000     1.00000000      1 

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
          0       0       0       0       0       0   0.3000 
          4       0       0       0       0       0   0.3000 
          4       0       0       0       0       0   0.3000 
## Mirror Block Env_L EnvL_Var  RW RW_blk Sigma_RW
# Additional variance (parameters)
#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    0.00010000     0.00000001     2.00000000           0     1.00000000   100.00000000     -4 
    0.00010000     0.00000001     2.00000000           0     1.00000000   100.00000000     -4 
    0.00010000     0.00000001     2.00000000           0     1.00000000   100.00000000     -4 
    0.10000000     0.00000001     2.00000000           0     1.00000000   100.00000000      4 
    0.00010000     0.00000001     2.00000000           0     1.00000000   100.00000000     -4 
    0.00010000     0.00000001     2.00000000           0     1.00000000   100.00000000     -4 

## ==================================================================================== ##
## CONTROLS ON F                                                                        ##
## ==================================================================================== ##
## 
# Controls on F
#   Initial_male_F Initial_fema_F Pen_SD (early) Pen_SD (later) Phz_mean_F_mal Phz_mean_F_fem   Lower_mean_F   Upper_mean_F Low_ann_male_F  Up_ann_male_F    Low_ann_f_F     Up_ann_f_F
          0.020000       0.000000       0.500000      45.500000       1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Winter_Com
          0.020000       0.000000       0.500000      45.500000       1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Subsistence
          0.120000       0.000000       0.500000      45.500000       1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Summer_Com
          0.000000       0.000000       2.000000      20.000000      -1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # NMFS_Trawl
          0.000000       0.000000       2.000000      20.000000      -1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # ADFG_Trawl
          0.000000       0.000000       2.000000      20.000000      -1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # NBS_Trawl
          0.000000       0.000000       2.000000      20.000000      -1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Winter_Pot

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

#  Winter_Com Winter_Com Summer_Com Summer_Com Summer_Com Summer_Com Summer_Com Summer_Com NMFS_Trawl NMFS_Trawl ADFG_Trawl ADFG_Trawl NBS_Trawl NBS_Trawl Winter_Pot Winter_Pot
#  male male male male male male male male male male male male male male male male
#  retained retained retained retained discard discard total total total total total total total total total total
#  newshell oldshell newshell oldshell newshell oldshell newshell oldshell newshell oldshell newshell oldshell newshell oldshell newshell oldshell
#  immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature
      1      1      1      1      1      1      1      1      1      1      1      1      1      1      1      1 # Type of likelihood
      0      0      0      0      0      0      0      0      0      0      0      0      0      0      0      0 # Auto tail compression (pmin)
 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 # Initial value for effective sample size multiplier
     -4     -4     -4     -4     -4     -4     -4     -4     -4     -4     -4     -4     -4     -4     -4     -4 # Phz for estimating effective sample size (if appl.)
      1      1      2      2      3      3      4      4      5      5      6      6      7      7      8      8 # Composition aggregator codes
      1      1      1      1      1      1      1      1      2      2      2      2      2      2      2      2 # Set to 1 for catch-based predictions; 2 for survey or total catch predictions
 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 # Lambda for effective sample size
 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 # Lambda for overall likelihood

## ==================================================================================== ##
## EMPHASIS FACTORS                                                                     ##
## ==================================================================================== ##

1.0000 # Emphasis on tagging data

 1.0000 1.0000 0.0000 1.0000 # Emphasis on Catch: (by catch dataframes)

#AEP AEP AEP AEP
   1.0000   0.0000   0.0000   0.0000 # Winter_Com
   0.1000   0.0000   0.0000   0.0000 # Subsistence
   1.0000   0.0000   0.0000   0.0000 # Summer_Com
   0.0000   0.0000   0.0000   0.0000 # NMFS_Trawl
   0.0000   0.0000   0.0000   0.0000 # ADFG_Trawl
   0.0000   0.0000   0.0000   0.0000 # NBS_Trawl
   0.0000   0.0000   0.0000   0.0000 # Winter_Pot
# 
## Emphasis Factors (Priors/Penalties: 13 values) ##
     1.0000	#--Log_fdevs
     0.0000	#--MeanF
     0.0000	#--Mdevs
     1.0000	#--Rec_devs
    15.0000	#--Initial_devs
     1.0000	#--Fst_dif_dev
     3.0000	#--Mean_sex_ratio
    60.0000	#--Molt_prob
     0.1000	#--free selectivity
     1.0000	#--Init_n_at_len
     0.0000	#--Fvecs
     0.0000	#--Fdovss
     1.0000	#--Random walk in selectivity

# eof_ctl
9999
