### control file for base model 23.0a , fall 2023 estimate base M for males - updates to gmacs v2.20.16##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## LEADING PARAMETER CONTROLS                                                           ##
##     Controls for leading parameter vector (theta)                                    ##
## LEGEND                                                                               ##
##     prior: 0 = uniform, 1 = normal, 2 = lognormal, 3 = beta, 4 = gamma               ##
## ———————————————————————————————————————————————————————————————————————————————————— ##

# Blocks to be used in the model (block 0 is the year range)
6
# Number of blocks per group (after the first block, i.e. 1 means two blocks)
1 2 1 1 1 1
# Block definitions  (first block always start with syr; year 0 is last year)
1980 1984  #1985 previous b/c start of new block
1983 1993 1994 2022
1980 2022
2005 2020 #????
1982 2023     # 5
2005 2023     # 6  

## ———————————————————————————————————————————————————————————————————————————————————— ##
## GENERAL CONTROLS
## ———————————————————————————————————————————————————————————————————————————————————— ##
1975       # First rec_dev
2022       # last rec_dev
   0       # Terminal molting (0 = off, 1 = on). If on, the calc_stock_recruitment_relationship() isn't called in the procedure
   2       # Estimated rec_dev phase
   2       # Estimated sex_ratio
 0.5       # initial sex-ratio
   3       # Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters, 3 = Free parameters (revised))
   1  # 4       # Reference size-class for initial conditons = 3 k.p think this should be 1 for bbrkc
   1       # Lambda (proportion of mature male biomass for SPR reference points).
   0       # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)
   1       # Use years specified to computed average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)
   200     # Year to compute equilibria             !!!NEW 1/2022
   5       # Devpar phase (!!)
 1940      # First year of bias-correction
 1950      # First full bias-correction
 2050      # Last full bias-correction
 2051      # Last year of bias-correction

## ———————————————————————————————————————————————————————————————————————————————————— ##
## ival        lb        ub        phz   prior     p1      p2         # parameter       ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
   16.5       -10        18         -2       0  -10.0    20.0         # logR0
   19.5       -10        25          3       0   10.0    25.0         # logRini, to estimate if NOT initialized at unfished (n68)
   16.5       -10        25          1       0   10.0    20.0   #1      # logRbar, to estimate if NOT initialized at unfished      #1
   72.5        55       100         -4       1   72.5     7.25        # recruitment expected value (males or combined)
    0.726149   0.32      1.64        3       0    0.1     5.0         # recruitment scale (variance component) (males or combined)
    0.00       -5         5         -4       0   0.0     20.00        # recruitment expected value (females)
    0.00       -1.69      0.40       3       0    0.0    20.0         # recruitment scale (variance component) (females)
   -0.10536     -10         0.75      -4       0  -10.0     0.75        # ln(sigma_R)
   #-0.10        -5         5.0       4       0   -10.0     10.0        # ln(sigma_R)
    0.75        0.20      1.00      -2       3    3.0     2.00        # steepness
    0.01        0.00      1.00      -3       3    1.01    1.01        # recruitment autocorrelation
#   0.00      -10         4          2       0   10.0    20.00        # Deviation for size-class 1 (normalization class)
    1.107962885630      -10         4          9       0   10.0    20.00        # Deviation for size-class 2
    0.563229168219      -10         4          9       0   10.0    20.00        # Deviation for size-class 3
    0.681928313426      -10         4          9       0   10.0    20.00        # Deviation for size-class 4
    0.491057364532      -10         4          9       0   10.0    20.00        # Deviation for size-class 5
    0.407911777560      -10         4          9       0   10.0    20.00        # Deviation for size-class 6
    0.436516142684      -10         4          9       0   10.0    20.00        # Deviation for size-class 7
    0.40612675395550    -10         4          9       0   10.0    20.00        # Deviation for size-class 8
    0.436145974880      -10         4          9       0   10.0    20.00        # Deviation for size-class 9
    0.40494522852708     -10         4         9        0   10.0    20.00        # Deviation for size-class 10
    0.30401970466854     -10         4         9        0   10.0    20.00        # Deviation for size-class 11
    0.2973752673022     -10         4          9       0   10.0    20.00        # Deviation for size-class 12
    0.1746800712364   -10         4          9       0   10.0    20.00        # Deviation for size-class 13
    0.0845298456942     -10         4          9       0   10.0    20.00        # Deviation for size-class 14
    0.0107462399193     -10         4          9       0   10.0    20.00        # Deviation for size-class 15
    -0.190468322904     -10         4          9       0   10.0    20.00        # Deviation for size-class 16
    -0.376312503735     -10         4          9       0   10.0    20.00        # Deviation for size-class 17
    -0.699162895473     -10         4          9       0   10.0    20.00        # Deviation for size-class 18
    -1.15881771530      -10         4          9       0   10.0    20.00        # Deviation for size-class 19
    -1.17311583316      -10         4          9       0   10.0    20.00        # Deviation for size-class 20
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 1
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 2
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 3
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 4
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 5
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 6
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 7
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 8
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 9
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 10
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 11
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 12
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 13
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 14
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 15
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 16
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 17
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 18
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 19
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 20
    0.425704202053      -10         4          9       0   10.0    20.00        # Deviation for size-class 1
    2.268408592660      -10         4          9       0   10.0    20.00        # Deviation for size-class 2
    1.810451373080      -10         4          9       0   10.0    20.00        # Deviation for size-class 3
    1.37035725111       -10         4          9       0   10.0    20.00        # Deviation for size-class 4
    1.158258087990      -10         4          9       0   10.0    20.00        # Deviation for size-class 5
    0.596196784439      -10         4          9       0   10.0    20.00        # Deviation for size-class 6
    0.225756761257      -10         4          9       0   10.0    20.00        # Deviation for size-class 7
    -0.0247857565368    -10         4          9       0   10.0    20.00        # Deviation for size-class 8
    -0.214045895269     -10         4          9       0   10.0    20.00        # Deviation for size-class 9
    -0.560539577780     -10         4          9       0   10.0    20.00        # Deviation for size-class 10
    -0.974218300021     -10         4          9       0   10.0    20.00        # Deviation for size-class 11
    -1.24580072031      -10         4          9       0   10.0    20.00        # Deviation for size-class 12
    -1.49292897450      -10         4          9       0   10.0    20.00        # Deviation for size-class 13
    -1.94135821253      -10         4          9       0   10.0    20.00        # Deviation for size-class 14
    -2.05101560679      -10         4          9       0   10.0    20.00        # Deviation for size-class 15
    -1.94956606430      -10         4          9       0   10.0    20.00        # Deviation for size-class 16
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 17
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 18
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 19
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 20
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 1
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 2
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 3
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 4
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 5
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 6
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 7
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 8
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 9
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 10
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 11
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 12
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 13
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 14
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 15
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 16
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 17
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 18
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 19
 -100.00      -101         5         -2       0   10.0    20.00        # Deviation for size-class 20


#	weight-at-length input	method	(1 = allometry	[w_l = a*l^b],	2 = vector by sex)																												
2																																										
##	Males																																									
0.000224781	0.000281351	0.000346923	0.000422209	0.000507927	0.000604802	0.000713564	0.00083495	0.0009697	0.00111856	0.00128229	0.00146163	0.00165736	0.00187023	0.00210101	0.00235048	0.00261942	0.00290861	0.00321882	0.0039059
##	Females																																									
0.0002151	0.00026898	0.00033137	0.00040294	0.00048437	0.00062711	0.0007216	0.00082452	0.00093615	0.00105678	0.00118669	0.00132613	0.00147539	0.00163473	0.00180441	0.00218315	0.00218315	0.00218315	0.00218315	0.0021831
# Proportion mature by sex
0 0	0 0	0 0	0 0	0 0	0 1	1 1	1 1	1 1	1 1
0 0	0 0	0 1	1 1	1 1	1 1	1 1	1 1	1 1	1 1
# Proportion legal by sex
0 0	0 0	0 0	0 0	0 0	0 1	1 1	1 1	1 1	1 1
0 0 0 0 0 0 0 0 0 0 0 0	0 0	0 0	0 0	0 0

## ———————————————————————————————————————————————————————————————————————————————————— ##

## ———————————————————————————————————————————————————————————————————————————————————— ##
## GROWTH PARAMETER CONTROLS                                                            ##
##     Two lines for each parameter if split sex, one line if not                       ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## ==================================================================================== ##
7 5 # Maximum size-class for recruitment(males then females)
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
       3     3       0    # Growth-transition Males
       3     3       2    # Growth-transition Females
# Molt probability
# Options for the molt probability function
# 0: Pre-specified
# 1: Constant at 1
# 2: Logistic
# 3: Individual
## Type Block
      2     3  # Molt probability Males
      1     0  # Molt probability Females; mature

# General parameter specificiations 
#  Relative: 0: absolute; 1 relative 
#  Block: Block number for time-varying growth   
#  Block_fn: 0:absolute values; 1:exponential
#  Env_L: Environmental link - options are 1:additive; 2:multiplicative; 3:exponential
#  EnvL_var: Environmental variable
#  RW: 0 for not random walk changes; 1 otherwise
#  RW_blk: Block number for random walks


# Inputs for sex * type 1
# MAIN PARS: Initial Lower_bound Upper_bound Prior_type Prior_1 Prior_2 Phase Block Block_fn Env_L EnvL_var RW RW_Block RW_SIgma
16.5    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
16.5    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
16.4    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
16.3    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
16.3    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
16.2    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
16.2    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
16.1    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
16.1    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
16.0    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
16.0    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
15.9    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
15.8    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
15.8    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
15.7    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
15.7    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
15.6    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
15.6    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
15.5    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
15.5    0   20  0   0   999 -33 0   1   0   0   0   0   0.3 # Males
1       0.5 3   0   0   999   6 0   1   0   0   0   0   0.3 # Males (beta)
# EXTRA PARS: Initial Lower_bound Upper_bound Prior_type Prior_1 Prior_2 Phase Relative 
# Inputs for sex * type 2
# MAIN PARS: Initial Lower_bound Upper_bound Prior_type Prior_1 Prior_2 Phase Block Block_fn Env_L EnvL_var RW RW_Block RW_Sigma
13.8  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
12.2  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
10.5  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
8.4  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
7.5  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
7    0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
6.6  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
6.1  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
5.6  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
5.1  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
4.6  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
4.1  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
3.6  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
3.2  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
2.7  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
2.2  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
1.7  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
1.2  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
0.7  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
0.4  0   20  0   0   999 -33 2   1   0   0   0   0   0.3 # Females
1.5  0.5 3   0   0   999 6   0   1   0   0   0   0   0.3 # Females
# EXTRA PARS: Initial Lower_bound Upper_bound Prior_type Prior_1 Prior_2 Phase Relative 
15.4    0   20  0   0   999 -33 0   # Females   1   1
15.1    0   20  0   0   999 -33 0   # Females   1   2
13.8    0   20  0   0   999 -33 0   # Females   2   1
14  0   20  0   0   999 -33 0   # Females   2   2
12.2    0   20  0   0   999 -33 0   # Females   3   1
12.9    0   20  0   0   999 -33 0   # Females   3   2
10.5    0   20  0   0   999 -33 0   # Females   4   1
11.8    0   20  0   0   999 -33 0   # Females   4   2
8.9 0   20  0   0   999 -33 0   # Females   5   1
10.6    0   20  0   0   999 -33 0   # Females   5   2
7.9 0   20  0   0   999 -33 0   # Females   6   1
8.7 0   20  0   0   999 -33 0   # Females   6   2
7.2 0   20  0   0   999 -33 0   # Females   7   1
7.4 0   20  0   0   999 -33 0   # Females   7   2
6.6 0   20  0   0   999 -33 0   # Females   8   1
6.6 0   20  0   0   999 -33 0   # Females   8   2
6.1 0   20  0   0   999 -33 0   # Females   9   1
6.1 0   20  0   0   999 -33 0   # Females   9   2
5.6 0   20  0   0   999 -33 0   # Females   10  1
5.6 0   20  0   0   999 -33 0   # Females   10  2
5.1 0   20  0   0   999 -33 0   # Females   11  1
5.1 0   20  0   0   999 -33 0   # Females   11  2
4.6 0   20  0   0   999 -33 0   # Females   12  1
4.6 0   20  0   0   999 -33 0   # Females   12  2
4.1 0   20  0   0   999 -33 0   # Females   13  1
4.1 0   20  0   0   999 -33 0   # Females   13  2
3.6 0   20  0   0   999 -33 0   # Females   14  1
3.6 0   20  0   0   999 -33 0   # Females   14  2
3.2 0   20  0   0   999 -33 0   # Females   15  1
3.2 0   20  0   0   999 -33 0   # Females   15  2
2.7 0   20  0   0   999 -33 0   # Females   16  1
2.7 0   20  0   0   999 -33 0   # Females   16  2
2.2 0   20  0   0   999 -33 0   # Females   17  1
2.2 0   20  0   0   999 -33 0   # Females   17  2
1.7 0   20  0   0   999 -33 0   # Females   18  1
1.7 0   20  0   0   999 -33 0   # Females   18  2
1.2 0   20  0   0   999 -33 0   # Females   19  1
1.2 0   20  0   0   999 -33 0   # Females   19  2
0.7 0   20  0   0   999 -33 0   # Females   20  1
0.7 0   20  0   0   999 -33 0   # Females   20  2
# Inputs for sex * type 3
# MAIN PARS: Initial Lower_bound Upper_bound Prior_type Prior_1 Prior_2 Phase Block Block_fn Env_L EnvL_var RW RW_Block RW_Sigma
145.0386    100   500   0   0   999 3   3   0   0   0   0   0   0.3 # molt_mu male
0.053036    0.02    2   0   0   999 3   3   0   0   0   0   0   0.3 # molt_cv males 
# EXTRA PARS: Initial Lower_bound Upper_bound Prior_type Prior_1 Prior_2 Phase Relative 
145.0386    100   500   0   0   999 3   0   # molt_mu males         
0.053036    0.02    2   0   0   999 3   0   # molt_cv males         
## ——————————————————————————————————————————————————————————————————————————————————— ##

# The custom growth-increment matrix

# custom molt probability matrix

## ==================================================================================== ##
## NATURAL MORTALITY RATES                                                              ##
## ==================================================================================== ##
# Relative: 0 - absolute values; 1+ - based on another M-at-size vector (indexed by ig)
# Type: 0 for standard; 1: Spline
# Brkpnts: number of changes in M by size
# Mirror: Mirror M-at-size over to that for another partition (indexed by ig)
# Block: Block number for time-varying M-at-size
# Block_fn: 0:absolute values; 1:exponential
# Env_L: Environmental link - options are 1:additive; 2:multiplicative; 3:exponential
# EnvL_var: Environmental variable
# RW: 0 for not random walk changes; 1 otherwise
# RW_blk: Block number for random walks
# Sigma_RW: Sigma for the random walk parameters
# Mirror_RW: Should time-varying aspects be mirrows (Indexed by ig)
## Relative? Type Extra SizeBrkpts Mirror  Block Block_fn Env_L EnvL_Var  RW RW_blk Sigma_RW Mirror_RW
           0    0     0          0      0      1        1     0        0   0      0      0.3         0  # Males; mature
           1    0     0          0      0      0        0     0        0   0      0      0.3         1  # Females; mature

## Size breakpoints 
#2 3
##          
## ival      lb       ub     prior     p1       p2       phz      
   0.180   0.15      0.4        2   0.18       0.04        4                    # Males (Mature)
   1.734   0.00      2.0        0   0.000      2.00        8                    # Block 1 - change to 8 from 4?
   0.000  -0.40     0.40        1   0.000      0.03        4                    # Females (Mature)
   

## ———————————————————————————————————————————————————————————————————————————————————— ##
## SELECTIVITY CONTROLS                                                                 ##
##     Selectivity P(capture of all sizes). Each gear must have a selectivity and a     ##
##     retention selectivity. If a uniform prior is selected for a parameter then the   ##
##     lb and ub are used (p1 and p2 are ignored)                                       ##
## LEGEND                                                                               ##
##     sel type: 0 = parametric, 1 = coefficients (NIY), 2 = logistic, 3 = logistic95,  ##
##               4 = double normal (NIY)                                                ##
##     gear index: use +ve for selectivity, -ve for retention                           ##
##     sex dep: 0 for sex-independent, 1 for sex-dependent                              ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## Gear-1   Gear-2   Gear-3   Gear-4   Gear-5   Gear-6
## PotFshry TrawlByc TCFshry  FixedGr  NMFS     BSFRF
   1        0        1        0        0        0         # sex specific selectivity
   2        2        2        2        2        2         # male selectivity type
   2        2        2        2        2        2         # female selectivity type
   0        0        0        0        6        0         # within another gear
   0        0        0        0        0        0         #-NEW: extra parameters for each pattern by fleet, males
   0        0        0        0        0        0         #-NEW: extra parameters for each pattern by fleet, females
   1        1        1        1        1        1         # determines if maximum selectivity at size is forced to equal 1 or not (males)
   1        1        1        1        1        1         # determines if maximum selectivity at size is forced to equal 1 or not (females)
  20       20       20       20       20       20         # size-class at which selectivity is 1 males
  20       20       20       20       20       20         # size-class at which selectivity is 1 females
## Gear-1   Gear-2   Gear-3   Gear-4   Gear-5   Gear-6
   1        0        0        0        0        0         # sex specific retention
   2        6        6        6        6        6         # male   retention type
   6        6        6        6        6        6         # female retention type
   1        0        0        0        0        0         # male   retention flag (0 = no, 1 = yes)
   0        0        0        0        0        0         # female retention flag (0 = no, 1 = yes)
   0        0        0        0        0        0         #-NEW: extra parameters for each pattern by fleet, males
   0        0        0        0        0        0         #-NEW: extra parameters for each pattern by fleet, females
   0        0        0        0        0        0         # estimate asymtotic retention (males)
   0        0        0        0        0        0         # estimate asymtotic retention (females)

# MAIN PARS: Initial Lower_bound Upper_bound Prior_type Prior_1 Prior_2 Phase Block Block_fn Env_L EnvL_var RW RW_Block 
# Selectivity
# Gear-1; males
#   125 5   190 0   1   999 4   0   0   1   1   0   4   0.3
#   8   0.1 20  0   1   999 4   0   0   0   0   1   4   0.3
#   0.1 -1  1   0   1   999 -4  0                       
    125 5   190 0   1   999 4   0   0   0   0   0   0   0.3
    8   0.1 20  0   1   999 4   0   0   0   0   0   0   0.3
    
# Gear-2; males
    165 5   190 0   1   999 4   0   0   0   0   0   0   0.3
    15  0.1 25  0   1   999 4   0   0   0   0   0   0   0.3
# Gear-3; males
    103.275 5   190 1   103.275 30.98   4   0   0   0   0   0   0   0.3
    8.834   0.1 25  1   8.834   2.65    4   0   0   0   0   0   0   0.3
# Gear-4; males
    115 5   190 0   1   999 4   0   0   0   0   0   0   0.3
    9   0.1 25  0   1   999 4   0   0   0   0   0   0   0.3
# Gear-5; males
    75  30  190 0   1   999 4   5   1   0   0   0   0   0.3
    5   1   50  0   1   999 4   5   1   0   0   0   0   0.3
# Gear-5; males block
    80  30  190 0   1   999 4   0                       
    10  1   50  0   1   999 4   0                       
# Gear-6; males
    75  1   180 0   1   999 4   0   0   0   0   0   0   0.3
    8.5 1   50  0   1   999 4   0   0   0   0   0   0   0.3
# Gear-1; females
    84  5   150 0   1   999 4   0   0   0   0   0   0   0.3
    4   0.1 20  0   1   999 4   0   0   0   0   0   0   0.3
# Gear-3; females
    91.178  5   190 1   91.178  27.35   4   0   0   0   0   0   0   0.3                     
    2.5 0.1 25  1   2.5 0.75    4   0   0   0   0   0   0   0.3                     
# Retained 
# Gear-1; males
    135 1   999 0   1   999 4   6   1   0   0   0   0   0.3
    2   1   20  0   1   999 4   6   1   0   0   0   0   0.3
#1  0.001   1.01    0   1   999 4   0   0   0   0   0   0   0.3                 
# Gear-1; males block
    140 1   999 0   1   999 4   0                       
    2.5 1   20  0   1   999 4   0                       




## ———————————————————————————————————————————————————————————————————————————————————— ##
## PRIORS FOR CATCHABILITY
##     If a uniform prior is selected for a parameter then the lb and ub are used (p1   ##
##     and p2 are ignored). ival must be > 0                                            ##
## LEGEND                                                                               ##
##     prior: 0 = uniform, 1 = normal, 2 = lognormal, 3 = beta, 4 = gamma               ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## Analytic? LAMBDA Emphasis Mirror Block Env_L EnvL_Var  RW RW_blk Sigma_RW
           0      1        1      0     0     0        0   0      0       0.3          # NMFS
           0      1        1      0     0     0        0   0      0       0.3          # BSFRF
           
## ival     lb       ub    prior        p1        p2     phz
   0.896     0        2        1      0.896     0.03       6   # NMFS
   1.0       0        5        0      0.001     5.00      -6   # BSFRF
## ———————————————————————————————————————————————————————————————————————————————————— ##

## ———————————————————————————————————————————————————————————————————————————————————— ##
## ADDITIONAL CV FOR SURVEYS/INDICES                                                    ##
##     If a uniform prior is selected for a parameter then the lb and ub are used (p1   ##
##     and p2 are ignored). ival must be > 0                                            ##
## LEGEND                                                                               ##
##     prior type: 0 = uniform, 1 = normal, 2 = lognormal, 3 = beta, 4 = gamma          ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
## Mirror Block Env_L EnvL_Var  RW RW_blk Sigma_RW
        0     0     0        0   0      0      0.3  # NMFS
        0     0     0        0   0      0      0.3  # BSFRF

## ival        lb        ub       prior       p1      p2    phz
   0.0001      0.00001   10.0         4    1.000     100     -4  # NMFS
   0.25      0.00001     10.0         0    0.001    1.00     10  # BSFRF
## ———————————————————————————————————————————————————————————————————————————————————— ##
## PENALTIES FOR AVERAGE FISHING MORTALITY RATE FOR EACH GEAR
## ———————————————————————————————————————————————————————————————————————————————————— ##
## Mean_F   Female Offset STD_PHZ1   STD_PHZ2   PHZ_M   PHZ_F
   0.22313        0.0505      0.5      45.50      1       1     -12      4    -10   2.95     -10    10  # Pot
   0.0183156         1.0      0.5      45.50      1      -1     -12      4    -10     10     -10    10   # Trawl
   0.011109           1.0      0.5      45.50      1       1     -12      4    -10     10     -10    10   # Tanner (-1 -5)
   0.011109           1.0      0.5      45.50      1      -1     -12      4    -10     10     -10    10   # Fixed
   0.00               0.0     2.00      20.00     -1      -1     -12      4    -10     10     -10    10   # NMFS trawl survey (0 catch)
   0.00               0.0     2.00      20.00     -1      -1     -12      4    -10     10     -10    10   # BSFRF (0)
## ———————————————————————————————————————————————————————————————————————————————————— ##

## ———————————————————————————————————————————————————————————————————————————————————— ##
## OPTIONS FOR SIZE COMPOSTION DATA                                                     ##
##     One column for each data matrix                                                  ##
## LEGEND                                                                               ##
##     Likelihood: 1 = Multinomial with estimated/fixed sample size                     ##
##                 2 = Robust approximation to multinomial                              ##
##                 3 = logistic normal (NIY)                                            ##
##                 4 = multivariate-t (NIY)                                             ##
##                 5 = Dirichlet       
##                 6 = Dirichlet (Thorson et al. 2016)                                  ##
## AUTO TAIL COMPRESSION                                                                ##
##     pmin is the cumulative proportion used in tail compression                       ##
## ———————————————————————————————————————————————————————————————————————————————————— ##
#  Pot         Trawl   Tanner  Fixed   NMFS    BSFRF
   2   2   2   2   2   2   2   2   2   2   2   2  2   # Type of likelihood
   0   0   0   0   0   0   0   0   0   0   0   0  0   # Auto tail compression ??? added 2024 ? maybe on/off switch
   0   0   0   0   0   0   0   0   0   0   0   0  0   # Auto tail compression (pmin)
#   1   1   1   1   1   1   1   1   1   1   1   1  1   # Initial value for effective sample size multiplier
#  -4  -4  -4  -4  -4  -4  -4  -4  -4  -4  -4  -4 -4   # Phz for estimating effective sample size (if appl.)
   1   2   3   4   4   5   5   6   6   7   7   8  8   # Composition splicer
   1   1   1   1   1   1   1   1   1   2   2   2  2   # Set to 2 for survey-like predictions; 1 for catch-like predictions !!!NEW 1/2022
   1   1   1   1   1   1   1   1   1   1   1   1  1   # LAMBDA for effective sample size
   1   1   1   1   1   1   1   1   1   1   1   1  1   # Emphasis AEP / LAMBDA for overall likelihood
   0   0   0   0   0   0   0   0   0   0   0   0  0   # Survey to set Q for this comp, 0 keeps this "as is" ask Buck
## ———————————————————————————————————————————————————————————————————————————————————— ##


#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
#    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
#    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
#    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
#    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 
#    1.00000000     0.10000000     5.00000000           0     0.00000000   999.00000000     -4 


## ———————————————————————————————————————————————————————————————————————————————————— ##
##  ?????????????????????????????????????????? ##
##  TAGGING controls  CONTROLS                      !!!NEW 1/2022
##  ?????????????????????????????????????????? ##
1          # emphasis on tagging data
## ———————————————————————————————————————————————————————————————————————————————————— ##  
                                
## ——————————————————————————————————————————————————————————————————————————————————————————— ##                                                                                   
## EMPHASIS FACTORS (CATCH)
## ———————————————————————————————————————————————————————————————————————————————————— ##
#Ret_male Disc_male Disc_female Disc_trawl Disc_Tanner_male Disc_Tanner_female Disc_fixed
        1         1           1          1                1                  1          1
#     500       100         100         50              100                100         50
## EMPHASIS FACTORS (Priors) by fleet: fdev_total, Fdov_total, Fdev_year, Fdov_year   !!!NEW 1/2022
1 1 0 0 # Pot fishery
1 1 0 0 # Trawl   by-catch
1 1 0 0 # Tanner  by-catch
1 1 0 0 # Fixed  by-catch
1 1 0 0 # Trawl survey
1 1 0 0 # BSFRF survey

## ———————————————————————————————————————————————————————————————————————————————————— ##
## EMPHASIS FACTORS (Priors)
## ———————————————————————————————————————————————————————————————————————————————————— ##
# Log_fdevs   meanF       Mdevs  Rec_devs Initial_devs Fst_dif_dev Mean_sex-Ratio Molt_prob Free selectivity Init_n_at_len   Fvecs Fdovs (!!!NEW for the last two 1/2022)
#      10000       0        1.0         2            0           0             10       0     0      0       0       0
10000       # Log_fdevs
0           # meanF 
1.0         # Mdevs
2           # Rec_devs 
0           # Initial_devs
0           # Fst_dif_dev
10          # Mean_sex-Ratio
0           # Molt_prob
0           # Free selectivity
0           # Init_n_at_len
0           # Fdevs
0           # Fdovs
0           # Sel_devs

## EOF
9999
