#--check model run results
require(gmr);
require(ggplot2)
#--source("~/Work/Programming/GMACS-project/gmr/R/GMACS_run_Utilities.R")

#--get directory for this file
dirThs = dirname(rstudioapi::getActiveDocumentContext()$path);

#--change working directory to dirThs
oldwd  =  setwd(dirThs);

# #===PULL gmacs DATA AND outputs
mod_names <- c("24_01")
ScenarioNames<-mod_names

#--specify model run folders
#----needs terminal backslash (?)<-not using file.path but paste?
.MODELDIR = file.path(dirThs, "../../ModelRuns/TannerCrab24_01");
dir.exists(.MODELDIR)


.THEME    = theme_bw(base_size = 12, base_family = "") +
  theme(strip.text.x = element_text(margin= margin(1,0,1,0)),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        strip.background = element_rect(color="white",fill="white"))

.OVERLAY  = TRUE

#==some of this repeats info in the .DAT file and should be read directly, rather than
#==repeated here (e.g. .FLEET and .SEAS)
.SEX      = c("Aggregate","Male","Female")
.FLEET    = c("TCF","SCF","RKF","GFT","GFF","GFT","NMFS")
.All_FLEET  = c("TCF","SCF","RKF","GFT","GFF","GFT","NMFS")
.TYPE     = c("Retained","Discarded","Total")
.SHELL    = c("New","Old")
.MATURITY = c("Aggregate","Mature","Immature")
.SEAS     = c("1","2","3")

#--read files from model run
fn       <- file.path(.MODELDIR, "gmacs")
M        <- lapply(fn, read_admb) #need .prj file to run gmacs and need .rep file here
names(M) <- mod_names

#--read input files
ctl = readGMACSctl(file.path(.MODELDIR,"TannerCrab_24_01.ctl"))

#--plot fit to survey cpue
mdf <- .get_cpue_df(M)
mdf <- dplyr::filter(mdf,fleet=="NMFS")

p = ggplot(data=mdf)+
      geom_pointrange(aes(year, cpue, ymax = ube, ymin = lbe) )+
      geom_line(aes(x=year,y=pred,col=Model,group=Model),lwd=2,alpha=0.8)+
      theme_bw()+facet_wrap(~sex,ncol=1,scales='free_y')+
      theme(legend.position=c(.99,.99),
            legend.justification=c(1,1))+
      ylab("Biomass (1,000 t)")
print(p);
print(p+scale_y_log10())

#--plot fit to catch data
mdf <- .get_catch_df(M)
mdf$type<-as.character(mdf$type)
#==SOMETHING WRONG HERE
mdf$type[which(mdf$type=="Retained")]<-"Total"
mdf$type[which(mdf$type=="Discarded")]<-"Retained"

p <- ggplot(mdf, aes(x = year, y = observed)) +
       geom_bar(stat = "identity", position = "dodge", alpha = 0.15,col='light grey') +
       geom_linerange(aes(ymax = ub, ymin = lb), position = position_dodge(0.5),
                      linewidth = 0.2, alpha = 0.5, col = "black") +
       geom_line(aes(x = as.integer(year), y = predicted,col=model), lwd=1.5,alpha=.8) +
       facet_wrap(~fleet + sex + type + units, scales = 'free_y')+
       .THEME +
       theme(legend.position=c(0.99,0.99),
             legend.justification=c(1,1)) +
       ylab("Biomass (1,000 t)");
print(p)

#--using gmr plotting functions
plot_cpue(M)              #--ok (but no axes lines)
plot_cpue_res(M)          #--ok
plot_catch(M)             #--got plots, but should be total, retained got discarded, retained (and labels switched)
plot_datarange(M)         #--got plot, but very odd (year starts at 0)
#plot_fishing_mortality(M) #--function is incomplete, needs to be finished
plot_F(M)                 #--ok
plot_size_comps(M)        #--ok
plot_growth(M)            #--error: needs to be revised
plot_growth_ridges(M)     #--corrected now, file renamed to plot-growth-ridges.R
plot_growth_inc(M)        #--corrected now for plotting w/out observations
dfr = .get_length_weight_df(M);
p = plot_length_weight(M)     #--corrected now for allometric relationship defined by coefficients
plot_molt_prob(M)         #--ok
plot_selectivity(M)       #--ok
plot_natural_mortality(
  M,plt_knots=FALSE)      #--corrected previous sawtooth pattern
dfr = .get_numbers_df(M)
plot_numbers(M)           #--meh! (it works, good for quick check)
plot_recruitment(M)       #--warning: Hessian not pos def (ran -nohess)
plot_recruitment_size(M)  #--ok
plot_models_recruitment(M,names(M)) #--doesn't work because lapply fails
plot_ssb(M) #--got error

#-------------------------------------------------------------------------------
#--read files from model run
res = gmr::readGMACSfiles("../run",verbose=TRUE);

#--read report, par, and cor files
res = gmr::read_admb("../run/gmacs")

M = list(test=res);
gmr::plot_datarange(M)
gmr::plot_catch(M)
gmr::plot_gmr(M,target_dir=".");
