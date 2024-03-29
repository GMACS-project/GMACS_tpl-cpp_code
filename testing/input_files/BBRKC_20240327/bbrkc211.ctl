## GMACS Version 2.11.05; ** AEP **; Compiled 2024-03-13

# Block structure
# Number of blocks
6
# Block structure
1 2 1 1 1 1 
# The blocks
1980 1984 
1983 1993 1994 2021 
1980 2021 
2005 2020 
1982 2022 
2005 2022 

# Extra controls
1975 # First year of recruitment estimation
2021 # Last year of recruitment estimation
   0 # Consider terminal molting (0 = off, 1 = on). If on, the calc_stock_recruitment_relationship() isn't called in the procedure
   2 # Phase for recruitment estimation
   2 # Phase for recruitment sex-ratio estimation
0.50 # Initial value for recruitment sex-ratio
   3 # Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters, 3 = Free parameters (revised))
1.00 # Lambda (proportion of mature male biomass for SPR reference points)
   0 # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)
   1 # Use years specified to computed average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)
 200 # Years to compute equilibria
   5 # Phase for deviation parameters

# Expecting 89 theta parameters
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
    16.50000000   -10.00000000    18.00000000    -2          0   -10.00000000    20.00000000
    19.50000000   -10.00000000    25.00000000     3          0    10.00000000    25.00000000
    16.50000000   -10.00000000    25.00000000     1          0    10.00000000    20.00000000
    72.50000000    55.00000000   100.00000000    -4          1    72.50000000     7.25000000
     0.72614900     0.32000000     1.64000000     3          0     0.10000000     5.00000000
     0.00000000    -5.00000000     5.00000000    -4          0     0.00000000    20.00000000
     0.00000000    -1.69000000     0.40000000     3          0     0.00000000    20.00000000
    -0.10536000   -10.00000000     0.75000000    -4          0   -10.00000000     0.75000000
     0.75000000     0.20000000     1.00000000    -2          3     3.00000000     2.00000000
     0.01000000     0.00000000     1.00000000    -3          3     1.01000000     1.01000000
     1.10796289   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.56322917   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.68192831   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.49105736   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.40791178   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.43651614   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.40612675   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.43614597   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.40494523   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.30401970   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.29737527   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.17468007   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.08452985   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.01074624   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -0.19046832   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -0.37631250   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -0.69916290   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -1.15881772   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -1.17311583   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
     0.42570420   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     2.26840859   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     1.81045137   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     1.37035725   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     1.15825809   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.59619678   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
     0.22575676   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -0.02478576   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -0.21404590   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -0.56053958   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -0.97421830   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -1.24580072   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -1.49292897   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -1.94135821   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -2.05101561   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
    -1.94956606   -10.00000000     4.00000000     9          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
  -100.00000000  -101.00000000     5.00000000    -2          0    10.00000000    20.00000000
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
 0.00022478 0.00028135 0.00034692 0.00042221 0.00050793 0.00060480 0.00071356 0.00083495 0.00096970 0.00111856 0.00128229 0.00146163 0.00165736 0.00187023 0.00210101 0.00235048 0.00261942 0.00290861 0.00321882 0.00390590
 0.00021510 0.00026898 0.00033137 0.00040294 0.00048437 0.00062711 0.00072160 0.00082452 0.00093615 0.00105678 0.00118669 0.00132613 0.00147539 0.00163473 0.00180441 0.00218315 0.00218315 0.00218315 0.00218315 0.00218310
# Proportion mature by sex and size
 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000
 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000
# Proportion legal by sex and size
 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000 1.00000000
 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000 0.00000000

## ==================================================================================== ##
## GROWTH PARAMETER CONTROLS                                                            ##
## ==================================================================================== ##
## 
# Maximum number of size-classes to which recruitment must occur
 7 5
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
        3      3      0 
        3      3      2 
# Molt probability
# Type: Options for the molt probability function
#  0: Pre-specified
#  1: Constant at 1
#  2: Logistic
#  3: Individual
#  Block: Block number for time-varying growth   
## Type Block
      2     3 
      1     0 

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
            16.500000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_1
            16.500000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_2
            16.400000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_3
            16.300000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_4
            16.300000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_5
            16.200000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_6
            16.200000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_7
            16.100000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_8
            16.100000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_9
            16.000000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_10
            16.000000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_11
            15.900000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_12
            15.800000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_13
            15.800000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_14
            15.700000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_15
            15.700000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_16
            15.600000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_17
            15.600000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_18
            15.500000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_19
            15.500000     0.000000    20.000000          0     0.000000   999.000000    -33      0      1      0      0      0      0   0.3000 # Molt_increment_male_period_1_class_20
             1.000000     0.500000     3.000000          0     0.000000   999.000000      6      0      1      0      0      0      0   0.3000 # Gscale_male_period_1
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1      Prior_2  Phase Reltve 
# Inputs for sex * type 2
# MAIN PARS: Initial  Lower_bound  Upper_bound Prior_type       Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
            13.800000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_1
            12.200000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_2
            10.500000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_3
             8.400000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_4
             7.500000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_5
             7.000000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_6
             6.600000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_7
             6.100000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_8
             5.600000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_9
             5.100000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_10
             4.600000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_11
             4.100000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_12
             3.600000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_13
             3.200000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_14
             2.700000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_15
             2.200000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_16
             1.700000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_17
             1.200000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_18
             0.700000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_19
             0.400000     0.000000    20.000000          0     0.000000   999.000000    -33      2      1      0      0      0      0   0.3000 # Molt_increment_female_period_1_class_20
             1.500000     0.500000     3.000000          0     0.000000   999.000000      6      0      1      0      0      0      0   0.3000 # Gscale_female_period_1
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1      Prior_2  Phase Reltve 
            15.400000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_1
            15.100000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_1
            13.800000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_2
            14.000000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_2
            12.200000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_3
            12.900000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_3
            10.500000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_4
            11.800000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_4
             8.900000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_5
            10.600000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_5
             7.900000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_6
             8.700000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_6
             7.200000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_7
             7.400000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_7
             6.600000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_8
             6.600000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_8
             6.100000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_9
             6.100000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_9
             5.600000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_10
             5.600000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_10
             5.100000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_11
             5.100000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_11
             4.600000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_12
             4.600000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_12
             4.100000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_13
             4.100000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_13
             3.600000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_14
             3.600000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_14
             3.200000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_15
             3.200000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_15
             2.700000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_16
             2.700000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_16
             2.200000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_17
             2.200000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_17
             1.700000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_18
             1.700000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_18
             1.200000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_19
             1.200000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_19
             0.700000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_2_class_20
             0.700000     0.000000    20.000000          0     0.000000   999.000000    -33      0 # Molt_increment_female_period_3_class_20
# Inputs for sex * type 3
# MAIN PARS: Initial  Lower_bound  Upper_bound Prior_type       Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           145.038600   100.000000   500.000000          0     0.000000   999.000000      3      3      0      0      0      0      0   0.3000 # Molt_probability_mu_male_period_1
             0.053036     0.020000     2.000000          0     0.000000   999.000000      3      3      0      0      0      0      0   0.3000 # Molt_probability_CV_male_period_1
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1      Prior_2  Phase Reltve 
           145.038600   100.000000   500.000000          0     0.000000   999.000000      3      0 # Molt_probability_mu_male_period_2
             0.053036     0.020000     2.000000          0     0.000000   999.000000      3      0 # Molt_probability_CV_male_period_2


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
          0       0       0       0       0       1       1       0       0       0       0   0.3000       0
          1       0       0       0       0       0       0       0       0       0       0   0.3000       1

#     Initial     Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    0.18000000     0.15000000     0.20000000           1     0.27100000     0.04000000     -4 
    1.73400000     0.00000000     2.00000000           0     0.00000000     2.00000000      4 
    0.00000000    -0.40000000     0.40000000           1     0.00000000     0.03000000      4 

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
# #  Pot_Fishery Trawl_Bycatch Bairdi_Fishery_Bycatch Fixed_Gear NMFS_Trawl BSFRF
 1 0 1 0 0 0 # is selectivity sex=specific? (1=Yes; 0=No)
 2 2 2 2 2 2 # male selectivity type
 2 2 2 2 2 2 # female selectivity type
 0 0 0 0 6 0 # selectivity within another gear
 0 0 0 0 0 0 # male extra parameters for each pattern
 0 0 0 0 0 0 # female extra parameters for each pattern
 1 1 1 1 1 1 # male: is maximum selectivity at size forced to equal 1 (1) or not (0)
 1 1 1 1 1 1 # female: is maximum selectivity at size forced to equal 1 (1) or not (0)
 20 20 20 20 20 20 # size-class at which selectivity is forced to equal 1 (ignored if the previous input is 1)
 20 20 20 20 20 20 # size-class at which selectivity is forced to equal 1 (ignored if the previous input is 1)
## Retention specifications --
 1 0 0 0 0 0 # is retention sex=specific? (1=Yes; 0=No)
 2 6 6 6 6 6 # male retention type
 6 6 6 6 6 6 # female retention type
 1 0 0 0 0 0 # male retention flag (0 = no, 1 = yes)
 0 0 0 0 0 0 # female retention flag (0 = no, 1 = yes)
 0 0 0 0 0 0 # male extra parameters for each pattern
 0 0 0 0 0 0 # female extra parameters for each pattern
 0 0 0 0 0 0 # male - should maximum retention be estimated for males (1=Yes; 0=No)
 0 0 0 0 0 0 # female - should maximum retention be estimated for females (1=Yes; 0=No)

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
           125.000000     5.000000   190.000000          0     1.000000   999.000000      4      0      0      0      0      0      0   0.3000 # Sel_Pot_Fishery_male_period_1_par_1
             8.000000     0.100000    20.000000          0     1.000000   999.000000      4      0      0      0      0      0      0   0.3000 # Sel_Pot_Fishery_male_period_1_par_2

# Inputs for type*sex*fleet: selectivity male Trawl_Bycatch
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           165.000000     5.000000   190.000000          0     1.000000   999.000000      4      0      0      0      0      0      0   0.3000 # Sel_Trawl_Bycatch_male_period_1_par_1
            15.000000     0.100000    25.000000          0     1.000000   999.000000      4      0      0      0      0      0      0   0.3000 # Sel_Trawl_Bycatch_male_period_1_par_2

# Inputs for type*sex*fleet: selectivity male Bairdi_Fishery_Bycatch
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           103.275000     5.000000   190.000000          1   103.275000    30.980000      4      0      0      0      0      0      0   0.3000 # Sel_Bairdi_Fishery_Bycatch_male_period_1_par_1
             8.834000     0.100000    25.000000          1     8.834000     2.650000      4      0      0      0      0      0      0   0.3000 # Sel_Bairdi_Fishery_Bycatch_male_period_1_par_2

# Inputs for type*sex*fleet: selectivity male Fixed_Gear
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           115.000000     5.000000   190.000000          0     1.000000   999.000000      4      0      0      0      0      0      0   0.3000 # Sel_Fixed_Gear_male_period_1_par_1
             9.000000     0.100000    25.000000          0     1.000000   999.000000      4      0      0      0      0      0      0   0.3000 # Sel_Fixed_Gear_male_period_1_par_2

# Inputs for type*sex*fleet: selectivity male NMFS_Trawl
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
            75.000000    30.000000   190.000000          0     1.000000   999.000000      4      5      1      0      0      0      0   0.3000 # Sel_NMFS_Trawl_male_period_1_par_1
             5.000000     1.000000    50.000000          0     1.000000   999.000000      4      5      1      0      0      0      0   0.3000 # Sel_NMFS_Trawl_male_period_1_par_2
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1     Prior_2  Phase Reltve 
            80.000000    30.000000   190.000000          0     0.000000     0.000000      4      0 # Sel_NMFS_Trawl_male_period_2_par_1
            10.000000     1.000000    50.000000          0     0.000000     0.000000      4      0 # Sel_NMFS_Trawl_male_period_2_par_2

# Inputs for type*sex*fleet: selectivity male BSFRF
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
            75.000000     1.000000   180.000000          0     1.000000   999.000000      4      0      0      0      0      0      0   0.3000 # Sel_BSFRF_male_period_1_par_1
             8.500000     1.000000    50.000000          0     1.000000   999.000000      4      0      0      0      0      0      0   0.3000 # Sel_BSFRF_male_period_1_par_2

# Inputs for type*sex*fleet: selectivity female Pot_Fishery
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
            84.000000     5.000000   150.000000          0     1.000000   999.000000      4      0      0      0      0      0      0   0.3000 # Sel_Pot_Fishery_female_period_1_par_1
             4.000000     0.100000    20.000000          0     1.000000   999.000000      4      0      0      0      0      0      0   0.3000 # Sel_Pot_Fishery_female_period_1_par_2

# Inputs for type*sex*fleet: selectivity female Bairdi_Fishery_Bycatch
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
            91.178000     5.000000   190.000000          1    91.178000    27.350000      4      0      0      0      0      0      0   0.3000 # Sel_Bairdi_Fishery_Bycatch_female_period_1_par_1
             2.500000     0.100000    25.000000          1     2.500000     0.750000      4      0      0      0      0      0      0   0.3000 # Sel_Bairdi_Fishery_Bycatch_female_period_1_par_2

# Inputs for type*sex*fleet: retention male Pot_Fishery
# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma
           135.000000     1.000000   999.000000          0     1.000000   999.000000      4      6      1      0      0      0      0   0.3000 # Ret_Pot_Fishery_male_period_1_par_1
             2.000000     1.000000    20.000000          0     1.000000   999.000000      4      6      1      0      0      0      0   0.3000 # Ret_Pot_Fishery_male_period_1_par_2
# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1     Prior_2  Phase Reltve 
           140.000000     1.000000   999.000000          0     0.000000     0.000000      4      0 # Ret_Pot_Fishery_male_period_2_par_1
             2.500000     1.000000    20.000000          0     0.000000     0.000000      4      0 # Ret_Pot_Fishery_male_period_2_par_2


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
    0.89600000     0.00000000     2.00000000           1     0.89600000     0.03000000      6 
    1.00000000     0.00000000     5.00000000           0     0.00100000     5.00000000     -6 

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
    0.00010000     0.00001000    10.00000000           4     1.00000000   100.00000000     -4 
    0.25000000     0.00001000    10.00000000           0     0.00100000     1.00000000     10 

## ==================================================================================== ##
## CONTROLS ON F                                                                        ##
## ==================================================================================== ##
## 
# Controls on F
#   Initial_male_F Initial_fema_F Pen_SD (early) Pen_SD (later) Phz_mean_F_mal Phz_mean_F_fem   Lower_mean_F   Upper_mean_F Low_ann_male_F  Up_ann_male_F    Low_ann_f_F     Up_ann_f_F
          0.223130       0.050500       0.500000      45.500000       1.000000       1.000000     -12.000000       4.000000     -10.000000       2.950000     -10.000000      10.000000  # Pot_Fishery
          0.018316       1.000000       0.500000      45.500000       1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Trawl_Bycatch
          0.011109       1.000000       0.500000      45.500000       1.000000       1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Bairdi_Fishery_Bycatch
          0.011109       1.000000       0.500000      45.500000       1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # Fixed_Gear
          0.000000       0.000000       2.000000      20.000000      -1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # NMFS_Trawl
          0.000000       0.000000       2.000000      20.000000      -1.000000      -1.000000     -12.000000       4.000000     -10.000000      10.000000     -10.000000      10.000000  # BSFRF

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

#  Pot_Fishery Pot_Fishery Pot_Fishery Trawl_Bycatch Trawl_Bycatch Pot_Fishery Pot_Fishery Fixed_Gear Fixed_Gear NMFS_Trawl NMFS_Trawl BSFRF BSFRF
#  male male female male female male female male female male female male female
#  retained total total total total total total total total total total total total
#  all_shell all_shell all_shell all_shell all_shell all_shell all_shell all_shell all_shell all_shell all_shell all_shell all_shell
#  immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature immature+mature
      2      2      2      2      2      2      2      2      2      2      2      2      2 # Type of likelihood
      0      0      0      0      0      0      0      0      0      0      0      0      0 # Auto tail compression (pmin)
 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 # Initial value for effective sample size multiplier
     -4     -4     -4     -4     -4     -4     -4     -4     -4     -4     -4     -4     -4 # Phz for estimating effective sample size (if appl.)
      1      2      3      4      4      5      5      6      6      7      7      8      8 # Composition aggregator codes
      1      1      1      1      1      1      1      1      1      2      2      2      2 # Set to 1 for catch-based predictions; 2 for survey or total catch predictions
 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 # Lambda for effective sample size
 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 # Lambda for overall likelihood

## ==================================================================================== ##
## EMPHASIS FACTORS                                                                     ##
## ==================================================================================== ##

1.0000 # Emphasis on tagging data

 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000 # Emphasis on Catch: (by catch dataframes)

#AEP AEP AEP AEP
   1.0000   1.0000   0.0000   0.0000 # Pot_Fishery
   1.0000   1.0000   0.0000   0.0000 # Trawl_Bycatch
   1.0000   1.0000   0.0000   0.0000 # Bairdi_Fishery_Bycatch
   1.0000   1.0000   0.0000   0.0000 # Fixed_Gear
   1.0000   1.0000   0.0000   0.0000 # NMFS_Trawl
   1.0000   1.0000   0.0000   0.0000 # BSFRF
# 
## Emphasis Factors (Priors/Penalties: 13 values) ##
 10000.0000	#--Log_fdevs
     0.0000	#--MeanF
     1.0000	#--Mdevs
     2.0000	#--Rec_devs
     0.0000	#--Initial_devs
     0.0000	#--Fst_dif_dev
    10.0000	#--Mean_sex_ratio
     0.0000	#--Molt_prob
     0.0000	#--free selectivity
     0.0000	#--Init_n_at_len
     0.0000	#--Fvecs
     0.0000	#--Fdovss
     0.0000	#--Random walk in selectivity

# eof_ctl
9999
