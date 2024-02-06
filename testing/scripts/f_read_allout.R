## read GMACSall.out file
## tyler jackson
## 2/5/2024
## args:
### file - file path to Gmacsall.out
## output - list object
## example - f_read_allout(file = "./AIGKC/models/2024/may/EAG/23.1b/Gmacsall.out")

f_read_allout <- function(file) {
  
  # setup ----
  # Suppress the NA message in the coercion to double
  options(warn = -1) 
  # load tidyverse
  if(!("tidyverse" %in% .packages())){
    library(tidyverse) 
  }
  
  # read text file
  allout <- read.delim(file, sep = "", header = F, col.names = c(1:1000), fill = T, na.strings = "", colClasses = "character")
  # create out object
  out <- list()
  
  # version ----
  out$version <- str_flatten(allout[1,], collapse = " ", na.rm = T)
  # stock ----
  out$stock <- gsub("#Stock being assessed: ", "", str_flatten(allout[2,], collapse = " ", na.rm = T))
  # general info ----
  ## years
  out$yr_range <- as.numeric(allout[grep("Year_range", allout[,1]), 2:3])
  out$mod_yrs <- out$yr_range[1]:out$yr_range[2]
  last <- grep("Year_range", allout[,1]) # start saving last position in file
  ## number of seasons
  out$n_season <- as.numeric(str_extract(str_flatten(allout[last + 1,], na.rm = T), "([[:digit:]]+)")); last <- last + 1
  ## number of fleets
  out$n_fleets <- as.numeric(str_extract(str_flatten(allout[last + 1,], na.rm = T), "([[:digit:]]+)")); last <- last + 1
  ## fleet names
  out$fleet_names <- as.character(allout[last + 1, 2:(out$n_fleets + 1)]); last <- last + 1
  ## n sexes
  out$n_sex <- as.numeric(str_extract(str_flatten(allout[last + 1,], na.rm = T), "([[:digit:]]+)")); last <- last + 1
  ## n shell conidition
  out$n_shell <- as.numeric(str_extract(str_flatten(allout[last + 1,], na.rm = T), "([[:digit:]]+)")); last <- last + 1 
  ## n maturity states
  out$n_maturity <- as.numeric(str_extract(str_flatten(allout[last + 1,], na.rm = T), "([[:digit:]]+)")); last <- last + 1 
  ## units 
  out$wt_units <-  gsub("Weightunitis:", "", str_flatten(allout[last + 1,], na.rm = T)); last <- last + 1 
  
  # likelihoods by type ----
  
  # read lines individually
  catch = as.numeric(na.omit(as.numeric(allout[last + 2,]))); last <- last + 2 
  index = as.numeric(na.omit(as.numeric(allout[last + 1,]))); last <- last + 1 
  size = as.numeric(na.omit(as.numeric(allout[last + 1,]))); last <- last + 1 
  recruitment = as.numeric(na.omit(as.numeric(allout[last + 1,]))); last <- last + 1
  tagging =  as.numeric(na.omit(as.numeric(allout[last + 1,]))); last <- last + 1
  penalties =  as.numeric(na.omit(as.numeric(allout[last + 1,]))); last <- last + 1
  priors = as.numeric(na.omit(as.numeric(allout[last + 1,]))); last <- last + 1
  initial_size = as.numeric(na.omit(as.numeric(allout[last + 1,]))); last <- last + 1
  total = as.numeric(na.omit(as.numeric(allout[last + 1,]))); last <- last + 1
  
  # coerce to tibble
  rbind(catch, index, size, recruitment, tagging) %>% as_tibble() %>%
    transmute(process = c("catch", "index", "size", "recruitment", "tagging"), raw_lik = V1, net_lik = V2) %>%
    add_row(process = "penalites", raw_lik = penalties, net_lik = penalties) %>%
    add_row(process = "priors", raw_lik = priors, net_lik = priors) %>%
    add_row(process = "initial_size", raw_lik = initial_size, net_lik = initial_size) %>%
    add_row(process = "total", raw_lik = sum(.$raw_lik), net_lik = total) -> out$likelihoods_by_type
  
  # likelihoods by type and fleet ---- 
  ## catches
  tibble(raw_lik = as.numeric(na.omit(as.numeric(allout[last + 3,]))),
         emphasis = as.numeric(na.omit(as.numeric(allout[last + 4,]))),
         net_lik = as.numeric(na.omit(as.numeric(allout[last + 5,])))) %>%
    transmute(process = paste0("catch_", 1:nrow(.)), raw_lik, emphasis, net_lik) -> catch; last <- last + 5
  ## index
  tibble(raw_lik = as.numeric(na.omit(as.numeric(allout[last + 2,]))),
         emphasis = as.numeric(na.omit(as.numeric(allout[last + 3,]))),
         net_lik = as.numeric(na.omit(as.numeric(allout[last + 4,])))) %>%
    transmute(process = paste0("index_", 1:nrow(.)), raw_lik, emphasis, net_lik) -> index; last <- last + 4    
  ## size composition
  tibble(raw_lik = as.numeric(na.omit(as.numeric(allout[last + 2,]))),
         emphasis = as.numeric(na.omit(as.numeric(allout[last + 3,]))),
         net_lik = as.numeric(na.omit(as.numeric(allout[last + 4,])))) %>%
    transmute(process = paste0("size_comp_", 1:nrow(.)), raw_lik, emphasis, net_lik) -> size; last <- last + 4    
  ## recruitment penalties
  tibble(raw_lik = as.numeric(na.omit(as.numeric(allout[last + 2,]))),
         net_lik = as.numeric(na.omit(as.numeric(allout[last + 2,])))) %>%
    transmute(process = paste0("rec_pen_", 1:nrow(.)), raw_lik, net_lik) -> rec_pen; last <- last + 2
  ## tagging
  tibble(raw_lik = as.numeric(na.omit(as.numeric(allout[last + 2,]))),
         emphasis = as.numeric(na.omit(as.numeric(allout[last + 3,]))),
         net_lik = as.numeric(na.omit(as.numeric(allout[last + 4,])))) %>%
    transmute(process = paste0("tagging_", 1:nrow(.)), raw_lik, emphasis, net_lik) -> tagging; last <- last + 4   
  ## growth 
  tibble(raw_lik = as.numeric(na.omit(as.numeric(allout[last + 2,]))),
         net_lik = as.numeric(na.omit(as.numeric(allout[last + 2,])))) %>%
    transmute(process = paste0("growth_", 1:nrow(.)), raw_lik, net_lik) -> growth; last <- last + 2
  bind_rows(catch, index, size, rec_pen, tagging, growth) -> out$likelihoods_by_type_and_fleet
  
  
  
  # penalties ----
  
  tmp <- matrix(nrow = 12, ncol = 3)
  for(i in 1:12) {tmp[i, 1:3] <- as.numeric(na.omit(as.numeric(allout[last + 1 + i,])[-1]))}
  row.names(tmp) <- c("Mean_Fbar = 0", "Mean_Fdev", "Mdevs", "Rec_ini", "Rec_dev", "Sex_ratio",
                      "Molt_prob", "Smooth_select", "Init_numbers", "Fdevs_(flt)", "Fdovs_(flt)",
                      "Seldevs")
  out$penalties <- tmp
  last <- last + 13
  
  # parameters ----
  
  ## par tibble
  tmp <- matrix(ncol = 10, nrow = length((last + 2):grep("#---", allout[,1])[1]))
  for(i in 1:nrow(tmp)) {
    if("*" %in% as.character(allout[last + 1 + i, 1:10])) {
      as.character(allout[last + 1 + i, 1:12]) %>%
        .[!is.na(.)] %>% .[. != "*"] -> tmp[i,]
    } else{as.character(allout[last + 1 + i, 1:10]) -> tmp[i,]}
  }
  as_tibble(tmp) %>%
    rename_all(~na.omit(as.character(allout[last + 1,]))) %>%
    janitor::clean_names() %>%
    mutate_at(c(1, 4:10), as.numeric) %>% 
    dplyr::select(-index) -> out$parameters; last <- grep("#---", allout[,1])[1]
  ## parameters at bounds
  out$parameters %>%
    mutate(range = upper_bound - lower_bound,
           status = ifelse(estimate < (lower_bound+range*0.01), 1,
                           ifelse(estimate > upper_bound-range*0.01, 1, 0))) %>%
    filter(status == 1) %>% dplyr::select(-range, -status) -> out$parameters_at_bounds
  
  # reference points ----
  
  ## ref tibble
  tmp <- matrix(ncol = 3, nrow = length((last + 2):(grep("#---", allout[,1])[2] - 2)))
  for(i in 1:nrow(tmp)) {
    tmp[i,] <- na.omit(as.numeric(allout[last + 1 + i,]))
  }
  as_tibble(tmp) %>%
    mutate(ref = c("Male_spr_bar", "Female_spr_bar", "SSSB/R_F=0", "BMSY", "Bcurr/BMSY", "OFL_tot",
                   paste0("Fmsy_", 1:out$n_fleets), paste0("Fofl_", 1:out$n_fleets), 
                   paste0("OFL_", 1:out$n_fleets))) %>%
    transmute(parameter_name = ref, estimate = V1, se = V2, est_quantity_count = V3) -> out$reference_points
  last <- grep("#---", allout[,1])[2] - 1
  ## ref sigma
  allout[last,] %>% dplyr::select_if(~ !any(is.na(.))) %>%
    mutate_all(., function(x){gsub(";", "", x)}) %>%
    .[1,] %>% as.numeric() %>%na.omit() %>% as.numeric() -> out$ref_sigmaR
  names(out$ref_sigmaR) <- c("sigmaR", "weight")
  last <- grep("#---", allout[,1])[2]
  # overall summary ----
  
  tmp <- matrix(ncol = 15 + (3*out$n_sex) + out$n_fleets, nrow = length(out$mod_yrs))
  for(i in 1:nrow(tmp)) {
    tmp[i,] <- as.numeric(allout[last+2+i,1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~make.unique(as.character(allout[last+2,1:ncol(tmp)]))) %>%
    janitor::clean_names(.) %>% rename(year = number_year, log_recruits_male = log_recruits, sd_log_recruits_male = sd_log_recruits) -> out$derived_quant_summary
  # do some renaming
  
  if(out$n_sex == 2) {
    out$derived_quant_summary %>%
      rename(log_recruits_female = log_recruits_1, sd_log_recruits_female = sd_log_recruits_1) -> out$derived_quant_summary
  }
  last <- grep("#---", allout[,1])[3]
  
  # mean wt ----
  
  ## add size bins
  out$size_bins <- as.numeric(na.omit(as.numeric(allout[last+2,])))
  ## weight at size matrix
  tmp <- matrix(nrow = out$n_sex*out$n_maturity*length(out$mod_yrs), ncol = length(out$size_bins)+3)
  for(i in 1:nrow(tmp)) {
    tmp[i,] <- as.character(allout[last+3,1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    mutate_at(2:ncol(.), as.numeric) %>%
    rename_all(~c("sex", "maturity", "year", paste0("lbin_", out$size_bins))) -> out$wt_at_size
  last <- last + 3 + nrow(tmp)
  
  # maturity vector ----
  
  out$maturity_at_size_vector <- as.numeric(allout[last+1,1:length(out$size_bins)]); last <- grep("#---", allout[,1])[4]
  
  # catch fit summary ----
  
  ## catch summary
  tmp <- matrix(nrow = length((last+3):(grep("#---", allout[,1])[5]-3)), ncol = 14)
  for(i in 1:nrow(tmp)){
    tmp[i,] <- as.character(allout[last+2+i,1:14])
  }
  as_tibble(tmp) %>%
    mutate_at(c(1:2, 4, 6:7, 10:14), as.numeric) %>%
    rename_all(~c("series", "year", "fleet", "season", "sex", "obs_catch", "cv", "type", "units", "mult", "effort", "disc_m", 
                  "pred_catch", "residual")) -> out$catch_fit_summary; last <- grep("#---", allout[,1])[5]-3
  ## catch q
  tibble(series = unique(out$catch_fit_summary$series),
         log_q = as.numeric(allout[last+2,1:length(unique(out$catch_fit_summary$series))])) -> out$log_q_catch; last <- grep("#---", allout[,1])[5]
  
  # index fix_summary ----
  
  ## index summary
  tmp <- matrix(nrow = length((last+3):(grep("sdnr_MAR_cpue", allout[,1])-2)), ncol = 13)
  for(i in 1:nrow(tmp)){
    tmp[i,] <- as.character(allout[last+2+i,1:13])
  }
  as_tibble(tmp) %>%
    mutate_at(c(1:2, 4, 7:9, 11:13), as.numeric) %>%
    rename_all(~c("series", "year", "fleet", "season", "sex", "maturity", "obs_index", "obs_cv", 
                  "tot_cv", "units", "q", "timing", "pred_index")) -> out$index_fit_summary; last <- last + nrow(tmp) + 2
  ## sdnr_MAR_cpue
  tmp <- matrix(nrow = length(unique(out$index_fit_summary$series)), ncol = 2)
  for(i in 1:nrow(tmp)) {
    tmp[i,] <- as.numeric(allout[last+3, 1:2])
  }
  out$sdnr_MAR_cpue <- tmp; last <- grep("#---", allout[,1])[6]
  
  # size composition fit summary ----
  ## size composition fit summary
  tmp <- matrix(ncol = 10 + (length(out$size_bins) * 2), nrow = length((last+3):(grep("sdnr_MAR_lf", allout[,1])-2)))
  for(i in 1:nrow(tmp)) {
    tmp[i,] <- as.character(allout[last+2+i, 1:(10+length(out$size_bins)*2)])
  }
  as_tibble(tmp) %>%
    dplyr::select(1:(10 + length(out$size_bins))) %>%
    rename_all(~c("org_series", "mod_series", "year", "fleet", "season", "sex", "type", "shell", "maturity", "nsamp", out$size_bins)) %>%
    pivot_longer(11:(10 + length(out$size_bins)), names_to = "size", values_to = "obs") %>%
    bind_cols(as_tibble(tmp) %>%
                dplyr::select(c(1:10, (ncol(tmp)-length(out$size_bins)+1):ncol(tmp))) %>% 
                rename_all(~c("org_series", "mod_series", "year", "fleet", "season", "sex", "type", "shell", "maturity", "nsamp", out$size_bins)) %>%
                pivot_longer(11:(10 + length(out$size_bins)), names_to = "size", values_to = "pred") %>% transmute(pred)) %>%
    mutate_at(c(1:3, 5, 10:13), as.numeric) %>%
    mutate(residual = obs - pred) -> out$size_fit_summary; last <- grep("sdnr_MAR_lf", allout[,1])
  ## sdnr_MAR_lf
  tmp <- matrix(ncol = 2, nrow = length(unique(out$size_fit_summary$org_series)))
  for(i in 1:nrow(tmp)) {
    tmp[i,] <- as.numeric(allout[last+i, 1:2])
  }
  out$sdnr_MAR_lf <- tmp
  last <- grep("Francis_weights", allout[,1])
  ## francis weights
  out$francis_weights <- as.numeric(allout[last+1, 1:length(unique(out$size_fit_summary$org_series))]); last <- grep("#---", allout[,1])[7]
  
  
  # selectivity ----
  
  ## selex
  tmp <- matrix(ncol = 3 + length(out$size_bins), nrow = length(out$mod_yrs) * out$n_sex * out$n_fleets)
  for(i in 1:nrow(tmp)) {
    tmp[i,] <- as.character(allout[last+3+i, 1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("year", "sex", "fleet", out$size_bins)) %>%
    pivot_longer(4:ncol(.), values_to = "capture", names_to = "size") %>%
    mutate_at(c(1, 4, 5), as.numeric) -> slx_cap; last <- last + 3 + nrow(tmp)
  ## retention
  tmp <- matrix(ncol = 3 + length(out$size_bins), nrow = length(out$mod_yrs) * out$n_sex * out$n_fleets)
  for(i in 1:nrow(tmp)) {
    tmp[i,] <- as.character(allout[last+2+i, 1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("year", "sex", "fleet", out$size_bins)) %>%
    pivot_longer(4:ncol(.), values_to = "retention", names_to = "size") %>%
    mutate_at(c(1, 4, 5), as.numeric) -> slx_ret; last <- last + 2 + nrow(tmp)
  ## discard
  tmp <- matrix(ncol = 3 + length(out$size_bins), nrow = length(out$mod_yrs) * out$n_sex * out$n_fleets)
  for(i in 1:nrow(tmp)) {
    tmp[i,] <- as.character(allout[last+2+i, 1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("year", "sex", "fleet", out$size_bins)) %>%
    pivot_longer(4:ncol(.), values_to = "discard", names_to = "size") %>%
    mutate_at(c(1, 4, 5), as.numeric) -> slx_disc; last <- grep("#---", allout[,1])[8]
  out$selectivity <- left_join(slx_cap, slx_ret, by = join_by(year, sex, fleet, size)) %>% 
    left_join(., slx_disc, by = join_by(year, sex, fleet, size))
  
  # mortality ----
  
  ## M by season
  tmp <- matrix(nrow = length(out$mod_yrs), ncol = 1 + out$n_season)
  for(i in 1:nrow(tmp)){
    tmp[i,] <- as.numeric(allout[last + 3 + i, 1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("year", paste0("season_", 1:out$n_season))) -> out$proportion_M_by_season; last <- last + nrow(tmp) + 4
  
  ## M by sex-maturity-size class
  tmp <- matrix(nrow = length(out$mod_yrs) * out$n_sex * out$n_maturity, ncol = 3 + length(out$size_bins))
  for(i in 1:nrow(tmp)){
    tmp[i,] <- as.character(allout[last+1+i, 1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("year", "sex", "maturity", out$size_bins)) %>%
    pivot_longer(4:ncol(.), names_to = "size", values_to = "M") %>%
    mutate_at(c(1, 3:5), as.numeric) -> out$M_by_class; last <- last + nrow(tmp) + 2
  
  ## fully selected F by season, sex, fleet
  tmp <- matrix(nrow = out$n_sex * out$n_fleets * length(out$mod_yrs), ncol = 3 + out$n_season)
  for(i in 1:nrow(tmp)){
    tmp[i,] <- as.character(allout[last+1+i, 1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("sex", "fleet", "year", 1:out$n_season)) %>%
    mutate_at(c(3:ncol(.)), as.numeric) %>%
    pivot_longer(4:ncol(.), names_to = "season", values_to = "F") -> out$F_by_sex_fleet_year_season;last <- last + nrow(tmp) + 2
  
  ## fully selected F by season, sex, fleet
  ## skip same as above
  last <- last + nrow(out$F_by_sex_fleet_year_season)/out$n_fleets + 2
  
  ## F by sex, year, season, size
  tmp <- matrix(nrow = out$n_sex * length(out$mod_yrs) * out$n_season, ncol = 3 + length(out$size_bins))
  for(i in 1:nrow(tmp)){
    tmp[i,] <- as.character(allout[last+1+i, 1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("sex", "year", "season", out$size_bins)) %>%
    pivot_longer(4:ncol(.), names_to = "size", values_to = "F_continuos") %>%
    mutate_at(2:ncol(.), as.numeric) -> cont; last <- last + nrow(tmp) + 2
  tmp <- matrix(nrow = out$n_sex * length(out$mod_yrs) * out$n_season, ncol = 3 + length(out$size_bins))
  for(i in 1:nrow(tmp)){
    tmp[i,] <- as.character(allout[last+1+i, 1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("sex", "year", "season", out$size_bins)) %>%
    pivot_longer(4:ncol(.), names_to = "size", values_to = "F_discrete") %>%
    mutate_at(2:ncol(.), as.numeric) -> disc; last <- last + nrow(tmp) + 2
  out$F_by_sex_maturity_year_season_size <- left_join(cont, disc, by = join_by(sex, year, season, size)); 
  
  ## Z by sex, year, maturity, season, size
  tmp <- matrix(nrow = out$n_sex * out$n_maturity * length(out$mod_yrs) * out$n_season, ncol = 4 + length(out$size_bins))
  for(i in 1:nrow(tmp)){
    tmp[i,] <- as.character(allout[last+1+i, 1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("sex", "maturity", "year", "season", out$size_bins)) %>%
    pivot_longer(5:ncol(.), names_to = "size", values_to = "Z_continuos") %>%
    mutate_at(2:ncol(.), as.numeric) -> cont; last <- last + nrow(tmp) + 2 
  for(i in 1:nrow(tmp)){
    tmp[i,] <- as.character(allout[last+1+i, 1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("sex", "maturity", "year", "season", out$size_bins)) %>%
    pivot_longer(5:ncol(.), names_to = "size", values_to = "Z_discrete") %>%
    mutate_at(2:ncol(.), as.numeric) -> disc; last <- grep("#---", allout[,1])[9]
  out$Z_by_sex_maturity_year_season_size <- left_join(cont, disc, by = join_by(sex, maturity, year, season, size))
  
  # n matrix ----
  
  nmats <- grep("#N(.)", apply(allout[(grep("#---", allout[,1])[9]+2):grep("#---", allout[,1])[10],], 1, str_flatten, na.rm = T), value = T)
  nmats_index <- as.numeric(names(nmats))
  
  list_tmp <- list()
  for(m in 1:length(nmats)) {
    tmp <- matrix(nrow = length(out$mod_yrs), ncol = 1 + length(out$size_bins))
    for(i in 1:nrow(tmp)) {
      tmp[i,] <- as.numeric(allout[nmats_index[m]+1+i, 1:ncol(tmp)])
    }
    as_tibble(tmp) %>% rename_all(~c("year", out$size_bins)) %>%
      mutate(type = gsub("[()]|#N", "", nmats[m])) -> list_tmp[[m]]
  }
  do.call("bind_rows", list_tmp) %>%
    pivot_longer(2:(ncol(.)-1), names_to = "size", values_to = "n") %>%
    pivot_wider(names_from = type, values_from = n) -> out$n_matrix; last <- grep("#---", allout[,1])[10]
  
  
  # growth ----
  
  ## molt probability
  tmp <- matrix(nrow = out$n_sex * length(out$mod_yrs), ncol = 2 + length(out$size_bins))
  for(i in 1:nrow(tmp)) {
    tmp[i,] <- as.character(allout[last+3+i,1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("sex", "year", out$size_bins)) %>%
    pivot_longer(3:ncol(.), names_to = "size", values_to = "molt_probability") %>%
    mutate_at(2:ncol(.), as.numeric) -> out$molt_probability; last <- last + 3 + nrow(tmp)
  
  ## growth transition matrix
  gmats <- grep("#growth_matrix", allout[,1]); last <- gmats[1]
  gmats_names <- lapply(apply(allout[gmats,], 1, str_flatten, na.rm = T), function(x){strsplit(x, ":")[[1]][2]}) %>% unlist
  list_tmp <- list()
  for(m in 1:length(gmats)) {
    tmp <- matrix(nrow = length(out$size_bins), ncol = length(out$size_bins))
    for(i in 1:nrow(tmp)) {
      tmp[i,] <- as.numeric(allout[gmats[m]+i, 1:ncol(tmp)])
    }
    row.names(tmp) <- out$size_bins; colnames(tmp) <- out$size_bins
    list_tmp[[m]] <- tmp
  }
  names(list_tmp) <- gmats_names
  out$growth_transition <- list_tmp
  
  ## size transition matrix
  smats <- grep("#size_matrix", allout[,1]); last <- gmats[1]
  smats_names <- lapply(apply(allout[smats,], 1, str_flatten, na.rm = T), function(x){strsplit(x, ":")[[1]][2]}) %>% unlist
  list_tmp <- list()
  for(m in 1:length(smats)) {
    tmp <- matrix(nrow = length(out$size_bins), ncol = length(out$size_bins))
    for(i in 1:nrow(tmp)) {
      tmp[i,] <- as.numeric(allout[smats[m]+i, 1:ncol(tmp)])
    }
    row.names(tmp) <- out$size_bins; colnames(tmp) <- out$size_bins
    list_tmp[[m]] <- tmp
  }
  names(list_tmp) <- smats_names
  out$size_transition <- list_tmp
  last <- grep("#---", allout[,1])[11]
  
  
  
  
  # reference points ----
  
  # combinations of seasons and fleets with Fs
  tmp <- matrix(nrow = out$n_season, ncol = out$n_fleets + 1)
  for(i in 1:nrow(tmp)){
    tmp[i,] <- as.numeric(allout[last+2+i, 1:ncol(tmp)])
  }
  as_tibble(tmp) %>%
    rename_all(~c("season", out$fleet_names)) -> out$seasons_fleets_w_F
  
  ##reference points and ofl
  out$spr_syr <- as.numeric(allout[grep("spr_syr", allout[,1])+1, 1])
  out$spr_nyr <- as.numeric(allout[grep("spr_nyr", allout[,1])+1, 1])
  out$spr_rbar <- as.numeric(allout[grep("spr_rbar", allout[,1])+1, 1:2])
  out$proj_rbar <- as.numeric(allout[grep("proj_rbar", allout[,1])+1, 1:2])
  out$spr_sexr <- as.numeric(allout[grep("spr_sexr", allout[,1])+1, 1])
  out$SR_alpha_prj <- as.numeric(allout[grep("SR_alpha_prj", allout[,1])+1, 1])
  out$SR_beta_prj <- as.numeric(allout[grep("SR_beta_prj", allout[,1])+1, 1])
  out$spr_fofl <- as.numeric(allout[grep("spr_fofl", allout[,1])+1, 1])
  out$spr_cofl_ret <- as.numeric(allout[grep("spr_cofl_ret", allout[,1])+1, 1])
  
  # simple likelihood stuff ----
  max(c(length(unique(out$catch_fit_summary$series)),
        length(unique(out$index_fit_summary$series)),
        length(unique(out$size_fit_summary$series)))) -> cols
  tmp <- matrix(nrow = 5, ncol = cols)
  for(i in 1:nrow(tmp)){
    tmp[i,] <- as.numeric(allout[grep("nloglike", allout[,1])+i, 1:ncol(tmp)])
  }
  out$nloglike <- tmp
  out$nlogPenalty <- as.numeric(na.omit(as.numeric(allout[grep("nlogPenalty", allout[,1])+1,])))
  out$priorDensity <- as.numeric(na.omit(as.numeric(allout[grep("priorDensity", allout[,1])+1,])))
  
  # output ----
  return(out)
  
  
  
  
}


