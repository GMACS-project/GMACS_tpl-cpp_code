// ==================================================================================== //
//  Gmacs: A generalized size-structured stock assessment modeling framework.
//
//  Authors: gmacs development team at the
//           Alaska Fisheries Science Centre, Seattle
//           and the University of Washington.
//
//  Info: https://github.com/seacode/gmacs Copyright (C) 2014-2019. All rights reserved.
//
//  ACKNOWLEDGEMENTS:
//     finacial support provided by NOAA and Bering Sea Fisheries Research Foundation.
//
//  INDEXES:
//    g/ig = group
//    h = sex
//    i = year
//    j = time step (years)
//    k = gear or fleet
//    l = index for length class
//    m = index for maturity state
//    o = index for shell condition.
//
//  OUTPUT FILES:
//    gmacs.rep  Main result file for reading into R etc
//    gmacs.std  Result file for reading into R etc
//    gmacsall.out Result file for all all sorts of purposes.
//
//  FOR DEBUGGING INPUT FILES: (for accessing easily with read_admb() function)
//    gmacs_files_in.dat  Which control and data files were specified for the current run
//    gmacs_in.ctl        Code-generated copy of control file content (useful for checking read)
//    gmacs_in.dat        Code-generated copy of data file content (useful for checking read)
//    gmacs_in.prj        Code-generated copy of projection file content (useful for checking read)
//
//  TO ECHO INPUT
//    checkfile.rep       All of data read in
//
//  COMMANDLINE OPTIONS
//    The following specify using an ascii pin file fnPin to set parameter values, 
//    and set usepinfile=1 regardless of the value in gmacs.dat. Pinfile usage can 
//    also be turned "on" in the gmacs.dat file (in which case the commandline options 
//    are only usful for specifying a non-default pinfile name). 
//    If fnPin not given, then fnPin = "gmacs.pin" (the ADMB default).
//    -pin fnPin          
//    -ainp fnPin
//    -apin fnPin
// ==================================================================================== //


// ************************************************************************************ //
// Developers
// ************************************************************************************ //
// AEP: Andre E. Punt
// CS:  Cody Szuwalski
// JI:  Jim Ianelli
// WTS: William T. Stockhausen
// AW:  Athol Whitten
// DW:  Darcey Webber  
// MV:  Matthieu Veron
// TJ:  Tyler Jackson
// ************************************************************************************ //

// Submodels labeling
// ************************************************************************************ //
// Label 130: Projection inputs
// Label 200: INITIALIZATION_SECTION
// Label 400: calc_objective_function
// Label 401: catch_likelihood
// Label 402: index_likelihhod
// Label 403: length_likelihood
// Label 404: recruitment_likelihood
// Label 405: growth_likelihood
// Label 500: calc_spr_reference_points2
// Label 501: calc_brute_equilibrium
// Label 502: project_biomass_OFL
// Label 503: calc_predicted_project
// Label 504: project_biomass
// Label 505: compute_OFL_and_ABC
// Label 506: project_one_year
// Label 600: CreateOutput
// Label 700: write_eval
// ************************************************************************************ //
DATA_SECTION

 !! TheHeader = adstring("## GMACS Version 2.20.16; ** AEP & WTS **; Compiled 2024-07-23");

//-------------------------------
// Sandbox for testing functions |
//-------------------------------

 LOCAL_CALCS
  {
    //
    //@brief command line option for sandbox.
    //
    int on = 0; int opt;//defined for local scope only here
    int testingflag = 0;
    if ( (on=option_match(ad_comm::argc,ad_comm::argv,"-testing",opt))>-1 )
    {
    testingflag = 1;
    }
    if (testingflag==1){
    //Testing alternative dat file reader
    cout<<"|---------------------------------------|"<<endl;
    cout<<"| Testing with alternative dat file     |"<<endl;
    cout<<"|---------------------------------------|"<<endl;
    //cifstream is("TannerCrab_NewDatFile.dat",ios::in);
    //DatFileReader* pDFR = new DatFileReader();
    //is>>(*pDFR);
    //is.close();
    //cout<<(*pDFR)<<endl;
    exit(1);
    }
    if (0){
       //Testing selectivity using "constant" values
      cout<<"|---------------------------------------|"<<endl;
      cout<<"| Testing sandbox using constant values |"<<endl;
      cout<<"|---------------------------------------|"<<endl;
      class gsm::Selex<dvector> *pSLX;
      dvector z(1,32);
      for (int i=z.indexmin();i<=z.indexmax();i++) z(i) = 27.5+(i-1)*5.0;
      cout<<"--Cubic Spline"<<endl;
      dvector x_knts(1,5);
      x_knts[1]=z[1]; for (int i=1;i<=4;i++) x_knts[i+1] = z[8*i];
      dvector y_vals = 1.0/(1.0+exp(-(x_knts-100.0)/30.0));
      cout<<"x_knts = "<<x_knts<<endl;
      cout<<"y_vals = "<<y_vals<<endl;
      pSLX = new class gsm::SelectivitySpline<dvector,dvector>(y_vals,x_knts);
      cout<<"z        = "<<x_knts<<endl;
      cout<<"sel      = "<<pSLX->Selectivity(x_knts)<<endl;
      cout<<"z        = "<<z<<endl;
      cout<<"sel      = "<<pSLX->Selectivity(z)<<endl;
      cout<<"logsel   = "<<pSLX->logSelectivity(z)<<endl;
      cout<<"logselM1 = "<<pSLX->logSelexMeanOne(z)<<endl;
      cout<<"--change knots and y_vals to check reallocation"<<endl;
      dvector x_knts1(1,9);
      x_knts1[1]=z[1]; for (int i=1;i<=8;i++) x_knts1[i+1] = z[4*i];
      dvector y_vals1 = 1.0/(1.0+exp(-(x_knts1-100.0)/30.0));
      ((gsm::SelectivitySpline<dvector,dvector>*)pSLX)->initSpline(y_vals1,x_knts1);
      cout<<"z        = "<<x_knts1<<endl;
      cout<<"sel      = "<<pSLX->Selectivity(x_knts1)<<endl;
      cout<<"z        = "<<z<<endl;
      cout<<"sel      = "<<pSLX->Selectivity(z)<<endl;
      cout<<"logsel   = "<<pSLX->logSelectivity(z)<<endl;
      cout<<"logselM1 = "<<pSLX->logSelexMeanOne(z)<<endl;
      //exit(1);
      cout<<"--DoubleNormal"<<endl;
      double p1 = 30.0;
      double p2 = 100.0;
      double p3 = 50.0;
      pSLX = new class gsm::DoubleNormal<dvector,double>(p1,p2,p3);
      cout<<z<<endl;
      cout<<pSLX->Selectivity(z)<<endl;
      cout<<pSLX->logSelectivity(z)<<endl;
      cout<<pSLX->logSelexMeanOne(z)<<endl;
      cout<<"--DoubleNormal4"<<endl;
      p1 = 30.0;
      p2 = 100.0;
      p3 = 50.0;
      double p4 = 130.0;
      pSLX = new class gsm::DoubleNormal4<dvector,double>(p1,p2,p3,p4);
      cout<<z<<endl;
      cout<<pSLX->Selectivity(z)<<endl;
      cout<<pSLX->logSelectivity(z)<<endl;
      cout<<pSLX->logSelexMeanOne(z)<<endl;
      cout<<"--Uniform"<<endl;
      pSLX = new class gsm::UniformCurve<dvector>();
      cout<<z<<endl;
      cout<<pSLX->Selectivity(z)<<endl;
      cout<<pSLX->logSelectivity(z)<<endl;
      cout<<pSLX->logSelexMeanOne(z)<<endl;
      cout<<"--Uniform0"<<endl;
      pSLX = new class gsm::Uniform0Curve<dvector>();
      cout<<z<<endl;
      cout<<pSLX->Selectivity(z)<<endl;
      cout<<pSLX->logSelectivity(z)<<endl;
      cout<<pSLX->logSelexMeanOne(z)<<endl;
      exit(1);
    }
   }//--end local scope
 END_CALCS

  //friend_class gmacs_comm;
  // |---------------------|
  // | SIMULATION CONTROLS |
  // |---------------------|

  int jitflag;//--jitter indicator from commandline 
  int simflag;
  int rseed;
  int nyrRetro1; //--number of retrospective peels from commandline (overrides value from gmacs.dat file)
 LOC_CALCS
  jitflag = 0;
  simflag = 0;
  rseed = 0;
  nyrRetro1 = -1;//--dummy value at this point
  int opt,on;

  sexes(0) = "undetermined";
  sexes(1) = "male";
  sexes(2) = "female";
  
  maturestate(0) = "undetermined";
  maturestate(1) = "mature";
  maturestate(2) = "immature";

  shellstate(0) = "undetermined";
  shellstate(1) = "new";
  shellstate(2) = "old";

  catchtypes(0) = "total";
  catchtypes(1) = "retained";
  catchtypes(2) = "discarded";

  unitstypes += "biommass";
  unitstypes += "numbers";

  seltypes += "selectivity";
  seltypes += "retention";
  


  /**
  * @brief command line option for simulating data.
  **/
  if ( (on=option_match(ad_comm::argc,ad_comm::argv,"-sim",opt))>-1 )
  {
    simflag = 1;
    rseed = atoi(ad_comm::argv[on+1]);
  }
  /**
  * @brief command line option for jittering parameter values (overrides gmacs.dat setting).
  **/
  if ( (on=option_match(ad_comm::argc,ad_comm::argv,"-jitter",opt))>-1 )
  {
    jitflag = 1;
    rseed = atoi(ad_comm::argv[on+1]);//set rseed to 0 to use start time
  }


  if ( (on=option_match(ad_comm::argc,ad_comm::argv,"-i",opt))>-1 )
  {
    cout << "\n";
    cout << "  +----------------------------------------------------------+\n";
    cout << "  | CONTRIBUTIONS (code and intellectual)                    |\n";
    cout << "  +----------------------------------------------------------+\n";
    cout << "  | Name:                        Organization:               |\n";
    cout << "  | James Ianelli                NOAA-NMFS                   |\n";
    cout << "  | D'Arcy Webber                Quantifish                  |\n";
    cout << "  | Steven Martell               SeaState                    |\n";
    cout << "  | Jack Turnock                 NOAA-NMFS                   |\n";
    cout << "  | Jie Zheng                    ADF&G                       |\n";
    cout << "  | Hamachan Hamazaki            ADF&G                       |\n";
    cout << "  | Athol Whitten                University of Washington    |\n";
    cout << "  | Andre Punt                   University of Washington    |\n";
    cout << "  | Dave Fournier                Otter Research              |\n";
    cout << "  | John Levitt                  Mathemetician               |\n";
    cout << "  | William Stockhausen          NOAA-NMFS                   |\n";
    cout << "  +----------------------------------------------------------+\n";
    cout << "\n";
    cout << "  +----------------------------------------------------------+\n";
    cout << "  | FINANCIAL SUPPORT                                        |\n";
    cout << "  +----------------------------------------------------------+\n";
    cout << "  | Financial support for this project was provided by the   |\n";
    cout << "  | National Marine Fisheries Service, the Bering Sea        |\n";
    cout << "  | Fisheries Research Foundation, ...                       |\n";
    cout << "  +----------------------------------------------------------+\n";
    cout << "\n";
    cout << "  +----------------------------------------------------------+\n";
    cout << "  | DOCUMENTATION                                            |\n";
    cout << "  +----------------------------------------------------------+\n";
    cout << "  | online api: http://seacode.github.io/gmacs/index.html    |\n";
    cout << "  +----------------------------------------------------------+\n";
    cout << "\n";
    exit(1);
   }

  // Command line option here to do retrospective analysis
  if ( (on=option_match(ad_comm::argc,ad_comm::argv, "-retro", opt))>-1 )
   {
    cout << "\n";
    cout << "  +----------------------------------------------------------+\n";
    cout << "  | Running retrospective model with " << ad_comm::argv[on+1] << " recent yrs removed |\n";
    cout << "  +----------------------------------------------------------+\n";
    nyrRetro1 = atoi(ad_comm::argv[on+1]);
  }
 END_CALCS

  // create a random number generator for projections

  // |------------------------|
  // | DATA AND CONTROL FILES |
  // |------------------------|
  //--read gmacs.dat file
  !!WriteFileName(TheHeader);
  init_adstring datafile;
  init_adstring controlfile;
  init_adstring projectfile;
  init_adstring weightunit;
  init_adstring numbersunit;
  init_adstring StockName;
  !!WriteFileName(datafile); WriteFileName(controlfile); WriteFileName(projectfile);
  !!WriteFileName(weightunit);
  !!WriteFileName(numbersunit);
  !!WriteFileName(StockName);
  init_int IsJittered;
  init_number sdJitter;
  !! if (jitflag) IsJittered = 1;
  !! if (IsJittered==1) cout << "Jittering with sd: " << sdJitter << endl;
  !! WriteFileName(IsJittered);
  !! WriteFileName(sdJitter);
  init_int OutRefPars;
  !! WriteFileName(OutRefPars);
  init_int OutRecruit;
  !! WriteFileName(OutRecruit);
  init_int OutSSB;
  !! WriteFileName(OutSSB);
  init_int Outfbar;
  !! WriteFileName(Outfbar);
  init_int OutDynB0;
  !! WriteFileName(OutDynB0);
  init_int nyrRetro;                                        ///> Retrospective end year
 LOCAL_CALCS
  if (nyrRetro1 > -1) nyrRetro = nyrRetro1;//--override value from gmacs.dat
  WriteFileName(nyrRetro);
 END_CALCS
  
  init_int TurnOffPhase;                                    ///> Maximum phase
  init_int StopAfterFnCall                                  ///> Number of function calls to stop after
  init_int CalcRefPoints;                                   ///> Set this to zero not to compute reference points
  init_int usepinfile                                       ///> Read in a special file (0=normal;1=pin file)
  init_int verbose;                                         ///> Flag to print to screen

  //check for commandline overide of pinfile use (if set, overrides value from gmacs.dat)
 LOCAL_CALCS
    if ( (on=option_match(ad_comm::argc,ad_comm::argv,"-verbose",opt))>-1 ){
      verbose = atoi(ad_comm::argv[on+1]);
      cout<<"#--verbose level set to: "<<verbose<<endl;
    }
    if ( (on=option_match(ad_comm::argc,ad_comm::argv,"-ainp",opt))>-1 ){
      usepinfile = 1;
      adstring fnPin = ad_comm::argv[on+1];
      if (std::fstream(fnPin)){
          ad_comm::change_pinfile_name(fnPin);
          cout<<"#Initial parameter values from pin file: "<<fnPin<<endl;
      } else {
          cout<<"#Initial parameter values from pin file: gmacs.pin"<<endl;
      }
    }
    if ( (on=option_match(ad_comm::argc,ad_comm::argv,"-apin",opt))>-1 ){
      usepinfile = 1;
      adstring fnPin = ad_comm::argv[on+1];
      if (std::fstream(fnPin)){
          ad_comm::change_pinfile_name(fnPin);
          cout<<"#Initial parameter values from pin file: "<<fnPin<<endl;
      } else {
          cout<<"#Initial parameter values from pin file: gmacs.pin"<<endl;
      }
    }
    if ( (on=option_match(ad_comm::argc,ad_comm::argv,"-pin",opt))>-1 ){
      usepinfile = 1;
      adstring fnPin = ad_comm::argv[on+1];
      if (std::fstream(fnPin)){
          ad_comm::change_pinfile_name(fnPin);
          cout<<"#Initial parameter values from pin file: "<<fnPin<<endl;
      } else {
          cout<<"#Initial parameter values from pin file: gmacs.pin"<<endl;
      }
    }
 END_CALCS
  !!gmacs_files << TurnOffPhase << " # Maximum phase (stop the estimation after this phase)" << endl;
  !!gmacs_files << StopAfterFnCall << " # Maximum number of function calls" << endl;
  !!gmacs_files << CalcRefPoints << " # Calculate reference points (0=no)" << endl;
  !!gmacs_files << usepinfile << " # use pin file (0=no, 1=yes)" << endl;
  !!gmacs_files << verbose << " # VERBOSE FLAG (0 = off, 1 = on, 2 = objective func; 3 diagnostics)" << endl;
  !!echoinput << TurnOffPhase << " # Maximum phase (stop the estimation after this phase)" << endl;
  !!echoinput << StopAfterFnCall << " # Maximum number of function calls" << endl;
  !!echoinput << CalcRefPoints  << " # Calculate reference points (0=no)" << endl;
  !!echoinput << usepinfile << " # use pin file (0=no, 1=yes)" << endl;
  !!echoinput << verbose << " # VERBOSE FLAG (0 = off, 1 = on, 2 = objective func; 3 diagnostics)" << endl;
 
  init_int dataeof;
  !! WriteFileName(dataeof);
  !! if ( dataeof != 9999 ) {cout << "Error reading GMACS.DAT" << endl; exit(1);}
  !! cout << "end of GMACS.DAT" << endl;
  //----------------------------------------------------------------------------
  
  //--read data file
  !! ad_comm::change_datafile_name(datafile);
  !! cout << "+----------------------+" << endl;
  !! cout << "| Reading data file    |" << endl;
  !! cout << "+----------------------+" << endl;

  !! gmacs_data << "# =========================================" << endl;
  !! gmacs_data << "# The inputs for catch and index data are CV. To convert from CVs to standard errors of the log and to weights is given by" << endl;
  !! gmacs_data << "# sigma = sqrt(ln(1.0+CV^2))" << endl;
  !! gmacs_data << "# weight = 1.0/(2*sigma^2)" << endl;
  !! gmacs_data << "# CV = sqrt(exp(1/(2*Weight))-1)" << endl;
  !! gmacs_data << "# =========================================" << endl << endl;
  // |------------------|
  // | MODEL DIMENSIONS |
  // |------------------|
  !! cout << " * Model dimensions" << endl;
  !! WRITEDAT(TheHeader);
  init_int syr;                                            ///> initial year
  init_int nyr;                                            ///> terminal year
  int nyrRetroNo; 
  !! nyrRetroNo = nyrRetro;
  !! nyrRetro = nyr-nyrRetro;                              ///> Adjust to nyear_retro
  init_int nseason;                                        ///> time step (years)
  init_int nfleet;                                         ///> number of gears (including surveys and fisheries)
  init_int nsex;                                           ///> number of sexes
  !! if (nsex != 1 && nsex != 2)
  !!  { cout << "nsex can only be 1 or 2; STOPPING" << endl; exit(1); }
  init_int nshell;                                         ///> number of shell conditions
  init_int nmature;                                        ///> number of maturity types
  init_int nclass;                                         ///> number of size-classes

  init_int season_recruitment;                             ///> Season that recruitment occurs (end of year before growth)
  init_int season_growth;                                  ///> Season that growth occurs (end of year after recruitment)
  init_int season_ssb;                                     ///> Season to calculate SSB (end of year)
  init_int season_N;                                       ///> Season to output N
  init_ivector nSizeSex(1,nsex);                           ///> Number of size-classes by sex
  
  int n_grp;                                               ///> number of sex/newshell/oldshell groups
  int nlikes;                                              ///> 1      2     3           4         5

  int Nyears;
  !! Nyears =(nyrRetro-syr+1);
  int Nyears2;
  !! Nyears2 =(nyrRetro+1-syr+1);

 LOC_CALCS
  n_grp = nsex * nshell * nmature;
  nlikes = 5;          ///> catch, cpue, size comps, recruits, molt increments
  gmacs_data << syr << " # Start year" << endl;
  gmacs_data << nyrRetro << " # End year (retro)" << endl;
  gmacs_data << nseason << " # Number of seasons" << endl;
  gmacs_data << nfleet << " # Number of distinct data groups (fleet, among fishing fleets and surveys)" << endl;
  gmacs_data << nsex << " # Number of sexes" << endl;
  gmacs_data << nshell << " # Number of shell condition types" << endl;
  gmacs_data << nmature << " # Number of maturity types" << endl;
  gmacs_data << nclass << " # Number of size-classes in the model" << endl;
  gmacs_data << season_recruitment << " # Season recruitment occurs" << endl;
  gmacs_data << season_growth << " # Season molting and growth occurs" << endl;
  gmacs_data << season_ssb << " # Season to calculate SSB (changed to match Feb mating)" << endl;
  gmacs_data << season_N << " # Season for N output" << endl;
  gmacs_data << "# maximum size-class (males then females)" << endl;
  gmacs_data << nSizeSex << endl;
  
  // Check at least one matches nclass
  if (max(nSizeSex)!=nclass) { cout << "One of the maximum size-classes needs to match nclass; STOPPING" << endl; exit(1); }
 END_CALCS

  // Set up index pointers
  ivector isex(1,n_grp);
  ivector ishell(1,n_grp);
  ivector imature(1,n_grp);
  3darray pntr_hmo(1,nsex,1,nmature,1,nshell);
 LOC_CALCS
  int h,m,o;
  int hmo=1;
  gmacs_data << "# Group definitions: " << n_grp << endl;
  gmacs_data << "# Index Sex Shell Maturity" << endl;
  for ( h = 1; h <= nsex; h++ )
   for ( m = 1; m <= nmature; m++ )
    for ( o = 1; o <= nshell; o++ )
     {
      isex(hmo) = h;
      ishell(hmo) = o;
      imature(hmo) = m;
      gmacs_data << "# " << hmo << " : " << sexes(h) << " ";
      if (o==NEW_SHELL) gmacs_data << "New shell(" << o << ") ";
      if (o==OLD_SHELL) gmacs_data << "old shell(" << o << ") ";
      if (m==IMMATURE) gmacs_data << "Immature(" << m << ") ";
      if (m==MATURE) gmacs_data << "Mature(" << m << ") ";
      pntr_hmo(h,m,o) = hmo++;
      gmacs_data << pntr_hmo(h,m,o) << endl;
     }
 END_CALCS
  init_vector size_breaks(1,nclass+1);
  vector mid_points(1,nclass);
  !! gmacs_data << "# size_breaks (a vector giving the break points between size intervals with dimension nclass+1)" << endl;
  !! gmacs_data << size_breaks << endl;

  // |-------------------------------|
  // | NATURAL MORTALITY             |
  // |-------------------------------|
  !! cout << " * Natural mortality" << endl;
  init_int m_prop_type;                                    ///> 1 for vector by season; 2 for matrix by year and season
  !! if (m_prop_type != 1 && m_prop_type != 2)
  !!  { cout << "m_prop_type can only be 1 or 2; STOPPING" << endl; exit(1); }
  int m_dim;
 LOC_CALCS
   m_dim = 1;
   if ( m_prop_type == 2 ) m_dim = nyr - syr + 1;
 END_CALCS
  init_matrix m_prop_in(1,m_dim,1,nseason);
  !! gmacs_data << "# Natural mortality per season input type (1 = vector by season, 2 = matrix by season/year)" << endl << " 2" << endl;
  matrix m_prop(syr,nyrRetro,1,nseason);
  LOC_CALCS
   switch ( m_prop_type )
    {
     // vector by season
     case 1:
      for ( int i = syr; i <= nyrRetro; i++ )
       for ( int j = 1; j <= nseason; j++ )
         m_prop(i,j) = m_prop_in(1,j);
      break;
     // matrix by year and season
     case 2:
      for ( int i = syr; i <= nyrRetro; i++ )
       for ( int j = 1; j <= nseason; j++ )
         m_prop(i,j) = m_prop_in(i-syr+1,j);
      break;
    }
    for ( int i = syr; i <= nyrRetro; i++ )
     if ( sum(m_prop(i)) > 1.0000001 || sum(m_prop(i)) < 0.999999 )
      {
       cout << "Error: the proportion of natural mortality applied each season (in the .dat file) does not sum to 1! It sums to " << sum(m_prop(i)) << endl;
        exit(1);
      }
   gmacs_data << "# Proportion of the total natural mortality to be applied each season" << endl;
   for (int i=syr;i<=nyrRetro;i++)
    gmacs_data << setw(14) << setprecision(11) << setfixed() << m_prop(i) << " # " << i << endl;
 END_CALCS

  // |-------------|
  // | FLEET NAMES |
  // |-------------|
  
  !! for (int ifleet=1;ifleet<=nfleet;ifleet++)
  !!  {
  !!      *(ad_comm::global_datafile) >> anystring;
  !!      fleetname+=anystring;
  !!  }
  !! WRITEDAT(fleetname)
 
  // |-------------|
  // | FLEET TYPES |
  // |-------------|
  init_ivector season_type(1,nseason);                     ///> Set to 0 for discrete; 1 for continuous
  !! gmacs_data << "#Season type: Set to 1 for continuous F and 0 for instantanous F" << endl;
  !! gmacs_data << season_type << endl;

  // |---------------|
  // |--CLASS Subst--|
  // |---------------|
 LOCAL_CALCS
  //class to provide substitutions from/to strings/integers
  class Subst{
  public:
    int fleetID(adstring& flt,adstring_array& fleetname){
      int id = 0;
      for (int f=fleetname.indexmin();f<=fleetname.indexmax();f++)
        if (flt==fleetname[f]) id = f;
      return id;
      cout<<"Problem assigning fleetID to '"<< flt <<"'."<< endl;
      cout<<"Allowed values are ";
      for (int f=fleetname.indexmin();f<fleetname.indexmax();f++)
        cout<<"'"<<fleetname[f]<<"', ";
      cout<<"or '"<<fleetname[fleetname.indexmax()]<<"'."<< endl;
      exit(-1);
    }
    int catchTypeID(adstring& str){
      int id = -1;
      adstring strp = to_lower(str);
      if (strp=="retained")  return(RETAINED);
      if (strp=="discard")   return(DISCARDED);
      if (strp=="discarded") return(DISCARDED);
      if (strp=="total")     return(TOTALCATCH);
      cout<<"Problem assigning catchTypeID to '"<< str <<"'."<< endl;
      cout<<"Allowed values are 'retained', 'discard', 'discarded' or 'total'."<< endl;
      exit(-1);
      return(id);
    }
    int unitsTypeID(adstring& str){
      int id = -1;
      adstring strp = to_lower(str);
      if (strp=="abundance")  return(ABUNDANCE);
      if (strp=="biomass")    return(BIOMASS);
      cout<<"Problem assigning unitsTypeID to '"<< str <<"'."<< endl;
      cout<<"Allowed values are 'abundance' or 'biomass'."<< endl;
      exit(-1);
      return(id);
    }
    int indexTypeID(adstring& str){
      int id = -1;
      adstring strp = to_lower(str);
      if (strp=="sel")     return(1);
      if (strp=="sel+ret") return(2);
      cout<<"Problem assigning indexTypeID to '"<< str <<"'."<< endl;
      cout<<"Allowed values are 'sel' or 'sel+ret'."<< endl;
      exit(-1);
      return(id);
    }
    int sexID(adstring& str){
      int id = -1;
      adstring strp = to_lower(str);
      if (strp=="males")        return(MALES);
      if (strp=="females")      return(FEMALES);
      if (strp=="male")         return(MALES);
      if (strp=="female")       return(FEMALES);
      if (strp=="undetermined") return(UNDET_SEX);
      return(id);
      cout<<"Problem assigning sexID to '"<< str <<"'."<< endl;
      cout<<"Allowed values are 'male', 'males', 'female', 'females', or 'undetermined'."<< endl;
      exit(-1);
    }
    int matID(adstring& str){
      int id = -1;
      adstring strp = to_lower(str);
      if (strp=="immature")     return(IMMATURE);
      if (strp=="mature")       return(MATURE);
      if (strp=="undetermined") return(UNDET_MATURE);
      cout<<"Problem assigning matID to '"<< str << endl;
      cout<<"Allowed values are 'immature' or 'mature'."<< endl;
      exit(-1);
      return(id);
    }
    int shellID(adstring& str){
      int id = -1;
      adstring strp = to_lower(str);
      if (strp=="new shell")    return(NEW_SHELL);
      if (strp=="new_shell")    return(NEW_SHELL);
      if (strp=="old shell")    return(OLD_SHELL);
      if (strp=="old_shell")    return(OLD_SHELL);
      if (strp=="undetermined") return(UNDET_SHELL);
      cout<<"Problem assigning shellID to '"<< str <<"'."<< endl;
      cout<<"Allowed values are 'new shell', 'new_shell', 'old shell', 'old_shell', or 'undetermined'."<< endl;
      exit(-1);
      return(id);
    }
  };
  Subst substStuff;
 END_CALCS


  // |--------------|
  // | CATCH SERIES |
  // |--------------|
  !! cout << " * Catch data" << endl;
  !! gmacs_data << "\n"<<endl;
  !! gmacs_data << "##------------------------------------------------------------" << endl;
  !! gmacs_data << "##--CATCH DATA------------------------------------------------" << endl;
  !! gmacs_data << "##------------------------------------------------------------" << endl;
  init_int fmtCDS_in;
  !! gmacs_data << fmtCDS_in << " #--input catch data format (0: old format, 1: new format)" << endl;
  init_int nCatchDF;
  !! gmacs_data << nCatchDF << "  #--Number of catch data frames" << endl;

  ivector nCatchRows(1,nCatchDF); // this can't be an init_vector here--incompatible with "new" format
  3darray dCatchData(1,nCatchDF); // array of catch data WTS: full allocation delayed until nCatchRows is determined
  !!float TempW;
  !!float SDlogD;
 LOCAL_CALCS
    {
      cifstream* pGD = ad_comm::global_datafile;
      if (fmtCDS_in==0){
        //--read in using old format
        (*pGD) >> nCatchRows;
        gmacs_data << "# Number of lines for each dataframe (this is not correct for retrospective analyses)" << endl;
        gmacs_data << nCatchRows << endl;
        for (int idf=1;idf<=nCatchDF;idf++) dCatchData(idf).allocate(1,nCatchRows(idf),1,11);//--finish allocation
        (*pGD) >> dCatchData;
      } else {
        //--read in using new format
        adstring unitsType,catchType,fleet,sex,maturity, shell;
        int iUT,iCT,iF,iX,iM,iS;
        for (int idf=1;idf<=nCatchDF;idf++) {
          gmacs_data << "#----------------" << endl;
          gmacs_data << "# catch dataframe number " << idf << endl;
          (*pGD) >> unitsType;        iUT = substStuff.unitsTypeID(unitsType);
          (*pGD) >> catchType;        iCT = substStuff.catchTypeID(catchType);
          (*pGD) >> fleet;            iF  = substStuff.fleetID(fleet,fleetname);
          (*pGD) >> sex;              iX  = substStuff.sexID(sex);
          (*pGD) >> maturity;         iM  = substStuff.matID(maturity);
          (*pGD) >> shell;            iS  = substStuff.shellID(shell);
          (*pGD) >> nCatchRows(idf);
          gmacs_data << unitsType << "   #--units type" << endl;
          gmacs_data << catchType << "   #--catch type (retained, discard(ed), total)" << endl;
          gmacs_data << fleet     << "   #--fleet name" << endl;
          gmacs_data << sex       << "   #--sex (male(s), female(s), undetermined)" << endl;
          gmacs_data << maturity  << "   #--maturity (immature, mature, undetermined)" << endl;
          gmacs_data << shell     << "   #--shell condition (new shell, old shell, undetermined)" << endl;
          gmacs_data << nCatchRows(idf) << "   #--number of rows in dataframe" << endl;
          dmatrix inpCatchData(1,nCatchRows(idf),1,7);
          dCatchData(idf).allocate(1,nCatchRows(idf),1,11);//--finish allocation
          (*pGD) >> inpCatchData;
          gmacs_data << "#year season value cv multiplier effort discard_mortality" << endl;
          gmacs_data << inpCatchData << endl;
          for (int irw=1;irw<=nCatchRows(idf);irw++){
            dCatchData(idf,irw, 1) = (int) inpCatchData(irw,1);
            dCatchData(idf,irw, 2) = (int) inpCatchData(irw,2);
            dCatchData(idf,irw, 3) = iF;
            dCatchData(idf,irw, 4) = iX;
            dCatchData(idf,irw, 5) = inpCatchData(irw,3);
            dCatchData(idf,irw, 6) = inpCatchData(irw,4);
            dCatchData(idf,irw, 7) = iCT;
            dCatchData(idf,irw, 8) = iUT;
            dCatchData(idf,irw, 9) = inpCatchData(irw,5);
            dCatchData(idf,irw,10) = inpCatchData(irw,6);
            dCatchData(idf,irw,11) = inpCatchData(irw,7);
          }//--irw
        }//--idf
        gmacs_data << "#--old format:"<<endl;
      }//--end reading new format

      gmacs_data << "## Sex: 1 = male, 2 = female, 0 = both" << endl;
      gmacs_data << "## Type of catch: 1 = retained, 2 = discard, 0 = total" << endl;
      gmacs_data << "## Units of catch: 1 = biomass, 2 = numbers" << endl;
      gmacs_data << "## Mult: 1= use data as they are, 2 = multiply by this number (e.g., lbs to kg)" << endl;
      gmacs_data << "# Year Season Fleet Sex Obs CV Type Units Mult Effort Discard_mortality" << endl;
      for (int iCatOut=1;iCatOut<=nCatchDF;iCatOut++){
        for (int irow=1;irow<=nCatchRows(iCatOut); irow++) {
          if (dCatchData(iCatOut,irow,1) <= nyrRetro) {
            if (fmtCDS_in>0) gmacs_data << "# ";
            gmacs_data << (int) dCatchData(iCatOut,irow)(1) << " ";
            gmacs_data << (int) dCatchData(iCatOut,irow)(2) << " ";
            gmacs_data << (int) dCatchData(iCatOut,irow)(3) << " ";
            gmacs_data << (int) dCatchData(iCatOut,irow)(4) << " ";
            gmacs_data << dCatchData(iCatOut,irow)(5,6) << " ";
            gmacs_data << (int) dCatchData(iCatOut,irow)(7) << " ";
            gmacs_data << (int) dCatchData(iCatOut,irow)(8) << " ";
            gmacs_data << dCatchData(iCatOut,irow)(9,11) << " ";
            anystring = "# " + fleetname(dCatchData(iCatOut,irow,3));
            if (dCatchData(iCatOut,irow,4)==MALES)      anystring = anystring +"_male";
            if (dCatchData(iCatOut,irow,4)==FEMALES)    anystring = anystring +"_female";
            if (dCatchData(iCatOut,irow,7)==TOTALCATCH) anystring = anystring +"_total";
            if (dCatchData(iCatOut,irow,7)==RETAINED)   anystring = anystring +"_retained";
            if (dCatchData(iCatOut,irow,7)==DISCARDED)  anystring = anystring +"_discard";
            if (dCatchData(iCatOut,irow,8)==BIOMASS)    anystring = anystring +"_biomass";
            if (dCatchData(iCatOut,irow,8)==ABUNDANCE)  anystring = anystring +"_numbers";
            if (dCatchData(iCatOut,irow,6) <= 0) {
              cout << "Error: CV of catch is zero (or less) for group " << iCatOut << " row " << irow << endl;
              exit(1);
            }
            gmacs_data << anystring << " ";
            SDlogD = sqrt(log(1.0 + square(dCatchData(iCatOut,irow,6))));
            TempW = 0.5/(SDlogD*SDlogD);
            gmacs_data << "Sd of log = " << SDlogD << "; Weight = " << TempW << " ";
            gmacs_data << endl;
          }//--dCatchData(iCatOut,irow,1) <= nyrRetro
        }//--irow
      }//--iCatOut
    }
 END_CALCS

  matrix obs_catch(1,nCatchDF,1,nCatchRows);
  matrix obs_effort(1,nCatchDF,1,nCatchRows);
  3darray dCatchData_out(1,nCatchDF,syr,nyr,1,11);
  matrix obs_catch_out(1,nCatchDF,syr,nyr);

  matrix catch_cv(1,nCatchDF,1,nCatchRows);
  matrix catch_dm(1,nCatchDF,1,nCatchRows);
  matrix catch_mult(1,nCatchDF,1,nCatchRows);

 LOC_CALCS
  for ( int k = 1; k <= nCatchDF; k++ )
   {
    catch_mult(k) = column(dCatchData(k),9);
    obs_catch(k)  = column(dCatchData(k),5);
    catch_cv(k)   = column(dCatchData(k),6);
    catch_dm(k)   = column(dCatchData(k),11);
    obs_catch(k)  = elem_prod(obs_catch(k), catch_mult(k));         ///> rescale catch by multiplier
    obs_effort(k) = column(dCatchData(k),10);
   }
  ECHO(obs_catch);
  ECHO(catch_cv);
 END_CALCS

  // From the catch series determine the number of fishing mortality rate parameters that need to be estimated. 
  // Note that there are a number of combinations which require an F to be estimated.
  ivector nFparams(1,nfleet);                     ///> The number of deviations required for each fleet
  ivector nYparams(1,nfleet);                     ///> The number of deviations for female Fs
  3darray fhit(syr,nyrRetro,1,nseason,1,nfleet);  ///> set to 1 for present; 0 for absent
  3darray yhit(syr,nyrRetro,1,nseason,1,nfleet);  ///> set to 1 for present; 0 for absent
  matrix dmr(syr,nyrRetro,1,nfleet);              ///> discard mortality - has to be the same for all catch series for each fleet
  matrix fhitfut(1,nseason,1,nfleet);             ///> set to 1 for present in any year; 0 for absent

 LOC_CALCS
  nFparams.initialize();
  nYparams.initialize();
  fhit.initialize();
  yhit.initialize();
  dmr.initialize();
  echoinput<<"\n\nDetermining number of fishing rate parameters to be estimated."<<endl;
  for ( int k = 1; k <= nCatchDF; k++ )
   {
      echoinput<<"catchDF (k) = "<<k<<endl;
    for ( int i = 1; i <= nCatchRows(k); i++ )
     if (dCatchData(k)(i,1) <= nyrRetro && dCatchData(k)(i,1) >= syr)
      {
       int y = dCatchData(k)(i,1);                          ///> year
       int j = dCatchData(k)(i,2);                          ///> season
       int g = dCatchData(k)(i,3);                          ///> fleet
       int h = dCatchData(k)(i,4);                          ///> sex
       echoinput<<"Processing i,y,j,g,h (row,year, season, fleet, sex): "<<i<<" "<<y<<" "<<j<<" "<<g<<" "<<h<<endl;

       // Check whether the fleet is instantaneous but natural mortality in the relevant period is not zero!
       if (season_type(j) == INSTANT_F && m_prop(y,j) > 0)
        {
         cout      << "The proportion of M should be zero for season " << j << " in year " << y << endl;
         echoinput << "The proportion of M should be zero for season " << j << " in year " << y << endl;
         exit(1);
        }

       if ( !fhit(y,j,g) )
        {
         fhit(y,j,g) ++;
         nFparams(g) ++;
         dmr(y,g) = catch_dm(k)(i);//TODO: presumably dmr could depend on season and sex, as well as year and gear/fleet
        }
       if ( !yhit(y,j,g) && h == 2 )
        {
         yhit(y,j,g) ++;
         nYparams(g) ++;
         dmr(y,g) = catch_dm(k)(i);
        }
      }
   }
  for (int g=1;g<=nfleet; g++) { if (nFparams(g) == 0) nFparams(g) = 1; }
  for (int g=1;g<=nfleet; g++) { if (nYparams(g) == 0) nYparams(g) = 1; }
  ECHO(nFparams); ECHO(nYparams); // ECHO(fhit); ECHO(yhit); ECHO(dmr);
  echoinput << "fhit" << endl;
  echoinput << "iy(yr)  j(season)  hit_for_fleet " <<endl;
  fhitfut.initialize();
  for (int iy=syr;iy<=nyrRetro;iy++)
   for (int j=1;j<=nseason;j++)
    {
     echoinput << iy << " " << j << " ";
     for (int g=1;g<=nfleet;g++) echoinput << fhit(iy,j,g) << " ";
     for (int g=1;g<=nfleet;g++) if (fhit(iy,j,g)==1) fhitfut(j,g) = 1;
     echoinput << endl;
    }
  echoinput << "fhitfut" << endl;
  echoinput << "j(season)  hit_for_fleet? " <<endl;
  for (int j=1;j<=nseason;j++)
   {
    echoinput << " " << j << " ";
    for (int g=1;g<=nfleet;g++) echoinput << fhitfut(j,g) << " ";
    echoinput << endl;
   }
  echoinput << "yhit" << endl;
  echoinput << "iy(yr)  j(season)  hit_for_fleet? " <<endl;
  for (int iy=syr;iy<=nyrRetro;iy++)
   for (int j=1;j<=nseason;j++)
    {
     echoinput << iy << " " << j << " ";
     for (int g=1;g<=nfleet;g++) echoinput << yhit(iy,j,g) << " ";
     echoinput << endl;
    }
  ECHO(dmr);
  echoinput<<"dmr:"<<endl;
  echoinput<<"year   fleet   dmr"<<endl;
  for (int iy=syr;iy<=nyrRetro;iy++)
    for (int g=1;g<=nfleet;g++) echoinput<<iy<<" "<<g<<" "<<dmr(iy,g)<<endl;

  // Check for errors in discard rate assumptions
  for ( int k = 1; k <= nCatchDF; k++ )
   for ( int i = 1; i <= nCatchRows(k); i++ )
    if (dCatchData(k)(i,1) <= nyrRetro && dCatchData(k)(i,1) >= syr)
     {
      int y = dCatchData(k)(i,1);                           ///> year
      int g = dCatchData(k)(i,3);                           ///> fleet
      if (catch_dm(k)(i) != dmr(y,g))
       { cout       << "ERROR: discard rates do not match: year " << y << " and fleet " << g << " in CatchDF " << k<< endl; 
         gmacs_data << "ERROR: discard rates do not match: year " << y << " and fleet " << g << " in CatchDF " << k<< endl; 
         gmacs_data << "k = "<<k<<" i = "<<i<<" y = "<<y<<" g = "<<g<<endl;
         gmacs_data << "catch_dm(k)(i) = " <<catch_dm(k)(i) << "  dmr(y,g) = " << dmr(y,g) << endl;
         exit(1); }
     }

  // Create the dCatchData_out object for output and plotting in R, this object simply fills in the years that don't have data with zero catch
  dCatchData_out.initialize();
  obs_catch_out.initialize();
  for ( int k = 1; k <= nCatchDF; k++ )
   for ( int i = syr; i <= nyrRetro; i++ )
    {
     dCatchData_out(k,i,1) = i; // Year
     int j = 1;
     for ( int ii = 1; ii <= nCatchRows(k); ii++ )
      {
       if ( i == dCatchData(k,ii,1) ) // year index
        {
         j = ii;
         obs_catch_out(k,i)    = dCatchData(k,ii,5); // Obs
         dCatchData_out(k,i,5) = dCatchData(k,ii,5); // Obs
         dCatchData_out(k,i,6) = dCatchData(k,ii,6); // CV
         dCatchData_out(k,i,9)  = dCatchData(k,j,9); // Mult
         dCatchData_out(k,i,10) = dCatchData(k,j,10); // Effort
         dCatchData_out(k,i,11) = dCatchData(k,j,11); // Discard mortality
        }
      }
     // Replicate these variables
     dCatchData_out(k,i,2) = dCatchData(k,j,2); // Season
     dCatchData_out(k,i,3) = dCatchData(k,j,3); // Fleet
     dCatchData_out(k,i,4) = dCatchData(k,j,4); // Sex
     dCatchData_out(k,i,7) = dCatchData(k,j,7); // Type
     dCatchData_out(k,i,8) = dCatchData(k,j,8); // Units
    }
 END_CALCS

  // |----------------------------|
  // | RELATIVE ABUNDANCE INDICES |
  // |----------------------------|
  !! cout << " * Abundance data" << endl;
  !! gmacs_data << "\n" << endl;
  !! gmacs_data << "##------------------------------------------------------------" << endl;
  !! gmacs_data << "##--RELATIVE ABUNDANCE DATA-----------------------------------" << endl;
  !! gmacs_data << "##------------------------------------------------------------" << endl;
  init_int fmtRAD; ///> Format type (0: old format, 1: new format)
  !!gmacs_data << fmtRAD    << "  #--input format type (0: old format, 1: new format)" << endl;
  init_int nSurveys;                                                 ///> Number of survey series
  !! gmacs_data << nSurveys << "  #--Number of dataframes" << endl; //TODO: change name to nSurveyDFs
  ivector SurveyType(1,nSurveys);                               ///> Type of survey
  int nSurveyRows;                                              ///> total number of rows in survey dataframes
  matrix dSurveyData;                                           ///> survey data
 LOCAL_CALCS
  {
    cifstream* pGD = ad_comm::global_datafile;
    if (fmtRAD==0){
      //old format
      gmacs_data << "# Type of 'survey' catchability (1=Selectivity; 2=Selectivity+Retention), by data frame" << endl;
      (*pGD) >> SurveyType;
      gmacs_data << SurveyType << endl;
      gmacs_data << "# Number of data rows, by data frame" << endl;
      (*pGD) >> nSurveyRows;
      gmacs_data << "#   NOTE: this is not correct for retrospective analyses" << endl;
      gmacs_data << nSurveyRows << endl;;
      dSurveyData.allocate(1,nSurveyRows,0,9);
      (*pGD) >> dSurveyData;
      gmacs_data << "# Survey data:"<<endl;
      gmacs_data << dSurveyData <<endl;
    } else {
      //new format
      adstring indexType, unitsType, fleet, sexType, matType, shlType;
      ivector nrows(1,nSurveys), idIndex(1,nSurveys),idUnits(1,nSurveys);
      ivector idFlt(1,nSurveys),idSex(1,nSurveys),idMat(1,nSurveys),idShl(1,nSurveys);
      d3_array inpDFs(1,nSurveys);
      for (int idf = 1;idf<=nSurveys;idf++){
        gmacs_data << "#----------------" << endl;
        gmacs_data << "# relative abundance dataframe number " << idf << endl;
        (*pGD) >> unitsType;  idUnits(idf) = substStuff.unitsTypeID(unitsType);
        (*pGD) >> indexType;  idIndex(idf) = substStuff.indexTypeID(indexType);
        (*pGD) >> fleet;      idFlt(idf) = substStuff.fleetID(fleet,fleetname);
        (*pGD) >> sexType;    idSex(idf) = substStuff.sexID(sexType);
        (*pGD) >> matType;    idMat(idf) = substStuff.matID(matType);
        (*pGD) >> shlType;    idShl(idf) = substStuff.shellID(shlType);
        (*pGD) >> nrows(idf);
        gmacs_data << indexType << "  #--abundance index type ('sel' or 'sel+ret')" << endl;
        gmacs_data << unitsType << "  #--units type ('abundance' or 'biomass')" << endl;
        gmacs_data << fleet     << "  #--fleet name" << endl;
        gmacs_data << sexType   << "  #--sex             (male(s), female(s), undetermined)" << endl;
        gmacs_data << matType   << "  #--maturity        (immature, mature, undetermined)" << endl;
        gmacs_data << shlType   << "  #--shell condition (new_shell, old_shell, undetermined)" << endl;
        inpDFs(idf).allocate(1,nrows(idf),1,7);//--allocate dataframe
        (*pGD) >> inpDFs(idf);
        gmacs_data << "# q_index year season value cv multiplier CPUE_timing " <<endl;
        gmacs_data << inpDFs(idf) <<endl;
      }//--idf
      nSurveyRows = sum(nrows);
      dSurveyData.allocate(1,nSurveyRows,0,9);
      int jrw = 1;
      for (int idf = 1;idf<=nSurveys;idf++){
        SurveyType(idf) = idIndex(idf);
        for (int irw = 1;irw<=nrows(idf);irw++){
          dSurveyData(jrw, 0) = inpDFs(idf,irw,1); //--q_index
          dSurveyData(jrw, 1) = inpDFs(idf,irw,2); //--year
          dSurveyData(jrw, 2) = inpDFs(idf,irw,3); //--season
          dSurveyData(jrw, 3) = idFlt(idf);        //--fleet
          dSurveyData(jrw, 4) = idSex(idf);        //--sex
          dSurveyData(jrw, 5) = idMat(idf);        //--maturity
          dSurveyData(jrw, 6) = inpDFs(idf,irw,4); //--observed value
          dSurveyData(jrw, 7) = inpDFs(idf,irw,5); //--cv
          dSurveyData(jrw, 8) = inpDFs(idf,irw,6); //--units scaling
          dSurveyData(jrw, 9) = inpDFs(idf,irw,7); //--cpue timing
          jrw++;
        }//--irw
      }//--idf
     }//--if (fmtRAD)
  }
 END_CALCS
  vector obs_cpue(1,nSurveyRows);
  vector cpue_cv(1,nSurveyRows);
  vector cpue_sd(1,nSurveyRows);
  vector cpue_cv_add(1,nSurveyRows);
  vector cpue_time(1,nSurveyRows);
 LOC_CALCS
  obs_cpue = column(dSurveyData,6);
  cpue_cv  = column(dSurveyData,7);
  cpue_sd  = sqrt(log(1.0 + square(cpue_cv)));
  cpue_time  = column(dSurveyData,9);
  if (fmtRAD) gmacs_data << "# old format:" << endl;
  gmacs_data << "## Index: One q is estimated for each index (the number of index values should match nSurveys" << endl;
  gmacs_data << "## Sex: 1 = male, 2 = female, 0 = both" << endl;
  gmacs_data << "## Maturity: 1 = mature, 2 = immature, 0 = both" << endl;
  gmacs_data << "## Units of survey: 1 = biomass, 2 = numbers" << endl;
  gmacs_data << "# row Index Year Season Fleet Sex Maturity Obs CV Units CPUE_time" << endl;
  for (int irow=1;irow<=nSurveyRows; irow++)
   if (((dSurveyData(irow,1) <= nyrRetro) || ((dSurveyData(irow,1) == nyrRetro+1) && (dSurveyData(irow,2) == 1))) && dSurveyData(irow,1) >= syr)
    {
     gmacs_data << "# " << irow << " " << (int) dSurveyData(irow,0) << " ";
     gmacs_data << (int) dSurveyData(irow,1) << " ";//year
     gmacs_data << (int) dSurveyData(irow,2) << " ";//season
     gmacs_data << (int) dSurveyData(irow,3) << " ";//fleet
     gmacs_data << (int) dSurveyData(irow,4) << " ";//sex
     gmacs_data << (int) dSurveyData(irow,5) << " ";//maturity
     gmacs_data << dSurveyData(irow)(6,7) << " ";//obs, cv
     gmacs_data << (int) dSurveyData(irow,8) << " ";//data type
     gmacs_data << dSurveyData(irow,9) << " ";//CPUE time
     anystring = "# " + fleetname(dSurveyData(irow,3));
     if (dSurveyData(irow,4)==UNDET_SEX)        anystring = anystring +"_male+female";
     if (dSurveyData(irow,4)==MALES)            anystring = anystring +"_male";
     if (dSurveyData(irow,4)==FEMALES)          anystring = anystring +"_female";
     if (dSurveyData(irow,5)==UNDET_MATURE) anystring = anystring +"_immature+mature";
     if (dSurveyData(irow,5)==IMMATURE)     anystring = anystring +"_immature";
     if (dSurveyData(irow,5)==MATURE)       anystring = anystring +"_mature";
     gmacs_data << anystring << " ";
     
     SDlogD = sqrt(log(1.0 + square(dSurveyData(irow,7))));
     TempW = 0.5/(SDlogD*SDlogD);
     gmacs_data << "Sd of log = " << SDlogD << "; Weight = " << TempW << " ";
     gmacs_data << anystring << endl;
    }
  ECHO(obs_cpue); ECHO(cpue_cv); ECHO(cpue_sd); ECHO(cpue_time);
 END_CALCS

  // |-----------------------|
  // | SIZE COMPOSITION DATA |
  // |-----------------------|
  !! cout << " * Size composition data" << endl;
  !! gmacs_data << "\n" << endl;
  !! gmacs_data << "##------------------------------------------------------------" << endl;
  !! gmacs_data << "##--SIZE COMPOSITION DATA-------------------------------------" << endl;
  !! gmacs_data << "##------------------------------------------------------------" << endl;
   init_int fmtZCs_in;                                           ///> size composition format flag (0=old style, 1=new style)
  !! gmacs_data << fmtZCs_in     << "   #--format flag (0=old style, 1=new style)" << endl;
  init_int nSizeComps_in;                                       ///> Number of series of size-comp data
  !! gmacs_data << nSizeComps_in << "   #--number of dataframes" << endl;
  ivector nSizeCompRows_in(1,nSizeComps_in);                    ///> Rows of data for each series (was init_ivector)
  ivector nSizeCompCols_in(1,nSizeComps_in);                    ///> Number of size-class bins    (was init_ivector)
  3darray d3_SizeComps_in(1,nSizeComps_in); //--other dimensions are allocated below (was init_3darray)
 LOCAL_CALCS
  {
    cifstream* pGD = ad_comm::global_datafile;
    if (fmtZCs_in==0){
      (*pGD) >> nSizeCompRows_in;
      (*pGD) >> nSizeCompCols_in;
      //--allocate remaining dimensions
      for (int iZC=1;iZC<=nSizeComps_in;iZC++)
        d3_SizeComps_in(iZC).allocate(1,nSizeCompRows_in(iZC),-7,nSizeCompCols_in(iZC));
      d3_SizeComps_in.initialize();//--set elements to 0
    }
  }
 END_CALCS
 LOCAL_CALCS
  {
    cifstream* pGD = ad_comm::global_datafile;
    if (fmtZCs_in==0){
      (*pGD) >> d3_SizeComps_in;
    } else if (fmtZCs_in==1) {
      cout << "reading size compositions using new format" << endl;
      adstring ct_, flt_, x_, m_, s_; 
      int      ict_,iflt_,ix_,im_,is_;
      for (int iZC=1;iZC<=nSizeComps_in;iZC++){
        cout << "iZC = " << iZC << endl;
        gmacs_data << "#----------------" << endl;
        gmacs_data << "#--size composition dataframe number " << iZC << endl;
        (*pGD) >> ct_;            //--catch type as string
        (*pGD) >> flt_;           //--fleet as string
        (*pGD) >> x_;             //--sex as string
        (*pGD) >> m_;             //--maturity as string
        (*pGD) >> s_;             //--shell condition as string
        gmacs_data << ct_  << "   #--catch type (retained, discard(ed), total)" << endl;
        gmacs_data << flt_ << "   #--fleet name" << endl;
        gmacs_data << x_   << "   #--sex type (male(s), female(s), undetermined)" << endl;
        gmacs_data << m_   << "   #--maturity type (immature, mature, undetermined)" << endl;
        gmacs_data << s_   << "   #--shell condition (new_shell, old_shell, undetermined)" << endl;
        (*pGD) >> nSizeCompRows_in(iZC);
        (*pGD) >> nSizeCompCols_in(iZC);
        gmacs_data << nSizeCompRows_in(iZC) << "   #--number of rows in dataframe" << endl;
        gmacs_data << nSizeCompCols_in(iZC) << "   #--number of columns in dataframe" << endl;
        cout << ct_ << " " << flt_ << " " << x_ << " " << m_ << " " << s_ << endl;
        ict_  = substStuff.catchTypeID(ct_);
        iflt_ = substStuff.fleetID(flt_,fleetname);
        ix_   = substStuff.sexID(x_);
        im_   = substStuff.matID(m_);
        is_   = substStuff.shellID(s_);
        d3_SizeComps_in(iZC).allocate(1,nSizeCompRows_in(iZC),-7,nSizeCompCols_in(iZC));
        gmacs_data << "#Year  Season  Stage1_EffN  DataVec" << endl;
        for (int rw=1;rw<=nSizeCompRows_in(iZC);rw++){
          //cout << "rw = " << rw << endl;
          (*pGD) >> d3_SizeComps_in(iZC,rw)(-7,-6);                   //--year, season
          gmacs_data << d3_SizeComps_in(iZC,rw)(-7,-6) <<" ";
          d3_SizeComps_in(iZC,rw)(-5) = iflt_;
          d3_SizeComps_in(iZC,rw)(-4) = ix_;
          d3_SizeComps_in(iZC,rw)(-3) = ict_;
          d3_SizeComps_in(iZC,rw)(-2) = is_;
          d3_SizeComps_in(iZC,rw)(-1) = im_;
          //cout<< "*" << d3_SizeComps_in(iZC,rw)(-5,-1) << "*" << endl;//fleet,sex,catch type,shell,maturity
          (*pGD) >> d3_SizeComps_in(iZC,rw)(0,nSizeCompCols_in(iZC)); //--the remainder
          gmacs_data << d3_SizeComps_in(iZC,rw)(0,nSizeCompCols_in(iZC)) << endl;
        }//--rw
      } //--iZC
      cout <<"finished reading new format size comps" << endl;
    } else {
      cout<<"Error in data file: fmtZCs_in should be 0 or 1, not "<<fmtZCs_in<<endl;
    }
  }
 END_CALCS

  3darray d3_obs_size_comps_in(1,nSizeComps_in,1,nSizeCompRows_in,1,nSizeCompCols_in);
  matrix size_comp_sample_size_in(1,nSizeComps_in,1,nSizeCompRows_in);
  matrix size_comp_year_in(1,nSizeComps_in,1,nSizeCompRows_in);
  matrix size_comp_season_in(1,nSizeComps_in,1,nSizeCompRows_in);

 LOC_CALCS
  for ( int kk = 1; kk <= nSizeComps_in; kk++ ) {
    dmatrix tmp = trans(d3_SizeComps_in(kk)).sub(1,nSizeCompCols_in(kk));
    d3_obs_size_comps_in(kk) = trans(tmp);
    size_comp_sample_size_in(kk) = column(d3_SizeComps_in(kk),0);
    size_comp_year_in(kk) = column(d3_SizeComps_in(kk),-7);
    size_comp_season_in(kk) = column(d3_SizeComps_in(kk),-6);
  }
  if (fmtZCs_in>0) gmacs_data << "# old format:" << endl;
  if (fmtZCs_in==0){
    ECHO(nSizeComps_in); WRITEDAT(nSizeCompRows_in); WRITEDAT(nSizeCompCols_in);
  }
  gmacs_data << "## Sex: 1 = male, 2 = female, 0 = both" << endl;
  gmacs_data << "## Type of catch: 1 = retained, 2 = discard, 0 = total" << endl;
  gmacs_data << "## Shell: 1 = newshell, 2 = oldshell, 0 = both" << endl;
  gmacs_data << "## Maturity: 1 = immature, 2 = mature, 0 = both" << endl;
  gmacs_data << "## Stage1_EffN: the stage-1 effective sample size (this can be modified in the CTL file)" << endl;
  gmacs_data << "# Year Season Fleet Sex Type Shell Maturity Stage1_EffN Data" << endl;
  float testtotal;
  for (int irow=1;irow<=nSizeComps_in; irow++)
   for (int jrow=1;jrow<=nSizeCompRows_in(irow);jrow++)
    if ( ((d3_SizeComps_in(irow,jrow,-7) <= nyrRetro) || (d3_SizeComps_in(irow,jrow,-7) == nyrRetro+1 && d3_SizeComps_in(irow,jrow,-6) == 1)) 
           && d3_SizeComps_in(irow,jrow,-7) >= syr)
     {
      if (fmtZCs_in>0) gmacs_data << "# ";
      gmacs_data << d3_SizeComps_in(irow,jrow) << " ";
      anystring = "# " + fleetname(d3_SizeComps_in(irow,jrow,-5));
      testtotal = 0;
      for (int ilen=1;ilen<=nSizeCompCols_in(irow);ilen++) testtotal += d3_SizeComps_in(irow,jrow,ilen);
      if (testtotal <=0)
       {
        cout << "Error: one of your rows of length data has no data (group " << irow << "; row "<< jrow << ")" << endl;
        exit(1);
       }
      int h = d3_SizeComps_in(irow,jrow,-4);
      if (h==0 && nSizeCompCols_in(irow) != nclass)
       {
        cout << "Error: the specified sex and the number of classes is mis-matched (group " << irow << "; row "<< jrow << ")" << endl;
        exit(1);
       }
      if (h!=0 && nSizeCompCols_in(irow) != nSizeSex(h))
       {
        cout << "Error: the specified sex and the number of classes is mis-matched (group " << irow << "; row "<< jrow << ")" << endl;
        exit(1);
       }

      if (d3_SizeComps_in(irow,jrow,-4)==UNDET_SEX)        anystring = anystring +"_male+female";
      if (d3_SizeComps_in(irow,jrow,-4)==MALES)            anystring = anystring +"_male";
      if (d3_SizeComps_in(irow,jrow,-4)==FEMALES)          anystring = anystring +"_female";
      if (d3_SizeComps_in(irow,jrow,-3)==TOTALCATCH)       anystring = anystring +"_total";
      if (d3_SizeComps_in(irow,jrow,-3)==RETAINED)         anystring = anystring +"_retained";
      if (d3_SizeComps_in(irow,jrow,-3)==DISCARDED)        anystring = anystring +"_discard";
      if (d3_SizeComps_in(irow,jrow,-2)==UNDET_SHELL)      anystring = anystring +"_all_shell";
      if (d3_SizeComps_in(irow,jrow,-2)==NEW_SHELL)        anystring = anystring +"_newshell";
      if (d3_SizeComps_in(irow,jrow,-2)==OLD_SHELL)        anystring = anystring +"_oldshell";
      if (d3_SizeComps_in(irow,jrow,-1)==UNDET_MATURE)     anystring = anystring +"_immature+mature";
      if (d3_SizeComps_in(irow,jrow,-1)==IMMATURE)         anystring = anystring +"_immature";
      if (d3_SizeComps_in(irow,jrow,-1)==MATURE)           anystring = anystring +"_mature";
      gmacs_data << anystring << endl;
     }
  ECHO(d3_obs_size_comps_in);
 END_CALCS

  // |-----------------------|
  // | GROWTH INCREMENT DATA |
  // |-----------------------|
  !! cout << " * Growth data" << endl;
  init_int GrowthObsType;                                  ///> Type of observation (increment or change in size-class)
  !! if (GrowthObsType != NOGROWTH_DATA && GrowthObsType != GROWTHINC_DATA && GrowthObsType != GROWTHCLASS_DATA && GrowthObsType != GROWTHCLASS_VALS)
  !!  { cout << "GrowthObsType can only be 0,1, 2 or 3; STOPPING" << endl; exit(1); }
  init_int nGrowthObs;                                     ///> Number of data points
  int NGrowthInputs;
  !!if (GrowthObsType==GROWTHINC_DATA) NGrowthInputs = 4; else NGrowthInputs = 8;
  !!if(GrowthObsType==GROWTHINC_DATA) gmacs_data << "## Size increments" << endl;
  !!if(GrowthObsType==GROWTHCLASS_DATA) gmacs_data << "## size-at-release, size-at-recaptures, and time-at-liberty" << endl;
  !!if(GrowthObsType==GROWTHCLASS_VALS) gmacs_data << "## size-class-at-release, sex, size-class-at-recapture, and time-at-liberty fleet recapture_year number" << endl;
  init_matrix dGrowthData(1,nGrowthObs,1,NGrowthInputs);

  vector dPreMoltSize(1,nGrowthObs);
  ivector iMoltIncSex(1,nGrowthObs);
  vector dMoltInc(1,nGrowthObs);
  vector dMoltIncCV(1,nGrowthObs);
  vector mle_alpha(1,nsex);
  vector mle_beta(1,nsex);
  ivector iMoltInitSizeClass(1,nGrowthObs);
  ivector iMoltEndSizeClass(1,nGrowthObs);
  ivector iMoltTimeAtLib(1,nGrowthObs);
  ivector iMoltTrans(1,nGrowthObs);
  ivector iMoltFleetRecap(1,nGrowthObs);
  ivector iMoltYearRecap(1,nGrowthObs);
  ivector iMoltSampSize(1,nGrowthObs);
  ivector MaxGrowTimeLibSex(1,nsex)
  !! MaxGrowTimeLibSex.initialize();
  int MaxGrowTimeLib;
  !! MaxGrowTimeLib = 0;
 LOC_CALCS
  if (GrowthObsType==GROWTHINC_DATA)
   {
    dPreMoltSize = column(dGrowthData,1);
    iMoltIncSex  = ivector(column(dGrowthData,2));
    dMoltInc     = column(dGrowthData,3);
    dMoltIncCV   = column(dGrowthData,4);

    dvector xybar(1,nsex);
    dvector xx(1,nsex);
    dvector xbar(1,nsex);
    dvector ybar(1,nsex);
    ivector nh(1,nsex);

    nh.initialize();
    xybar.initialize();
    xbar.initialize();
    ybar.initialize();
    xx.initialize();

    // MLE estimates for alpha and beta for the linear growth increment model.
    if ( nGrowthObs > 0 )
     {
      for ( int i = 1; i <= nGrowthObs; i++ )
       {
        int h = iMoltIncSex(i);
        nh(h)++;
        xybar(h) += dPreMoltSize(i) * dMoltInc(i);
        xbar(h)  += dPreMoltSize(i);
        ybar(h)  += dMoltInc(i);
        xx(h)    += square(dPreMoltSize(i));
       }
      for ( h = 1; h <= nsex; h++ )
       {
        xybar(h) /= nh(h);
        xbar(h) /= nh(h);
        ybar(h) /= nh(h);
        xx(h) /= nh(h);
        double slp = (xybar(h) - xbar(h)*ybar(h)) / (xx(h) - square(xbar(h)));
        double alp = ybar(h) - slp*xbar(h);
        mle_alpha(h) = alp;
        mle_beta(h) = -slp;
       }
     }
   }
  if (GrowthObsType==GROWTHCLASS_DATA)
   {
    int iclass;
    int h2;
    iMoltIncSex  = ivector(column(dGrowthData,2));
    iMoltTimeAtLib  = ivector(column(dGrowthData,4));
    iMoltTrans = ivector(column(dGrowthData,5));
    iMoltFleetRecap = ivector(column(dGrowthData,6));
    iMoltYearRecap = ivector(column(dGrowthData,7));
    iMoltSampSize = ivector(column(dGrowthData,8));
    for (int i = 1; i <= nGrowthObs; i++)
     {
      h2 = iMoltIncSex(i);
      iclass = -1;
      for (int j = 1; j <=nclass; j++)
       if (dGrowthData(i,1) >= size_breaks(j) &&  dGrowthData(i,1) < size_breaks(j+1)) iclass = j;
      iMoltInitSizeClass(i) = iclass;
      if (iclass == -1) { cout << "Error: release size out of range; row" << i << endl; exit(1); }
      iclass = -1;
      for (int j = 1; j <=nclass; j++)
       if (dGrowthData(i,3) >= size_breaks(j) &&  dGrowthData(i,3) < size_breaks(j+1)) iclass = j;
      iMoltEndSizeClass(i) = iclass;
      if (iclass == -1) { cout << "Error: recapture size out of range; row " << i << endl; exit(1); }
      if (iMoltEndSizeClass(i) < iMoltInitSizeClass(i)) { cout << "Error: recapture size less than recapture size; row " << i << endl; exit(1); }

      if (MaxGrowTimeLibSex(h2) < iMoltTimeAtLib(i)) MaxGrowTimeLibSex(h2) = iMoltTimeAtLib(i);
      if (MaxGrowTimeLib < iMoltTimeAtLib(i)) MaxGrowTimeLib = iMoltTimeAtLib(i);
     }
   }
  if (GrowthObsType==GROWTHCLASS_VALS)
   {
    int iclass;
    int h2;
    iMoltIncSex  = ivector(column(dGrowthData,2));
    iMoltTimeAtLib  = ivector(column(dGrowthData,4));
    iMoltTrans = ivector(column(dGrowthData,5));
    iMoltFleetRecap = ivector(column(dGrowthData,6));
    iMoltYearRecap = ivector(column(dGrowthData,7));
    iMoltSampSize = ivector(column(dGrowthData,8));
    for (int i = 1; i <= nGrowthObs; i++)
     {
      h2 = iMoltIncSex(i);
      iMoltInitSizeClass(i) = dGrowthData(i,1);
      if (iMoltInitSizeClass(i) < 1 || iMoltInitSizeClass(i) > nclass) { cout << "Error: release size out of range; row" << i << endl; exit(1); }
      iMoltEndSizeClass(i) = dGrowthData(i,3);
      if (iMoltEndSizeClass(i)  < 1 || iMoltEndSizeClass(i) >  nclass) { cout << "Error: recapture size less than recapture size; row " << i << endl; exit(1); }

      if (MaxGrowTimeLibSex(h2) < iMoltTimeAtLib(i)) MaxGrowTimeLibSex(h2) = iMoltTimeAtLib(i);
      if (MaxGrowTimeLib < iMoltTimeAtLib(i)) MaxGrowTimeLib = iMoltTimeAtLib(i);
     }
   }
  WRITEDAT(GrowthObsType); WRITEDAT(nGrowthObs);
  if(GrowthObsType==GROWTHINC_DATA) gmacs_data << "# Pre-molt_size Sex size-increment CV" << endl;
  if(GrowthObsType==GROWTHCLASS_DATA) gmacs_data << "# Size-at-release Sex Size-at-recapture Time-at-liberty fleet-at-recapture year-at-recapture sample_size" << endl;
  gmacs_data << dGrowthData << endl;
  if (GrowthObsType==GROWTHINC_DATA)
   {  ECHO(dPreMoltSize); ECHO(iMoltIncSex); ECHO(dMoltInc); ECHO(dMoltIncCV); }
  if (GrowthObsType==GROWTHCLASS_DATA)
   {  ECHO(iMoltIncSex);ECHO(iMoltInitSizeClass); ECHO(iMoltEndSizeClass); ECHO(iMoltTimeAtLib); ECHO(iMoltFleetRecap); ECHO(iMoltYearRecap); ECHO(iMoltSampSize);}
  if (GrowthObsType==GROWTHCLASS_VALS)
   {  ECHO(iMoltIncSex);ECHO(iMoltInitSizeClass); ECHO(iMoltEndSizeClass); ECHO(iMoltTimeAtLib); ECHO(iMoltFleetRecap); ECHO(iMoltYearRecap); ECHO(iMoltSampSize);}
 END_CALCS

  // |--------------------|
  // | ENVIRONMENTAL DATA |
  // |--------------------|
  !! cout << " * Environmental data" << endl;
  !! gmacs_data << endl << "# Environmental data" << endl;
   init_int fmtEIs_in;                                           ///> environmental indices format flag (0=old style, 1=new style)
  !! ECHO(fmtEIs_in)
  !! gmacs_data << fmtEIs_in << "   #--format flag (0=old style, 1=new style)" << endl;
  init_int NenvIndics;                                  ///> Number of environmental indices
  !! ECHO(NenvIndics)
  !! gmacs_data << NenvIndics << "   #--number of environmental indices " << endl;
  imatrix EnvYrs(1,NenvIndics,1,2);
  adstring_array strEIs;
  int NenvData;
  matrix EnvDataInp; 
  matrix EnvData(syr,nyr,1,NenvIndics);
 LOCAL_CALCS
  if (NenvIndics>0) {
    strEIs.allocate(1,NenvIndics);
    EnvData.initialize();
    cifstream* pGD = ad_comm::global_datafile;
    NenvData = 0;
    if (fmtEIs_in==0){
      gmacs_data << "# Year range" << endl;
      for (int i=1;i<=NenvIndics;i++) {
        (*pGD) >> EnvYrs(i);//--start year, end year
        gmacs_data << EnvYrs(i) << endl;
        strEIs(i) = str(i);
        NenvData += EnvYrs(i)(2)-EnvYrs(i)(1)+1;
      }
      ECHO(EnvYrs)
      EnvDataInp.allocate(1,NenvData,1,3); 
      gmacs_data << "# index year value" << endl;
      for (int i=1;i<=NenvData;i++){
        (*pGD) >> EnvDataInp(i);//--index number, year, value
        gmacs_data << EnvDataInp(i) << endl;
        EnvData((int)EnvDataInp(i,2),(int) EnvDataInp(i,1)) = EnvDataInp(i,3);
      }//--i loop
    } else {
      int idx = -1;
      gmacs_data << "# index start_year end_year  name" << endl;
      for (int i=1;i<=NenvIndics;i++) {
        (*pGD) >> idx;      //--index number
        (*pGD) >> EnvYrs(i);//--start year, end year
        (*pGD) >> strEIs(i);//--index name
        gmacs_data << idx << " " << EnvYrs(i) << " " << strEIs(i) << endl;
        NenvData += EnvYrs(i)(2)-EnvYrs(i)(1)+1;
      }
      ECHO(EnvYrs)
      EnvDataInp.allocate(1,NenvData,1,3); 
      adstring strEI;
      gmacs_data << "# index year value  name" << endl;
      for (int i=1;i<=NenvData;i++){
        (*pGD) >> EnvDataInp(i);//--index number, year, value
        (*pGD) >> strEI;        //--index name
        gmacs_data << EnvDataInp(i) << " " << strEI << endl;
        if (strEI != strEIs[EnvDataInp(i,1)]) {
          cout<<"Mismatch in EI index number and name for row " << i << endl;
          ad_exit(-1);
        }
        EnvData((int)EnvDataInp(i,2),(int) EnvDataInp(i,1)) = EnvDataInp(i,3);
      }//--i loop
    }
  }//--if NenvIndics > 0
 END_CALCS

  // |------------------|
  // | END OF DATA FILE |
  // |------------------|
  init_int eof;
  !! gmacs_data << "# eof" << endl;
  !! gmacs_data << eof << endl;
  !! if ( eof != 9999 ) {cout << "EOF not '9999'. Error reading data" << endl; exit(1);}
  !! cout << "end of data section" << endl;

  // Integer pass variables
  ivector isizeTrans_pass(1,nsex);


// ================================================================================================
// ================================================================================================
  //--read control file
  // |----------------------------|
  // | LEADING PARAMETER CONTROLS |
  // |----------------------------|
  !! ad_comm::change_datafile_name(controlfile);
  !! cout << "+----------------------+" << endl;
  !! cout << "| Reading control file |" << endl;
  !! cout << "+----------------------+" << endl;
  !! ECHOSTR("+----------------------+");
  !! ECHOSTR("| Reading control file |");
  !! ECHOSTR("+----------------------+");
  !! gmacs_ctl << TheHeader << endl << endl;

  // |---------------------------------------------------------|
  // | BLOCK SET UP                                            |
  // |---------------------------------------------------------|

  !! echoinput << "# Block structure" << endl;
  !! gmacs_ctl << "# Block structure" << endl;
  !! echoinput << "# Number of block groups" << endl;
  !! gmacs_ctl << "# Number of block groups" << endl;
  init_int nblocks
  !! echoinput << nblocks << endl;
  !! gmacs_ctl << nblocks << endl;
  int maxblocks;
  !! gmacs_ctl << "# Block structure (number of blocks per block group)" << endl;
  !! echoinput << "# Block structure (number of blocks per block group)" << endl;
  ivector blocks(0,nblocks);
  !! blocks(0) = 1; maxblocks = 1;
  !! for (int ii=1;ii<=nblocks;ii++) 
  !! { 
  !!  *(ad_comm::global_datafile) >> blocks(ii); if (blocks(ii) > maxblocks) maxblocks = blocks(ii); 
  !!  gmacs_ctl <<  blocks(ii) << " # block group " << ii << endl; 
  !!  echoinput <<  blocks(ii) << " # block group " << ii << endl;
  !! }

  !! gmacs_ctl << "# The blocks" << endl;
  !! echoinput << "# The blocks" << endl;
  3darray blocklimits(0,nblocks,0,maxblocks,1,2);
  !! blocklimits(0,0,1) = syr; blocklimits(0,0,2) = nyrRetro;
  !! for (int ii=1;ii<=nblocks;ii++) 
  !!  {
  !!   gmacs_ctl << "#Block " << ii << ": "<< endl;
  !!   for (int j=1;j<=blocks(ii);j++)
  !!    {
  !!     *(ad_comm::global_datafile) >> blocklimits(ii,j,1) ;
  !!     *(ad_comm::global_datafile) >> blocklimits(ii,j,2); if (blocklimits(ii,j,2)==0) blocklimits(ii,j,2) = nyrRetro; 
  !!     echoinput << blocklimits(ii,j,1) << " " << blocklimits(ii,j,2) << " # block_group_"<< ii << "_block_" << j << endl;
  !!     gmacs_ctl << blocklimits(ii,j,1) << " " << blocklimits(ii,j,2) << " # block_group_"<< ii << "_block_" << j << endl;
  !!    }
  !!    blocklimits(ii,0,1) = syr; blocklimits(ii,0,2) = blocklimits(ii,1,1)-1;
  //!!    gmacs_ctl << endl; echoinput << endl;  
  !!  }
  !! ECHO(nblocks);
  !! ECHO(blocks);
  !! ECHO(maxblocks);
  !! ECHO(blocklimits);

  // |---------------------------------------------------------|
  // | GENERAL CTL DECLARATION                                 |
  // |---------------------------------------------------------|
  int PPnt;
  !! PPnt;

  int n_deviations;
  int n_devvars;
  !! n_devvars=0;
  imatrix devpoints(1,100,1,10);
  matrix rdevpoints(1,100,1,5);
  !! devpoints.initialize();

  // |---------------------------------------------------------|
  // | GENERAL CONTROLS                                        |
  // |---------------------------------------------------------|
  !! cout << " * General controls" << endl;
  !! ECHOSTR(" * General controls");
  init_vector model_controls(1,17);
  int rdv_syr;                                             ///> First year of estimates devs
  int rdv_eyr;                                             ///> First year of estimates devs
  int Term_molt;                                           ///> Consider terminal molting?
  int rdv_phz;                                             ///> Estimated rec_dev phase

  int bInitializeUnfished;                                 ///> Flag to initialize population size structure
  int Refclass;                                            ///> Reference class for calculation of initial conditions
  int bSteadyState;                                        ///> Variable to store option related to initial state
  number spr_lambda;                                       ///> Proportion of mature male biomass for MMB
  int nSRR_flag;                                           ///> if nSRR_flag == 1 then use a Beverton-Holt model to compute the recruitment deviations for minimization.
  int rec_prop_phz;                                        ///> Phase for sex ratios
  int ntheta;                                              ///> Number of theta parameters
  number init_sex_ratio;                                   ///> Sex ratio input
  int BRP_rec_sexR;                                        ///> Way average recruitment for reference points is calculated (0= used the End year - 1=Use an average sex ratio) 
  int NyrEquil;                                            ///> Number of years to project when computing equilbria
  int devParPhase;                                         ///> Phase for the deviation parameters 
  int bias1;                                               ///> First year of bias-correction
  int bias2;                                               ///> First full bias-correction
  int bias3;                                               ///> Last full bias-correction
  int bias4;                                               ///> Last year of bias-correction
  vector Rec_bias(syr,nyr);
 
 LOC_CALCS
  {
  rdv_syr             = int(model_controls(1));
  if (rdv_syr == 0) rdv_syr = syr;                         ///> Default value for start year
  if ( rdv_syr < syr )
   {
     cout << "Error: recruitment cannot be estimated before start year" << endl;//NOTE: could set phases to -1
     exit(1);
   }
  model_controls(2) -= (nyr-nyrRetro);
  rdv_eyr             = int(model_controls(2));
  if ( rdv_eyr < rdv_syr )
   {
     cout << "Error: end recruitment year must be AFTER start recruitment year" << endl;
     exit(1);
   }
  if ( rdv_eyr > nyr )
   {
     cout << "Error: recruitment cannot be estimated after end year" << endl;//NOTE: could set phases to -1
     exit(1);
   }
  Term_molt           = int(model_controls(3));	
  if (Term_molt==1 && nmature==1)
   {
    cout << "Error: terminal molt requires two maturity partitions" << endl;
    exit(1);
   }
  rdv_phz             = int(model_controls(4));
  if (nsex==1) rec_prop_phz = -1; else rec_prop_phz = int(model_controls(5));
  init_sex_ratio = model_controls(6);
  init_sex_ratio = -1.0*log((1.0-init_sex_ratio)/init_sex_ratio);

  bInitializeUnfished = int(model_controls(7));
  Refclass            = int(model_controls(8));
  spr_lambda          = model_controls(9);
  nSRR_flag           = int(model_controls(10));
  BRP_rec_sexR        = int(model_controls(11));
  NyrEquil            = int(model_controls(12));
  devParPhase         = int(model_controls(13));  
  bias1               = int(model_controls(14));  
  bias2               = int(model_controls(15));  
  bias3               = int(model_controls(16));  
  bias4               = int(model_controls(17));  
  
  for (int Iy=syr;Iy<=nyr;Iy++)
   if (Iy <= bias1)
    Rec_bias(Iy) = 0;
   else
    if (Iy <= bias2)
     Rec_bias(Iy) = (float(Iy)-bias1)/(bias2-bias1);
    else
     if (Iy <= bias3)
      Rec_bias(Iy) = 1.0;
     else
      if (Iy <= bias4)
       Rec_bias(Iy) = 1.0-(float(Iy)-bias3)/(bias4-bias3);
      else
       Rec_bias(Iy) = 0;
     
  gmacs_ctl << endl << "##  ------------------------------------------------------------------------------------ ##" << endl;
  gmacs_ctl << "##  OTHER  CONTROLS" << endl;
  gmacs_ctl << "##  ------------------------------------------------------------------------------------ ##" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(1)) << " # First year of recruitment estimation" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(2)) << " # Last year of recruitment estimation" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(3)) << " # Consider terminal molting (0 = off, 1 = on). If on, the calc_stock_recruitment_relationship() isn't called in the procedure" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(4)) << " # Phase for recruitment estimation" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(5)) << " # Phase for recruitment sex-ratio estimation" << endl;
  gmacs_ctl << setw(4) << setprecision(2) << setfixed()<< model_controls(6) << " # Initial value for recruitment sex-ratio" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(7)) << " # Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters, 3 = Free parameters (revised))" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(8)) << " # Reference size-class for initial conditons = 3" << endl;
  gmacs_ctl << setw(4) << setprecision(2) << setfixed()<< model_controls(9) << " # Lambda (proportion of mature male biomass for SPR reference points)" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(10)) << " # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(11)) << " # Use years specified to computed average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(12)) << " # Years to compute equilibria" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(13)) << " # Phase for deviation parameters" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(14)) << " # First year of bias-correction" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(15)) << " # First full bias-correction" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(16)) << " # Last full bias-correction" << endl;
  gmacs_ctl << setw(4) << setfixed()<< int(model_controls(17)) << " # Last year of bias-correction" << endl;
  gmacs_ctl << endl;
  echoinput << endl << "# Extra controls" << endl;
  echoinput << model_controls(1) << " # First year of recruitment estimation" << endl;
  echoinput << model_controls(2) << " # Last year of recruitment estimation" << endl;
  echoinput << model_controls(3) << " # Consider terminal molting (0 = off, 1 = on). If on, the calc_stock_recruitment_relationship() isn't called in the procedure" << endl;
  echoinput << model_controls(4) << " # Phase for recruitment estimation" << endl;
  echoinput << model_controls(5) << " # Phase for recruitment sex-ratio estimation" << endl;
  echoinput << model_controls(6) << " # Initial value for recruitment sex-ratio" << endl;
  echoinput << model_controls(7) << " # Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters, 3 = Free parameters (revised))" << endl;
  echoinput << model_controls(8) << " # Reference size-class for initial conditons = 3" << endl;
  echoinput << model_controls(9) << " # Lambda (proportion of mature male biomass for SPR reference points)" << endl;
  echoinput << model_controls(10) << " # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)" << endl;
  echoinput << model_controls(11) << " # Use years specified to computed average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)" << endl;
  echoinput << model_controls(12) << " # Years to compute equilibria" << endl;
  echoinput << model_controls(13) << " # Phase for deviation parameters" << endl;
  echoinput << model_controls(14) << " # First year of bias-correction" << endl;
  echoinput << model_controls(15) << " # First full bias-correction" << endl;
  echoinput << model_controls(16) << " # Last full bias-correction" << endl;
  echoinput << model_controls(17) << " # Last year of bias-correction" << endl;
  echoinput << endl;

  // Default number of parameters
  ntheta = 3 + 2*nsex + 3;
  
  int Jpnt;
  int Kpnt;
  Jpnt = 1;
  parname1(Jpnt) = "Log(R0)";
  parname1(Jpnt+1) = "Log(Rinitial)";
  parname1(Jpnt+2) = "Log(Rbar)";
  parname1(Jpnt+3) = "Recruitment_ra-males";
  parname1(Jpnt+4) = "Recruitment_rb-males";
  Jpnt = Jpnt + 5;
  if (nsex>1)
   {
    parname1(Jpnt) = "Recruitment_ra-females";
    parname1(Jpnt+1) = "Recruitment_rb-females";
    Jpnt += 2;
   }
  parname1(Jpnt) = "log(SigmaR)";
  parname1(Jpnt+1) = "Steepness";
  parname1(Jpnt+2) = "Rho";
  Jpnt = Jpnt + 2;
  PPnt = Jpnt;

  int nthetatest;
  nthetatest = 0;
  if (bInitializeUnfished == FISHEDEQN)      nthetatest = nfleet;
  if (bInitializeUnfished == FREEPARS)       nthetatest = nclass*nsex*nmature*nshell;
  if (bInitializeUnfished == FREEPARSSCALED) nthetatest = (nclass*nsex*nmature*nshell-1);
  ntheta += nthetatest;
  cout << "Expecting " << ntheta << " theta parameters" << endl;
  gmacs_ctl << "# Expecting " << ntheta << " theta parameters" << endl;
  echoinput << "Expecting " << ntheta<< " theta parameters" << endl;
  echoinput << "Thetas" << endl;
  echoinput << 3 << " for log(R0), log(Rini), and log(Rbar)" << endl;
  echoinput << 2*nsex << " for the recruitment distribution parameters" << endl;
  echoinput << 3 << " for log(sigmaR), steepness and recruitment autocorrelation" << endl;
  echoinput << nthetatest << " for the parameters to define the initial size-structure" << endl;
  echoinput << endl;
  
  // Estimate initial numbers as absolute
  if ( bInitializeUnfished == FREEPARS )
   {
    int Ipnt = 0;
    for ( int h = 1; h <= nsex; h++ )
     for ( int m = 1; m <= nmature; m++ )
      for ( int o = 1; o <= nshell; o++ )
       {
        int Ihmo = pntr_hmo(h,m,o);
        for ( int l = 1; l <= nclass; l++ )
         {
          Ipnt += 1;
          anystring = "Initial_logN_for_sex_"+sexes(h)+"_mature_"+maturestate(m)+"_"+shellstate(o)+"shell_class_"+str(l);
          parname1(Jpnt+Ipnt) = anystring;
         }
       }
     PPnt += Ipnt;
   }
   
  // Estimate initial numbers as logistic offsest
  if ( bInitializeUnfished == FREEPARSSCALED )
   {
    int Ipnt = 0; Kpnt = 0;
    for ( int h = 1; h <= nsex; h++ )
     for ( int m = 1; m <= nmature; m++ )
      for ( int o = 1; o <= nshell; o++ )
       {
        int Ihmo = pntr_hmo(h,m,o);
        for ( int l = 1; l <= nclass; l++ )
         {
          if (Kpnt!=Refclass-1)
           { 
            Ipnt += 1;
            anystring = "Scaled_logN_for_"+sexes(h)+"_mature_"+maturestate(m)+"_"+shellstate(o)+"shell_class_"+str(l);
            parname1(Jpnt+Ipnt) = anystring;
           }
          Kpnt += 1; 
         }  
       }
    PPnt += Ipnt;
   }
  }
 END_CALCS


  !! cout << " * Key parameter controls" << endl;
  !! ECHOSTR(" * Key parameter controls");
  init_matrix theta_control(1,ntheta,1,7);                 ///> The specifications for the controls
  !! gmacs_ctl << "# Core parameters" << endl;
  !! gmacs_ctl << "## Initial: Initial value for the parameter (must lie between lower and upper)" << endl;
  !! gmacs_ctl << "## Lower & Upper: Range for the parameter" << endl;
  !! gmacs_ctl << "## Phase: Set equal to a negative number not to estimate" << endl;
  !! gmacs_ctl << "## Prior type:"  << endl;
  !! gmacs_ctl << "## 0: Uniform   - parameters are the range of the uniform prior"  << endl;
  !! gmacs_ctl << "## 1: Normal    - parameters are the mean and sd" << endl;
  !! gmacs_ctl << "## 2: Lognormal - parameters are the mean and sd of the log" << endl;
  !! gmacs_ctl << "## 3: Beta      - parameters are the two beta parameters [see dbeta]" << endl;
  !! gmacs_ctl << "## 4: Gamma     - parameters are the two gamma parameters [see dgamma]" << endl;
  !! gmacs_ctl << "# Initial_value    Lower_bound    Upper_bound Phase Prior_type        Prior_1        Prior_2" << endl;
  !! for (int i=1;i<=ntheta;i++) {
  !!    gmacs_ctl << setw(15) << setprecision(8) <<  setfixed() << theta_control(i,1) << " ";
  !!    gmacs_ctl << setw(14) << setprecision(8) <<  setfixed() << theta_control(i,2) << " ";
  !!    gmacs_ctl << setw(14) << setprecision(8) <<  setfixed() << theta_control(i,3) << " ";
  !!    gmacs_ctl << setw(5) << setfixed() << (int) theta_control(i,4) << " ";
  !!    gmacs_ctl << setw(10) << setfixed() << (int) theta_control(i,5) << " ";
  !!    gmacs_ctl << setw(14) << setprecision(8) << setfixed() << theta_control(i,6) << " ";
  !!    gmacs_ctl << setw(14) << setprecision(8) << setfixed() << theta_control(i,7) << " # " << parname1(i) << endl;
  !! }
  vector theta_ival(1,ntheta);
  vector theta_lb(1,ntheta);
  vector theta_ub(1,ntheta);
  ivector theta_phz(1,ntheta);
  ivector prior_theta_type(1,ntheta);
  vector prior_theta_p1(1,ntheta);
  vector prior_theta_p2(1,ntheta);
  
 LOC_CALCS
  theta_ival = column(theta_control,1);
  theta_lb   = column(theta_control,2);
  theta_ub   = column(theta_control,3);
  theta_phz  = ivector(column(theta_control,4));
  prior_theta_type = ivector(column(theta_control,5));
  prior_theta_p1   = column(theta_control,6);
  prior_theta_p2   = column(theta_control,7);

  // If a uniform prior is specified then use the lb and ub rather than p1 and p2.
  for (int ipar=1;ipar<=ntheta;ipar++)
   if ( prior_theta_type(ipar) == UNIFORM_PRIOR )
   { prior_theta_p1(ipar) = theta_lb(ipar);  prior_theta_p2(ipar) = theta_ub(ipar);  }


  // Some combinations of options don't work
  if ( bInitializeUnfished == UNFISHEDEQN && theta_phz(2) > 0 )
   { cout << "Error: cannot estimate LogRini when unfished steady state is selected" << endl;  exit(1); }
  if ( bInitializeUnfished == FISHEDEQN && theta_phz(1) > 0 )
   { cout << "Error: cannot estimate LogR0 when fished steady state is selected" << endl;  exit(1); }
  if ( bInitializeUnfished == FREEPARS && theta_phz(1) > 0 )
   {
    cout << "Error: cannot estimate LogR0 when individual parameters are estimated" << endl;
    exit(1);
   }
  if ( bInitializeUnfished == FREEPARS && theta_phz(2) > 0 )
   {
    cout << "Error: cannot estimate LogRini when individual parameters are estimated" << endl;
    exit(1);
   }
 END_CALCS


  // |-------------------|
  // | CUSTOM INPUT DATA |
  // |-------------------|

  // |-----------|
  // | ALLOMETRY |
  // |-----------|
  !! cout << " * Allometry" << endl;
  !! ECHOSTR(" * Allometry");
  init_int lw_type;               ///> length-weight type/method (i.e. provide parameters or a vector)
  !! gmacs_ctl << endl << " ##Allometry" << endl;
  !! gmacs_ctl << "# weight-at-length input  method  (1 = allometry  [w_l = a*l^b],  2 = vector by sex; 3= matrix by sex)" << endl;
  !! gmacs_ctl << lw_type << endl;
  !! if (lw_type < 1 || lw_type > 3)
  !!  { cout << "length-weight type can only be 1,2 or 3; STOPPING" << endl; 
  !!    gmacs_ctl <<  "length-weight type can only be 1,2 or 3; STOPPING" << endl;
  !!    exit(1); }
  int lw_dim;
  int lw_dim2;
 LOC_CALCS
  lw_dim = nsex*nmature;
  if ( lw_type == LW_MATRIX ) lw_dim = nsex*nmature * (nyr+1 - syr + 1);
  ECHO(lw_dim);
  lw_dim2 = nsex*nmature;
  if ( lw_type == LW_MATRIX ) lw_dim2 = nsex*nmature * (nyrRetro+1 - syr + 1);
  ECHO(lw_dim2);
 END_CALCS
  matrix lw_alfa(1,nsex,1,nmature);
  matrix lw_beta(1,nsex,1,nmature);
  matrix mean_wt_in(1,lw_dim,1,nclass);
  4darray mean_wt(1,nsex,1,nmature,syr,nyrRetro+1,1,nclass);         ///> Ultimate array for this

 LOC_CALCS
  if (lw_type==LW_RELATIONSHIP)
   {
    WriteCtlStr("Using LW_RELATIONSHIP. Parameters are:");
    for (int h=1;h<=nsex;h++) { 
      for (int m=1;m<=nmature;m++) {
        *(ad_comm::global_datafile) >> lw_alfa(h,m);
        *(ad_comm::global_datafile) >> lw_beta(h,m);
        echoinput << lw_alfa(h,m) << " " << lw_beta(h,m) << " #--" << endl;
        gmacs_ctl << lw_alfa(h,m) << " " << lw_beta(h,m) << " #--" << endl;
      }
    }
    //ECHO(lw_alfa); ECHO(lw_beta);
    //WriteCtl(lw_alfa); WriteCtl(lw_beta);
   }
  if (lw_type==LW_VECTOR || lw_type==LW_MATRIX)
   {
    for (int I=1;I<=lw_dim;I++)
     for ( int l = 1; l <= nclass; l++ ) *(ad_comm::global_datafile) >> mean_wt_in(I,l);
    ECHOSTR("# Using LW_VECTOR or LW_MATRIX. mean_wt_in:");
    for (int I=1;I<=lw_dim2;I++)
     {
      echoinput << mean_wt_in(I) << endl;
      gmacs_ctl << setw(14) << setprecision(8) <<  setfixed() << mean_wt_in(I) << endl;
     }
   }
  mid_points = size_breaks(1,nclass) + 0.5 * first_difference(size_breaks);
  int ctr;
  switch ( lw_type )
   {
    // allometry
    case LW_RELATIONSHIP:
     for ( int h = 1; h <= nsex; h++ )
      for ( int m = 1; m <= nmature; m++)
       for ( int i = syr; i <= nyrRetro+1; i++ )
        mean_wt(h,m,i) = lw_alfa(h,m) * pow(mid_points, lw_beta(h,m));
     break;
    // vector by sex
    case LW_VECTOR:
     ctr = 0;
     for ( int h = 1; h <= nsex; h++ )
      for ( int m = 1; m <= nmature; m++)
       {
        ctr++;
        for ( int i = syr; i <= nyrRetro+1; i++ )
         for ( int l = 1; l <= nclass; l++ )  mean_wt(h,m,i,l) = mean_wt_in(ctr,l);
       } // --h and m
     break;
    // matrix by sex

    case LW_MATRIX:
     ctr = 0;
     for ( int h = 1; h <= nsex; h++ )
      for ( int m = 1; m <= nmature; m++)
       for ( int i = syr; i <= nyrRetro+1; i++ ){
        ctr++;
        for ( int l = 1; l <= nclass; l++ )
         mean_wt(h,m,i,l) = mean_wt_in(ctr,l);
       } // --h, m and i
     break;
   }
  ECHO(mean_wt);
 END_CALCS

  // |-----------------------------------|
  // | FECUNDITY FOR MMB/MMA CALCULATION |
  // |-----------------------------------|
  !! cout << " * Maturity definition" << endl;
  init_matrix maturity(1,nsex,1,nclass);
  !! gmacs_ctl << "# Proportion mature by sex and size" << endl;
  !! gmacs_ctl << maturity << endl;
  !! cout << " * Legal definition" << endl;
  !! gmacs_ctl << "# Proportion legal by sex and size" << endl;
  init_matrix legal(1,nsex,1,nclass);
  !! gmacs_ctl << legal << endl;
  
  // --------------------------------------------------------------------------------------------------------------------------------------
  // |----------------------------|
  // | GROWTH PARAMETER CONTROLS  |
  // |----------------------------|
  !! cout << " * Growth parameter controls" << endl;
  !! gmacs_ctl << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## GROWTH PARAMETER CONTROLS                                                            ##" << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## " << endl;
 
  init_ivector nSizeClassRec(1,nsex);                      ///> Maximum of size-classes to which recruitment must occur
  !! gmacs_ctl << "# Maximum number of size-classes to which recruitment must occur" << endl;
  !! gmacs_ctl <<nSizeClassRec << endl;
  !! ECHO(nSizeClassRec );
  
  init_int use_func_mat;
  !! gmacs_ctl << "# Use functional maturity for terminally molting animals (0=no; 1=Yes)?" << endl;
  !! gmacs_ctl << use_func_mat << endl;
  !! ECHO(use_func_mat);

  ivector bUseCustomGrowthMatrix2(1,nsex);                                         // Option for the growth/size-transition matrix
  ivector bUseGrowthIncrementModel2(1,nsex);                                       // Option for molt increment
  ivector bUseCustomMoltProbability2(1,nsex);                                      // Option for molt probability
  ivector bUseCustomMatureProbability2(1,nsex);                                    // Option for probability of maturing
  !! bUseCustomGrowthMatrix2.initialize();
  !! bUseGrowthIncrementModel2.initialize();
  !! bUseCustomMoltProbability2.initialize();
  !! bUseCustomMatureProbability2.initialize();

  imatrix Growth_controls(1,3*nsex,1,3);
  !! Growth_controls.initialize();
  !! gmacs_ctl << "# Growth transition" << endl;
  !! echoinput << "# Growth transition" << endl;
  !! gmacs_ctl << "##Type_1: Options for the growth matrix" << endl;
  !! gmacs_ctl << "#  1: Pre-specified growth transition matrix (requires molt probability)" << endl;
  !! gmacs_ctl << "#  2: Pre-specified size transition matrix (molt probability is ignored)" << endl;
  !! gmacs_ctl << "#  3: Growth increment is gamma distributed (requires molt probability)" << endl;
  !! gmacs_ctl << "#  4: Post-molt size is gamma distributed (requires molt probability)" << endl;
  !! gmacs_ctl << "#  5: Von Bert.: kappa varies among individuals (requires molt probability)" << endl;
  !! gmacs_ctl << "#  6: Von Bert.: Linf varies among individuals (requires molt probability)" << endl;
  !! gmacs_ctl << "#  7: Von Bert.: kappa and Linf varies among individuals (requires molt probability)" << endl;
  !! gmacs_ctl << "#  8: Growth increment is normally distributed (requires molt probability)" << endl;
  !! gmacs_ctl << "## Type_2: Options for the growth increment model matrix" << endl;
  !! gmacs_ctl << "#  1: Linear" << endl;
  !! gmacs_ctl << "#  2: Individual" << endl;
  !! gmacs_ctl << "#  3: Individual (Same as 2)" << endl;
  !! gmacs_ctl << "#  4: Power law for mean post-molt size" << endl;
  !! gmacs_ctl << "#  Block: Block number for time-varying growth   " << endl;
  !! gmacs_ctl << "## Type_1 Type_2  Block" << endl;
  !! echoinput << "## Type_1 Type_2  Block" << endl;
  !! for (int ig=1;ig<=nsex;ig++) *(ad_comm::global_datafile) >> Growth_controls(ig); 
  !!  for (int ig=1;ig<=nsex;ig++) { gmacs_ctl << "   "; for (int ii=1;ii<=3;ii++) gmacs_ctl << setw(6) << setfixed() << Growth_controls(ig,ii) << " "; gmacs_ctl << endl; }
  !! for (int ig=1;ig<=nsex;ig++) echoinput << Growth_controls(ig) << endl;
  !! for (int ig=1;ig<=nsex;ig++) 
  !!  {
  !!   bUseCustomGrowthMatrix2(ig) = Growth_controls(ig,1);
  !!   if (bUseCustomGrowthMatrix2(ig) < 1 || bUseCustomGrowthMatrix2(ig) > 8)
  !!    { cout << "growth matrix type can only be 1-8; STOPPING" << endl; exit(1); }
  !!   }
  !! for (int ig=1;ig<=nsex;ig++) 
  !!   {
  !!    bUseGrowthIncrementModel2(ig) = Growth_controls(ig,2);
  !!    if (bUseCustomGrowthMatrix2(ig) == GROWTH_VARYK) bUseGrowthIncrementModel2(ig) = GROWTH_VARYK;
  !!    if (bUseCustomGrowthMatrix2(ig) == GROWTH_VARYLINF) bUseGrowthIncrementModel2(ig) = GROWTH_VARYLINF;
  !!    if (bUseCustomGrowthMatrix2(ig) == GROWTH_VARYKLINF) bUseGrowthIncrementModel2(ig) = GROWTH_VARYKLINF;
  !!   }
 
  !! gmacs_ctl << "# Molt probability" << endl;
  !! echoinput << "# Molt probability" << endl;
  !! gmacs_ctl << "# Type: Options for the molt probability function" << endl;
  !! gmacs_ctl << "#  0: Pre-specified" << endl;
  !! gmacs_ctl << "#  1: Constant at 1" << endl;
  !! gmacs_ctl << "#  2: Logistic" << endl;
  !! gmacs_ctl << "#  3: Individual" << endl;
  !! gmacs_ctl << "#  Block: Block number for time-varying growth   " << endl;
  !! gmacs_ctl << "## Type Block" << endl;
  !! echoinput << "## Type Block" << endl;
  !! for (int ig=1;ig<=nsex;ig++) 
  !! { *(ad_comm::global_datafile) >> Growth_controls(nsex+ig,1) >> Growth_controls(nsex+ig,3); }
  !! for (int ig=1;ig<=nsex;ig++) 
  !!    { gmacs_ctl << "  " << setw(5) << setfixed() << Growth_controls(nsex+ig,1) << " " << setw(5) << setfixed() << Growth_controls(nsex+ig,3) << " "; gmacs_ctl << endl; }
  !! for (int ig=1;ig<=nsex;ig++) 
  !! { echoinput << Growth_controls(nsex+ig,1) << " " << Growth_controls(nsex+ig,3) << " "; echoinput << endl; }
  !! for (int ig=1;ig<=nsex;ig++) 
  !!  {
  !!   bUseCustomMoltProbability2(ig) = Growth_controls(ig+nsex,1);
  !!   if (bUseCustomGrowthMatrix2(ig) == GROWTH_FIXEDSIZETRANS && bUseCustomMoltProbability2(ig) != CONSTANT_PROB_MOLT)
  !!    { cout << "If a custom size transition matrix is provided, the probability of molting must be set constant and equal to 1; STOPPING" << endl; exit(1); }
  !!  }
  
  !! if (nmature==2)
  !!  {
  !!   gmacs_ctl << "# Mature probability" << endl;
  !!   gmacs_ctl << "# Type: Options for the mature probability function" << endl;
  !!   gmacs_ctl << "#  0: Pre-specified" << endl;
  !!   gmacs_ctl << "#  1: Constant at 1" << endl;
  !!   gmacs_ctl << "#  2: Logistic" << endl;
  !!   gmacs_ctl << "#  3: Individual" << endl;
  !!   gmacs_ctl << "# Block: Block number for time-varying growth   " << endl;
  !!   gmacs_ctl << "## Type Block" << endl;
  !!   echoinput << "## Type Block" << endl;
  !!   for (int ig=1;ig<=nsex;ig++) 
  !!    { *(ad_comm::global_datafile) >> Growth_controls(2*nsex+ig,1)>> Growth_controls(2*nsex+ig,3); }
  !!   for (int ig=1;ig<=nsex;ig++) 
  !!    { gmacs_ctl << "  " << setw(5) << setfixed() << Growth_controls(2*nsex+ig,1) << " " << setw(5) << setfixed() << Growth_controls(2*nsex+ig,3) << " "; gmacs_ctl << endl; }
  !!   for (int ig=1;ig<=nsex;ig++) 
  !!    { echoinput << Growth_controls(2*nsex+ig,1) << " " << Growth_controls(2*nsex+ig,3) << " "; echoinput << endl; }
  !!   for (int ig=1;ig<=nsex;ig++) 
  !!    {
  !!     bUseCustomMatureProbability2(ig) = Growth_controls(ig+2*nsex,1);
  !!    }
  !!  } //-- if (nmature==2)
  !!  echoinput << "Growth_controls\n" << Growth_controls << endl;

  int n_Gpar;
  ivector nparGs(1,3*nsex)
  ivector G_block(1,3*nsex);
  vector G_RW_sigma(1,3*nsex);
 LOC_CALCS
  n_Gpar = 0; int nparG; nparGs.initialize();
  G_block    = column(Growth_controls,3);
  for (int ig=1;ig<=3*nsex;ig++)
   {
    nparG = 0;
    if (ig <= nsex)
     {
      if (bUseGrowthIncrementModel2(ig)==LINEAR_GROWTHMODEL)      nparG = 3;
      if (bUseGrowthIncrementModel2(ig)==PWRLAW_GROWTHMODEL)      nparG = 3;
      if (bUseGrowthIncrementModel2(ig)==INDIVIDUAL_GROWTHMODEL1) nparG = (nclass+1);
      if (bUseGrowthIncrementModel2(ig)==INDIVIDUAL_GROWTHMODEL2) nparG = (nclass+1);
      if (bUseGrowthIncrementModel2(ig)==GROWTH_VARYK)            nparG = 3;
      if (bUseGrowthIncrementModel2(ig)==GROWTH_VARYLINF)         nparG = 3;
      if (bUseGrowthIncrementModel2(ig)==GROWTH_VARYKLINF)        nparG = 4;
     }
    if (ig >nsex && ig <= 2*nsex) 
     {
      if (bUseCustomMoltProbability2(ig-nsex)==LOGISTIC_PROB_MOLT)     nparG = 2;
      if (bUseCustomMoltProbability2(ig-nsex)==FREE_PROB_MOLT)         nparG = (nclass);
     }
    if (ig >2*nsex && ig <= 3*nsex) 
     {
      if (bUseCustomMatureProbability2(ig-2*nsex)==LOGISTIC_PROB_MATURE) nparG = 2;
      if (bUseCustomMatureProbability2(ig-2*nsex)==FREE_PROB_MATURE)     nparG = (nclass);
     }
    nparGs(ig) = nparG; 
   } //-ig 
  cout << "nparGs" << nparGs << endl;
 END_CALCS
 
  // Storage by year
  imatrix GrowPnt(1,3*nsex*Nyears,1,nclass+5);

  matrix Gpar_control(1,1000,1,15);
  imatrix GtoIG(1,1000,1,4);
  int PPstoreG;
  !! PPstoreG = PPnt;
 LOC_CALCS 
  {
   n_Gpar = 0;
   int n_Gpar2; int h; int iblock;
   GrowPnt.initialize();
   gmacs_ctl << endl;
   echoinput << endl;
   gmacs_ctl << "## General parameter specificiations " << endl;
   echoinput << "## General parameter specificiations " << endl;
   gmacs_ctl << "##  Initial: Initial value for the parameter (must lie between lower and upper)" << endl;
   gmacs_ctl << "##  Lower & Upper: Range for the parameter" << endl;
   gmacs_ctl << "##  Prior type:"  << endl;
   gmacs_ctl << "##   0: Uniform   - parameters are the range of the uniform prior"  << endl;
   gmacs_ctl << "##   1: Normal    - parameters are the mean and sd" << endl;
   gmacs_ctl << "##   2: Lognormal - parameters are the mean and sd of the log" << endl;
   gmacs_ctl << "##   3: Beta      - parameters are the two beta parameters [see dbeta]" << endl;
   gmacs_ctl << "##   4: Gamma     - parameters are the two gamma parameters [see dgamma]" << endl;
   gmacs_ctl << "##  Phase: Set equal to a negative number not to estimate" << endl;
   gmacs_ctl << "##  Relative: 0: absolute; 1 relative " << endl;
   gmacs_ctl << "##  Block: Block number for time-varying selectivity   " << endl;
   gmacs_ctl << "##  Block_fn: 0:absolute values; 1:exponential" << endl;
   gmacs_ctl << "##  Env_L: Environmental link - options are 0:none; 1:additive; 2:multiplicative; 3:exponential" << endl;
   gmacs_ctl << "##  EnvL_var: Environmental variable" << endl;
   gmacs_ctl << "##  RW: 0 for no random walk changes; 1 otherwise" << endl;
   gmacs_ctl << "##  RW_blk: Block number for random walks" << endl;
   gmacs_ctl << "##  Sigma_RW: Sigma used for the random walk" << endl;
   gmacs_ctl << endl;
   for (int ig=1;ig<=3*nsex;ig++)
    {
     if (nparGs(ig) > 0) gmacs_ctl << "# Inputs for sex * type " << ig << endl;
     if (nparGs(ig) > 0) gmacs_ctl << "# MAIN PARS: Initial  Lower_bound  Upper_bound Prior_type       Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma" << endl;
     n_Gpar2 = n_Gpar;
     if (nsex==1) h = 1;
     if (nsex==2 && (ig==1 || ig==3)) h = 1;
     if (nsex==2 && (ig==2 || ig==4)) h = 2;
     for (int iyr=syr;iyr<=nyrRetro;iyr++)
      {
       GrowPnt((ig-1)*Nyears+iyr-syr+1,nclass+2) = ig;
       GrowPnt((ig-1)*Nyears+iyr-syr+1,nclass+3) = iyr;
      }
     for (int ipar=1; ipar<=nparGs(ig);ipar++)
      {
       n_Gpar += 1;
       GtoIG(n_Gpar,1) = ig;
       GtoIG(n_Gpar,2) = ipar;
       GtoIG(n_Gpar,3) = 0;
       iblock = 1;
       for (int ii=1;ii<=14;ii++) *(ad_comm::global_datafile) >> Gpar_control(n_Gpar,ii);
       if (ig <= nsex && bUseGrowthIncrementModel2(ig)==LINEAR_GROWTHMODEL && ipar==1) anystring = "Alpha_base_"+sexes(h);
       if (ig <= nsex && bUseGrowthIncrementModel2(ig)==LINEAR_GROWTHMODEL && ipar==2) anystring = "Beta_base_"+sexes(h);
       if (ig <= nsex && bUseGrowthIncrementModel2(ig)==LINEAR_GROWTHMODEL && ipar==3) anystring = "Gscale_base_"+sexes(h);
       if (ig <= nsex && bUseGrowthIncrementModel2(ig)==PWRLAW_GROWTHMODEL && ipar==1) anystring = "Alpha_base_"+sexes(h)+"_(ln-scale)";
       if (ig <= nsex && bUseGrowthIncrementModel2(ig)==PWRLAW_GROWTHMODEL && ipar==2) anystring = "Beta_base_"+sexes(h);
       if (ig <= nsex && bUseGrowthIncrementModel2(ig)==PWRLAW_GROWTHMODEL && ipar==3) anystring = "Gscale_base_"+sexes(h)+"_(ln-scale)";

       if (ig <= nsex && (bUseGrowthIncrementModel2(h)==INDIVIDUAL_GROWTHMODEL1 || bUseGrowthIncrementModel2(h)==INDIVIDUAL_GROWTHMODEL2))
        if (ipar <=nclass)
         anystring = "Molt_increment_base_"+sexes(h)+"_class_"+str(ipar);
        else 
         anystring = "Gscale_base_"+sexes(h);
       if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYK && ipar==1) anystring = "Linf_base_"+sexes(h)+"_period_"+str(iblock);
       if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYK && ipar==2) anystring = "Kappa_base_"+sexes(h)+"_period_"+str(iblock);
       if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYK && ipar==3) anystring = "SigmaKappa_base_"+sexes(h)+"_period_"+str(iblock);
       if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYLINF && ipar==1) anystring = "Linf_base_"+sexes(h)+"_period_"+str(iblock);
       if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYLINF && ipar==2) anystring = "Kappa_base_"+sexes(h)+"_period_"+str(iblock);
       if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYLINF && ipar==3) anystring = "SigmaKappa_base_"+sexes(h)+"_period_"+str(iblock);
       if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYKLINF && ipar==1) anystring = "Linf_base_"+sexes(h)+"_period_"+str(iblock);
       if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYKLINF && ipar==2) anystring = "Kappa_base_"+sexes(h)+"_period_"+str(iblock);
       if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYKLINF && ipar==3) anystring = "SigmaKappa_base_"+sexes(h)+"_period_"+str(iblock);
       if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYKLINF && ipar==4) anystring = "SigmaKappa_base_"+sexes(h)+"_period_"+str(iblock);
       if ((ig>nsex && ig <= 2*nsex) && bUseCustomMoltProbability2(h)==LOGISTIC_PROB_MOLT && ipar==1) anystring = "Molt_probability_mu_base_"+sexes(h)+"_period_"+str(iblock);
       if ((ig>nsex && ig <= 2*nsex) && bUseCustomMoltProbability2(h)==LOGISTIC_PROB_MOLT && ipar==2) anystring = "Molt_probability_CV_base_"+sexes(h)+"_period_"+str(iblock);
       if ((ig>nsex && ig <= 2*nsex) && bUseCustomMoltProbability2(h)==FREE_PROB_MOLT) anystring = "Molt_probability_base_"+sexes(h)+"_period_"+str(iblock)+"_class_"+str(ipar);
       if ((ig>2*nsex && ig <= 3*nsex) && bUseCustomMatureProbability2(h)==LOGISTIC_PROB_MATURE && ipar==1) anystring = "Mature_probability_mu_base_"+sexes(h)+"_period_"+str(iblock);
       if ((ig>2*nsex && ig <= 3*nsex) && bUseCustomMatureProbability2(h)==LOGISTIC_PROB_MATURE && ipar==2) anystring = "Mature_probability_CV_base_"+sexes(h)+"_period_"+str(iblock);
       if ((ig>2*nsex && ig <= 3*nsex) && bUseCustomMatureProbability2(h)==FREE_PROB_MATURE) anystring = "Mature_probability_base_"+sexes(h)+"_period_"+str(iblock)+"_class_"+str(ipar);
       gmacs_ctl << "         "; for (int ii=1;ii<=3;ii++) gmacs_ctl << setw(12) << setprecision(6) << setfixed() << Gpar_control(n_Gpar,ii) << " ";
       gmacs_ctl << setw(10) << setfixed() << int(Gpar_control(n_Gpar,4)) << " ";
       for (int ii=5;ii<=6;ii++) gmacs_ctl << setw(12) << setprecision(6) << setfixed() << Gpar_control(n_Gpar,ii) << " ";
       for (int ii=7;ii<=13;ii++) gmacs_ctl << setw(6) << setfixed() << int(Gpar_control(n_Gpar,ii)) << " ";
       gmacs_ctl << setw(8) << setprecision(4) << setfixed() << Gpar_control(n_Gpar,14) << " # " << anystring; gmacs_ctl << endl;
       for (int ii=1;ii<=14;ii++) echoinput << Gpar_control(n_Gpar,ii) << " "; echoinput << "# " << anystring; echoinput << endl;
       parname1(PPnt+1) = anystring;
       PPnt += 1;
      }
     if (nparGs(ig) > 0)  gmacs_ctl << "# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1      Prior_2  Phase Reltve " << endl;
     for (int iyr=syr;iyr<=nyrRetro;iyr++)
      for (int ipar=1; ipar<=nparGs(ig);ipar++)  GrowPnt((ig-1)*Nyears+iyr-syr+1,ipar) = n_Gpar2+ipar;
     
     for (int ipar=1; ipar<=nparGs(ig);ipar++)
      {
       // Are there blocks
       int jpar = n_Gpar2+ipar;
       int IgBlock = int(Gpar_control(jpar,8));
       int IgBlockFn = int(Gpar_control(jpar,9));
       int IgEnvLink = int(Gpar_control(jpar,10));
       int IgEnvLinkVar = int(Gpar_control(jpar,11));
       int IgRW = int(Gpar_control(jpar,12));
       int IgRWBlock = int(Gpar_control(jpar,13));
       float SigmaRW = Gpar_control(jpar,15);
       if (IgBlock !=0)
        {
         // Environmental link
         if ((IgEnvLink!=0) || (IgRW!=0)) { cout << "Error: you can't have blocks and RWs at the same time - growth line " << ig << " par " << ipar <<  endl; exit(1); } 
         if ((IgBlock<0 )&& (IgBlock>nblocks)) { cout << "Error: block out of range - growth line " << ig << " par " << ipar << endl; exit(1); }        
         if ((IgBlockFn<0) && (IgBlockFn>1)) { cout << "Error: block_fn out of range - growth line " << ig << " par " << ipar << endl; exit(1); }        
         for (int kpar=1;kpar<=blocks(IgBlock);kpar++)
          {
           iblock = kpar + 1;
           n_Gpar += 1;
           GtoIG(n_Gpar,1) = ig;
           GtoIG(n_Gpar,2) = ipar;
           GtoIG(n_Gpar,3) = 0;
           for (int ii=1;ii<=7;ii++) *(ad_comm::global_datafile) >> Gpar_control(n_Gpar,ii);*(ad_comm::global_datafile) >> Gpar_control(n_Gpar,15);
           for (int iyr=blocklimits(IgBlock,kpar,1);iyr<=blocklimits(IgBlock,kpar,2);iyr++)
            GrowPnt((ig-1)*Nyears+iyr-syr+1,ipar) = n_Gpar;
           if (ig <= nsex && bUseGrowthIncrementModel2(ig)==LINEAR_GROWTHMODEL && ipar==1) anystring = "Alpha_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(ig)==LINEAR_GROWTHMODEL && ipar==2) anystring = "Beta_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(ig)==LINEAR_GROWTHMODEL && ipar==3) anystring = "Gscale_"+sexes(h);
           if (ig <= nsex && bUseGrowthIncrementModel2(ig)==PWRLAW_GROWTHMODEL && ipar==1) anystring = "Alpha_"+sexes(h)+" (ln-scale)";
           if (ig <= nsex && bUseGrowthIncrementModel2(ig)==PWRLAW_GROWTHMODEL && ipar==2) anystring = "Beta_"+sexes(h);
           if (ig <= nsex && bUseGrowthIncrementModel2(ig)==PWRLAW_GROWTHMODEL && ipar==3) anystring = "Gscale_"+sexes(h)+" (ln-scale)";
	   if (ig <= nsex && (bUseGrowthIncrementModel2(h)==INDIVIDUAL_GROWTHMODEL1 || bUseGrowthIncrementModel2(h)==INDIVIDUAL_GROWTHMODEL2))
	   if (ipar <=nclass)
	    anystring = "Molt_increment_"+sexes(h)+"_class_"+str(ipar);
	   else 
	    anystring = "Gscale_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYK && ipar==1) anystring = "Linf_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYK && ipar==2) anystring = "Kappa_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYK && ipar==3) anystring = "SigmaKappa_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYLINF && ipar==1) anystring = "Linf_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYLINF && ipar==2) anystring = "Kappa_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYLINF && ipar==3) anystring = "SigmaKappa_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYKLINF && ipar==1) anystring = "Linf_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYKLINF && ipar==2) anystring = "Kappa_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYKLINF && ipar==3) anystring = "SigmaKappa_"+sexes(h);
	   if (ig <= nsex && bUseGrowthIncrementModel2(h)==GROWTH_VARYKLINF && ipar==4) anystring = "SigmaKappa_"+sexes(h);
	   if ((ig>nsex && ig <= 2*nsex) && bUseCustomMoltProbability2(h)==LOGISTIC_PROB_MOLT && ipar==1) anystring = "Molt_probability_mu_"+sexes(h);
	   if ((ig>nsex && ig <= 2*nsex) && bUseCustomMoltProbability2(h)==LOGISTIC_PROB_MOLT && ipar==2) anystring = "Molt_probability_CV_"+sexes(h);
	   if ((ig>nsex && ig <= 2*nsex) && bUseCustomMoltProbability2(h)==FREE_PROB_MOLT) anystring = "Molt_probability_"+sexes(h)+"_class_"+str(ipar);
           if ((ig>2*nsex && ig <= 3*nsex) && bUseCustomMatureProbability2(h)==LOGISTIC_PROB_MATURE && ipar==1) anystring = "Mature_probability_mu_"+sexes(h);
           if ((ig>2*nsex && ig <= 3*nsex) && bUseCustomMatureProbability2(h)==LOGISTIC_PROB_MATURE && ipar==2) anystring = "Mature_probability_CV_"+sexes(h);
           if ((ig>2*nsex && ig <= 3*nsex) && bUseCustomMatureProbability2(h)==FREE_PROB_MATURE) anystring = "Mature_probability_"+sexes(h)+"_class_"+str(ipar);
           anystring = anystring+"_block_group_"+str(IgBlock)+"_block_"+str(kpar);
           gmacs_ctl << "         "; for (int ii=1;ii<=3;ii++) gmacs_ctl << setw(12) << setprecision(6) << setfixed() << Gpar_control(n_Gpar,ii) << " ";
	   gmacs_ctl << setw(10) << setfixed() << int(Gpar_control(n_Gpar,4)) << " ";
	   for (int ii=5;ii<=6;ii++) gmacs_ctl << setw(12) << setprecision(6) << setfixed() << Gpar_control(n_Gpar,ii) << " ";
	   for (int ii=7;ii<=8;ii++) gmacs_ctl << setw(6) << setfixed() << int(Gpar_control(n_Gpar,ii)) << " ";
	   gmacs_ctl << "# " << anystring; gmacs_ctl << endl;
           for (int ii=1;ii<=7;ii++) echoinput << Gpar_control(n_Gpar,ii) << " "; echoinput << Gpar_control(n_Gpar,15) << " # " << anystring <<  endl;
           parname1(PPnt+1) = anystring;
           PPnt += 1;
         } //-- kpar
        } //-- blocks 
      if (IgEnvLink !=0) 
       {
        if (IgEnvLink != 1 && IgEnvLink != 2 && IgEnvLink != 3) { cout << "Error: Environmental links can only be 1, 2 or 3 - growth line " << ig << " par " << ipar <<endl; exit(1); } 
        if (IgEnvLinkVar <= 0 || IgEnvLinkVar > NenvIndics) { cout << "Error: Environmental variable outside range - growth line " << ig << " par " << ipar << endl; exit(1); } 
        if (IgRWBlock <=0) { cout << "Error: There needs to a block for environment variables - growth line " << ig << " par " << ipar <<  endl; exit(1); }
        n_Gpar += 1;
        parname1(PPnt+1) = "Env_link_"+sexes(h);
        PPnt += 1;
        GtoIG(n_Gpar,1) = ig;
        GtoIG(n_Gpar,2) = ipar;
        GtoIG(n_Gpar,3) = 0;
        for (int ii=1;ii<=7;ii++) *(ad_comm::global_datafile) >> Gpar_control(n_Gpar,ii);
          *(ad_comm::global_datafile) >> Gpar_control(n_Gpar,15);
        for (int ii=1;ii<=7;ii++) gmacs_ctl << Gpar_control(n_Gpar,ii) << " ";  gmacs_ctl << Gpar_control(n_Gpar,15) << endl;
        for (int ii=1;ii<=7;ii++) echoinput << Gpar_control(n_Gpar,ii) << " "; echoinput << Gpar_control(n_Gpar,15) << endl;
        for (int kpar=1;kpar<=blocks(IgRWBlock);kpar++)
         {
          for (int iyr=blocklimits(IgRWBlock,kpar,1);iyr<=blocklimits(IgRWBlock,kpar,2);iyr++)
           GrowPnt((ig-1)*Nyears+iyr-syr+1,ipar) = iyr*1000000.0+n_Gpar*10000+0+IgEnvLink*100+IgEnvLinkVar;
         } //-- kpar
       } //--Env link
      // Random walk
      if (IgRW !=0) 
       {
        n_devvars += 1;
        devpoints(n_devvars,1) = 1; devpoints(n_devvars,2) = ig; devpoints(n_devvars,3) = n_deviations+1;
        if (IgRWBlock <=0) { cout << "Error: There needs to a block for random walk - growth line " << ig << " par " << ipar <<   endl;  exit(1); }
        if (IgRWBlock > nblocks) { cout << "Error: The block for random walk survey in out of range - growth line " << ig << " par " << ipar <<  endl;  exit(1); }
        for (int kpar=1;kpar<=blocks(IgRWBlock);kpar++)
         for (int iyr=blocklimits(IgRWBlock,kpar,1);iyr<=blocklimits(IgRWBlock,kpar,2);iyr++)
           GrowPnt((ig-1)*Nyears+iyr-syr+1,ipar) = -10000*IgRWBlock-(n_deviations+iyr-blocklimits(IgRWBlock,kpar,1)+1);
        for (int iblk=1;iblk<=blocks(IgRWBlock);iblk++)
         n_deviations += (blocklimits(IgRWBlock,iblk,2)-blocklimits(IgRWBlock,iblk,1)+1);
        devpoints(n_devvars,4) = n_deviations; 
        devpoints(n_devvars,5) = IgRWBlock;
        devpoints(n_devvars,6) = ipar;
        if (ig <= nsex)  devpoints(n_devvars,7) = 1;
        if (ig > nsex && ig <= 2*nsex)  devpoints(n_devvars,7) = 2;
        if (ig > 2*nsex && ig <= 3*nsex)  devpoints(n_devvars,7) = 3;
        rdevpoints(n_devvars,1) =  SigmaRW;
       } //--Random walk
     } //--ipar
      
    } //--ig
   }  
  echoinput <<  "GrowPnt" << endl;
  echoinput <<  GrowPnt << endl;

 END_CALCS

  imatrix iYrsIncChanges(1,nsex,syr,nyrRetro);
  imatrix iYrsMoltChanges(1,nsex,syr,nyrRetro);
  imatrix iYrsMatureChanges(1,nsex,syr,nyrRetro);
  ivector nSizeIncVaries(1,nsex);
  int maxSizeIncVaries;
  ivector nMoltVaries(1,nsex);
  int maxMoltVaries;   
  ivector nMatureVaries(1,nsex);
  int maxMatureVaries;   

 LOC_CALCS
  int inew;
  nSizeIncVaries.initialize();
  nMoltVaries.initialize();
  nMatureVaries.initialize();
  for (int ig=1;ig<=3*nsex;ig++)
   {
    inew = 1;
    GrowPnt((ig-1)*Nyears+1,nclass+4) = 1;
    if (ig <=nsex) iYrsIncChanges(ig,syr) = 1;
    if (ig > nsex && ig <=2*nsex) iYrsMoltChanges(ig-nsex,syr) = 1;
    if (ig > 2*nsex && ig <=3*nsex) iYrsMatureChanges(ig-2*nsex,syr) = 1;
    for (int iyr=syr+1;iyr<=nyrRetro;iyr++)
     {
      int OK = 1; int Match=-1;
      for (int iyr2=syr;iyr2<iyr;iyr2++)
       {
        int OK2 = 0;
        for (int ipar=1;ipar<=nclass+1;ipar++)
         if (GrowPnt((ig-1)*Nyears+iyr-syr+1,ipar)!=GrowPnt((ig-1)*Nyears+iyr2-syr+1,ipar)) OK2 = 1;
        if (OK2 == 0 && Match < 0) Match = iyr2;
        if (OK2==0) OK = 0; 
       }
      if (OK==1) { inew += 1; GrowPnt((ig-1)*Nyears+iyr-syr+1,nclass+4) = inew; }
      if (OK==0) { GrowPnt((ig-1)*Nyears+iyr-syr+1,nclass+4) = GrowPnt((ig-1)*Nyears+Match-syr+1,nclass+4); }
      if (ig <=nsex) iYrsIncChanges(ig,iyr) = GrowPnt((ig-1)*Nyears+iyr-syr+1,nclass+4);
      if ((ig > nsex)   && (ig <=2*nsex)) iYrsMoltChanges(ig-nsex,iyr)     = GrowPnt((ig-1)*Nyears+iyr-syr+1,nclass+4);
      if ((ig > 2*nsex) && (ig <=3*nsex)) iYrsMatureChanges(ig-2*nsex,iyr) = GrowPnt((ig-1)*Nyears+iyr-syr+1,nclass+4);
     } //--iyr
     if (ig <=nsex) nSizeIncVaries(ig) = inew;
     if (ig > nsex && ig <=2*nsex) nMoltVaries(ig-nsex) = inew;
     if (ig > 2*nsex && ig <=3*nsex) nMatureVaries(ig-2*nsex) = inew;
   } //-- ig
 END_CALCS
  
  // Set up the specifications for the growth parameters
  vector G_ival(1,n_Gpar);
  vector G_lb(1,n_Gpar);
  vector G_ub(1,n_Gpar);
  ivector G_phz(1,n_Gpar);
  ivector prior_Gtype(1,n_Gpar);
  vector prior_G_p1(1,n_Gpar);
  vector prior_G_p2(1,n_Gpar);
  ivector G_relative(1,n_Gpar);

 LOC_CALCS
  for (int ipar=1;ipar<=n_Gpar;ipar++)
   {
    G_ival(ipar)        = Gpar_control(ipar,1);
    G_lb(ipar)          = Gpar_control(ipar,2);
    G_ub(ipar)          = Gpar_control(ipar,3);
    prior_Gtype(ipar)   = int(Gpar_control(ipar,4));
    prior_G_p1(ipar)    = Gpar_control(ipar,5);
    prior_G_p2(ipar)    = Gpar_control(ipar,6);
    G_phz(ipar)         = int(Gpar_control(ipar,7));
    G_relative(ipar)    = int(Gpar_control(ipar,15));
  
    // If a uniform prior is specified then use the lb and ub rather than p1 and p2.
    if ( prior_Gtype(ipar) == UNIFORM_PRIOR )
     { prior_G_p1(ipar) = G_lb(ipar); prior_G_p2(ipar) = G_ub(ipar); }
   } //--ipar
  ECHO(G_ival) 
  ECHO(prior_Gtype); ECHO(prior_G_p1); ECHO(prior_G_p2); ECHO(G_phz) ; ECHO(G_relative);
 END_CALCS
  
  // Special situation when growth, molt increment or maturity are pre-specified
 LOC_CALCS
  int OK; int IgBlock; 
  ivector ipointer(syr,nyr+1);
  ivector ipointer2(syr,nyr+1);
  for (int ig=1;ig<=3*nsex;ig++)
   {
    cout << ig << endl;
    OK = 0;
    if (nsex==1 && ig==1 && (bUseCustomGrowthMatrix2(ig) == GROWTH_FIXEDGROWTHTRANS || bUseCustomGrowthMatrix2(ig) == GROWTH_FIXEDSIZETRANS)) OK = 1;
    if (nsex==1 && ig==2 && bUseCustomMoltProbability2(ig-nsex) == FIXED_PROB_MOLT) OK = 1;
    if (nsex==1 && ig==3 && bUseCustomMatureProbability2(ig-2*nsex) == FIXED_PROB_MATURE) OK = 1;
    if (nsex==2 && (ig==1 || ig==2) && (bUseCustomGrowthMatrix2(ig) == GROWTH_FIXEDGROWTHTRANS || bUseCustomGrowthMatrix2(ig) == GROWTH_FIXEDSIZETRANS)) OK = 1;
    if (nsex==2 && (ig==3 || ig==4) && bUseCustomMoltProbability2(ig-nsex) == FIXED_PROB_MOLT) OK = 1;
    if (nsex==2 && (ig==5 || ig==6) && bUseCustomMatureProbability2(ig-2*nsex) == FIXED_PROB_MATURE) OK = 1;
    cout << "Special " << ig << " " << OK << endl;
    if (OK==1)
     {
      IgBlock = G_block(ig); inew = 1;
      for (int iyr=syr;iyr<=nyr+1;iyr++) ipointer(iyr) = 1;
      if (IgBlock > 0)
       for (int kpar=1;kpar<=blocks(IgBlock);kpar++)
        for (int iyr=blocklimits(IgBlock,kpar,1);iyr<=blocklimits(IgBlock,kpar,2);iyr++)
         ipointer(iyr) = kpar+1;
      ipointer2(syr) = 1;
      for (int iyr=syr+1;iyr<=nyr+1;iyr++)
       {
        int OK2 = 1; int Match=-1;
        for (int iyr2=syr;iyr2<iyr;iyr2++)
         {
          int OK3 = 0;
          if (ipointer(iyr)!=ipointer(iyr2)) OK3 = 1;
          if (OK3==0 && Match < 0) Match = iyr2;
          if (OK3==0) OK2 = 0; 
         }
        if (OK2==1) { inew += 1; ipointer2(iyr) = inew; }
        if (OK2==0) { ipointer2(iyr) = ipointer2(Match); }
       } //--iyr
      if (ig <= nsex) nSizeIncVaries(ig) = inew;
      if (ig > nsex && ig <=2*nsex) nMoltVaries(ig-nsex) = inew;
      if (ig > 2*nsex && ig <=3*nsex) nMatureVaries(ig-2*nsex) = inew;
      if (ig <= nsex) 
       for (int iyr=syr;iyr<=nyrRetro;iyr++)
        iYrsIncChanges(ig,iyr) = ipointer2(iyr);
      if (ig > nsex && ig <= 2*nsex) 
       for (int iyr=syr;iyr<=nyrRetro;iyr++)
        iYrsMoltChanges(ig=nsex,iyr) = ipointer2(iyr);
      if (ig > 2*nsex && ig <= 3*nsex) 
       for (int iyr=syr;iyr<=nyrRetro;iyr++)
        iYrsMatureChanges(ig-2*nsex,iyr) = ipointer2(iyr);
     } //-- ig
   
   }
  maxSizeIncVaries = max(nSizeIncVaries); 
  echoinput << "nSizeIncVaries " << nSizeIncVaries << endl;
  echoinput << "maxSizeIncVaries " << maxSizeIncVaries << endl;
  maxMoltVaries = max(nMoltVaries);
  echoinput << "nMoltVaries " <<nMoltVaries << endl;
  echoinput << "maxMoltVaries " <<maxMoltVaries << endl;
  maxMatureVaries = max(nMatureVaries);
  echoinput << "nMatureVaries " <<nMatureVaries << endl;
  echoinput << "maxMatureVaries " <<maxMatureVaries << endl;
  echoinput << "iYrsIncChangess " <<iYrsIncChanges << endl;
  echoinput << "iYrsMoltChangess " <<iYrsMoltChanges << endl;
  echoinput << "iYrsMatureChangess " <<iYrsMatureChanges << endl;
 END_CALCS
     
  // Read pre-specified growth matrices 
  4darray CustomGrowthMatrix(1,nsex,1,maxSizeIncVaries,1,nclass,1,nclass);     ///> Custom growth matrix or size-transition matrix (read in)
  !!for (int ig=1;ig<=nsex;ig++)
  !! if (bUseCustomGrowthMatrix2(ig)==GROWTH_FIXEDGROWTHTRANS || bUseCustomGrowthMatrix2(ig)==GROWTH_FIXEDSIZETRANS)
  !!  {
  !!   if (bUseCustomGrowthMatrix2(ig)==GROWTH_FIXEDGROWTHTRANS) gmacs_ctl << "\n# Using custom growth matrix" << endl;
  !!   if (bUseCustomGrowthMatrix2(ig)==GROWTH_FIXEDSIZETRANS)   gmacs_ctl << "\n# Using custom size transition matrix" << endl;
  !!   for (int i=1;i<=nSizeIncVaries(ig);i++)
  !!     {
  !!      for (int class1=1;class1<= nSizeSex(ig);class1++)
  !!       for (int class2=1;class2<= nSizeSex(ig);class2++)
  !!       *(ad_comm::global_datafile) >>  CustomGrowthMatrix(ig,i,class2,class1);
  !!      gmacs_ctl << setw(6) << setprecision(4) << setfixed() << trans(CustomGrowthMatrix(ig,i)) << endl;
  !!     }
  !!  }

  // Read pre-specified molt probability matrices 
  3darray CustomMoltProbabilityMatrix(1,nsex,1,maxMoltVaries,1,nclass);          ///> Custom molt probability (read in)
  !! for (int ig=1;ig<=nsex;ig++)
  !!  if (bUseCustomMoltProbability2(ig)==FIXED_PROB_MOLT)
  !!   {
  !!    gmacs_ctl << "\n# Using custom molt probability" << endl;
  !!    for (int i=1;i<=nMoltVaries(ig);i++)
  !!     for (int l=1;l<= nSizeSex(ig);l++) *(ad_comm::global_datafile) >>  CustomMoltProbabilityMatrix(ig,i,l);
  !!    gmacs_ctl << "#Pre-specified molt probability" << endl;;
  !!    for (int i=1;i<=nMoltVaries(ig);i++)
  !!     {
  !!      for (int l=1;l<= nSizeSex(ig);l++) gmacs_ctl << setw(6) << setprecision(4) << setfixed() << CustomMoltProbabilityMatrix(ig,i,l) << " ";
  !!      gmacs_ctl << endl;
  !!     }
  !!   }

  // Read pre-specified probability of maturing matrices 
  3darray CustomMatureProbabilityMatrix(1,nsex,1,maxMatureVaries,1,nclass);          ///> Custom mature probability (read in)
  !! for (int ig=1;ig<=nsex;ig++)
  !!  if (nmature==2 && bUseCustomMatureProbability2(ig)==FIXED_PROB_MATURE)
  !!   {
  !!    gmacs_ctl << "\n# Using custom mature probability" << endl;
  !!    for (int i=1;i<=nMatureVaries(ig);i++)
  !!     for (int l=1;l<= nSizeSex(ig);l++) *(ad_comm::global_datafile) >>  CustomMatureProbabilityMatrix(ig,i,l);
  !!    gmacs_ctl << "#Pre-specified mature probability" << endl;;
  !!    for (int i=1;i<=nMatureVaries(ig);i++)
  !!     {
  !!      for (int l=1;l<= nSizeSex(ig);l++)  gmacs_ctl << setw(6) << setprecision(4) << setfixed() << CustomMatureProbabilityMatrix(ig,i,l) << " ";
  !!      gmacs_ctl << endl;
  !!     }
  !!   }

  // --------------------------------------------------------------------------------------------------------------------------------------
  // |--------------------------------|
  // | NATURAL MORTALITY CONTROLS |
  // |--------------------------------|
  !! cout << " * Natural mortality parameter controls" << endl;
  !! ECHOSTR(" * Natural mortality parameter controls");
  init_matrix M_controls(1,nmature*nsex,1,13);
  !! ECHO(M_controls);
  !! gmacs_ctl <<  setw(14) << setprecision(8) << setfixed() << endl;
  !! gmacs_ctl << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## NATURAL MORTALITY PARAMETER CONTROLS                                                 ##" << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## " << endl;
  !! gmacs_ctl <<"# Relative: 0 - absolute values; 1+ - based on another M-at-size vector (indexed by ig)" << endl;
  !! gmacs_ctl <<"# Type: 0 for standard; 1: Spline" << endl;
  !! gmacs_ctl <<"#  For spline: set extra to the number of knots, the parameters are the knots (phase -1) and the log-differences from base M" << endl;
  !! gmacs_ctl <<"# Extra: control the number of knots for splines" << endl;
  !! gmacs_ctl <<"# Brkpts: number of changes in M by size" << endl;
  !! gmacs_ctl <<"# Mirror: Mirror M-at-size over to that for another partition (indexed by ig)" << endl;
  !! gmacs_ctl <<"# Block: Block number for time-varying M-at-size" << endl;
  !! gmacs_ctl <<"# Block_fn: 0:absolute values; 1:exponential" << endl;
  !! gmacs_ctl <<"# Env_L: Environmental link - options are 0: none; 1:additive; 2:multiplicative; 3:exponential" << endl;;
  !! gmacs_ctl <<"# EnvL_var: Environmental variable" << endl;
  !! gmacs_ctl <<"# RW: 0 for no random walk changes; 1 otherwise" << endl;
  !! gmacs_ctl <<"# RW_blk: Block number for random walks" << endl;
  !! gmacs_ctl <<"# Sigma_RW: Sigma for the random walk parameters" << endl;
  !! gmacs_ctl <<"# Mirror_RW: Should time-varying aspects be mirrored (Indexed by ig)" << endl;
  !! gmacs_ctl <<"## Relative?   Type   Extra  Brkpts  Mirror   Block  Blk_fn Env_L   EnvL_Vr      RW  RW_blk Sigma_RW Mirr_RW" << endl;
  !! for (int b=1; b<=nmature*nsex;b++)
  !!  {
  !!   gmacs_ctl << "    ";for (int ii=1;ii<=11;ii++) gmacs_ctl << setw(7) << setfixed() << int(M_controls(b,ii)) << " " ;
  !!   gmacs_ctl << setw(8) << setprecision(4) << setfixed() << M_controls(b,12) << " ";
  !!   gmacs_ctl << setw(7) << setfixed() << int(M_controls(b,13)) << endl;
  !!  }
  
  ivector M_relative(1,nmature*nsex);
  ivector M_type(1,nmature*nsex);
  ivector M_extra(1,nmature*nsex);
  ivector M_size_breakpnts(1,nmature*nsex);
  ivector M_mirror(1,nmature*nsex);
  ivector M_block(1,nmature*nsex);
  ivector M_block_fn(1,nmature*nsex);
  ivector M_env_link(1,nmature*nsex);
  ivector M_env_var(1,nmature*nsex);
  ivector M_RW(1,nmature*nsex);
  ivector M_RW_blk(1,nmature*nsex);
  vector M_RW_sigma(1,nmature*nsex);
  ivector M_mirror_RW(1,nmature*nsex);
  int n_Mpar;
  int MaxMbreaks;
  int PPstoreM;
  !! PPstoreM = PPnt;
 LOC_CALCS
   M_relative       = ivector(column(M_controls,1));
   M_type           = ivector(column(M_controls,2));
   M_extra          = ivector(column(M_controls,3));
   M_size_breakpnts = ivector(column(M_controls,4));
   M_mirror         = ivector(column(M_controls,5));
   M_block          = ivector(column(M_controls,6));
   M_block_fn       = ivector(column(M_controls,7));
   M_env_link       = ivector(column(M_controls,8));
   M_env_var        = ivector(column(M_controls,9));
   M_RW             = ivector(column(M_controls,10));
   M_RW_blk         = ivector(column(M_controls,11));
   M_RW_sigma       = column(M_controls,12);
   M_mirror_RW      = ivector(column(M_controls,13));
   n_Mpar = 0;   MaxMbreaks = 0;
   for (h=1;h<=nsex;h++)
    for (m=1;m<=nmature;m++)
     {
      int ig = (h-1)*nmature+m;
      anystring = "";
      if (M_mirror(ig) == 0)
       {
        n_Mpar += 1;                                                      // Basic parameters
        anystring = "_"+sexes(h)+"_"+maturestate(m);
        PPnt += 1;
        parname1(PPnt) = "M_base"+anystring; 
        // Initial checks
        if (ig==1) 
         {
          if (M_relative(ig)!=0) { cout << "Error: M_relative for the first sex*maturity state must be 0" << endl; exit(1); }
         }
        if (ig >1)
         {
          if (M_relative(ig)!=0 && (M_relative(ig)<0 || M_relative(ig)>=ig)) { cout << "Error: M_relative must be 0 or a value less than ig - sex*maturity state " << h << " & " << m << endl; exit(1); }
         }
        if (M_mirror(ig)<0 || M_mirror(ig)>=ig)  { cout << "Error: mirror pointer out of range - sex*maturity state " << h << " & " << m << endl; exit(1); }        
        if (M_size_breakpnts(ig)<0 || M_size_breakpnts(ig)>=nclass)  { cout << "Error: size breakpoints out of range - sex*maturity state " << h << " & " << m << endl; exit(1); }        
        n_Mpar += M_size_breakpnts(ig);
        if (M_size_breakpnts(ig) > MaxMbreaks) MaxMbreaks = M_size_breakpnts(ig);
        
        // Block adjustment
        if (M_block(ig)<0 && M_block(ig)>nblocks) { cout << "Error: block out of range - sex*maturity state " << h << " & " << m <<  endl; exit(1); }        
        if (M_block_fn(ig)<0 && M_block(ig)>1) { cout << "Error: block_fn out of range - sex*maturity state " << h << " & " << m <<  endl; exit(1); }        
        if (M_block(ig)>0) 
         {
          n_Mpar += blocks(M_block(ig));
          for (int iblock=1;iblock<=blocks(M_block(ig));iblock++)
           {
            PPnt += 1;
	    parname1(PPnt) = "M"+anystring+"_block_group_"+str(M_block(ig))+"_block_"+str(iblock);
	   }
	 } //-- if M_block  
        
        // Environmental link
        if (M_env_link(ig)!=0) 
         {
          if (M_env_link(ig) != 1 && M_env_link(ig) != 2 && M_env_link(ig) != 3) { cout << "Error: Environmental links can only be 1, 2 or 3 -sex*maturity state " << h << " & " << m << endl; exit(1); } 
          if (M_env_var(ig) <= 0 || M_env_var(ig) > NenvIndics) { cout << "Error: Environmental variable outside range - sex*maturity state " << h << " & " << m << endl; exit(1); } 
          if (M_RW_blk(ig) <=0) { cout << "Error: There needs to a block for environment variables - sex*maturity state " << h << " & " << m << endl; exit(1); }
          n_Mpar += 1; 
          PPnt += 1;
	  parname1(PPnt) = "M"+anystring+"_env_link";
         }
        // Type-specific (knots)
        if (M_type(ig)==1) n_Mpar += 2*M_extra(ig);
        // Random walk
        if (M_RW(ig)!=0) 
         {
          n_devvars += 1;
          devpoints(n_devvars,1) = 2; devpoints(n_devvars,2) = ig; devpoints(n_devvars,3) = n_deviations+1;
          if (M_RW_blk(ig) <=0) { cout << "Error: There needs to a block for random walk - sex*maturity state " << h << " & " << m << endl;  exit(1); }
          if (M_RW_blk(ig) > nblocks) { cout << "Error: The block for random walk survey in out of range - sex*maturity state " << sexes(h) << " & " << m << endl;  exit(1); }
          for (int iblk=1;iblk<=blocks(M_RW_blk(ig));iblk++)
           n_deviations += (blocklimits(M_RW_blk(ig),iblk,2)-blocklimits(M_RW_blk(ig),iblk,1)+1);
          devpoints(n_devvars,4) = n_deviations; devpoints(n_devvars,5) = M_RW_blk(ig);
          devpoints(n_devvars,6) = blocks(M_RW_blk(ig));
          rdevpoints(n_devvars,1) = M_RW_sigma(ig);
         }
        if (M_mirror_RW(ig)<0 || M_mirror_RW(ig)>=ig)  { cout << "Error: random walk mirror pointer out of range - sex*maturity state " << sexes(h) << " & " << m << endl; exit(1); }        
        if (M_mirror_RW(ig) != 0 && (M_block(ig)>0 || M_RW(ig) >0 || M_env_link(ig)>0)) { cout << "Error: mirrow_RW requires no blocks, environmenal links or random walks - sex*maturity state " << h << " & " << m << endl; exit(1); }        
      } //--Mirror 
    } //--ig
   
 END_CALCS

  imatrix Mbreaks(1,nsex*nmature,1,MaxMbreaks);
  !! if (MaxMbreaks > 0) gmacs_ctl <<"# MaxMbreaks" << endl;
 LOC_CALCS
   for (int h=1;h<=nsex;h++)
    for (int m=1;m<=nmature;m++)
     {
      int ig = (h-1)*nmature+m;
      if (M_size_breakpnts(ig) > 0)
      for (int ii=1;ii<=M_size_breakpnts(ig);ii++) *(ad_comm::global_datafile) >> Mbreaks(ig,ii); 
      for (int ii=1;ii<=M_size_breakpnts(ig);ii++) gmacs_ctl << Mbreaks(ig,ii) << " "; gmacs_ctl << " # sex*maturity state: " << sexes(h) << " & " << m << endl;
     } 
 END_CALCS   

  ivector MToIg(1,n_Mpar);
  ivector MType(1,n_Mpar);
  ivector MPoint(1,nsex*nmature);
 LOC_CALCS
  {
   int iq; iq = 0;
   for (h=1;h<=nsex;h++)
    for (m=1;m<=nmature;m++)
     {
      int ig = (h-1)*nmature+m;
      if (M_mirror(ig) == 0)
       {
        iq +=1; MToIg(iq) = ig; MType(iq) = 0; MPoint(ig) = iq;
        if (M_size_breakpnts(ig)>0)
         for (int j=1;j<=M_size_breakpnts(ig);j++) { iq += 1; MToIg(iq) = ig; MType(iq) = 0; }
        if (M_type(ig)>0)
         for (int j=1;j<=2*M_extra(ig);j++) { iq += 1; MToIg(iq) = ig; MType(iq) = 0; }
        if (M_block(ig)>0) 
         for (int j=1;j<=blocks(M_block(ig));j++) { iq += 1; MToIg(iq) = ig; MType(iq) = 0; }
        if (M_env_link(ig)!=0)
         { iq += 1; MToIg(iq) = ig; MType(iq) = 1; }
       } 
      }
    ECHO(MToIg);
  }
 END_CALCS
  
  init_matrix M_pars(1,n_Mpar,1,7);
  vector M_ival(1,n_Mpar);
  vector M_lb(1,n_Mpar);
  vector M_ub(1,n_Mpar);
  ivector M_phz(1,n_Mpar);
  ivector prior_Mtype(1,n_Mpar);
  vector prior_M_p1(1,n_Mpar);
  vector prior_M_p2(1,n_Mpar);

 LOC_CALCS
  gmacs_ctl << endl;
  gmacs_ctl << "#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase " << endl;
  for (int b=1; b<=n_Mpar;b++)
   {
    for (int ii=1;ii<=3;ii++) gmacs_ctl << setw(14) << setprecision(8) << setfixed() << M_pars(b,ii) << " ";
    gmacs_ctl << setw(11) << setfixed() << int(M_pars(b,4)) << " ";
    for (int ii=5;ii<=6;ii++) gmacs_ctl << setw(14) << setprecision(8) << setfixed() << M_pars(b,ii) << " ";
    gmacs_ctl << setw(6) << setfixed() << int(M_pars(b,7)) << " # " << parname1(PPstoreM+b) << endl;
   }
  echoinput << endl;
  echoinput << "# Initial Lower_bound Upper_bound Prior_type Prior_1 Prior_2 Phase " << endl;
  echoinput << M_pars << endl;
  M_ival        = column(M_pars,1);
  M_lb          = column(M_pars,2);
  M_ub          = column(M_pars,3);
  prior_Mtype   = ivector(column(M_pars,4));
  prior_M_p1    = column(M_pars,5);
  prior_M_p2    = column(M_pars,6);
  M_phz         = ivector(column(M_pars,7));
  
  for ( int k = 1; k <= n_Mpar; k++ )
   {
    // If a uniform prior is specified then use the lb and ub rather than p1 and p2.
    if ( prior_Mtype(k) == UNIFORM_PRIOR )
     { prior_M_p1(k) = M_lb(k); prior_M_p2(k) = M_ub(k); }
   }
  ECHO(prior_Mtype); ECHO(prior_M_p1); ECHO(prior_M_p2); ECHO(M_phz);

 END_CALCS
 
  // --------------------------------------------------------------------------------------------------------------------------------------
  // |--------------------------------|
  // | SELECTIVITY PARAMETER CONTROLS |
  // |--------------------------------|
  !! cout << " * Selectivity parameter controls" << endl;
 
  imatrix slx_bsex_in(1,2,1,nfleet);                    //> boolean for sex-specific selex
  imatrix slx_type_in(1,2*nsex,1,nfleet);               //> integer for selectivity type (e.g. logistic, double normal)
  imatrix slx_include_in(1,2,1,nfleet);                 //> insertion of fleet in another
  imatrix slx_extra_in(1,2*nsex,1,nfleet);              //> extra parameters for each pattern
  imatrix slx_max_at_1_in(1,2*nsex,1,nfleet);	        //> determines if selectivity for the maximum size class is forced to be 1
  imatrix slx_1_at_size(1,2*nsex,1,nfleet);	        //> size class at which selex is 1
  imatrix slx_nret(1,2*nsex,1,nfleet);                  //> boolean for retention/discard
  imatrix ret_max_in(1,2*nsex,1,nfleet);	        //> should asymptotic selectivity be estimated?
  imatrix slx_type_npar(1,2*nsex,1,nfleet);             //> integer for number of selex parameters

  int Nyears3;
  !! Nyears3 = 2*nfleet*nsex*(nyr+1-syr+1);
  matrix CustomSelex(1,Nyears3,1,nclass);

 LOC_CALCS 
  gmacs_ctl << endl;
  gmacs_ctl <<"## ==================================================================================== ##" << endl;
  gmacs_ctl <<"## SELECTIVITY PARAMETERS CONTROLS                                                      ##" << endl;
  gmacs_ctl <<"## ==================================================================================== ##" << endl;
  gmacs_ctl <<"## " << endl;
  anystring = "";
  WriteCtlStr("## Selectivity parameter controls");
  WriteCtlStr("## Selectivity (and retention) types");
  WriteCtlStr("##  <0: Mirror selectivity");
  WriteCtlStr("##   0: Nonparametric selectivity (one parameter per class)");
  WriteCtlStr("##   1: Nonparametric selectivity (one parameter per class, constant from last specified class)");
  WriteCtlStr("##   2: Logistic selectivity (inflection point and width (i.e. 1/slope))");
  WriteCtlStr("##   3: Logistic selectivity (50% and 95% selection)");
  WriteCtlStr("##   4: Double normal selectivity (3 parameters)");
  WriteCtlStr("##   5: Flat equal to zero (1 parameter; phase must be negative)");
  WriteCtlStr("##   6: Flat equal to one (1 parameter; phase must be negative)");
  WriteCtlStr("##   7: Flat-topped double normal selectivity (4 parameters)");
  WriteCtlStr("##   8: Declining logistic selectivity with initial values (50% and 95% selection plus extra)");
  WriteCtlStr("##   9: Cubic-spline (specified with knots and values at knots)");
  WriteCtlStr("##      Inputs: knots (in length units); values at knots (0-1) - at least one should have phase -1");
  WriteCtlStr("##  10: One parameter logistic selectivity (inflection point and slope)");
  WriteCtlStr("##  11: Pre-specified selectivity (matrix by year and class)");
  gmacs_ctl << "## Selectivity specifications --" << endl;
  
  WriteCtlStr("## Extra (type 1): number of selectivity parameters to estimated");
  anystring = "# ";
  for ( int kk = 1; kk <= nfleet; kk++ ) anystring = anystring + " " + fleetname(kk);
  WriteCtlStr(anystring);
  
  slx_bsex_in.initialize();
  slx_type_in.initialize();
  slx_include_in.initialize();
  slx_extra_in.initialize();
  slx_max_at_1_in.initialize();
  slx_1_at_size.initialize();
  slx_nret.initialize();
  ret_max_in.initialize();
  slx_type_npar.initialize();
  
  *(ad_comm::global_datafile) >> slx_bsex_in(1);
  gmacs_ctl << slx_bsex_in(1)  << " # is selectivity sex=specific? (1=Yes; 0=No)"  << endl;
  for (int h=1;h<=nsex;h++) *(ad_comm::global_datafile) >> slx_type_in(h);
  for (int h=1;h<=nsex;h++) gmacs_ctl << slx_type_in(h)  << " # " <<sexes(h) << " selectivity type"  << endl;
  *(ad_comm::global_datafile) >>slx_include_in(1);
  gmacs_ctl <<slx_include_in(1)  << " # selectivity within another gear"  << endl;
  for (int h=1;h<=nsex;h++) *(ad_comm::global_datafile) >> slx_extra_in(h);
  for (int h=1;h<=nsex;h++) gmacs_ctl << slx_extra_in(h)  << " # " << sexes(h) << " extra parameters for each pattern"  << endl;
  for (int h=1;h<=nsex;h++) *(ad_comm::global_datafile) >> slx_max_at_1_in(h);
  for (int h=1;h<=nsex;h++) gmacs_ctl << slx_max_at_1_in(h)  << " # " << sexes(h) << ": is maximum selectivity at size forced to equal 1 (1) or not (0)"  << endl;
  for (int h=1;h<=nsex;h++) *(ad_comm::global_datafile) >> slx_1_at_size(h);
  for (int h=1;h<=nsex;h++) gmacs_ctl << slx_1_at_size(h)  << " # size-class at which selectivity is forced to equal 1 (ignored if the previous input is 1)" << endl;
  
  gmacs_ctl << "## Retention specifications --" << endl;
  *(ad_comm::global_datafile) >> slx_bsex_in(2);
  gmacs_ctl << slx_bsex_in(2)  << " # is retention sex=specific? (1=Yes; 0=No)"  << endl;
  for (int h=1;h<=nsex;h++) *(ad_comm::global_datafile) >> slx_type_in(nsex+h);
  for (int h=1;h<=nsex;h++) gmacs_ctl << slx_type_in(nsex+h)  << " # " << sexes(h) << " retention type"  << endl;
  for (int h=1;h<=nsex;h++) *(ad_comm::global_datafile) >> slx_nret(nsex+h);
  for (int h=1;h<=nsex;h++) gmacs_ctl << slx_nret(nsex+h)  << " # " << sexes(h) << " retention flag (0 = no, 1 = yes)"  << endl;
  for (int h=1;h<=nsex;h++) *(ad_comm::global_datafile) >> slx_extra_in(nsex+h);
  for (int h=1;h<=nsex;h++) gmacs_ctl << slx_extra_in(nsex+h)  << " # " << sexes(h) << " extra parameters for each pattern"  << endl;
  for (int h=1;h<=nsex;h++) *(ad_comm::global_datafile) >> ret_max_in(nsex+h);
  for (int h=1;h<=nsex;h++) gmacs_ctl << ret_max_in(nsex+h)  << " # " << sexes(h) << " - should maximum retention be estimated for " <<sexes(h) << "s (1=Yes; 0=No)" << endl;
  gmacs_ctl << endl;
 END_CALCS

  // Find the base parameters
  int n_Spar;
  imatrix nparSs(1,2,1,2*nfleet)
 LOC_CALCS 
  n_Spar = 0; int nparS; nparSs.initialize();  
  slx_type_npar.initialize();
  for (int it=1;it<=2;it++)
   for (int k=1;k<=nfleet;k++) 
    {
     for (int h=1;h<=slx_bsex_in(it,k)+1;h++)
      {
       nparS = 0;
       int ipnt = (it-1)*nsex+h;
       if (slx_type_in(ipnt,k) == SELEX_PARAMETRIC)   nparS = nclass;                 ///> non-parametric
       if (slx_type_in(ipnt,k) == SELEX_COEFFICIENTS) nparS = slx_extra_in(h,k);      ///> coefficients
       if (slx_type_in(ipnt,k) == SELEX_STANLOGISTIC) nparS = 2;                      ///> logistic has 2 parameters
       if (slx_type_in(ipnt,k) == SELEX_5095LOGISTIC) nparS = 2;                      ///> logistic has 2 parameters
       if (slx_type_in(ipnt,k) == SELEX_ONE_PAR_LOGISTIC) nparS = 1;                  ///> logisticOne has 1 parameter
       if (slx_type_in(ipnt,k) == SELEX_DECLLOGISTIC) nparS = 2+slx_extra_in(h,k);    ///> declining logistic has 2 + extra parameters
       if (slx_type_in(ipnt,k) == SELEX_DOUBLENORM) nparS = 3;                        ///> double normal has 3 parameters
       if (slx_type_in(ipnt,k) == SELEX_DOUBLENORM4) nparS = 4;                       ///> double normal has 4 parameters
       if (slx_type_in(ipnt,k) == SELEX_UNIFORM1) nparS = 0;                          ///> uniform has 0 parameters
       if (slx_type_in(ipnt,k) == SELEX_UNIFORM0) nparS = 0;                          ///> uniform has 0 parameters
       if (slx_type_in(ipnt,k) == SELEX_CUBIC_SPLINE) nparS = 2 * slx_extra_in(h,k);  ///> spline has parameters for knots and values
       if (slx_type_in(ipnt,k)< 0) nparS = 0;                                         ///> mirror has 0 parameters
       nparS += ret_max_in(ipnt,k); 
       slx_type_npar(ipnt,k) = nparS;
       nparSs(it,(h-1)*nfleet+k) = nparS;
      } //-- h
    } //-- k
 END_CALCS;

  // Storage by year
  imatrix SelPnt(1,2*nsex*nfleet*Nyears2,1,nclass+6);

  matrix Spar_control(1,1000,1,15);
  imatrix StoIG(1,1000,1,4);
  int PPstoreS;
  !! PPstoreS = PPnt;
 LOC_CALCS 
  {
   n_Spar = 0;
   int n_Spar2; int h; int iblock;
   SelPnt.initialize();
   echoinput << endl;
   gmacs_ctl << "## General parameter specificiations " << endl;
   gmacs_ctl << "##  Initial: Initial value for the parameter (must lie between lower and upper)" << endl;
   gmacs_ctl << "##  Lower & Upper: Range for the parameter" << endl;
   gmacs_ctl << "##  Prior type:"  << endl;
   gmacs_ctl << "##   0: Uniform   - parameters are the range of the uniform prior"  << endl;
   gmacs_ctl << "##   1: Normal    - parameters are the mean and sd" << endl;
   gmacs_ctl << "##   2: Lognormal - parameters are the mean and sd of the log" << endl;
   gmacs_ctl << "##   3: Beta      - parameters are the two beta parameters [see dbeta]" << endl;
   gmacs_ctl << "##   4: Gamma     - parameters are the two gamma parameters [see dgamma]" << endl;
   gmacs_ctl << "##  Phase: Set equal to a negative number not to estimate" << endl;
   gmacs_ctl << "##  Relative: 0: absolute; 1 relative " << endl;
   gmacs_ctl << "##  Block: Block number for time-varying selectivity   " << endl;
   gmacs_ctl << "##  Block_fn: 0:absolute values; 1:exponential" << endl;
   gmacs_ctl << "##  Env_L: Environmental link - options are 0:none; 1:additive; 2:multiplicative; 3:exponential" << endl;
   gmacs_ctl << "##  EnvL_var: Environmental variable" << endl;
   gmacs_ctl << "##  RW: 0 for no random walk changes; 1 otherwise" << endl;
   gmacs_ctl << "##  RW_blk: Block number for random walks" << endl;
   gmacs_ctl << "##  Sigma_RW: Sigma used for the random walk" << endl;
   gmacs_ctl << endl;
   for (int it=1;it<=2;it++)
    for (int h=1;h<=nsex;h++)
     for (int k=1;k<=nfleet;k++)
     if ( nparSs(it,(h-1)*nfleet+k) > 0)
      {
       int ipnt1 = (h-1)*nfleet+k;
       int ipnt2 = (it-1)*nsex*nfleet+(h-1)*nfleet+k;
       int ipnt3 = (it-1)*nsex*nfleet*Nyears2+(h-1)*nfleet*Nyears2+(k-1)*Nyears2;
       int ipnt4 = (it-1)*nsex+h;
       if (nparSs(it,ipnt1) > 0) gmacs_ctl << "# Inputs for type*sex*fleet: " << seltypes(it) << " " << sexes(h) << " " << fleetname(k) << endl;
       if (nparSs(it,ipnt1) > 0) gmacs_ctl << "# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma" << endl;
       n_Spar2 = n_Spar;
       for (int iyr=syr;iyr<=nyrRetro+1;iyr++)
        {
         SelPnt(ipnt3+iyr-syr+1,nclass+2) = it;
         SelPnt(ipnt3+iyr-syr+1,nclass+3) = h;
         SelPnt(ipnt3+iyr-syr+1,nclass+4) = k;
         SelPnt(ipnt3+iyr-syr+1,nclass+5) = iyr;
        }
       int ExtraStuff;
       ExtraStuff = 0;
       for (int ipar=1;ipar<=nparSs(it,ipnt1);ipar++)
        {
         n_Spar += 1;
         StoIG(n_Spar,1) = ipnt2;
         StoIG(n_Spar,2) = ipar;
         StoIG(n_Spar,3) = 0;
         iblock = 1;
         for (int ii=1;ii<=14;ii++) *(ad_comm::global_datafile) >> Spar_control(n_Spar,ii);
         if (it==1) anystring = "Sel_"+fleetname(k)+"_"+sexes(h)+"_base_";
         if (it==2) anystring = "Ret_"+fleetname(k)+"_"+sexes(h)+"_base_";
         if (slx_type_in(ipnt4,k) == SELEX_PARAMETRIC) anystring += "class_"+str(ipar);
         if (slx_type_in(ipnt4,k) == SELEX_COEFFICIENTS) anystring += "class_"+str(ipar);
         if (slx_type_in(ipnt4,k) == SELEX_STANLOGISTIC && ipar == 1) anystring += "Logistic_mean";
         if (slx_type_in(ipnt4,k) == SELEX_STANLOGISTIC && ipar == 2) anystring += "Logistic_cv";
         if (slx_type_in(ipnt4,k) == SELEX_5095LOGISTIC && ipar == 1) anystring += "Logistic_mean";
         if (slx_type_in(ipnt4,k) == SELEX_5095LOGISTIC && ipar == 2) anystring += "Logistic_cv";
         if (slx_type_in(ipnt4,k) == SELEX_ONE_PAR_LOGISTIC && ipar == 1) anystring += "Dec_Logistic_mean";
         if (slx_type_in(ipnt4,k) == SELEX_DECLLOGISTIC && ipar == 1) anystring += "Dec_Logistic_cv";
         if (slx_type_in(ipnt4,k) == SELEX_DECLLOGISTIC && ipar == 2) anystring += "Dec_Logistic_cv";
         if (slx_type_in(ipnt4,k) == SELEX_DECLLOGISTIC && ipar  > 2) anystring += "Dec_Logistic_extra_par"+str(ipar-2);
         if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM && ipar == 1) anystring += "Double normal_par_1";
         if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM && ipar == 2) anystring += "Double normal_par_2";
         if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM && ipar == 3) anystring += "Double normal_par_3";
         if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 1) anystring += "Double normal_par_1";
         if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 2) anystring += "Double normal_par_2";
         if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 3) anystring += "Double normal_par_3";
         if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 4) anystring += "Double normal_par_4";
         if (slx_type_in(ipnt4,k) == SELEX_CUBIC_SPLINE && ipar <= slx_extra_in(ipnt4,k)) anystring += "Spline_knot_"+str(ipar);
         if (slx_type_in(ipnt4,k) == SELEX_CUBIC_SPLINE && ipar > slx_extra_in(ipnt4,k)) anystring += "Spline_value_"+str(ipar-slx_extra_in(h,k));
         
	 gmacs_ctl << "         "; for (int ii=1;ii<=3;ii++) gmacs_ctl << setw(12) << setprecision(6) << setfixed() << Spar_control(n_Spar,ii) << " ";
	 gmacs_ctl << setw(10) << setfixed() << int(Spar_control(n_Spar,4)) << " ";
	 for (int ii=5;ii<=6;ii++) gmacs_ctl << setw(12) << setprecision(6) << setfixed() << Spar_control(n_Spar,ii) << " ";
	 for (int ii=7;ii<=13;ii++) gmacs_ctl << setw(6) << setfixed() << int(Spar_control(n_Spar,ii)) << " ";
	 gmacs_ctl << setw(8) << setprecision(4) << setfixed() << Spar_control(n_Spar,14) << " # " << anystring; gmacs_ctl << endl;
	 for (int ii=1;ii<=14;ii++) echoinput << Spar_control(n_Spar,ii) << " "; echoinput << "# " << anystring << endl;
	 if (int(Spar_control(n_Spar,8)) > 0 || int(Spar_control(n_Spar,10)) > 0 || int(Spar_control(n_Spar,12)) > 0) ExtraStuff = 1;
         parname1(PPnt+1) += anystring;
         PPnt += 1;
        }
       if (ExtraStuff==1) gmacs_ctl << "# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1     Prior_2  Phase Reltve " << endl;
       for (int iyr=syr;iyr<=nyrRetro+1;iyr++)
        for (int ipar=1; ipar<=nparSs(it,ipnt1);ipar++)  SelPnt(ipnt3+iyr-syr+1,ipar) = n_Spar2+ipar;
       for (int ipar=1; ipar<=nparSs(it,ipnt1);ipar++)
        {
         // Are there blocks
         int jpar = n_Spar2+ipar;
         int IgBlock = int(Spar_control(jpar,8));
         int IgBlockFn = int(Spar_control(jpar,9));
         int IgEnvLink = int(Spar_control(jpar,10));
         int IgEnvLinkVar = int(Spar_control(jpar,11));
         int IgRW = int(Spar_control(jpar,12));
         int IgRWBlock = int(Spar_control(jpar,13));
         float SigmaRW = Spar_control(jpar,14);
         if (IgBlock !=0)
          {
           // Environmental link
           if ((IgEnvLink!=0) || (IgRW!=0))      { cout << "Error: you can't have blocks and RWs at the same time - " << seltypes(it) << " " << sexes(h) << " " << fleetname(k) << endl; exit(1); } 
           if ((IgBlock<0) && (IgBlock>nblocks)) { cout << "Error: block out of range - " << seltypes(it) << " " << sexes(h) << " " << fleetname(k) << endl; exit(1); }        
           if ((IgBlockFn<0) && (IgBlockFn>1))   { cout << "Error: block_fn out of range - " << seltypes(it) << " " << sexes(h) << " " << fleetname(k) << endl; exit(1); }        
           for (int kpar=1;kpar<=blocks(IgBlock);kpar++)
            {
             iblock = kpar + 1;
             n_Spar += 1;
             StoIG(n_Spar,1) = ipnt2;
             StoIG(n_Spar,2) = ipar;
             StoIG(n_Spar,3) = 0;
             for (int ii=1;ii<=7;ii++) *(ad_comm::global_datafile) >> Spar_control(n_Spar,ii); *(ad_comm::global_datafile) >> Spar_control(n_Spar,15);
             for (int iyr=blocklimits(IgBlock,kpar,1);iyr<=blocklimits(IgBlock,kpar,2);iyr++)
              SelPnt(ipnt3+iyr-syr+1,ipar) = n_Spar;
             if (it==1) anystring = "Sel_"+fleetname(k)+"_"+sexes(h)+"_";
             if (it==2) anystring = "Ret_"+fleetname(k)+"_"+sexes(h)+"_";
             if (slx_type_in(ipnt4,k) == SELEX_PARAMETRIC) anystring += "class_"+str(ipar);
	     if (slx_type_in(ipnt4,k) == SELEX_COEFFICIENTS) anystring += "class_"+str(ipar);
	     if (slx_type_in(ipnt4,k) == SELEX_STANLOGISTIC && ipar == 1) anystring += "Logistic_mean";
	     if (slx_type_in(ipnt4,k) == SELEX_STANLOGISTIC && ipar == 2) anystring += "Logistic_cv";
	     if (slx_type_in(ipnt4,k) == SELEX_5095LOGISTIC && ipar == 1) anystring += "Logistic_mean";
	     if (slx_type_in(ipnt4,k) == SELEX_5095LOGISTIC && ipar == 2) anystring += "Logistic_cv";
	     if (slx_type_in(ipnt4,k) == SELEX_ONE_PAR_LOGISTIC && ipar == 1) anystring += "Dec_Logistic_mean";
	     if (slx_type_in(ipnt4,k) == SELEX_DECLLOGISTIC && ipar == 1) anystring += "Dec_Logistic_cv";
	     if (slx_type_in(ipnt4,k) == SELEX_DECLLOGISTIC && ipar == 2) anystring += "Dec_Logistic_cv";
	     if (slx_type_in(ipnt4,k) == SELEX_DECLLOGISTIC && ipar  > 2) anystring += "Dec_Logistic_extra_par"+str(ipar-2);
	     if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM && ipar == 1) anystring += "Double normal_par_1";
	     if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM && ipar == 2) anystring += "Double normal_par_2";
	     if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM && ipar == 3) anystring += "Double normal_par_3";
	     if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 1) anystring += "Double normal_par_1";
	     if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 2) anystring += "Double normal_par_2";
	     if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 3) anystring += "Double normal_par_3";
	     if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 4) anystring += "Double normal_par_4";
	     if (slx_type_in(ipnt4,k) == SELEX_CUBIC_SPLINE && ipar <= slx_extra_in(ipnt4,k)) anystring += "Spline_knot_"+str(ipar);
	     if (slx_type_in(ipnt4,k) == SELEX_CUBIC_SPLINE && ipar > slx_extra_in(ipnt4,k)) anystring += "Spline_value_"+str(ipar-slx_extra_in(h,k));
	     anystring += "_block_group_"+str(IgBlock)+"_block_"+str(kpar); 

             gmacs_ctl << "         "; for (int ii=1;ii<=3;ii++) gmacs_ctl << setw(12) << setprecision(6) << setfixed() << Spar_control(n_Spar,ii) << " ";
	     gmacs_ctl << setw(10) << setfixed() << int(Spar_control(n_Spar,4)) << " ";
	     for (int ii=5;ii<=6;ii++) gmacs_ctl << setw(12) << setprecision(6) << setfixed() << Spar_control(n_Spar,ii) << " ";
	     for (int ii=7;ii<=8;ii++) gmacs_ctl << setw(6) << setfixed() << int(Spar_control(n_Spar,ii)) << " ";
  	     gmacs_ctl << "# " << anystring; gmacs_ctl << endl;
             for (int ii=1;ii<=7;ii++) echoinput << Spar_control(n_Spar,ii) << " "; echoinput << Spar_control(n_Spar,15) << " # " << anystring << endl;
             parname1(PPnt+1) += anystring;
             PPnt += 1;
            } //-- kpar  
           } //-- blocks
         if (IgEnvLink !=0) 
          {
           if (IgEnvLink != 1 && IgEnvLink != 2 && IgEnvLink != 3) { cout << "Error: Environmental links can only be 1, 2 or 3 - " << seltypes(it) << " " << sexes(h) << " " << fleetname(k) << " par " << ipar << endl; exit(1); } 
           if (IgEnvLinkVar <= 0 || IgEnvLinkVar > NenvIndics) { cout << "Error: Environmental variable outside range - " << seltypes(it) << " " << sexes(h) << " " << fleetname(k) << " par " << ipar << endl; exit(1); } 
           if (IgRWBlock <=0) { cout << "Error: There needs to a block for environment variables - " << seltypes(it) << " " << sexes(h) << " " << fleetname(k) << " par " << ipar << endl; exit(1); }
           n_Spar += 1;
           anystring = "Env_link_"+fleetname(k)+"_"+sexes(h)+"_";
           if (slx_type_in(ipnt4,k) == SELEX_PARAMETRIC) anystring += "class_"+str(ipar);
	   if (slx_type_in(ipnt4,k) == SELEX_COEFFICIENTS) anystring += "class_"+str(ipar);
	   if (slx_type_in(ipnt4,k) == SELEX_STANLOGISTIC && ipar == 1) anystring += "Logistic_mean";
	   if (slx_type_in(ipnt4,k) == SELEX_STANLOGISTIC && ipar == 2) anystring += "Logistic_cv";
	   if (slx_type_in(ipnt4,k) == SELEX_5095LOGISTIC && ipar == 1) anystring += "Logistic_mean";
	   if (slx_type_in(ipnt4,k) == SELEX_5095LOGISTIC && ipar == 2) anystring += "Logistic_cv";
	   if (slx_type_in(ipnt4,k) == SELEX_ONE_PAR_LOGISTIC && ipar == 1) anystring += "Dec_Logistic_mean";
	   if (slx_type_in(ipnt4,k) == SELEX_DECLLOGISTIC && ipar == 1) anystring += "Dec_Logistic_cv";
	   if (slx_type_in(ipnt4,k) == SELEX_DECLLOGISTIC && ipar == 2) anystring += "Dec_Logistic_cv";
	   if (slx_type_in(ipnt4,k) == SELEX_DECLLOGISTIC && ipar  > 2) anystring += "Dec_Logistic_extra_par"+str(ipar-2);
	   if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM && ipar == 1) anystring += "Double normal_par_1";
	   if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM && ipar == 2) anystring += "Double normal_par_2";
	   if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM && ipar == 3) anystring += "Double normal_par_3";
	   if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 1) anystring += "Double normal_par_1";
	   if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 2) anystring += "Double normal_par_2";
	   if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 3) anystring += "Double normal_par_3";
	   if (slx_type_in(ipnt4,k) == SELEX_DOUBLENORM4 && ipar == 4) anystring += "Double normal_par_4";
	   if (slx_type_in(ipnt4,k) == SELEX_CUBIC_SPLINE && ipar <= slx_extra_in(ipnt4,k)) anystring += "Spline_knot_"+str(ipar);
	   if (slx_type_in(ipnt4,k) == SELEX_CUBIC_SPLINE && ipar > slx_extra_in(ipnt4,k)) anystring += "Spline_value_"+str(ipar-slx_extra_in(h,k));
           
           parname1(PPnt+1) = anystring;
           PPnt += 1;
           StoIG(n_Spar,1) = ipnt2;
           StoIG(n_Spar,2) = ipar;
           StoIG(n_Spar,3) = 1;
           for (int ii=1;ii<=7;ii++) *(ad_comm::global_datafile) >> Spar_control(n_Spar,ii); *(ad_comm::global_datafile) >> Spar_control(n_Spar,15);
           for (int ii=1;ii<=7;ii++) gmacs_ctl << Spar_control(n_Spar,ii) << " "; gmacs_ctl << Spar_control(n_Spar,15) << " # " << anystring << endl;
           for (int ii=1;ii<=7;ii++) echoinput << Spar_control(n_Spar,ii) << " "; echoinput << Spar_control(n_Spar,15) << " # " << anystring << endl;
           for (int kpar=1;kpar<=blocks(IgRWBlock);kpar++)
            {
             for (int iyr=blocklimits(IgRWBlock,kpar,1);iyr<=blocklimits(IgRWBlock,kpar,2);iyr++)
              SelPnt(ipnt3+iyr-syr+1,ipar) = iyr*1000000.0+n_Spar*10000+0+IgEnvLink*100+IgEnvLinkVar;
            } //-- kpar
          } //--Env link
        // Random walk
        if (IgRW !=0) 
         {
          n_devvars += 1;
          devpoints(n_devvars,1) = 3; devpoints(n_devvars,2) = ipnt2; devpoints(n_devvars,3) = n_deviations+1;
          if (IgRWBlock <=0) { cout << "Error: There needs to a block for random walk - " << seltypes(it) << " " << sexes(h) << " " << " par " << ipar <<   endl;  exit(1); }
          if (IgRWBlock > nblocks) { cout << "Error: The block for random walk survey in out of range - " << seltypes(it) << " " << sexes(h) << " " << " par " << ipar <<  endl;  exit(1); }
          for (int kpar=1;kpar<=blocks(IgRWBlock);kpar++)
           for (int iyr=blocklimits(IgRWBlock,kpar,1);iyr<=blocklimits(IgRWBlock,kpar,2);iyr++)
            {
             SelPnt(ipnt3+iyr-syr+1,ipar) = -10000*IgRWBlock-(n_deviations+iyr-blocklimits(IgRWBlock,kpar,1)+1);
            }
          for (int iblk=1;iblk<=blocks(IgRWBlock);iblk++)
           n_deviations += (blocklimits(IgRWBlock,iblk,2)-blocklimits(IgRWBlock,iblk,1)+1);
          devpoints(n_devvars,4) = n_deviations; devpoints(n_devvars,5) = IgRWBlock;
          devpoints(n_devvars,6) = ipar;
          devpoints(n_devvars,7) = it;
          devpoints(n_devvars,8) = h;
          devpoints(n_devvars,9) = k;
          rdevpoints(n_devvars,1) =  SigmaRW;
         } //--Random walk
        } //-- ipar (if)
      gmacs_ctl << endl;
     } //it,h,k
    else
     {
      int ipnt3 = (it-1)*nsex*nfleet*Nyears2+(h-1)*nfleet*Nyears2+(k-1)*Nyears2;
      for (int iyr=syr;iyr<=nyrRetro+1;iyr++)
       {
        SelPnt(ipnt3+iyr-syr+1,nclass+2) = it;
        SelPnt(ipnt3+iyr-syr+1,nclass+3) = h;
        SelPnt(ipnt3+iyr-syr+1,nclass+4) = k;
        SelPnt(ipnt3+iyr-syr+1,nclass+5) = iyr;
       } // iy
     } //- ipar (if)
   } 
 END_CALCS

  imatrix iYrsSelChanges(1,2*nsex*nfleet,syr,nyrRetro+1);
  int nsel_use;
  ivector sel_patterns(1,1000);
  ivector sel_patterns2(1,1000);
  ivector nSelVaries(1,2*nsex*nfleet);
  int maxSelVaries;
  int nsel_patterns;

  !! {
  !!  int inew;
  !!  nsel_patterns = 0;
  !!  nSelVaries.initialize();
  !!  for (int it=1;it<=2;it++)
  !!   for (int h=1;h<=nsex;h++)
  !!    for (int k=1;k<=nfleet;k++)
  !!     {
  !!      inew = 1;
  !!      int ipnt1 = (h-1)*nfleet+k;
  !!      int ipnt2 = (it-1)*nsex*nfleet+(h-1)*nfleet+k;
  !!      int ipnt3 = (it-1)*nsex*nfleet*Nyears2+(h-1)*nfleet*Nyears2+(k-1)*Nyears2;
  !!      SelPnt(ipnt3+1,nclass+6) = 1;
  !!      iYrsSelChanges(ipnt2,syr) = 1;
  !!      nsel_patterns += 1; sel_patterns(nsel_patterns) = ipnt3+1;
  !!      for (int iyr=syr+1;iyr<=nyrRetro+1;iyr++)
  !!       {
  !!        int OK = 1; int Match=-1;
  !!        for (int iyr2=syr;iyr2<iyr;iyr2++)
  !!         {
  !!         int OK2 = 0;
  !!         for (int ipar=1;ipar<=nclass;ipar++)
  !!          if (SelPnt(ipnt3+iyr-syr+1,ipar)!=SelPnt(ipnt3+iyr2-syr+1,ipar)) OK2 = 1;
  !!          if (OK2 == 0 && Match < 0) Match = iyr2;
  !!          if (OK2==0) OK = 0; 
  !!         }
  !!        if (OK==1) { inew += 1; SelPnt(ipnt3+iyr-syr+1,nclass+6) = inew; nsel_patterns += 1; sel_patterns(nsel_patterns) = ipnt3+iyr-syr+1; }
  !!        if (OK==0) { SelPnt(ipnt3+iyr-syr+1,nclass+6) = SelPnt(ipnt3+Match-syr+1,nclass+6); }
  !!        iYrsSelChanges(ipnt2,iyr) = SelPnt(ipnt3+iyr-syr+1,nclass+6);
  !!       }
  !!      nSelVaries(ipnt2) = inew;
  !!     } //-- it,h,k
  !!  maxSelVaries = max(nSelVaries); 
  !!  echoinput << "nSelVaries " << nSelVaries << endl;
  !!  echoinput << "maxSelVaries " << maxSelVaries << endl;
  !!  echoinput << "iYrsSelChanges " << endl;
  !!  echoinput << iYrsSelChanges << endl;
  !!  echoinput << SelPnt << endl;
  !!  echoinput << "sel_patterns" << endl;
  !!  echoinput << sel_patterns << endl;
  
  !!  // Get selectivity parameters
  !!  nsel_use = 0;
  !!  for (int it=1;it<=2;it++)
  !!   for (int h=1;h<=nsex;h++)
  !!    for (int k=1;k<=nfleet;k++)
  !!    if ( nparSs(it,(h-1)*nfleet+k) > 0)
  !!     {
  !!      int is = (it-1)*nsex*nfleet+(h-1)*nfleet+k;
  !!      int ipnt2 = (it-1)*nsex*nfleet+(h-1)*nfleet+k;
  !!      nsel_use +=  nSelVaries(ipnt2);
  !!     }
  !! }

  // Set up the specifications for the selectivity parameters
  vector S_ival(1,n_Spar);
  vector S_lb(1,n_Spar);
  vector S_ub(1,n_Spar);
  ivector S_phz(1,n_Spar);
  ivector prior_Stype(1,n_Spar);
  vector prior_S_p1(1,n_Spar);
  vector prior_S_p2(1,n_Spar);
  ivector S_relative(1,n_Spar);

 LOC_CALCS
  for (int ipar=1;ipar<=n_Spar;ipar++)
   {
    prior_Stype(ipar)   = int(Spar_control(ipar,4));
    if (StoIG(ipar,3)==0)
     {
      S_ival(ipar)        = log(Spar_control(ipar,1));
      S_lb(ipar)          = log(Spar_control(ipar,2));
      S_ub(ipar)          = log(Spar_control(ipar,3));
      prior_S_p1(ipar)    = log(Spar_control(ipar,5));
      prior_S_p2(ipar)    = log(Spar_control(ipar,6));
     }
    else
     {
      S_ival(ipar)        = Spar_control(ipar,1);
      S_lb(ipar)          = Spar_control(ipar,2);
      S_ub(ipar)          = Spar_control(ipar,3);
      prior_S_p1(ipar)    = Spar_control(ipar,5);
      prior_S_p2(ipar)    = Spar_control(ipar,6);
     }
    S_phz(ipar)         = int(Spar_control(ipar,7));
    S_relative(ipar)    = int(Spar_control(ipar,15));
    // If a uniform prior is specified then use the lb and ub rather than p1 and p2.
    if ( prior_Stype(ipar) == UNIFORM_PRIOR )
     {
      prior_S_p1(ipar) = S_lb(ipar);
      prior_S_p2(ipar) = S_ub(ipar);
     }
     
   } //--ipar
  ECHO(S_ival) 
  ECHO(prior_Stype); ECHO(prior_S_p1); ECHO(prior_S_p2); ECHO(S_phz);ECHO(S_relative);
 END_CALCS
  
  // Read in custom selectivity and retention ogives
  !! gmacs_ctl << "# pre-specified selectivity/retention (ordered by type, sex, fleet and year)" << endl;
  !!for (int it=1;it<=2;it++)
  !! for (int h=1;h<=nsex;h++)
  !!  for (int k=1;k<=nfleet;k++)
  !!   if (slx_type_in((it-1)*nsex+h,k) == SELEX_PRESPECIFIED)
  !!    {
  !!     gmacs_ctl << "# Pre-specified values for " << seltypes(it) << " for " << sexes(h) <<"s for " <<fleetname(k) << endl;
  !!     for (int ii=1;ii<=nclass;ii++) gmacs_ctl << setw(9) << setfixed() << ii << " "; gmacs_ctl << endl;
  !!     int offset = (it-1)*nfleet*nsex*(nyr+1-syr+1)+nfleet*(nyr+1-syr+1)*(h-1)+(nyr+1-syr+1)*(k-1);
  !!     for (int iyr =syr;iyr<=nyr+1;iyr++)
  !!      {
  !!       for (int ii=1;ii<=nclass;ii++) 
  !!        { 
  !!         *(ad_comm::global_datafile) >> CustomSelex(offset+iyr-syr+1,ii);
  !!         if (CustomSelex(offset+iyr-syr+1,ii) < 1.0e-10) CustomSelex(offset+iyr-syr+1,ii) = 1.0e-10;
  !!         if (CustomSelex(offset+iyr-syr+1,ii) > 1.0-1.0e-10) CustomSelex(offset+iyr-syr+1,ii) = 1.0-1.0e-10;
  !!        }
  !!       for (int ii=1;ii<=nclass;ii++) gmacs_ctl << setw(9) << setprecision(7) << setfixed() << CustomSelex(offset+iyr-syr+1,ii) << " ";
  !!       gmacs_ctl << "# " << iyr << endl;
  !!      }
  !!    }
    
  // --------------------------------------------------------------------------------------------------------------------------------------
  // |----------------------------------|
  // | CATCHABILITY PARAMETER CONTROLS  |
  // |----------------------------------|
  !! cout << " * Catchability parameter controls" << endl;
  !! gmacs_ctl << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## CATCHABILITY PARAMETER CONTROLS                                                      ##" << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## " << endl;

  !! ECHOSTR(" * Catchability parameter controls");
  !! ECHO(nSurveys);
  init_matrix q_controls(1,nSurveys,1,10);
  
  ivector q_anal(1,nSurveys);
  vector cpue_lambda(1,nSurveys);
  vector cpue_emphasis(1,nSurveys);
  ivector q_mirror(1,nSurveys);
  ivector q_env_var(1,nSurveys);
  ivector q_block(1,nSurveys);
  ivector q_env_link(1,nSurveys);
  ivector q_RW(1,nSurveys);
  ivector q_RW_blk(1,nSurveys);
  vector q_RW_sigma(1,nSurveys);
  int n_qpar;
 LOC_CALCS
  gmacs_ctl << "# Catchability (specifications)" << endl;
  gmacs_ctl <<"# Analytic: should q be estimated analytically (1) or not (0)" << endl;
  gmacs_ctl <<"# Lambda: the weight lambda" << endl;
  gmacs_ctl <<"# Emphasis: the weighting emphasis" << endl;
  gmacs_ctl <<"# Block: Block number for time-varying q" << endl;
  gmacs_ctl <<"# Block_fn: 0:absolute values; 1:exponential" << endl;
  gmacs_ctl <<"# Env_L: Environmental link - options are 0: none; 1:additive; 2:multiplicative; 3:exponential" << endl;;
  gmacs_ctl <<"# EnvL_var: Environmental variable" << endl;
  gmacs_ctl <<"# RW: 0 for no random walk changes; 1 otherwise" << endl;
  gmacs_ctl <<"# RW_blk: Block number for random walks" << endl;
  gmacs_ctl <<"# Sigma_RW: Sigma for the random walk parameters" << endl;

  gmacs_ctl << "## Analytic  Lambda Emphass  Mirror   Block   Env_L EnvL_Vr      RW  RW_blk Sigma_RW" << endl;
  for (int b=1; b<=nSurveys;b++)
   {
    gmacs_ctl << "    ";for (int ii=1;ii<=9;ii++) gmacs_ctl << setw(7) << setfixed() << int(q_controls(b,ii)) << " " ;
    gmacs_ctl << setw(8) << setprecision(4) << setfixed() << q_controls(b,10) << " " << endl;;
   }
  echoinput << "# Catchability  (specifications)" << endl;
  echoinput << q_controls << endl;
  q_anal        = ivector(column(q_controls,1));
  cpue_lambda   = column(q_controls,2);
  cpue_emphasis = column(q_controls,3);
  q_mirror      = ivector(column(q_controls,4));
  q_block       = ivector(column(q_controls,5));
  q_env_link    = ivector(column(q_controls,6));
  q_env_var     = ivector(column(q_controls,7));
  q_RW          = ivector(column(q_controls,8));
  q_RW_blk      = ivector(column(q_controls,9));
  q_RW_sigma    = column(q_controls,10);
  n_qpar = nSurveys; 
  for (int ii=1;ii<=nSurveys;ii++) if(q_mirror(ii)>0) --n_qpar; //--decrement parameter count for mirrored surveys
  for (int ii=1;ii<=nSurveys;ii++)
   if (q_mirror(ii)==0)
    if (q_block(ii)>0) n_qpar += blocks(q_block(ii)); 
  for (int ii=1;ii<=nSurveys;ii++)
   if (q_mirror(ii)==0)
    if (q_env_link(ii)!=0)
      {
      if (q_env_link(ii) != 1 && q_env_link(ii) != 2) { cout << "Error: Environmental links can only be 1 or 2 - survey: " << ii << endl; exit(1); } 
      if (q_env_var(ii) <= 0 || q_env_var(ii) > NenvIndics) { cout << "Error: Environmental variable outside range - survey: " << ii << endl; exit(1); } 
      if (q_RW_blk(ii) <=0) { cout << "Error: There needs to a block for environment variables - survey: " << ii << endl; exit(1); }
      n_qpar += 1; 
      }
  for (int ii=1;ii<=nSurveys;ii++)
   if (q_mirror(ii)==0)
    if (q_RW(ii)!=0)
      {
      n_devvars += 1;
      devpoints(n_devvars,1) = 4; devpoints(n_devvars,2) = ii; devpoints(n_devvars,3) = n_deviations+1;
      if (q_RW_blk(ii) <=0) { cout << "Error: There needs to a block for random walk - survey: " << ii <<endl;  exit(1); }
      if (q_RW_blk(ii) > nblocks) { cout << "Error: The block for random walk survey in out of range - survey: " << ii <<endl;  exit(1); }
      for (int iblk=1;iblk<=blocks(q_RW_blk(ii));iblk++)
        n_deviations += (blocklimits(q_RW_blk(ii),iblk,2)-blocklimits(q_RW_blk(ii),iblk,1)+1);
      devpoints(n_devvars,4) = n_deviations; devpoints(n_devvars,5) = q_RW_blk(ii);
      devpoints(n_devvars,6) = blocks(q_RW_blk(ii));
      rdevpoints(n_devvars,1) = q_RW_sigma(ii);
    }
  echoinput << "final number of catchability parameters: " << n_qpar << endl;
 END_CALCS
  ivector qToSurv(1,n_qpar);//--map from q index to non-mirrored survey index
  ivector qType(1,n_qpar);
  ivector qPoint(1,n_qpar); //--TODO: this is used nowhere
 LOC_CALCS
  int iq; iq = 0;
  for (int ii=1;ii<=nSurveys;ii++) 
   if (q_mirror(ii)==0)
    {
      iq +=1; qToSurv(iq) = ii; qType(iq) = 0; qPoint(iq) = iq; //--was qPoint(ii) = iq; TODO: qPoint is not used anywhere!!
      if (q_block(ii)>0) 
       for (int j=1;j<=blocks(q_block(ii));j++) { iq += 1; qToSurv(iq) = ii; qType(iq) = 0; }
      if (q_env_link(ii)!=0)
       { iq += 1; qToSurv(iq) = ii; qType(iq) = 1; }
    }
  ECHO(qToSurv);
 END_CALCS

  init_matrix q_pars(1,n_qpar,1,7);
  !! gmacs_ctl << "# Catchability (parameters)" << endl;
  !!  gmacs_ctl << "#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase " << endl;
  !!  for (int b=1; b<=n_qpar;b++)
  !!   {
  !!    for (int ii=1;ii<=3;ii++) gmacs_ctl << setw(14) << setprecision(8) << setfixed() << q_pars(b,ii) << " ";
  !!    gmacs_ctl << setw(11) << setfixed() << int(q_pars(b,4)) << " ";
  !!    for (int ii=5;ii<=6;ii++) gmacs_ctl << setw(14) << setprecision(8) << setfixed() << q_pars(b,ii) << " ";
  !!    gmacs_ctl << setw(6) << setfixed() << int(q_pars(b,7)) << " # Survey_q_parameter_"+str(b) << endl;
  !!   }
  !! echoinput << "# Catchability (parameters)" << endl;
  !! echoinput << "# Initial Lower_bound Upper_bound Prior_type Prior_1 Prior_2 Phase " << endl;
  !! echoinput << q_pars << endl;

  vector q_ival(1,n_qpar);
  vector q_lb(1,n_qpar);
  vector q_ub(1,n_qpar);
  ivector q_phz(1,n_qpar);
  ivector prior_qtype(1,n_qpar);
  vector prior_q_p1(1,n_qpar);
  vector prior_q_p2(1,n_qpar);
 LOC_CALCS
  q_ival        = column(q_pars,1);
  q_lb          = column(q_pars,2);
  q_ub          = column(q_pars,3);
  prior_qtype   = ivector(column(q_pars,4));
  prior_q_p1    = column(q_pars,5);
  prior_q_p2    = column(q_pars,6);
  q_phz         = ivector(column(q_pars,7));

  for ( int k = 1; k <= n_qpar; k++ )
   {
    // If a uniform prior is specified then use the lb and ub rather than p1 and p2.
    if ( prior_qtype(k) == UNIFORM_PRIOR )
     { prior_q_p1(k) = q_lb(k); prior_q_p2(k) = q_ub(k); }
    if ( q_anal(qToSurv(k)) == YES )
     {
      if (qType(k)==0 && (prior_qtype(k) != UNIFORM_PRIOR || prior_qtype(k) != LOGNORMAL_PRIOR) )
       {
        cout << "Error: you're only allowed to use a uniform or lognormal prior if the analytic q option is being used," << endl;
        cout << "       you can either specify a uniform or lognormal prior for q or switch analytic q off." << endl;
        exit(1);
       }
      // If we are using analytic q then turn off estimating this parameter by changing the estimation phase to be negative.
      q_phz(k) = -1;
     }
   }
  ECHO(prior_qtype); ECHO(prior_q_p1); ECHO(prior_q_p2); ECHO(q_phz);
 END_CALCS

  // |---------------------------------------------------------|
  // | ADDITIONAL SURVEY CV CONTROLS                           |
  // |---------------------------------------------------------|
  !! gmacs_ctl << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## ADDITIONAL CV PARAMETER CONTROLS                                                     ##" << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## " << endl;
  !! cout << " * Additional CV controls" << endl;
  !! ECHOSTR(" * Additional CV controls");
  init_matrix add_cv_controls(1,nSurveys,1,7);
  !! gmacs_ctl << "# Additiional CV controls (specifications)" << endl;
  !! gmacs_ctl <<"# Mirror: should additional variance be mirrored (value > 1) or not (0)?" << endl;
  !! gmacs_ctl <<"# Block: Block number for time-varying additional variance" << endl;
  !! gmacs_ctl <<"# Block_fn: 0:absolute values; 1:exponential" << endl;
  !! gmacs_ctl <<"# Env_L: Environmental link - options are 0: none; 1:additive; 2:multiplicative; 3:exponential" << endl;;
  !! gmacs_ctl <<"# EnvL_var: Environmental variable" << endl;
  !! gmacs_ctl <<"# RW: 0 for no random walk changes; 1 otherwise" << endl;
  !! gmacs_ctl <<"# RW_blk: Block number for random walks" << endl;
  !! gmacs_ctl <<"# Sigma_RW: Sigma for the random walk parameters" << endl;
  !! gmacs_ctl << "##   Mirror   Block   Env_L EnvL_Vr     RW   RW_blk Sigma_RW" << endl;
  !! for (int b=1; b<=nSurveys;b++)
  !!  {
  !!   gmacs_ctl << "    ";for (int ii=1;ii<=6;ii++) gmacs_ctl << setw(7) << setfixed() << int(add_cv_controls(b,ii)) << " " ;
  !!   gmacs_ctl << setw(8) << setprecision(4) << setfixed() << add_cv_controls(b,7) << " " << endl;;
  !! }
  !! echoinput << "# Additional Index CV" << endl;
  !! gmacs_ctl << "## Mirror Block Env_L EnvL_Var  RW RW_blk Sigma_RW" << endl;
  !! echoinput << add_cv_controls << endl;

  ivector add_cv_mirror(1,nSurveys);
  ivector add_cv_block(1,nSurveys);
  ivector add_cv_env_link(1,nSurveys);
  ivector add_cv_env_var(1,nSurveys);
  ivector add_cv_RW(1,nSurveys);
  ivector add_cv_RW_blk(1,nSurveys);
  vector add_cv_RW_sigma(1,nSurveys);
 LOC_CALCS
  add_cv_mirror     = ivector(column(add_cv_controls,1));
  add_cv_block      = ivector(column(add_cv_controls,2));
  add_cv_env_link   = ivector(column(add_cv_controls,3));
  add_cv_env_var    = ivector(column(add_cv_controls,4));
  add_cv_RW         = ivector(column(add_cv_controls,5));
  add_cv_RW_blk     = ivector(column(add_cv_controls,6));
  add_cv_RW_sigma   = column(add_cv_controls,6);
 END_CALCS

  int n_addcv_par;
 LOC_CALCS
  n_addcv_par = nSurveys; 
  for (int ii=1;ii<=nSurveys;ii++) if (add_cv_mirror(ii)>0) n_addcv_par--;
  echoinput << "n_addcv_par: " << n_addcv_par << endl;
  for (int ii=1;ii<=nSurveys;ii++)
   if (add_cv_mirror(ii)==0)
    if (add_cv_block(ii)>0) n_addcv_par += blocks(add_cv_block(ii)); 
  for (int ii=1;ii<=nSurveys;ii++)
   if (add_cv_mirror(ii)==0)
    if (add_cv_env_link(ii)!=0)
      { 
      if (add_cv_env_link(ii) != 1 && add_cv_env_link(ii) != 2) { cout << "Error: Environmental links can only be 1 or 2 - survey: " << ii << endl; exit(1); } 
      if (add_cv_env_var(ii) <= 0 || add_cv_env_var(ii) > NenvIndics) { cout << "Error: Environmental variable outside range - survey: " << ii <<  endl; exit(1);} 
      if (add_cv_RW_blk(ii) <=0) { cout << "Error: There needs to a block for environment variables - survey: " << ii <<endl;  exit(1); }
      n_addcv_par += 1; 
      }
  for (int ii=1;ii<=nSurveys;ii++)
   if (add_cv_mirror(ii)==0)
    if (add_cv_RW(ii)!=0) 
      {
      n_devvars += 1;
      devpoints(n_devvars,1) = 5; devpoints(n_devvars,2) = ii; devpoints(n_devvars,3) = n_deviations+1;
      if (add_cv_RW_blk(ii) <=0) { cout << "Error: There needs to a block for environment variables - survey: " << ii <<endl;  exit(1); }
      if (add_cv_RW_blk(ii) > nblocks) { cout << "Error: The block for random walk survey in out of range - survey: " << ii <<endl;  exit(1); }
      for (int iblk=1;iblk<=blocks(add_cv_RW_blk(ii));iblk++)
        n_deviations += (blocklimits(add_cv_RW_blk(ii),iblk,2)-blocklimits(add_cv_RW_blk(ii),iblk,1)+1);
      devpoints(n_devvars,4) = n_deviations; devpoints(n_devvars,5) = add_cv_RW_blk(ii);
      devpoints(n_devvars,6) = blocks(add_cv_RW_blk(ii));
      rdevpoints(n_devvars,1) = q_RW_sigma(ii);
    }
  echoinput << "n_addcv_par (final) = " << n_addcv_par << endl;
  ECHO(devpoints);
  ECHO(rdevpoints);
  ECHO(n_deviations);
 END_CALCS
  ivector AddcvToSurv(1,n_addcv_par);
  ivector AddcvType(1,n_addcv_par);
 LOC_CALCS
  int iaddcv; iaddcv = 0;
  for (int ii=1;ii<=nSurveys;ii++)
   if (add_cv_mirror(ii)==0)
    {
      iaddcv +=1; AddcvToSurv(iaddcv) = ii; AddcvType(iaddcv) = 0;
      if (add_cv_block(ii)>0) 
      for (int j=1;j<=blocks(add_cv_block(ii));j++) { iaddcv += 1; AddcvToSurv(iaddcv) = ii; AddcvType(iaddcv) = 0; }
      if (add_cv_env_link(ii)!=0)
      { iaddcv += 1; AddcvToSurv(iaddcv) = ii; AddcvType(iaddcv) = 1; }
    }
  echoinput << "iaddcv (final) = " << iaddcv << endl;
 END_CALCS

  vector add_cv_ival(1,n_addcv_par);
  vector add_cv_lb(1,n_addcv_par);
  vector add_cv_ub(1,n_addcv_par);
  ivector prior_add_cv_type(1,n_addcv_par);
  vector prior_add_cv_p1(1,n_addcv_par);
  vector prior_add_cv_p2(1,n_addcv_par);
  ivector cv_phz(1,n_addcv_par);

  init_matrix add_cv_pars(1,n_addcv_par,1,7);
  !! gmacs_ctl << "# Additional variance (parameters)" << endl;
  !!  gmacs_ctl << "#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase " << endl;
  !!  for (int b=1; b<=n_addcv_par;b++)
  !!   {
  !!    for (int ii=1;ii<=3;ii++) gmacs_ctl << setw(14) << setprecision(8) << setfixed() << add_cv_pars(b,ii) << " ";
  !!    gmacs_ctl << setw(11) << setfixed() << int(add_cv_pars(b,4)) << " ";
  !!    for (int ii=5;ii<=6;ii++) gmacs_ctl << setw(14) << setprecision(8) << setfixed() << add_cv_pars(b,ii) << " ";
  !!    gmacs_ctl << setw(6) << setfixed() << int(add_cv_pars(b,7)) << " # Add_cv_parameter_"+str(b) << endl;
  !!   }
  !! echoinput << "# Index CV" << endl;
  !! echoinput << "# Initial Lower_bound Upper_bound Prior_type Prior_1 Prior_2 Phase " << endl;
  !! echoinput << add_cv_pars << endl;

  vector log_add_cv_ival(1,n_addcv_par);
  vector log_add_cv_lb(1,n_addcv_par);
  vector log_add_cv_ub(1,n_addcv_par);
  
  !! add_cv_ival       = column(add_cv_pars,1);
  !! add_cv_lb         = column(add_cv_pars,2);
  !! add_cv_ub         = column(add_cv_pars,3);
  !! prior_add_cv_type = ivector(column(add_cv_pars,4));
  !! prior_add_cv_p1   = column(add_cv_pars,5);
  !! prior_add_cv_p2   = column(add_cv_pars,6);
  !! cv_phz            = ivector(column(add_cv_pars,7));
  
  !! // code to transform the initial values and turn off additional variance
  !! echoinput << "starting 1" <<endl;
  !! int k = 0;
  !! for (int ks = 1; ks <= nSurveys; ks++)
  !!  if (add_cv_mirror(ks)==0)
  !!  {
  !!   k++;
  !!   echoinput << "ks = "<<ks<< " k = "<<k<< endl;
  !!   for (int ipar=1;ipar<=n_addcv_par;ipar++)
  !!    {
  !!     echoinput << "ipar = "<<ipar<< " n_addcv_par = " << n_addcv_par << endl;
  !!     if (AddcvToSurv(k)==ks && AddcvType(k)==0) 
  !!      { echoinput << 2 << endl; log_add_cv_ival(ipar) = log(add_cv_ival(ipar)); log_add_cv_lb(ipar) = log(add_cv_lb(ipar)); log_add_cv_ub(ipar) = log(add_cv_ub(ipar)); }
  !!     if (AddcvToSurv(k)==ks && AddcvType(k)==1) 
  !!      { echoinput << 3 << endl; log_add_cv_ival(ipar) = add_cv_ival(ipar); log_add_cv_lb(ipar) = add_cv_lb(ipar); log_add_cv_ub(ipar) = add_cv_ub(ipar); }
  !!     // If a uniform prior is specified then use the lb and ub rather than p1 and p2.
  !!     if ( prior_add_cv_type(k) == UNIFORM_PRIOR )
  !!      {  echoinput << 4 << endl; prior_add_cv_p1(k) = add_cv_lb(k); prior_add_cv_p2(k) = add_cv_ub(k); }
  !!    }
  !!   } 
  !! echoinput << "finished 1" <<endl;
  !! ECHO(prior_add_cv_type); ECHO(prior_add_cv_p1); ECHO(prior_add_cv_p2);  ECHO(cv_phz);

  // |---------------------------------------------------------|
  // | PENALTIES FOR MEAN FISHING MORTALITY RATE FOR EACH GEAR |
  // |---------------------------------------------------------|
  !! cout << " * Fishing mortality controls" << endl;
  !! gmacs_ctl << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## CONTROLS ON F                                                                        ##" << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## " << endl;
  !! ECHOSTR(" * Fishing mortality controls");
  init_matrix f_controls(1,nfleet,1,12);
  ivector f_phz(1,nfleet);
  ivector foff_phz(1,nfleet);
  vector init_fbar(1,nfleet);
  vector log_init_fbar(1,nfleet);
  vector log_init_fbar_foff(1,nfleet);
  matrix pen_fstd(1,2,1,nfleet);
  vector fbar_lb(1,nfleet)
  vector fbar_ub(1,nfleet);
  vector fdev_lb(1,nfleet)
  vector fdev_ub(1,nfleet);
  vector foff_lb(1,nfleet)
  vector foff_ub(1,nfleet);

  !! gmacs_ctl << "# Controls on F" << endl;
  !! gmacs_ctl << "#   Initial_male_F  Initial_fem_F   Pen_SD (mal)   Pen_SD (fem) Phz_mean_F_mal Phz_mean_F_fem   Lower_mean_F   Upper_mean_F Low_ann_male_F  Up_ann_male_F    Low_ann_f_F     Up_ann_f_F" << endl;
  !! for (int b=1; b<=nfleet;b++)
  !!  {
  !!   gmacs_ctl << "    ";for (int ii=1;ii<=12;ii++) gmacs_ctl << setw(14) << setprecision(6) << setfixed() << f_controls(b,ii) << " " ;
  !!   gmacs_ctl << " # " << fleetname(b) << endl;
  !! }
  !! echoinput << "# Controls on F" << endl;
  !! echoinput << "# Initial_male_f Initial_female_F Penalty_SD (early phase) Penalty_SD (later Phase) Phase_mean_F_male Phase_mean_F_female Lower_bound_mean_F Upper_bound_mean_F Lower_bound_annual_male_F Upper_bound_annual_male_F Lower_bound_annual_female_F Upper_bound_annual_female_F" << endl;
  !! echoinput << f_controls << endl;
  !! init_fbar = column(f_controls,1);
  !! log_init_fbar = log(init_fbar + 1.0e-14);
  !! log_init_fbar_foff = log(column(f_controls,2) + 1.0e-14);
  !! for ( int i = 1; i <= 2; i++ ) pen_fstd(i) = trans(f_controls)(i+2);//TODO: use column extractor here
  !! f_phz = ivector(column(f_controls,5));
  !! foff_phz = ivector(column(f_controls,6));
  !! ECHO(f_phz);
  !! ECHO(foff_phz);
  !! fbar_lb = column(f_controls,7);
  !! fbar_ub = column(f_controls,8);
  !! ECHO(fbar_lb);
  !! ECHO(fbar_ub);
  !! fdev_lb = column(f_controls,9);
  !! fdev_ub = column(f_controls,10);
  !! ECHO(fdev_lb);
  !! ECHO(fdev_ub);
  !! foff_lb = column(f_controls,11);
  !! foff_ub = column(f_controls,12);
  !! ECHO(foff_lb);
  !! ECHO(foff_ub);
 
  // |-----------------------------------|
  // | OPTIONS FOR SIZE COMPOSITION DATA |
  // |-----------------------------------|
  !! cout << " * Size composition controls" << endl;
  !! gmacs_ctl << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## SIZE COMPOSITIONS OPTIONS                                                            ##" << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## " << endl;

  !! ECHOSTR(" * Size composition controls");
  init_ivector iSizeCompType_in(1,nSizeComps_in);                     ///> Size-comp likelihood
  !! for (int k =1; k<=nSizeComps_in; k++)
  !!  if (iSizeCompType_in(k) != 0 && iSizeCompType_in(k) != 1 && iSizeCompType_in(k) != 2 && iSizeCompType_in(k) != 5 && iSizeCompType_in(k) != 6)
  !!   { cout << "Size comp type must be 0, 1, 2, 5 or 6" << endl; 
  !!       ECHOSTR("Size comp type must be 0, 1, 2, 5 or 6"); 
  !!       echoinput<<"k = "<<k<<" iSizeCompType_in(k) = "<<iSizeCompType_in(k)<<endl;
  !!       exit(1); 
  !!   }
  init_ivector bTailCompression_in(1,nSizeComps_in);                 ///> option for tail compression
  init_vector bTailCompression_pmin_in(1,nSizeComps_in);             ///> extent of tail compression 
  init_ivector iCompAggregator(1,nSizeComps_in);                     ///> should data be aggregated
  init_ivector lf_catch_in(1,nSizeComps_in);                         ///> Survey-like predictions or catch-like predictions
  init_vector lf_lambda_in(1,nSizeComps_in);                         ///> Lambda for effect N
  init_vector lf_emphasis_in(1,nSizeComps_in);                       ///> Overall lambda
  init_ivector survey_for_q_in(1,nSizeComps_in);                     ///> Survey to which this comp relates

  !! echoinput << "iSizeCompType_in: " << iSizeCompType_in << endl;
  !! echoinput << "bTailCompression_in: " << bTailCompression_in << endl;
  !! echoinput << "bTailCompression_pmin_in: " << bTailCompression_pmin_in << endl;
  !! echoinput << "iCompAggregator: " << iCompAggregator << endl;
  !! echoinput << "lf_catch_in: " << lf_catch_in << endl;
  !! echoinput << "lf_lambda_in: " << lf_lambda_in << endl;
  !! echoinput << "lf_emphasis_in: " << lf_emphasis_in << endl;
  !! echoinput << "survey_for_q_in: " << survey_for_q_in << endl;
  int nSizeComps;
  !! nSizeComps = max(iCompAggregator);                              ///> Number of length comps after aggregation
  !! echoinput << "nSizeComps from iCompAggregator: " << nSizeComps << endl;
  ivector nSizeCompRows(1,nSizeComps);
  ivector nSizeCompCols(1,nSizeComps);
  ivector iSizeCompType(1,nSizeComps);
  ivector bTailCompression(1,nSizeComps);
  vector lf_catch(1,nSizeComps);
  vector lf_lambda(1,nSizeComps);
  vector lf_emphasis(1,nSizeComps);

  //--read the information for the effective sample size parameters 
  init_matrix log_vn_pars(1,nSizeComps,1,7);
  !! echoinput << "log_vn_pars: " << endl << log_vn_pars << endl;
  vector log_vn_ival(1,nSizeComps);
  vector log_vn_lb(1,nSizeComps);
  vector log_vn_ub(1,nSizeComps);
  ivector log_vn_phz(1,nSizeComps);
  vector prior_log_vn_type(1,nSizeComps);
  vector prior_log_vn_p1(1,nSizeComps);
  vector prior_log_vn_p2(1,nSizeComps);

 LOC_CALCS
  gmacs_ctl <<"# Options when fitting size-composition data" << endl;
  gmacs_ctl << "## Likelihood types: " << endl;
  gmacs_ctl << "##  1:Multinomial with estimated/fixed sample size" << endl;
  gmacs_ctl << "##  2:Robust approximation to multinomial" << endl;
  gmacs_ctl << "##  3:logistic normal" << endl;
  gmacs_ctl << "##  4:multivariate-t" << endl;
  gmacs_ctl << "##  5:Dirichlet" << endl;
  gmacs_ctl << "##  6:Dirichlet-Alt (Thorson et al 2016 rec'd)" << endl;
  gmacs_ctl << endl;
  anystring = "# ";
  for ( int kk = 1; kk <= nSizeComps_in; kk++ ) anystring = anystring + " " + fleetname(d3_SizeComps_in(kk,1,-5));
  gmacs_ctl << anystring << endl;
  ECHOSTR(anystring);
  anystring = "# ";
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    if (d3_SizeComps_in(kk,1,-4)==UNDET_SEX)        anystring = anystring +" M+F ";
    if (d3_SizeComps_in(kk,1,-4)==MALES)            anystring = anystring +"  M  ";
    if (d3_SizeComps_in(kk,1,-4)==FEMALES)          anystring = anystring +"  F  ";
   }
  gmacs_ctl << anystring << endl;
  ECHOSTR(anystring);
  anystring = "# ";
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    if (d3_SizeComps_in(kk,1,-3)==TOTALCATCH)       anystring = anystring +" tot ";
    if (d3_SizeComps_in(kk,1,-3)==RETAINED)         anystring = anystring +" ret ";
    if (d3_SizeComps_in(kk,1,-3)==DISCARDED)        anystring = anystring +" dsc ";
   }
  gmacs_ctl << anystring << endl;
  ECHOSTR(anystring);
  anystring = "# ";
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    if (d3_SizeComps_in(kk,1,-2)==UNDET_SHELL)      anystring = anystring +" N+S ";
    if (d3_SizeComps_in(kk,1,-2)==NEW_SHELL)        anystring = anystring +" NS  ";
    if (d3_SizeComps_in(kk,1,-2)==OLD_SHELL)        anystring = anystring +" OS  ";
   }
  gmacs_ctl << anystring << endl;
  ECHOSTR(anystring);
  anystring = "# ";
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    if (d3_SizeComps_in(kk,1,-1)==UNDET_MATURE)     anystring = anystring +" I+M ";
    if (d3_SizeComps_in(kk,1,-1)==IMMATURE)         anystring = anystring +" imm ";
    if (d3_SizeComps_in(kk,1,-1)==MATURE)           anystring = anystring +" mat ";
   }
  gmacs_ctl << anystring << endl;
  ECHOSTR(anystring);

  gmacs_ctl << setw(6) << setfixed() << iSizeCompType_in     << " # Type of likelihood" <<  endl;
  gmacs_ctl << setw(6) << setfixed() << bTailCompression_in << " # Auto tail compression" <<  endl;
  gmacs_ctl << setw(6) << setprecision(4) << setfixed()    << bTailCompression_pmin_in        << " # Auto tail compression (pmin)" << endl;
  gmacs_ctl << setw(6) << setfixed() << iCompAggregator    << " # Composition aggregator codes" << endl;
  gmacs_ctl << setw(6) << setfixed() << lf_catch_in        << " # Set to 1 for catch-based predictions; 2 for survey or total catch predictions" << endl;
  gmacs_ctl << setw(6) << setprecision(4) << setfixed()    << lf_lambda_in        << " # Lambda for effective sample size" << endl;
  gmacs_ctl << setw(6) << setprecision(4) << setfixed()    << lf_emphasis_in      << " # Lambda for overall likelihood" << endl;
  gmacs_ctl << setw(6) << setfixed()                       << survey_for_q_in     << " # Survey to set Q for this comp" << endl;
  nSizeCompCols.initialize();
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    int k = iCompAggregator(kk);
    // Currently this only works if the number of rows in each size composition group are the same and have the same years. If not then gmacs throws an error.
    nSizeCompRows(k) = nSizeCompRows_in(kk);
    // We are appending the arrays horizontally.
    nSizeCompCols(k) += nSizeCompCols_in(kk);
    // Again, we are using only the last specification here, may want to add a check to ensure the user specifies that these are the same and throw an error if not.
    iSizeCompType(k) = iSizeCompType_in(kk);
    bTailCompression(k) = bTailCompression_in(kk);
    lf_catch(k) = lf_catch_in(kk);
    lf_lambda(k) = lf_lambda_in(kk);
    lf_emphasis(k) = lf_emphasis_in(kk);
   }

  gmacs_ctl << endl;
  gmacs_ctl << "# Effective sample size parameters (number matches max(Composition Aggregator code)) " << endl;
  gmacs_ctl << "#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase " << endl;
  for (int b=1; b<=nSizeComps;b++)
   {
    for (int ii=1;ii<=3;ii++) gmacs_ctl << setw(14) << setprecision(8) << setfixed() << log_vn_pars(b,ii) << " ";
    gmacs_ctl << setw(11) << setfixed() << int(log_vn_pars(b,4)) << " ";
    for (int ii=5;ii<=6;ii++) gmacs_ctl << setw(14) << setprecision(8) << setfixed() << log_vn_pars(b,ii) << " ";
    gmacs_ctl << setw(6) << setfixed() << int(log_vn_pars(b,7)) << " # Overdispersion_parameter_for_size_comp_" << b << "(possibly extended)" << endl;;
   }
  echoinput << endl;
  echoinput << "# Initial Lower_bound Upper_bound Prior_type Prior_1 Prior_2 Phase " << endl;
  echoinput << log_vn_pars << endl;
  
  for ( int k = 1; k <= nSizeComps; k++ )
   {
    log_vn_ival(k)        = log(log_vn_pars(k,1));
    log_vn_lb(k)          = log(log_vn_pars(k,2));
    log_vn_ub(k)          = log(log_vn_pars(k,3));
    prior_log_vn_type(k)  = int(log_vn_pars(k,4));
    prior_log_vn_p1(k)    = log(log_vn_pars(k,5));
    prior_log_vn_p2(k)    = log(log_vn_pars(k,6));
    log_vn_phz(k)         = int(log_vn_pars(k,7));
   }
   
  for ( int k = 1; k <= nSizeComps; k++ )
   {
    // If a uniform prior is specified then use the lb and ub rather than p1 and p2.
    if ( prior_log_vn_type(k) == UNIFORM_PRIOR )
     { prior_log_vn_p1(k) = log_vn_lb(k); prior_log_vn_p2(k) = log_vn_ub(k); }
   }
  ECHO(prior_log_vn_type); ECHO(prior_log_vn_p1); ECHO(prior_log_vn_p2); ECHO(log_vn_phz);
  
  // Names of parameters
  for ( int ii=1;ii<=nSizeComps;ii++ )
   {
    PPnt += 1;
    parname1(PPnt) = "Log_vn_aggregated_size_comp"+str(ii); 
   }
  
  // Do the checks mentioned above
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    int k = iCompAggregator(kk);
    if ( nSizeCompRows(k) != nSizeCompRows_in(kk) )
     {
      cout << "Error: dimension mismatch in size-compositions being aggregated " << kk << " " << k << " " << nSizeCompRows_in(kk) << " "<<  nSizeCompRows(k) << endl;
      exit(1);
     }
    if ( iSizeCompType(k) != iSizeCompType_in(kk) )
     {
      cout << "Error: mismatch in type of likelihood for size-compositions being aggregated" << endl;
      exit(1);
     }
    if ( bTailCompression(k) != bTailCompression_in(kk) )
     {
      cout << "Error: mismatch in auto tail compression for size-compositions being aggregated" << endl;
      exit(1);
     }
   }
 END_CALCS

  int nMapInpToAggSizeComps;//--number of rows in map from input to aggregated size comps
 LOC_CALCS
  int rowCount;
  nMapInpToAggSizeComps = 0;
  // This aggregates the size composition data by appending size comps horizontally
  for ( int kk = 1; kk <= nSizeComps_in; kk++ ){
    int k = iCompAggregator(kk);
    rowCount = 0;
    for ( int ii = 1; ii <= nSizeCompRows_in(kk); ii++ ) {
      if ((d3_SizeComps_in(kk,ii,-7) <= nyrRetro) || 
          ((d3_SizeComps_in(kk,ii,-7) == nyrRetro+1) && (d3_SizeComps_in(kk,ii,-6) == 1)) ) {
        rowCount += 1;
        nMapInpToAggSizeComps += nSizeCompCols_in(kk);
       }
    }
    nSizeCompRows(k) = rowCount;
  }//--kk
 END_CALCS

  //--"map" from input size comps df, row, col to aggregated size comps df, row, col
  imatrix mapInpToAggSizeComps(1,nMapInpToAggSizeComps,1,6);

  3darray d3_obs_size_comps(1,nSizeComps,1,nSizeCompRows,1,nSizeCompCols);
  matrix size_comp_sample_size(1,nSizeComps,1,nSizeCompRows);
  matrix size_comp_year(1,nSizeComps,1,nSizeCompRows);
  matrix size_comp_season(1,nSizeComps,1,nSizeCompRows);
  ivector ilike_vector(1,nlikes)
  vector TempSize(1,nclass);
  vector cumsum(1,nclass);
  number pmin;
  number TotalSize;
  
  3darray tailcompind(1,nSizeComps_in,1,nSizeCompRows_in,1,2);

 LOC_CALCS
  int i,j;
   
  // Ths does the tail compression
  for ( int kk = 1; kk <= nSizeComps_in; kk++ ) 
   for ( int ii = 1; ii <= nSizeCompRows_in(kk); ii++ )
    {
     // Tail compression is on
     if (bTailCompression_in(kk) == 1)
      {
       pmin =bTailCompression_pmin_in(kk);
       TempSize.initialize();
       cout << d3_obs_size_comps_in(kk,ii) << endl;
       for (int jj=1;jj<=nSizeCompCols_in(kk);jj++) TempSize(jj) = d3_obs_size_comps_in(kk,ii,jj);
       TotalSize = sum(TempSize);
       TempSize /= TotalSize;
       int end = 0;
       cumsum.initialize(); 
       for (int jj=1;jj<=nSizeCompCols_in(kk) & end==0;jj++)
        {
         if (jj==1) cumsum(jj) = TempSize(jj);
         if (jj>1) cumsum(jj) = cumsum(jj-1) + TempSize(jj);
         TempSize(jj) = 0;
         if (cumsum(jj) > pmin) end = jj;
        }
       TempSize(end) = cumsum(end);
       tailcompind(kk,ii,1) = end;
       end = nSizeCompCols_in(kk)+1;
       int nsizecompscols = nSizeCompCols_in(kk);
       for (int jj=nSizeCompCols_in(kk);jj>=1;jj--)
         {
         if (jj==nSizeCompCols_in(kk)) cumsum(jj) = TempSize(jj);
         if (jj<nSizeCompCols_in(kk)) cumsum(jj) = cumsum(jj+1) + TempSize(jj);
         TempSize(jj) = 0;
         if (cumsum(jj) > pmin) { end = jj; jj = -1; }
        }
       TempSize(end) = cumsum(end);
       tailcompind(kk,ii,2) = end;
       //--normalize to input sample size
       for (int jj=1;jj<=nSizeCompCols_in(kk);jj++) d3_obs_size_comps_in(kk,ii,jj) = TempSize(jj)*size_comp_sample_size_in(kk,ii);
       cout << d3_obs_size_comps_in(kk,ii) << endl;
       //exit(1);
      }
     else
      { //--no tail compression
        tailcompind(kk,ii,1) = 1; tailcompind(kk,ii,2) = nSizeCompCols_in(kk); 
        //--normalize to input sample size
        d3_obs_size_comps_in(kk,ii) = size_comp_sample_size_in(kk,ii)*(d3_obs_size_comps_in(kk,ii)/sum(d3_obs_size_comps_in(kk,ii)));
      }
    }//--loops over ii and kk
  
  int oldk = 9999;
  // This aggregates the size composition data by appending size comps horizontally
  int idx = 1;//--row index into mapInpToAggSizeComps
  //cout << "nMapInpToAggSizeComps = " << nMapInpToAggSizeComps << endl;
  for ( int kk = 1; kk <= nSizeComps_in; kk++ ) {
    int k = iCompAggregator(kk);
    if ( oldk != k ) j = 0;
    oldk = k;
    for ( int jj = 1; jj <= nSizeCompCols_in(kk); jj++ ) {
      j += 1;
      for ( int ii = 1; ii <= nSizeCompRows_in(kk); ii++ ){
        if ((d3_SizeComps_in(kk,ii,-7) <= nyrRetro) || 
           ((d3_SizeComps_in(kk,ii,-7) == nyrRetro+1) && (d3_SizeComps_in(kk,ii,-6)) == 1) ){
          d3_obs_size_comps(k,ii,j) = d3_obs_size_comps_in(kk,ii,jj); //--_in now sums to input sample size over jj
          //cout << idx << " inp: " << kk << " " << ii << " " << jj << " agg: " << k << " " << ii << " " << j << endl;
          mapInpToAggSizeComps(idx)(1) = kk; //--input size comp dataframe index
          mapInpToAggSizeComps(idx)(2) = ii; //--input size comp row
          mapInpToAggSizeComps(idx)(3) = jj; //--input size comp column
          mapInpToAggSizeComps(idx)(4) = k;  //--aggregated size comp "dataframe" index
          mapInpToAggSizeComps(idx)(5) = ii; //--aggregated size comp row (redundant, yes)
          mapInpToAggSizeComps(idx)(6) = j;  //--aggregated size comp column
          idx++; //--increment row index into mapInpToAggSizeComps
        }
      }//--ii
     }//--jj
   }//--kk

   // The size composition sample sizes are calculated as the sum of the aggregated sample sizes
  size_comp_sample_size.initialize();
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    int k = iCompAggregator(kk);
    for ( int ii = 1; ii <= nSizeCompRows_in(kk); ii++ )
     if (d3_SizeComps_in(kk,ii,-7) <= nyrRetro || (d3_SizeComps_in(kk,ii,-7) == nyrRetro+1 && d3_SizeComps_in(kk,ii,-6) == 1) )
      {
       size_comp_sample_size(k,ii) += size_comp_sample_size_in(kk,ii);//--add up component input sample sies
       size_comp_year(k,ii) = size_comp_year_in(kk,ii);
       size_comp_season(k,ii) = size_comp_season_in(kk,ii);
      }
   }
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    int k = iCompAggregator(kk);
    for ( int ii = 1; ii <= nSizeCompRows_in(kk); ii++ )
     if (d3_SizeComps_in(kk,ii,-7) <= nyrRetro || (d3_SizeComps_in(kk,ii,-7) == nyrRetro+1 && d3_SizeComps_in(kk,ii,-6) == 1) )
      {
       if ( size_comp_year(k,ii) != size_comp_year_in(kk,ii) )
        {
         cout << "Error: mismatch in years for size-compositions being aggregated" << endl;
         cout << "       see the " << size_comp_year_in(kk,ii) << " year in size composition " << kk << " in the .dat file" << endl;
          exit(1);
        }
      }
   }

  // This normalizes all observations by row
  for ( int k = 1; k <= nSizeComps; k++ )
   for ( int i = 1; i <= nSizeCompRows(k); i++ )
    if (size_comp_year(k,i) <= nyrRetro || (size_comp_year(k,i) == nyrRetro+1 && size_comp_season(k,i) == 1) )
     d3_obs_size_comps(k,i) /= sum(d3_obs_size_comps(k,i));//--now sums to 1 over 3rd index for "aggregated" comp

  ECHO(d3_obs_size_comps);
  ilike_vector(1) = nCatchDF;
  like_names      =  adstring("Catch ");
  ilike_vector(2) = nSurveys;
  like_names      = like_names + adstring("Survey_Indices ");
  ilike_vector(3) = nSizeComps;
  like_names      = like_names + adstring("SizeComps ");
  ilike_vector(4) = 3;
  ilike_vector(5) = nsex;
 END_CALCS

  // |---------------------------------------------------------|
  // | TAGGING CONTROLS                                        |
  // |---------------------------------------------------------|
  !! cout << " * Tagging controls" << endl;
  !! gmacs_ctl << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! gmacs_ctl <<"## EMPHASIS FACTORS                                                                     ##" << endl;
  !! gmacs_ctl <<"## ==================================================================================== ##" << endl;
  !! ECHOSTR(" * Tagging controls");
  init_number tag_emphasis
  !! gmacs_ctl << "\n" << setw(6) << setprecision(4) << setfixed() << tag_emphasis << " # Emphasis on tagging data" << endl;
  !! echoinput << tag_emphasis << " # tag_emphasis" << endl;
  
  init_vector catch_emphasis(1,nCatchDF);                  ///> Weights on catches
  !! gmacs_ctl << "\n" << setw(6) << setprecision(4) << setfixed() << catch_emphasis << " # Emphasis on Catch: (by catch dataframes)" << endl;

  !! cout << "## Emphasis Factors (Fdev Penalties) ##" << endl;
  init_matrix Penalty_fdevs(1,nfleet,1,4);                 ///> Fleet-species weights
  !! gmacs_ctl << "\n# Weights for penalties 1, 11, and 12" << endl;
  !! gmacs_ctl << "#   Mean_M_fdevs | Mean_F_fdevs |  Ann_M_fdevs |  Ann_F_fdevs" << endl;
  !! for (int b=1;b<=nfleet;b++)
  !!  {
  !!   gmacs_ctl << " ";
  !!   gmacs_ctl <<setw(14) << setprecision(4) << setfixed() << Penalty_fdevs(b);
  !!   gmacs_ctl << " # " << fleetname(b) << endl;
  !!  }
  !! cout << "## Emphasis Factors (Priors/Penalties) ##" << endl;
  !! gmacs_ctl << "\n## Emphasis Factors (Priors/Penalties: 13 values) ##" << endl;
  
  init_vector Penalty_emphasis(1,13);                       ///> Weights on penalties
 LOCAL_CALCS
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(1)<<"\t#--Penalty on log_fdev (male+combined; female) to ensure they sum to zero"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(2)<<"\t#--Penalty on mean F by fleet to regularize the solution"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(3)<<"\t#--Not used"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(4)<<"\t#--Not used"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(5)<<"\t#--Not used"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(6)<<"\t#--Smoothness penalty on the recruitment devs"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(7)<<"\t#--Penalty on the difference of the mean_sex_ratio from 0.5"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(8)<<"\t#--Smoothness penalty on molting probability"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(9)<<"\t#--Smoothness penalty on selectivity patterns with class-specific coefficients"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(10)<<"\t#--Smoothness penalty on initial numbers at length"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(11)<<"\t#--Penalty on annual F-devs for males by fleet"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(12)<<"\t#--Penalty on annual F-devs for females by fleet"<<endl;
  gmacs_ctl<< setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(13)<<"\t#--Penalty on deviation parameters"<<endl;
 END_CALCS

  init_int eof_ctl;
  !! gmacs_ctl << endl;
  !! WriteCtl(eof_ctl);
  !! if ( eof_ctl != 9999 ){cout << "Error reading control file" << endl; exit(1);}
  !! cout << "end of control section" << endl;

  // Deal with the devs and their phases
  int n_deviations_est;
  !! n_deviations_est = n_deviations;
  !! if (n_deviations_est==0) n_deviations_est = 1;
  vector deviations_ival(1,n_deviations_est);
  ivector deviations_phz(1,n_deviations_est);
  !! if (n_deviations > 0)
  !! {
  !!  for (int i = 1; i<=n_deviations; i++)
  !!   { deviations_ival(i) =0 ;  deviations_phz(i) = devParPhase; }
  !!  int ndev_cnt;
  !!  ndev_cnt = 0;
  !!  cout << n_devvars <<endl;
  !!  for (int is=1;is<=n_devvars;is++)
  !!   {
  !!    for (int iblk=1;iblk<=blocks(devpoints(is,5));iblk++)
  !!     {
  !!     for (int iyr=blocklimits(devpoints(is,5),iblk,1);iyr<=blocklimits(devpoints(is,5),iblk,2);iyr++)
  !!       {
  !!        ndev_cnt += 1;
  !!        if (devpoints(n_devvars,1)==1) 
  !!         {
  !!          if (devpoints(is,7)==1) anystring = "Growth_increment_";
  !!          if (devpoints(is,7)==1) anystring = "Molt_probability_";
  !!          if (devpoints(is,7)==1) anystring = "Prob_mature_";
  !!          devnames1(ndev_cnt) = anystring       +str(devpoints(is,2))+"_par_"+str(devpoints(is,6))+"_dev_for_year_"+str(iyr);
  !!         }
  !!        if (devpoints(n_devvars,1)==2) devnames1(ndev_cnt) = "M_"            +str(devpoints(is,2))+"_par_1"+"_dev_for_year_"+str(iyr);
  !!        if (devpoints(n_devvars,1)==3) 
  !!         { 
  !!          anystring = seltypes(devpoints(is,7)) + "_" + sexes(devpoints(is,8)) + "_" + fleetname(devpoints(is,9));
  !!          devnames1(ndev_cnt) = "Selectivity_"  +anystring+"_par_"+str(devpoints(is,6))+"_dev_for_year_"+str(iyr);
  !!         }
  !!        if (devpoints(n_devvars,1)==4) devnames1(ndev_cnt) = "q_survey_"     +str(devpoints(is,2))+"_par_1"+"_dev_for_year_"+str(iyr);
  !!        if (devpoints(n_devvars,1)==5) devnames1(ndev_cnt) = "add_cv_survey_"+str(devpoints(is,2))+"_par_1"+"_dev_for_year_"+str(iyr);
  !!       }
  !!     }
  !!   }
  !! }
  !!else // fake parameters
  !! {
  !!  deviations_ival(1) = 0;
  !!  deviations_phz(1) = -1;
  !!  devnames1(1) = "Dummy_dev_par";
  // seldevnames1
  !! }

// ================================================================================================

  // Label 130: Projection inputs
  !! ad_comm::change_datafile_name(projectfile);
  !! cout << "+-------------------------+" << endl;
  !! cout << "| Reading projection file |" << endl;
  !! cout << "+-------------------------+" << endl;
  !! ECHOSTR("+-------------------------+");
  !! ECHOSTR("| Reading projection file |");
  !! ECHOSTR("+-------------------------+");
  !! WRITEPRJ(TheHeader);
  init_int Calc_MSY;
  !! WRITEPRJ(Calc_MSY);
  !! if (Calc_MSY != NO && Calc_MSY != YES)  { cout << "Calc_MSY = "<<Calc_MSY<<". Indicate 1=Yes or 0=No for whether MSY should be computed. STOPPING" << endl; exit(1); }
  init_ivector Ffixed(1,nfleet);
  !! ECHO(Ffixed);
  !! for (int k=1;k<=nfleet;k++) gmacs_prj << Ffixed(k) << " #--"<<fleetname(k)<<endl;
  !! for (int k=1;k<=nfleet;k++)
  !!  if (Ffixed(k) != NO && Ffixed(k) != YES) { cout << "Future F indicator = "<< Ffixed(k) <<" for "<<fleetname(k)<<". Must be 0 or 1" << endl; exit(1); }

  init_int spr_syr;
  !! if (spr_syr==0) spr_syr = syr;
  !! if (spr_syr==-1) spr_syr = syr+1;
  !! WRITEPRJ(spr_syr);
  !! if (spr_syr < syr) { cout << "First year for computing Rbar must be syr or later: STOPPING. spr_syr = " << spr_syr << " syr = " << syr << endl; exit(1); }
  init_int spr_nyr;
  !! if (spr_nyr==0) spr_nyr = nyr;
  !! WRITEPRJ(spr_nyr);
  !! if (spr_nyr > nyr) { cout << "Last year for computing Rbar must be nyr or earlier: STOPPING. spr_nyr = " << spr_nyr << "nyr = " << nyr << endl; exit(1); }
  !! if( spr_nyr < spr_syr)  { cout << "Last year for computing Rbar must be later than the first year: STOPPING. spr_syr = " << spr_syr << "spr_nyr = " << spr_nyr << endl; exit(1); }
  !! spr_nyr = spr_nyr - nyrRetroNo;
  !! if (spr_syr > spr_nyr) spr_syr = spr_nyr;

  init_int spr_SexR_syr;
  !! if (spr_SexR_syr==0) spr_SexR_syr = syr;
  !! WRITEPRJ(spr_SexR_syr);
  !! if (spr_SexR_syr < syr) { cout << "First year for computing sex ratio ("<<spr_SexR_syr<<") must be syr ("<<syr<<") or later: STOPPING" << endl; exit(1); }
  init_int spr_SexR_nyr;
  !! if (spr_SexR_nyr==0) spr_SexR_nyr = nyr;
  !! WRITEPRJ(spr_SexR_nyr);
  !! if (spr_SexR_nyr > nyr) { cout << "Last year for computing sex ratio ("<<spr_SexR_nyr<<") must be nyr ("<<nyr<<") or earlier: STOPPING" << endl; exit(1); }
  !! if( spr_SexR_nyr < spr_SexR_syr)  { cout << "Last year for computing sex ratio ("<<spr_SexR_nyr<<") must be later than the first year ("<<spr_SexR_syr<<") " << endl; exit(1); }
  !! spr_SexR_nyr = spr_SexR_nyr - nyrRetroNo;
  !! if (spr_SexR_syr > spr_SexR_nyr) spr_SexR_syr = spr_SexR_nyr;

  init_int spr_aveF_syr;
  !! if (spr_aveF_syr==0) spr_aveF_syr = syr;
  !! WRITEPRJ(spr_aveF_syr);
  !! if (spr_aveF_syr < syr) { cout << "First year for computing AveF  (spr_AveF_syr = "<<spr_aveF_syr<<") must be syr ("<<syr<<") or later: STOPPING" << endl; exit(1); }
  init_int spr_aveF_nyr;
  !! if (spr_aveF_nyr==0) spr_aveF_nyr = nyr;
  !! WRITEPRJ(spr_aveF_nyr);
  !! if (spr_aveF_nyr > nyr) { cout << "Last year for computing AveF  (spr_Ave_nyr = "<<spr_aveF_nyr<<") must be nyr ("<<nyr<<") or earlier: STOPPING" << endl; exit(1); }
  !! if( spr_aveF_nyr < spr_aveF_syr)  { cout << "Last year for computing AveF ("<<spr_aveF_nyr<<")  must be later than the first year ("<<spr_aveF_syr<<") " << endl; exit(1); }
  !! spr_aveF_nyr = spr_aveF_nyr - nyrRetroNo;
  !! if (spr_aveF_syr > spr_aveF_nyr) spr_aveF_syr = spr_aveF_nyr;

  init_int spr_M_syr;
  !! if (spr_M_syr==0) spr_M_syr = nyr;
  !! WRITEPRJ(spr_M_syr);
  !! if (spr_M_syr < syr) { cout << "First year for computing M  (spr_M_syr = "<<spr_M_syr<<") must be syr ("<<syr<<") or later: STOPPING" << endl; exit(1); }
  init_int spr_M_nyr;
  !! if (spr_M_nyr==0) spr_M_nyr = nyr;
  !! WRITEPRJ(spr_M_nyr);
  !! if (spr_M_nyr > nyr) { cout << "Last year for computing M  (spr_M_nyr = "<<spr_M_nyr<<") must be nyr ("<<nyr<<") or earlier: STOPPING" << endl; exit(1); }
  !! if( spr_M_nyr < spr_M_syr)  { cout << "Last year for computing M (spr_M_nyr = "<<spr_M_nyr<<") must be later than the first year (spr_M_syr = "<<spr_M_syr<<") " << endl; exit(1); }
  !! spr_M_nyr = spr_M_nyr - nyrRetroNo;
  !! if (spr_M_syr > spr_M_nyr) spr_M_syr = spr_M_nyr;

  init_int spr_Prop_syr;
  !! if (spr_Prop_syr==0) spr_Prop_syr = nyr;
  !! WRITEPRJ(spr_Prop_syr);
  !! if (spr_Prop_syr < syr) { cout << "First year for computing season lengths (spr_Prop_syr = "<<spr_Prop_syr<<") must be syr ("<<syr<<") or later: STOPPING" << endl; exit(1); }
  init_int spr_Prop_nyr;
  !! if (spr_Prop_nyr==0) spr_Prop_nyr = nyr;
  !! WRITEPRJ(spr_Prop_nyr);
  !! if (spr_Prop_nyr > nyr) { cout << "Last year for computing season lengths (spr_Prop_nyr = "<<spr_Prop_nyr<<") must be nyr ("<<nyr<<") or earlier: STOPPING" << endl; exit(1); }
  !! if( spr_Prop_nyr < spr_Prop_syr)  { cout << "Last year for computing season lengths (spr_Prop_nyr = "<<spr_Prop_nyr<<") must be later than the first year (spr_Prop_syr = "<<spr_Prop_syr<<") " << endl; exit(1); }
  !! spr_Prop_nyr = spr_Prop_nyr - nyrRetroNo;
  !! if (spr_Prop_syr > spr_Prop_nyr) spr_Prop_syr = spr_Prop_nyr;

  init_int spr_grow_yr;
  !! if (spr_grow_yr==0) spr_grow_yr = nyr;
  !! if (spr_grow_yr < syr) { cout << "Year for computing growth (spr_grow_yr = "<<spr_grow_yr<<") must be syr ("<<syr<<") or later: STOPPING" << endl; exit(1); }
  !! if (spr_grow_yr > nyr) { cout << "Year for computing growth (spr_grow_yr = "<<spr_grow_yr<<") must be nyr ("<<nyr<<") or earlier: STOPPING" << endl; exit(1); }
  !! WRITEPRJ(spr_grow_yr);
  !! spr_grow_yr = spr_grow_yr - nyrRetroNo;

  init_int spr_sel_syr;
  !! if (spr_sel_syr==0) spr_sel_syr = nyr;
  !! WRITEPRJ(spr_sel_syr);
  !! if (spr_sel_syr < syr) { cout << "First year for computing selex (spr_sel_syr = "<<spr_sel_syr<<") must be syr ("<<syr<<")  or later: STOPPING" << endl; exit(1); }
  init_int spr_sel_nyr;
  !! if (spr_sel_nyr==0) spr_sel_nyr = nyr;
  !! WRITEPRJ(spr_sel_nyr);
  !! if (spr_sel_nyr > nyr) { cout << "Last year for computing selex  (spr_sel_nyr = "<<spr_sel_nyr<<") must be nyr ("<<nyr<<") or earlier: STOPPING" << endl; exit(1); }
  !! if( spr_sel_nyr < spr_sel_syr)  { cout << "Last year for computing selex ("<<spr_sel_nyr<<") must be later than the first year ("<<spr_sel_syr<<") " << endl; exit(1); }
  !! spr_sel_nyr = spr_sel_nyr - nyrRetroNo;
  !! if (spr_sel_syr > spr_sel_nyr) spr_sel_syr = spr_sel_nyr;
 
  init_number spr_target;
  !! WRITEPRJ(spr_target);
  init_int OFLTier;
  !! WRITEPRJ(OFLTier);
  init_number OFLalpha;
  !! WRITEPRJ(OFLalpha);
  init_number OFLbeta;
  !! WRITEPRJ(OFLbeta);
  init_number OFLgamma;
  !! WRITEPRJ(OFLgamma);
  init_number ABCBuffer;
  !! WRITEPRJ(ABCBuffer);
  init_int Compute_yield_prj;
  !! if (Compute_yield_prj != NO && Compute_yield_prj != YES)  { cout << "Compute_yield_prj = "<<Compute_yield_prj<<". Must indicate 1=Yes or 0=No for whether the yield function should be reported" << endl; exit(1); }
  !! if (Calc_MSY==NO) Compute_yield_prj = NO;
  !! WRITEPRJ(Compute_yield_prj);

  int Eqn_basis;                                           ///> Option for recruitment (0=Constant; 1+ is SRR)

  int nproj;                                               ///> number of projection years
  init_int pyr;                                            ///> terminal projection year
  !! WRITEPRJ(pyr);
  !!  nproj = pyr - nyr;
  !! if (nproj < 0) { cout << "Terminal year for projections (pyr="<<pyr<<") must be later tha nyr ("<<nyr<<") : STOPPING" << endl; exit(1); }
  int nprojVec;
  !! nprojVec = nproj+1; if (nprojVec<2) nprojVec = 2;
  init_int Project_type;                                   ///> Projection type (1=Fixed F; 2=Proportion of current F)
  !! WRITEPRJ(Project_type);
  init_int prj_Nstrat;                                     ///> Account for state strategy
  !! WRITEPRJ(prj_Nstrat);
  init_vector Proj_Levels(1,prj_Nstrat);                   ///> Levels for projections
  !! WRITEPRJ(Proj_Levels);
    
  init_int prj_bycatch_on;                                 ///> Allow for bycatch fleets to have non-zero mortality
  !! WRITEPRJ(prj_bycatch_on);
  init_int prj_replicates;                                 ///> How many times each MCMC draw is run
  !! WRITEPRJ(prj_replicates);
  init_number Fixed_prj_Bmsy;                              ///> Should Bmsy be fixed (negative numbers)
  !! WRITEPRJ(Fixed_prj_Bmsy);
  
  init_int proj_syr;
  !! if (proj_syr==0) proj_syr = syr;
  !! WRITEPRJ(proj_syr);
  !! if (proj_syr < syr) { cout << "First year for Rbar calc (proj_syr = "<<proj_syr<<") must be syr ("<<syr<<") or later: STOPPING" << endl; exit(1); }
  init_int proj_nyr;
  !! if (proj_nyr==0) proj_nyr = nyr;
  !! WRITEPRJ(proj_nyr);
  !! if (proj_nyr > nyr) { cout << "Last year for Rbar calc (proj_nyr = "<<proj_nyr<<") nyr ("<<nyr<<") or earlier: STOPPING" << endl; exit(1); }
  !! if( proj_nyr < proj_syr)  { cout << "Last year for Rbar calc (proj_nyr = "<<proj_nyr<<") must be later than the first year (proj_syr = "<<proj_syr<<") "<< endl; exit(1); }
  !! proj_nyr = proj_nyr - nyrRetroNo;

  init_int proj_SexR_syr;
  !! if (proj_SexR_syr==0) proj_SexR_syr = syr;
  !! WRITEPRJ(proj_SexR_syr);
  !! if (proj_SexR_syr < syr) { cout << "First year for computing sex ratio (proj_SexR_syr="<<proj_SexR_syr<<") must be syr or later: STOPPING" << endl; exit(1); }
  init_int proj_SexR_nyr;
  !! if (proj_SexR_nyr==0) proj_SexR_nyr = nyr;
  !! WRITEPRJ(proj_SexR_nyr);
  !! if (proj_SexR_nyr > nyr) { cout << "Last year for computing sex ratio (proj_SexR_nyr="<<proj_SexR_nyr<<") must be nyr or earlier: STOPPING" << endl; exit(1); }
  !! if( proj_SexR_nyr < proj_SexR_syr)  { cout << "Last year for computing sex ratio (proj_SexR_nyr="<<proj_SexR_nyr<<") must be later than the first year (proj_SexR_syr="<<proj_SexR_syr<<") " << endl; exit(1); }
  !! proj_SexR_nyr = proj_SexR_nyr - nyrRetroNo;
  !! if (proj_SexR_syr > proj_SexR_nyr) proj_SexR_syr = proj_SexR_nyr;

  init_int proj_aveF_syr;
  !! if (proj_aveF_syr==0) proj_aveF_syr = syr;
  !! WRITEPRJ(proj_aveF_syr);
  !! if (proj_aveF_syr < syr) { cout << "First year for computing AveF (proj_aveF_syr="<<proj_aveF_syr<<") must be syr ("<<syr<<")or later: STOPPING" << endl; exit(1); }
  init_int proj_aveF_nyr;
  !! if (proj_aveF_nyr==0) proj_aveF_nyr = nyr;
  !! WRITEPRJ(proj_aveF_nyr);
  !! if (proj_aveF_nyr > nyr) { cout << "Last year for computing AveF (proj_aveF_syr="<<proj_aveF_nyr<<")must be nyr or earlier: STOPPING" << endl; exit(1); }
  !! if( proj_aveF_nyr < proj_aveF_syr)  { cout << "Last year for computing AveF  (proj_aveF_nyr="<<proj_aveF_nyr<<") must be later than the first year (proj_aveF_syr="<<proj_aveF_syr<<")" << endl; exit(1); }
  !! proj_aveF_nyr = proj_aveF_nyr - nyrRetroNo;
  !! if (proj_aveF_syr > proj_aveF_nyr) proj_aveF_syr = proj_aveF_nyr;

  init_int proj_M_syr;
  !! if (proj_M_syr==0) proj_M_syr = syr;
  !! WRITEPRJ(proj_M_syr);
  !! if (proj_M_syr < syr) { cout << "First year for computing M (proj_M_syr="<<proj_M_syr<<") must be syr or later: STOPPING" << endl; exit(1); }
  init_int proj_M_nyr;
  !! if (proj_M_nyr==0) proj_M_nyr = nyr;
  !! WRITEPRJ(proj_M_nyr);
  !! if (proj_M_nyr > nyr) { cout << "Last year for computing M (proj_SexR_nyr="<<proj_SexR_nyr<<") must be nyr or earlier: STOPPING" << endl; exit(1); }
  !! if( proj_M_nyr < proj_M_syr)  { cout << "Last year for computing M (proj_SexR_nyr="<<proj_SexR_nyr<<") must be later than the first year (proj_SexR_syr="<<proj_SexR_syr<<") " << endl; exit(1); }
  !! proj_M_nyr = proj_M_nyr - nyrRetroNo;
  !! if (proj_M_syr > proj_M_nyr) proj_M_syr = proj_M_nyr;

  init_int proj_Prop_syr;
  !! if (proj_Prop_syr==0) proj_Prop_syr = syr;
  !! WRITEPRJ(proj_Prop_syr);
  !! if (proj_Prop_syr < syr) { cout << "First year for computing season lengths (proj_Prop_syr="<<proj_Prop_syr<<") must be syr or later: STOPPING" << endl; exit(1); }
  init_int proj_Prop_nyr;
  !! if (proj_Prop_nyr==0) proj_Prop_nyr = nyr;
  !! WRITEPRJ(proj_Prop_nyr);
  !! if (proj_Prop_nyr > nyr) { cout << "Last year for computing season lengths (proj_Prop_nyr="<<proj_Prop_nyr<<") must be nyr or earlier: STOPPING" << endl; exit(1); }
  !! if( proj_Prop_nyr < proj_Prop_syr)  { cout << "Last year for computing season lengths (proj_Prop_nyr="<<proj_Prop_nyr<<") must be later than the first year (proj_Prop_syr="<<proj_Prop_syr<<") " << endl; exit(1); }
  !! proj_Prop_nyr = proj_Prop_nyr - nyrRetroNo;
  !! if (proj_Prop_syr > proj_Prop_nyr) proj_Prop_syr = proj_Prop_nyr;

  init_int proj_grow_yr;
  !! if (proj_grow_yr==0) proj_grow_yr = nyr;
  !! WRITEPRJ(proj_grow_yr);
  !! if (proj_grow_yr < syr) { cout << "Year for computing growth (proj_grow_yr="<<proj_grow_yr<<") must be syr or later: STOPPING" << endl; exit(1); }
  !! if (proj_grow_yr > nyr) { cout << "Year for computing growth (proj_grow_yr="<<proj_grow_yr<<") must be nyr or earlier: STOPPING" << endl; exit(1); }
  !! proj_grow_yr = proj_grow_yr - nyrRetroNo;

  init_int proj_sel_syr;
  !! if (proj_sel_syr==0) proj_sel_syr = syr;
  !! WRITEPRJ(proj_sel_syr);
  !! if (proj_sel_syr < syr) { cout << "First year for computing selex (proj_sel_syr="<<proj_sel_syr<<") must be syr or later: STOPPING" << endl; exit(1); }
  init_int proj_sel_nyr;
  !! if (proj_sel_nyr==0) proj_sel_nyr = nyr;
  !! WRITEPRJ(proj_sel_nyr);
  !! if (proj_sel_nyr > nyr) { cout << "Last year for computing selex (proj_sel_nyr="<<proj_sel_nyr<<") must be nyr or earlier: STOPPING" << endl; exit(1); }
  !! if( proj_sel_nyr < proj_sel_syr)  { cout << "Last year for computing selex (proj_sel_nyr="<<proj_sel_nyr<<") must be later than the first year (proj_sel_syr="<<proj_sel_syr<<") " << endl; exit(1); }
  !! proj_sel_nyr = proj_sel_nyr - nyrRetroNo;
  !! if (proj_sel_syr > proj_sel_nyr) proj_sel_syr = proj_sel_nyr;

  init_int Stock_rec_prj;                                  ///> Stock-recruitment relationship
  !! gmacs_prj << "# Options for the stock-recruitment relationship" << endl;
  !! gmacs_prj << "#    1: Sample recruitments from those for a pre-specified range of years"<< endl;
  !! gmacs_prj << "#    2: Ricker stock-recruitment relationship"<< endl;
  !! gmacs_prj << "#    3: Beverton-Holt stock-recruitment relationship"<< endl;
  !! gmacs_prj << "#    4: Pre-specified (constant) future recruitment "<< endl;
  !! gmacs_prj << Stock_rec_prj << endl;
  init_int Age_at_rec_prj;                                 ///> Age-at-recruitment
  !! WRITEPRJ(Age_at_rec_prj);
  init_int prj_futRec_syr;
  !! WRITEPRJ(prj_futRec_syr);
  !! if (prj_futRec_syr < syr) { cout << "First year for generating recruitment must be syr or later: STOPPING" << endl; exit(1); }
  init_int prj_futRec_nyr;
  !! WRITEPRJ(prj_futRec_nyr);
  !! if (prj_futRec_nyr > nyr) { cout << "Last year for generating recruitment must be nyr or earlier: STOPPING" << endl; exit(1); }
  !! if(prj_futRec_nyr < prj_futRec_syr)  { cout << "Last year for generating recruitment must be later than the first year" << endl; exit(1); }
  init_number mean_rec_prj;
  !! WRITEPRJ(mean_rec_prj);
  init_number SigmaR_prj                                   ///> Sigma(R)
  !! WRITEPRJ(SigmaR_prj);
  init_number Prow_prj                                     ///> Prow(R)
  !! WRITEPRJ(Prow_prj);
  init_number Initial_eps                                  ///> First rec_dev(R)
  !! WRITEPRJ(Initial_eps);

  init_int Apply_HCR_prj;                                  ///> Use a HCR
  !!if (Project_type==2) Apply_HCR_prj = 0;
  !! WRITEPRJ(Apply_HCR_prj);
  init_int Apply_StateHCR_prj;                             ///> Use a State HCR
  !! WRITEPRJ(Apply_StateHCR_prj);
  init_int NHCRpars;
  !! WRITEPRJ(NHCRpars);
  init_vector HCRpars(1,NHCRpars);
  !! WRITEPRJ(HCRpars); 

  init_int max_prj;
  !! WRITEPRJ(max_prj);
  
  init_int full_prj_diag
  !! WRITEPRJ(full_prj_diag);


  init_int eof_prj;
  !! WRITEPRJ(eof_prj);
  !! if ( eof_prj != 9999 ){cout << "Error reading projection file: " << eof_prj << endl; exit(1);}
  !! cout << "end of projection section" << endl;

// ================================================================================================

  int IsProject;                                           ///> Are we in projection mode

  // special constants (used for guassan quadrature)
  vector xg(1,32)
  vector wg(1,32)
  3darray l1_vec(1,nsex,1,nclass,1,32)     ///> temp storage

  // Phases off
  int NVarPar;
  int NEstPars;
  int NRefPars;
  int NRecPar;
  int NSSBPar;
  int NfbarPar;
  int NB0Par;
 LOC_CALCS
  NVarPar = 0;
  int Ipar;
  for (Ipar=1;Ipar<=ntheta; Ipar++) if (theta_phz(Ipar) > TurnOffPhase) theta_phz(Ipar) = -1;
  for (Ipar=1;Ipar<=n_Gpar; Ipar++) if (G_phz(Ipar) > TurnOffPhase) G_phz(Ipar) = -1;
  for (Ipar=1;Ipar<=n_Mpar; Ipar++) if (M_phz(Ipar) > TurnOffPhase) M_phz(Ipar) = -1;
  for (Ipar=1;Ipar<=n_Spar; Ipar++) if (S_phz(Ipar) > TurnOffPhase) S_phz(Ipar) = -1;
  for (Ipar=1;Ipar<=nfleet; Ipar++) if (f_phz(Ipar) > TurnOffPhase) f_phz(Ipar) = -1;
  for (Ipar=1;Ipar<=nfleet; Ipar++) if (foff_phz(Ipar) > TurnOffPhase) foff_phz(Ipar) = -1;
  if (rdv_phz > TurnOffPhase) rdv_phz = -1;
  if (rec_prop_phz > TurnOffPhase) rec_prop_phz = -1;
  for (Ipar=1;Ipar<=nSizeComps; Ipar++) if (log_vn_phz(Ipar) > TurnOffPhase) log_vn_phz(Ipar) = -1;
  for (Ipar=1;Ipar<=n_qpar; Ipar++) if (q_phz(Ipar) > TurnOffPhase) q_phz(Ipar) = -1;
  for (Ipar=1;Ipar<=n_addcv_par; Ipar++) if (cv_phz(Ipar) > TurnOffPhase) cv_phz(Ipar) = -1;

  for (Ipar=1;Ipar<=ntheta; Ipar++) if (theta_phz(Ipar) > 0) NVarPar += 1;
  for (Ipar=1;Ipar<=n_Gpar; Ipar++) if (G_phz(Ipar) > 0) NVarPar += 1;
  for (Ipar=1;Ipar<=n_Mpar; Ipar++) if (M_phz(Ipar) > 0) NVarPar += 1;
  for (Ipar=1;Ipar<=n_Spar; Ipar++) if (S_phz(Ipar) > 0) NVarPar += 1;
  for (Ipar=1;Ipar<=nfleet; Ipar++) if (f_phz(Ipar) > 0) NVarPar += 1;
  for (Ipar=1;Ipar<=nfleet; Ipar++) if (f_phz(Ipar) > 0) NVarPar += nFparams(Ipar);
  for (Ipar=1;Ipar<=nfleet; Ipar++) if (foff_phz(Ipar) > 0) NVarPar += 1;
  for (Ipar=1;Ipar<=nfleet; Ipar++) if (foff_phz(Ipar) > 0) NVarPar += nYparams(Ipar);
  if (rdv_phz > 0) NVarPar += (rdv_eyr-rdv_syr+1);
  if (rec_prop_phz > 0) NVarPar += (rdv_eyr-rdv_syr+1);
  for (Ipar=1;Ipar<=nSizeComps; Ipar++) if (log_vn_phz(Ipar) > 0) NVarPar += 1;
  for (Ipar=1;Ipar<=n_qpar; Ipar++) if (q_phz(Ipar) > 0) NVarPar += 1;
  for (Ipar=1;Ipar<=n_addcv_par; Ipar++) if (cv_phz(Ipar) > 0) NVarPar += 1;
  for (Ipar=1;Ipar<=n_deviations_est; Ipar++) if (deviations_phz(Ipar) > 0) NVarPar += 1;
  
  cout << "Number of estimated parameters: " << NVarPar << endl;
  NEstPars = NVarPar;
  
  NRefPars = NVarPar;
  if (OutRefPars==YES) NVarPar += (6 + 3*nfleet);
  NRecPar = NVarPar+1;
  if (OutRecruit==YES) NVarPar += nsex*(nyr-syr+1);
  NSSBPar = NVarPar+1;
  if (OutSSB==YES) NVarPar += (nyr-syr+1);
  NfbarPar = NVarPar+1;
  if (Outfbar==YES) NVarPar += (nyr-syr+1);
  NB0Par = NVarPar+1;
  if (OutDynB0==YES) NVarPar += (nyr-syr+1);
  cout << "Number of std variables: " << NVarPar << endl;
 END_CALCS

  int PhaseGrowthPar;
  int PhaseSelexPar;
 LOC_CALCS
  PhaseGrowthPar = 10000;                                  ///> Lowest phase for a growth parameter
  for (Ipar=1;Ipar<=n_Gpar; Ipar++) if (G_phz(Ipar) > 0 && G_phz(Ipar) < PhaseGrowthPar) PhaseGrowthPar = G_phz(Ipar);
  PhaseSelexPar = 10000;
  for (Ipar=1;Ipar<=n_Spar; Ipar++) if (S_phz(Ipar) > 0 && S_phz(Ipar) < PhaseSelexPar) PhaseSelexPar = S_phz(Ipar);
 END_CALCS

  int NfunCall;
  !! NfunCall = 0;

// ================================================================================================

// Label 200: INITIALIZATION_SECTION
INITIALIZATION_SECTION
   theta               theta_ival;
   G_pars_est          G_ival;
   M_pars_est          M_ival;
   S_pars_est          S_ival;
   log_fbar            log_init_fbar;
   log_foff            log_init_fbar_foff; //added 20240413 by WTS (otherwise log_foff implicitly initialized to 0)
   log_vn              log_vn_ival;
   survey_q            q_ival;
   logit_rec_prop_est  init_sex_ratio;
   log_add_cv          log_add_cv_ival;
   par_devs            deviations_ival;

// ================================================================================================

PARAMETER_SECTION
  !! cout << "+----------------------+" << endl;
  !! cout << "| Parameter section    |" << endl;
  !! cout << "+----------------------+" << endl;
//-------------------------------
// Sandbox for testing functions |
//-------------------------------
 LOCAL_CALCS
  if (0){
     //Testing selectivity using "dvar" values
    cout<<"|-----------------------------------|"<<endl;
    cout<<"| Testing sandbox using dvar values |"<<endl;
    cout<<"|-----------------------------------|"<<endl;
    class gsm::Selex<dvar_vector> *pSLX;
    dvar_vector z(1,32);
    for (int i=z.indexmin();i<=z.indexmax();i++) z(i) = 27.5+(i-1)*5.0;
    cout<<"--Cubic Spline"<<endl;
    dvar_vector x_knts(1,5);
    x_knts[1]=z[1]; for (int i=1;i<=4;i++) x_knts[i+1] = z[8*i];
    dvar_vector y_vals = 1.0/(1.0+exp(-(x_knts-100.0)/30.0));
    cout<<"x_knts = "<<x_knts<<endl;
    cout<<"y_vals = "<<y_vals<<endl;
    pSLX = new class gsm::SelectivitySpline<dvar_vector,dvar_vector>(y_vals,x_knts);
    cout<<"z        = "<<x_knts<<endl;
    cout<<"sel      = "<<pSLX->Selectivity(x_knts)<<endl;
    cout<<"z        = "<<z<<endl;
    cout<<"sel      = "<<pSLX->Selectivity(z)<<endl;
    cout<<"logsel   = "<<pSLX->logSelectivity(z)<<endl;
    cout<<"logselM1 = "<<pSLX->logSelexMeanOne(z)<<endl;
    cout<<"--change knots and y_vals to check reallocation"<<endl;
    dvar_vector x_knts1(1,9);
    x_knts1[1]=z[1]; for (int i=1;i<=8;i++) x_knts1[i+1] = z[4*i];
    dvar_vector y_vals1 = 1.0/(1.0+exp(-(x_knts1-100.0)/30.0));
    ((gsm::SelectivitySpline<dvar_vector,dvar_vector>*)pSLX)->initSpline(y_vals1,x_knts1);
    cout<<"z        = "<<x_knts1<<endl;
    cout<<"sel      = "<<pSLX->Selectivity(x_knts1)<<endl;
    cout<<"z        = "<<z<<endl;
    cout<<"sel      = "<<pSLX->Selectivity(z)<<endl;
    cout<<"logsel   = "<<pSLX->logSelectivity(z)<<endl;
    cout<<"logselM1 = "<<pSLX->logSelexMeanOne(z)<<endl;
    exit(1);
    dvariable p1 = 30.0;
    dvariable p2 = 100.0;
    dvariable p3 = 50.0;
    cout<<"--DoubleNormal"<<endl;
    pSLX = new class gsm::DoubleNormal<dvar_vector,dvariable>(p1,p2,p3);
    cout<<z<<endl;
    cout<<pSLX->Selectivity(z)<<endl;
    cout<<pSLX->logSelectivity(z)<<endl;
    cout<<pSLX->logSelexMeanOne(z)<<endl;
    p1 = 30.0;
    p2 = 100.0;
    p3 = 50.0;
    dvariable p4 = 130.0;
    cout<<"--DoubleNormal4"<<endl;
    pSLX = new class gsm::DoubleNormal4<dvar_vector,dvariable>(p1,p2,p3,p4);
    cout<<z<<endl;
    cout<<pSLX->Selectivity(z)<<endl;
    cout<<pSLX->logSelectivity(z)<<endl;
    cout<<pSLX->logSelexMeanOne(z)<<endl;
    cout<<"--Uniform"<<endl;
    pSLX = new class gsm::UniformCurve<dvar_vector>();
    cout<<z<<endl;
    cout<<pSLX->Selectivity(z)<<endl;
    cout<<pSLX->logSelectivity(z)<<endl;
    cout<<pSLX->logSelexMeanOne(z)<<endl;
    cout<<"--Uniform0"<<endl;
    pSLX = new class gsm::Uniform0Curve<dvar_vector>();
    cout<<z<<endl;
    cout<<pSLX->Selectivity(z)<<endl;
    cout<<pSLX->logSelectivity(z)<<endl;
    cout<<pSLX->logSelexMeanOne(z)<<endl;
    exit(1);
  }
 END_CALCS

  // Leading parameters
  // M         = theta(1)
  // ln(Ro)    = theta(2)
  // ln(R1)    = theta(3)
  // ln(Rbar)  = theta(4)
  // ra        = theta(5)
  // rbeta     = theta(6)
  // ra        = theta(7)
  // rbeta     = theta(8)
  // logSigmaR = theta(9+)
  // steepness = theta(10)
  // rho       = theta(11)
  // logN0     = theta(12,...)
  init_bounded_number_vector theta(1,ntheta,theta_lb,theta_ub,theta_phz);
  !! ECHO(theta);
  init_bounded_number_vector G_pars_est(1,n_Gpar,G_lb,G_ub,G_phz);
  !!ECHO(G_pars_est);
  // M parameters 
  init_bounded_number_vector M_pars_est(1,n_Mpar,M_lb,M_ub,M_phz);
  !!ECHO(M_pars_est);
  // Selectivity parameters
  init_bounded_number_vector S_pars_est(1,n_Spar,S_lb,S_ub,S_phz);
  !!ECHO(S_pars_est);

  // Fishing mortality rate parameters
  !! ECHO(f_phz);
  init_bounded_number_vector log_fbar(1,nfleet,fbar_lb,fbar_ub,f_phz);       ///> Male mean fishing mortality.
  !! ECHO(log_fbar);
  init_bounded_vector_vector log_fdev(1,nfleet,1,nFparams,fdev_lb,fdev_ub,f_phz);   ///> Male f devs
  !! ECHO(nFparams);
  !! for (int I=1;I<=nfleet;I++) { ECHO(log_fdev(I)); }
  !! ECHO(foff_phz);
  init_bounded_number_vector log_foff(1,nfleet,foff_lb,foff_ub,foff_phz);    ///> Female F offset to Male F. 
  !! ECHO(log_foff);
  !!ECHO(nYparams);
  init_bounded_vector_vector log_fdov(1,nfleet,1,nYparams,-10,10,foff_phz);    ///> log-scale Female F offset devs to Male F
  !! for (int I=1;I<=nfleet;I++) { ECHO(log_fdov(I)); }

  // Recruitment deviation parameters
  !! ECHO(rdv_syr); ECHO(rdv_eyr);
   init_bounded_vector rec_dev_est(rdv_syr,rdv_eyr,-12.0,12.0,rdv_phz);       ///> recruitment deviations
  !! ECHO(rec_dev_est);
  vector rec_dev(syr,nyrRetro);
  init_bounded_dev_vector logit_rec_prop_est(rdv_syr,rdv_eyr,-100,100,rec_prop_phz); ///> recruitment proportions deviations
  !! ECHO(logit_rec_prop_est);
  vector logit_rec_prop(syr,nyrRetro);

  // Effective sample size parameter for multinomial
  !! ECHO(nSizeComps)
  !! ECHO(log_vn_ival);
  !! ECHO(log_vn_lb);
  !! ECHO(log_vn_ub);
  !! ECHO(log_vn_phz);
  init_bounded_number_vector log_vn(1,nSizeComps,log_vn_lb,log_vn_ub,log_vn_phz);
  !! ECHO(log_vn);

  // Catchability coefficient (q)
  !! ECHO(n_qpar)
  init_bounded_number_vector survey_q(1,n_qpar,q_lb,q_ub,q_phz);
  !! ECHO(survey_q);

  // Addtional CV for surveys/indices
  !!ECHO(log_add_cv_ival);
  init_bounded_number_vector log_add_cv(1,n_addcv_par,log_add_cv_lb,log_add_cv_ub,cv_phz);
  !! ECHO(log_add_cv);

  // deviation parameters
  init_bounded_number_vector par_devs(1,n_deviations_est,-12.0,12.0,deviations_phz);
  !! ECHO(par_devs);


// --------------------------------------------------------------------------------------------------

  // Items related to the objective function
  vector priorDensity(1,NVarPar);
  matrix nloglike(1,nlikes,1,ilike_vector);
  vector nlogPenalty(1,13);                                ///>  Penalty terms
  matrix sdnr_MAR_cpue(1,nSurveys,1,2);
  matrix sdnr_MAR_lf(1,nSizeComps,1,2);
  vector Francis_weights(1,nSizeComps);

  objective_function_value objfun;

  number logR0;                                            ///> logarithm of unfished recruits
  number logRbar;                                          ///> logarithm of average recruits(syr+1,nyr)
  number logRini;                                          ///> logarithm of initial recruitment(syr)
  vector ra(1,nsex);                                       ///> Expected value of recruitment distribution
  vector rbeta(1,nsex);                                    ///> rate parameter for recruitment distribution
  number logSigmaR;                                        ///> standard deviation of recruitment deviations
  number steepness;                                        ///> steepness of the SRR
  number rho;                                              ///> autocorrelation coefficient in recruitment
  matrix logN0(1,n_grp,1,nclass);                          ///> initial numbers at length

  matrix alpha(1,nsex,1,maxSizeIncVaries);                 ///> intercept for linear growth increment model
  matrix beta(1,nsex,1,maxSizeIncVaries);                  ///> slope for the linear growth increment model
  matrix gscale(1,nsex,1,maxSizeIncVaries);                ///> scale parameter for the gamma distribution
  matrix Linf(1,nsex,1,maxSizeIncVaries);                  ///> Mean Linf
  matrix Kappa(1,nsex,1,maxSizeIncVaries);                 ///> Mean Kappa
  matrix SigmaKappa(1,nsex,1,maxSizeIncVaries);            ///> SD of kappa
  matrix SigmaLinf(1,nsex,1,maxSizeIncVaries);             ///> SD of linf

  matrix rec_sdd(1,nsex,1,nclass);                         ///> recruitment size_density_distribution
  matrix molt_mu(1,nsex,1,nMoltVaries);                    ///> 50% probability of molting at length each year
  matrix molt_cv(1,nsex,1,nMoltVaries);                    ///> CV in molting probabilility
  matrix mature_mu(1,nsex,1,nMoltVaries);                  ///> 50% probability of maturing at length each year
  matrix mature_cv(1,nsex,1,nMoltVaries);                  ///> CV in maturing probabilility

  matrix rec_pass(1,nsex,1,nclass);                        ///> passing into update routine 
  vector totrecruits(syr,nyrRetro);                        ///> vector of estimated recruits (total)
  matrix recruits(1,nsex,syr,nyrRetro);                    ///> vector of estimated recruits
  vector res_recruit(syr,nyrRetro);                        ///> vector of estimated recruits
  vector xi(syr,nyrRetro);                                 ///> vector of residuals for SRR

  matrix pre_catch(1,nCatchDF,1,nCatchRows);               ///> predicted catch (Baranov eq)
  matrix res_catch(1,nCatchDF,1,nCatchRows);               ///> catch residuals in log-space
  matrix obs_catch_effort(1,nCatchDF,1,nCatchRows);        ///> inferred catch if there is no catch but some effort
  matrix pre_catch_out(1,nCatchDF,syr,nyrRetro);           ///> Predicted catch for output
  matrix res_catch_out(1,nCatchDF,syr,nyrRetro);           ///> Residuals for output
  vector log_q_catch(1,nCatchDF);                          ///> Catchability

  3darray molt_increment(1,nsex,1,maxSizeIncVaries,1,nclass);               ///> linear molt increment
  matrix molt_prob_pass(1,nsex,1,nclass);                                   ///> passing into update routine  
  3darray molt_probability(1,nsex,syr,nyr,1,nclass);                        ///> probability of molting
  3darray molt_probability_in(1,nsex,1,maxSizeIncVaries,1,nclass);          ///> input probability of molting for free estimation
  matrix mature_prob_pass(1,nsex,1,nclass);                                 ///> passing into update routine  
  3darray mature_probability(1,nsex,syr,nyr,1,nclass);                      ///> probability of mature
  3darray mature_probability_in(1,nsex,1,maxSizeIncVaries,1,nclass);        ///> input probability of mature for free estimation
  3darray ProbMolt(1,nsex,1,nclass,1,nclass);                               ///> Diagonal matrix of molt probabilities
  4darray growth_transition(1,nsex,1,maxSizeIncVaries,1,nclass,1,nclass);   ///> The time-dependent growth transition matrix

  matrix S_pars(1,100,1,nclass);                                          ///> Extracted selectivity parameters
  4darray log_slx_capture(1,nfleet,1,nsex,syr,nyrRetro+1,1,nclass);       ///> capture selectivity
  4darray log_slx_retaind(1,nfleet,1,nsex,syr,nyrRetro+1,1,nclass);       ///> probability of retention
  4darray log_slx_discard(1,nfleet,1,nsex,syr,nyrRetro+1,1,nclass);       ///> probabilty of disards
  3darray log_high_grade(1,nfleet,1,nsex,syr,nyrRetro+1);                 ///> high-grading fraction
  number selex_smooth_pen;                                                ///> Penalty when individual parameters are estimated by year

  4darray M(1,nsex,1,nmature,syr-1,nyr,1,nclass);               ///> Natural mortality
  vector Mmult(1,nclass);                                       ///> size-class-specific multiplier
  matrix fout(1,nfleet,syr,nyrRetro);                           ///> Fishing mortality output
  vector finit(1,nfleet);                                       ///> Initial F
  4darray ft(1,nfleet,1,nsex,syr,nyrRetro,1,nseason);           ///> Fully-selected fishing mortality by gear
  4darray F(1,nsex,syr,nyrRetro,1,nseason,1,nclass);            ///> Fishing mortality actual
  4darray F2(1,nsex,syr,nyrRetro,1,nseason,1,nclass);           ///> Fishing mortality with full selection
  5darray Z(1,nsex,1,nmature,syr,nyrRetro,1,nseason,1,nclass);            ///> Total mortality actual
  5darray Z2(1,nsex,1,nmature,syr,nyrRetro,1,nseason,1,nclass);           ///> Total mortality with full selection
  6darray S(1,nsex,1,nmature,syr,nyrRetro,1,nseason,1,nclass,1,nclass);   ///> Survival Rate (S=exp(-Z))
  5darray SS_pass(1,nsex,1,nmature,1,nseason,1,nclass,1,nclass);          ///> Survival Rate
  
  4darray d4_N(1,n_grp,syr,nyrRetro+1,1,nseason,1,nclass);          ///> Numbers-at-sex/mature/shell/year/season/length.
  4darray d4_N_init(1,n_grp,1,NyrEquil,1,nseason,1,nclass);         ///> N matrix
  3darray d3_newShell(1,nsex,syr,nyrRetro+1,1,nclass);              ///> New shell crabs-at-length.
  3darray d3_oldShell(1,nsex,syr,nyrRetro+1,1,nclass);              ///> Old shell crabs-at-length.

  number TempSS;                                                    ///> Use to compute the selextivity penalty

  matrix SurveyQT(1,nSurveys,syr,nyrRetro+1);                       ///> SurveyQ
  matrix AddVarQT(1,nSurveys,syr,nyrRetro+1);                       ///> Additional variance
  vector pre_cpue(1,nSurveyRows);                                   ///> predicted relative abundance index
  vector res_cpue(1,nSurveyRows);                                   ///> relative abundance residuals
  vector res_cpue_stdzd(1,nSurveyRows);                             ///> standardized relative abundance residuals

  // Observed and predicted catch-at-size and results
  3darray d3_pre_size_comps_in(1,nSizeComps_in,1,nSizeCompRows_in,1,nSizeCompCols_in);
  3darray d3_res_size_comps_in(1,nSizeComps_in,1,nSizeCompRows_in,1,nSizeCompCols_in);
  3darray d3_obs_size_comps_out(1,nSizeComps_in,1,nSizeCompRows_in,1,nSizeCompCols_in); // _out is for output/plotting purposes
  3darray d3_pre_size_comps_out(1,nSizeComps_in,1,nSizeCompRows_in,1,nSizeCompCols_in); // _out is for output/plotting purposes
  3darray d3_res_size_comps_out(1,nSizeComps_in,1,nSizeCompRows_in,1,nSizeCompCols_in); // _out is for output/plotting purposes
  3darray d3_pre_size_comps(1,nSizeComps,1,nSizeCompRows,1,nSizeCompCols);
  3darray d3_res_size_comps(1,nSizeComps,1,nSizeCompRows,1,nSizeCompCols);

  // Use to compute the likelihood of the tagging data
  5darray FullY(1,nsex,1,maxSizeIncVaries,1,MaxGrowTimeLib,1,nclass,1,nclass);

  // Passing variable
  number ssb_pass;                                         ///> SSB passed back
  number ofltot_pass;                                      ///> Retained OFL passed back
  number oflret_pass;                                      ///> Total OFL passed back
  vector log_fimpbar(1,nfleet);                            ///> Vector of Fs
  vector log_fimpbarOFL(1,nfleet);                         ///> Vector of Fs for computing OFL
  vector log_fimpbarPass(1,nfleet);                        ///> Vector of Fs
  vector catch_pass(1,2+nfleet);                           ///> Various catch outputs
  matrix catch_summary(1,nfleet+5,1,nproj)                 ///> Various catch outputs for projections
  vector dvar_mid_points(1,nclass);                        ///>dvar version of size class midpoints
  !!dvar_mid_points = mid_points;
  matrix histcat(1,2+nfleet,syr,nyr);                      ///> Save the historical removals


  // SPR-related stuff
  vector spr_rbar(1,2);                                    ///> Mean recruitment for SPR calculations
  number spr_sexr;                                         ///> Sex ratio for SPR calculations
  number ssbF0;                                            ///> Unfished MMB
  number spr_bmsy;                                         ///> MMB corresponding to FMSY
  number spr_depl;                                         ///> MMB relative to BMSY for the OFL
  number spr_cofl;                                         ///> OFL
  number spr_cofl_ret;									   ///> retained portion of the OFL
  number spr_fofl;                                         ///> F relative to FMSY for the OFL
  number Bmsy;                                             ///> Also MMB corresponding to FMSY

  // Projection stuff
  vector proj_rbar(1,2);                                   ///> Mean recruitment for projections
  number SR_alpha_prj;                                     ///> Alpha for projections
  number SR_beta_prj;                                      ///> Beta for projections
  number Steepness;                                        ///> Stock-recruitment steepness
  matrix spr_yield(0,100,1,4);                             ///> Yield function
  matrix fut_recruits(1,nsex,1,nproj);                     ///> Projected recruitment
  4darray numbers_proj_gytl(1,n_grp,1,nprojVec,1,nseason,1,nclass);      ///> The N matrix for the projection
  vector OFLoutpass(1,2+nfleet);                           ///> Output of OFLs

  // Extra sd variables
//  vector sd_fbar(syr,nyr-1);
//  vector sd_log_dyn_Bzero(syr+1,nyr);
//  sdreport_vector sd_rbar(1,2);
//  sdreport_number sd_ssbF0;
//  sdreport_number sd_Bmsy;
//  sdreport_number sd_depl;
//  sdreport_vector sd_fmsy(1,nfleet);
//  sdreport_vector sd_fofl(1,nfleet);
//  sdreport_number sd_ofl;
//  sdreport_matrix sd_log_recruits(1,nsex,syr,nyr);
//  sdreport_vector sd_log_ssb(syr,nyr);
//  sdreport_number sd_last_ssb;

  vector gradientOut(1,NEstPars);
  sdreport_matrix sd_log_recruits(1,nsex,syr,nyrRetro);
  sdreport_vector ParsOut(1,NVarPar);
  vector sd_fmsy(1,nfleet);
  vector sd_fofl(1,nfleet);
  sdreport_vector sd_log_ssb(syr,nyrRetro);
  sdreport_number sd_last_ssb;

  //added eight lines by Jie
  //sdreport_vector sdrLnRecMMB(syr,nyrRetro-6);             //these are for spawning per recruits. Six years of recruitment time lag.
  //sdreport_vector sdrLnRec(syr,nyrRetro-6);
  //sdreport_vector sdrRec(syr,nyrRetro-6);
  //sdreport_vector sdrMMB(syr,nyrRetro-6);
  //sdreport_vector sdrLnRecMMB(syr+1,nyrRetro);          //these are for recruits.
  //sdreport_vector sdrLnRec(syr+1,nyrRetro);
  //sdreport_vector sdrRec(syr+1,nyrRetro);
  //sdreport_vector sdrMMB(syr+1,nyrRetro);

  // sdreport_vector sd_fbar(syr,nyr-1);
  vector dyn_Bzero(syr,nyrRetro);

  //friend_class population_model;

// ================================================================================================

PRELIMINARY_CALCS_SECTION
  dvector rands(1,1000);
  dvector randu(1,1000);
  cout << "+----------------------+" << endl;
  cout << "| Preliminary section  |" << endl;
  cout << "+----------------------+" << endl;
  
  // 32 Gaussian evaluation points
  xg( 1)=-0.99726; xg( 2)=-0.98561; xg( 3)=-0.96476; xg( 4)=-0.93490; xg( 5)=-0.89632; xg( 6)=-0.84936; xg( 7)=-0.79448; xg( 8)=-0.73218;
  xg( 9)=-0.66304; xg(10)=-0.58771; xg(11)=-0.50689; xg(12)=-0.42135; xg(13)=-0.33186; xg(14)=-0.23928; xg(15)=-0.14447; xg(16)= -0.0483;
  xg(17)= 0.04830; xg(18)= 0.14447; xg(19)= 0.23928; xg(20)= 0.33186; xg(21)= 0.42135 ;xg(22)= 0.50689; xg(23)= 0.58771; xg(24)= 0.66304;
  xg(25)= 0.73218; xg(26)= 0.79448; xg(27)= 0.84936; xg(28)= 0.89632; xg(29)= 0.93490; xg(30)= 0.96476; xg(31)= 0.98561; xg(32)= 0.99726;

  // 32 Gaussian weights
  wg( 1)=0.00701; wg( 2)=0.01627; wg( 3)=0.02539; wg( 4)=0.03427; wg( 5)=0.04283; wg( 6)=0.05099; wg( 7)=0.05868; wg( 8)=0.06582;
  wg( 9)=0.07234; wg(10)=0.07819; wg(11)=0.08331; wg(12)=0.08765; wg(13)=0.09117; wg(14)=0.09384; wg(15)=0.09563; wg(16)=0.09654;
  wg(17)=0.09654; wg(18)=0.09563; wg(19)=0.09384; wg(20)=0.09117; wg(21)=0.08765; wg(22)=0.08331; wg(23)=0.07819; wg(24)=0.07234;
  wg(25)=0.06582; wg(26)=0.05868; wg(27)=0.05099; wg(28)=0.04283; wg(29)=0.03427; wg(30)=0.02539; wg(31)=0.01627; wg(32)=0.00701;

  // evaluation points for l1 based on initial size class
  for (int h=1;h<=nsex;h++)
   for(int i=1; i<=32; i++)
    for(int j=1; j<=nclass; j++)
     l1_vec(h,j,i) = ((xg(i) + 1)/2)*(size_breaks(j+1)-size_breaks(j)) + size_breaks(j);

  if ( simflag )
   {
    if ( !global_parfile )
     {
      cerr << "Must have a gmacs.pin file to use the -sim command line option" << endl;
      ad_exit(1);
     }
    cout << "|-------------------------------------------|" << endl;
    cout << "|*** RUNNING SIMULATION WITH RSEED = " << rseed << " ***|" << endl;
    cout << "|-------------------------------------------|" << endl;
    simulation_model();
    //exit(1);
    cout<<"done"<<endl;
   }

  if (rseed==0) rseed = start;
  random_number_generator rng2( rseed ) ;
  if (IsJittered!=0) {
    cout << "+------------------------------+" << endl;
    cout << "| Jittering                    |" << endl;
    cout << "+------------------------------+" << endl;
    {
      ofstream JitFile;
      JitFile.open("jitter.txt");
      JitFile << rseed << endl;
      JitFile.close();
    }
    for (int ipar=1;ipar<=ntheta;ipar++)
     {
      rands.fill_randn(rng2);
      randu.fill_randn(rng2);
      theta(ipar) = GenJitter(IsJittered,theta_ival(ipar),theta_lb(ipar),theta_ub(ipar),theta_phz(ipar),sdJitter,rands,randu);
     }
    for (int ipar=1;ipar<=n_Gpar;ipar++)
     {
      rands.fill_randn(rng2);
      randu.fill_randn(rng2);
      G_pars_est(ipar) = GenJitter(IsJittered,G_ival(ipar),G_lb(ipar),G_ub(ipar),G_phz(ipar),sdJitter,rands,randu);
     }
    for (int ipar=1;ipar<=n_Spar;ipar++)
     {
      rands.fill_randn(rng2);
      randu.fill_randn(rng2);
      S_pars_est(ipar) = GenJitter(IsJittered,S_ival(ipar),S_lb(ipar),S_ub(ipar),S_phz(ipar),sdJitter,rands,randu);
     }
    for (int ipar=1;ipar<=nfleet;ipar++)
     for (int jpar=1;jpar<=nFparams(ipar); jpar++)
      {
       rands.fill_randn(rng2);
       randu.fill_randn(rng2);
       log_fdev(ipar,jpar) = GenJitter(IsJittered,(fdev_ub(ipar)+fdev_lb(ipar))/2.0,fdev_lb(ipar),fdev_ub(ipar),f_phz(ipar),sdJitter,rands,randu);
      }
    for (int ipar=1;ipar<=nfleet;ipar++)
     {
      rands.fill_randn(rng2);
      randu.fill_randn(rng2);
      log_foff(ipar) = GenJitter(IsJittered,(foff_ub(ipar)+foff_lb(ipar))/2.0,foff_lb(ipar),foff_ub(ipar),foff_phz(ipar),sdJitter,rands,randu);
     }
    for (int ipar=1;ipar<=nfleet;ipar++)
     for (int jpar=1;jpar<=nYparams(ipar); jpar++)
      {
       rands.fill_randn(rng2);
       randu.fill_randn(rng2);
       log_fdov(ipar,jpar) = GenJitter(IsJittered,0.0,-10.0,10.0,foff_phz(ipar),sdJitter,rands,randu);
      }
    for (int ipar=rdv_syr;ipar<=rdv_eyr;ipar++)
     {
      rands.fill_randn(rng2);
      randu.fill_randn(rng2);
      rec_dev_est(ipar) = GenJitter(IsJittered,0.0,-8.0,8.0,rdv_phz,sdJitter,rands,randu);
     }
    for (int ipar=rdv_syr;ipar<=rdv_eyr;ipar++)
     {
      rands.fill_randn(rng2);
      randu.fill_randn(rng2);
      logit_rec_prop_est(ipar) = GenJitter(IsJittered,init_sex_ratio,-100.0,100.0,rec_prop_phz,sdJitter,rands,randu);
     }
    for (int ipar=1;ipar<=nSizeComps;ipar++)
     {
      rands.fill_randn(rng2);
      randu.fill_randn(rng2);
      log_vn(ipar) = GenJitter(IsJittered,log_vn_ival(ipar),log_vn_lb(ipar),log_vn_ub(ipar),log_vn_phz(ipar),sdJitter,rands,randu);
     }
    for (int ipar=1;ipar<=n_qpar;ipar++)
     {
      rands.fill_randn(rng2);
      randu.fill_randn(rng2);
      survey_q(ipar) = GenJitter(IsJittered,q_ival(ipar),q_lb(ipar),q_ub(ipar),q_phz(ipar),sdJitter,rands,randu);
     }
    for (int ipar=1;ipar<=n_addcv_par;ipar++)
     {
      rands.fill_randn(rng2);
      randu.fill_randn(rng2);
      log_add_cv(ipar) = GenJitter(IsJittered,log_add_cv_ival(ipar),log_add_cv_lb(ipar),log_add_cv_ub(ipar),cv_phz(ipar),sdJitter,rands,randu);
     }
   }

  cout << "+------------------------------+" << endl;
  cout << "| Initial Procedure Section    |" << endl;
  cout << "+------------------------------+" << endl;

  initialize_model_parameters();            if ( verbose >= 3 ) cout << "Ok after initialize_model_parameters in Prelim ..." << endl;
  calc_growth_increments();                 if ( verbose >= 3 ) cout << "Ok after calc_growth_increments in Prelim ..." << endl;
  calc_molting_probability();               if ( verbose >= 3 ) cout << "Ok after calc_molting_probability in Prelim ..." << endl;
  calc_mature_probability();                if ( verbose >= 3 ) cout << "Ok after calc_mature_probability in Prelim ..." << endl;
  for ( int h = 1; h <= nsex; h++ )
   for ( int igrow = 1; igrow<=nSizeIncVaries(h); igrow++)
    for ( int l = 1; l <= nclass; l++ )
     if (molt_increment(h,igrow,l) < 0)
     {
       cout << "Error: Initial value of the growth increment for matrix " << igrow << " and sex " << h << " and size-class " << l << " is negative: " << molt_increment(h,igrow,l) << "; STOPPING" << endl;
       exit(1);
     }
  calc_growth_transition();                 if ( verbose >= 3 ) cout << "Ok after calc_growth_transition in Prelim ..." << endl;
  init_selectivities();                     if ( verbose >= 3 ) cout << "Ok after init_selectivities in Prelim ..." << endl;
  calc_selectivities();                     if ( verbose >= 3 ) cout << "Ok after calc_selectivities in Prelim ..." << endl;
  cout<<"done"<<endl;

  cout<<"Finished PRELIMINARY_CALCS_SECTION"<<endl;
// =============================================================================
// =============================================================================
BETWEEN_PHASES_SECTION
    cout<<endl;
    cout<<"#--BETWEEN_PHASES_SECTION---------------------"<<endl;
    adstring msg = "#----Starting phase "+str(current_phase())+" of "+str(initial_params::max_number_phases);
    cout<<msg<<endl;
    cout<<"Finished BETWEEN_PHASES_SECTION"<<endl;
    cout<<"----------------------------------------------"<<endl;
// ================================================================================================
// ================================================================================================

PROCEDURE_SECTION
  int Ipnt,ii,jj;

  //cout << theta << endl;
  //cout << Grwth << endl;
  //cout << log_slx_pars << endl;
  //exit(1);
 
  if ( verbose >= 3 ) {
    cout << "Starting PROCEDURE_SECTION.\n\tOk after start of function ..." << endl;
  }

  // Update function calls
  NfunCall += 1;

  // Initialize model parameters
  initialize_model_parameters();                            if ( verbose >= 3 ) cout << "Ok after initialize_model_parameters ..." << endl;

  // Fishing fleet dynamics ...
  if (current_phase() >= PhaseSelexPar)
   {calc_selectivities();                                   if ( verbose >= 3 ) cout << "Ok after calc_selectivities ..." << endl; }
  else
   if ( verbose >= 3 ) cout << "Ok after ignoring selex calculation..." << endl;

  calc_fishing_mortality();                                if ( verbose >= 3 ) cout << "Ok after calc_fishing_mortality ..." << endl;
  //calc_natural_mortality();                                if ( verbose >= 3 ) cout << "Ok after calc_natural_mortality ..." << endl;
  calc_total_mortality();                                  if ( verbose >= 3 ) cout << "Ok after calc_total_mortality ..." << endl;

  // growth ...
  if (current_phase() >= PhaseGrowthPar)
   {
    calc_growth_increments();                              if ( verbose >= 3 ) cout << "Ok after calc_growth_increments ..." << endl;
    calc_molting_probability();                            if ( verbose >= 3 ) cout << "Ok after calc_molting_probability ..." << endl;
    calc_mature_probability();                             if ( verbose >= 3 ) cout << "Ok after calc_mature_probability ..." << endl;
    calc_growth_transition();                              if ( verbose >= 3 ) cout << "Ok after calc_growth_transition ..." << endl;
   }
  else
   if ( verbose >= 3 ) cout << "Ok after ignoring growth calculation..." << endl;

  calc_recruitment_size_distribution();                    if ( verbose >= 3 ) cout << "Ok after calc_recruitment_size_distribution ..." << endl;
  calc_initial_numbers_at_length();                        if ( verbose >= 3 ) cout << "Ok after calc_initial_numbers_at_length ..." << endl;
  update_population_numbers_at_length();                   if ( verbose >= 3 ) cout << "Ok after update_population_numbers_at_length ..." << endl;
  if (Term_molt == 0)
   {
    calc_stock_recruitment_relationship();                 if ( verbose >= 3 ) cout << "Ok after calc_stock_recruitment_relationship ..." << endl;
   } 
  else 
   {												   
    if ( verbose >= 3 ) cout << "Terminal molting option has been selected - calc_stock_recruitment_relationship isn't called in the procedure ..." << endl;
    calc_stock_recruitment_relationship();                 if ( verbose >= 3 ) cout << "Ok after calc_stock_recruitment_relationship ..." << endl;
   }

  // observation models ...
  calc_predicted_catch();                                  if ( verbose >= 3 ) cout << "Ok after calc_predicted_catch ..." << endl;
  calc_relative_abundance();                               if ( verbose >= 3 ) cout << "Ok after calc_relative_abundance ..." << endl;
  calc_predicted_composition();                            if ( verbose >= 3 ) cout << "Ok after calc_predicted_composition ..." << endl;
  if ( verbose >= 3 ) cout << "Ok after observation models ..." << endl;

  // objective function ...
  calc_prior_densities();                                  if ( verbose >= 3 ) cout << "Ok after calc_prior_densities ..." << endl;
  calc_objective_function();                               if ( verbose >= 3 ) cout << "Ok after calc_objective_function ..." << endl;

  // sd_report variables
  if ( sd_phase() || StopAfterFnCall==1)
   {
    if ( verbose >= 3 ) cout<<"Starting sd_phase"<<endl;
    // Save the estimates parameters to ParsOut (used for variance estimation)
    Ipnt = 0;
    for (ii=1;ii<=ntheta;ii++) if (theta_phz(ii) > 0) {Ipnt +=1; ParsOut(Ipnt) = theta(ii); }
    for (ii=1;ii<=n_Gpar; ii++) if (G_phz(ii) > 0) {Ipnt +=1; ParsOut(Ipnt) = G_pars_est(ii); }
    for (ii=1;ii<=n_Mpar; ii++) if (M_phz(ii) > 0) {Ipnt +=1; ParsOut(Ipnt) = M_pars_est(ii); }
    for (ii=1;ii<=n_Spar; ii++) if (S_phz(ii) > 0) {Ipnt +=1; ParsOut(Ipnt) = S_pars_est(ii); }
    for (ii=1;ii<=nfleet; ii++) if (f_phz(ii) > 0) {Ipnt +=1; ParsOut(Ipnt) = log_fbar(ii); }
    for (ii=1;ii<=nfleet; ii++)
    for (jj=1;jj<=nFparams(ii);jj++) if (f_phz(ii) > 0) {Ipnt +=1; ParsOut(Ipnt) = log_fdev(ii,jj); }
    for (ii=1;ii<=nfleet; ii++) if (foff_phz(ii) > 0) {Ipnt +=1; ParsOut(Ipnt) = log_foff(ii); }
    for (ii=1;ii<=nfleet; ii++)
    if (nYparams(ii) > 0 && foff_phz(ii) > 0)
     {
      for (jj=1;jj<=nYparams(ii);jj++) {Ipnt +=1; ParsOut(Ipnt) = log_fdov(ii,jj); }
     }
    for (ii=rdv_syr;ii<=rdv_eyr; ii++) if (rdv_phz > 0) {Ipnt +=1; ParsOut(Ipnt) = rec_dev_est(ii); }
    for (ii=rdv_syr;ii<=rdv_eyr; ii++) if (rec_prop_phz > 0) {Ipnt +=1; ParsOut(Ipnt) = logit_rec_prop_est(ii); }
    for (ii=1;ii<=nSizeComps; ii++) if (log_vn_phz(ii) > 0) {Ipnt +=1; ParsOut(Ipnt) = log_vn(ii); }
    for (ii=1;ii<=n_qpar; ii++) if (q_phz(ii) > 0) {Ipnt +=1; ParsOut(Ipnt) = survey_q(ii); }
    for (ii=1;ii<=n_addcv_par; ii++) if (cv_phz(ii) > 0) {Ipnt +=1; ParsOut(Ipnt) = log_add_cv(ii); }
    for (ii=1;ii<=n_deviations_est; ii++) if (deviations_phz(ii) > 0) {Ipnt +=1; ParsOut(Ipnt) = par_devs(ii); }

    // AEP need to look at this
    if (CalcRefPoints!=0 && nyrRetroNo==0) calc_spr_reference_points2(1);
    if ( verbose >= 3 ) cout << "Ok after calc_spr_reference_points ..." << endl;
    calc_sdreport();
    if ( verbose >= 3 ) cout << "Ok after calc_sdreport ..." << endl;
   }

  // General outputs
  if ( mceval_phase() ) write_eval();
  if ( NfunCall == StopAfterFnCall ) {
      CreateOutput();
      cout<<"--------------------------------------"<<endl;
      cout<<"Stopping after "<<StopAfterFnCall<<" function calls"<<endl;
      cout<<"--------------------------------------"<<endl;
      exit(1);
	}


// =======================================================================================================================================

  /**
   * @brief Initialize model parameters
   * @details Set global variable equal to the estimated parameter vectors.
   *
  **/

FUNCTION initialize_model_parameters
  int Ipnt, Jpnt, Kpnt, Ihmo;

  if (verbose >= 3) cout<<"starting initialize_model_parameters";

  // Get parameters from theta control matrix:
  Jpnt = 1; 
  logR0     = theta(Jpnt);
  logRini   = theta(Jpnt+1);
  logRbar   = theta(Jpnt+2);
  ra(1)     = theta(Jpnt+3);
  rbeta(1)  =  theta(Jpnt+4);
  Jpnt = Jpnt + 5;
  if (nsex>1)
   {
    ra(2)     = ra(1)*exp(theta(Jpnt));
    rbeta(2)  = rbeta(1)*exp(theta(Jpnt+1));
    Jpnt += 2;
   }

  logSigmaR = theta(Jpnt);
  steepness = theta(Jpnt+1);
  rho       = theta(Jpnt+2);
  Jpnt = Jpnt + 2;

  // Set rec_deviations
  rec_dev.initialize();
  logit_rec_prop.initialize();
  for ( int i = rdv_syr; i <= rdv_eyr; i++)
   {
    rec_dev(i) = rec_dev_est(i);
    logit_rec_prop(i) = logit_rec_prop_est(i);
   }
   if (verbose >= 3) cout<<"--finished setting rec_dev()"<<endl;

  // Estimate initial numbers as absolute
  if ( bInitializeUnfished == FREEPARS )
   {
    Ipnt = 0;
    for ( int h = 1; h <= nsex; h++ )
     for ( int m = 1; m <= nmature; m++ )
      for ( int o = 1; o <= nshell; o++ )
       {
        Ihmo = pntr_hmo(h,m,o);
        for ( int l = 1; l <= nclass; l++ )
         {
          Ipnt += 1;
          logN0(Ihmo,l) = theta(Jpnt+Ipnt);
         }
       }
    }

  // Estimate initial numbers as logistic offsest
  TempSS = 0;
  if ( bInitializeUnfished == FREEPARSSCALED )
   {
    Ipnt = 0; Kpnt = 0;
    for ( int h = 1; h <= nsex; h++ )
     for ( int m = 1; m <= nmature; m++ )
      for ( int o = 1; o <= nshell; o++ )
       {
        Ihmo = pntr_hmo(h,m,o);
        for ( int l = 1; l <= nclass; l++ )
         {
          if (Kpnt==Refclass-1)
           logN0(Ihmo,l) = 0;
          else
           { 
            Ipnt += 1;    
            logN0(Ihmo,l) = theta(Jpnt+Ipnt);
            if (active(theta(Jpnt+Ipnt)))  TempSS += theta(Jpnt+Ipnt)*theta(Jpnt+Ipnt); 
           }
          Kpnt += 1;    
         } //--l
       }
   }
  if (verbose >= 3) cout<<"--finished setting initial devs()"<<endl;
 
  // Get Growth && Molting parameters
  dvar_vector G_pars(1,nclass+1);
  for ( int h = 1; h <= nsex; h++ )
   for ( int igrow = 1; igrow<=nSizeIncVaries(h); igrow++)
    {
     int OK; int irow; int irefrow; int iyr;
     OK = 0; irow = 0;
     for (int ivec=1;ivec<=nyrRetro-syr+1;ivec++)
      if (GrowPnt((h-1)*Nyears+ivec,nclass+4)==igrow && OK==0) { OK=1; irow=(h-1)*Nyears+ivec; }
     iyr = GrowPnt(irow,nclass+3);
     if (igrow==1) irefrow = irow;
     
     // Extract parameters 
     int ParNo; int RefParNo;
     G_pars.initialize();
     for (int ipar=1;ipar<=nclass+1;ipar++)
      if (GrowPnt(irow,ipar) != 0)
       {
        if (GrowPnt(irow,ipar) >0 && GrowPnt(irow,ipar) < 10000)
         {
          ParNo = GrowPnt(irow,ipar);
          RefParNo = GrowPnt(irefrow,ipar);
          if (igrow==1) G_pars(ipar) = G_pars_est(ParNo);
          if (igrow>0 && G_relative(ParNo)==0) G_pars(ipar) = G_pars_est(ParNo);
          if (igrow>0 && G_relative(ParNo)==1) G_pars(ipar) = G_pars_est(RefParNo)*exp(G_pars_est(ParNo));
         }
        else
         {
          if (GrowPnt(irow,ipar) > 0)
           {
            int EnvLinkVar = GrowPnt(irow,ipar) - int(GrowPnt(irow,ipar)/100.0)*100;
            int EnvLink = int(GrowPnt(irow,ipar)/100) - int(GrowPnt(irow,ipar)/10000)*100;
            int ParNo = int(GrowPnt(irow,ipar)/10000) - int(GrowPnt(irow,ipar)/1000000)*100;
            if (EnvLink==1) G_pars(ipar) = G_pars_est(RefParNo) + G_pars_est(ParNo)*EnvData(iyr,EnvLinkVar); 
            if (EnvLink==2) G_pars(ipar) = G_pars_est(RefParNo) * G_pars_est(ParNo)*EnvData(iyr,EnvLinkVar); 
            if (EnvLink==3) G_pars(ipar) = G_pars_est(RefParNo)*exp(G_pars_est(ParNo)*EnvData(iyr,EnvLinkVar)); 
          }
          else
           {
            int GrowPnt2 = -1*GrowPnt(irow,ipar);
            int Devpar = GrowPnt2  - int(GrowPnt2/100.0)*100;
            G_pars(ipar) = G_pars_est(RefParNo)*exp(par_devs(Devpar)); 
           }
         }
       
       } //-- ipar
     
     if (bUseGrowthIncrementModel2(h)==LINEAR_GROWTHMODEL)
      {
       alpha(h,igrow)   = G_pars(1);
       beta(h,igrow)    = G_pars(2);
       gscale(h,igrow)  = G_pars(3);
      }
     if (bUseGrowthIncrementModel2(h)==PWRLAW_GROWTHMODEL)
      {
       alpha(h,igrow)   = G_pars(1);
       beta(h,igrow)    = G_pars(2);
       gscale(h,igrow)  = exp(G_pars(3));
      }
     if (bUseGrowthIncrementModel2(h)==INDIVIDUAL_GROWTHMODEL1 || bUseGrowthIncrementModel2(h)==INDIVIDUAL_GROWTHMODEL2)
      {
       for (int l=1; l<=nclass;l++) molt_increment(h,igrow,l) = G_pars(l);
       gscale(h,igrow) = G_pars(nclass+1);
      }

     // Kappa varies
     if (bUseGrowthIncrementModel2(h)==GROWTH_VARYK)
      {
       Linf(h,igrow)       = G_pars(1);
       Kappa(h,igrow)      = G_pars(2);
       SigmaKappa(h,igrow) = G_pars(3);
      }
     // Linf varies
     if (bUseGrowthIncrementModel2(h)==GROWTH_VARYLINF)
      {
       Linf(h,igrow)       = G_pars(1);
       Kappa(h,igrow)      = G_pars(2);
       SigmaLinf(h,igrow)  = G_pars(3);
      }
     // Linf and Kappa varies
     if (bUseGrowthIncrementModel2(h)==GROWTH_VARYKLINF)
      {
       Linf(h,igrow)       = G_pars(1);
       Kappa(h,igrow)      = G_pars(2);
       SigmaLinf(h,igrow)  = G_pars(3);
       SigmaKappa(h,igrow) = G_pars(4);
      }
    } //-- h & igrow
 if (verbose >= 3) cout<<"--finished setting growth pars"<<endl;
 
  for ( int h = 1; h <= nsex; h++ )
   if (bUseCustomMoltProbability2(h) != FIXED_PROB_MOLT)
    for (int igrow=1;igrow<=nMoltVaries(h);igrow++)
     {
      int OK; int irow; int irefrow; int iyr;
      OK = 0; irow = 0;
      for (int ivec=1;ivec<=nyrRetro-syr+1;ivec++)
       if (GrowPnt(nsex*Nyears+(h-1)*Nyears+ivec,nclass+4)==igrow && OK==0) { OK=1; irow=nsex*Nyears+(h-1)*Nyears+ivec; }
      iyr = GrowPnt(irow,nclass+3);
      if (igrow==1) irefrow = irow;
     
      // Extract parameters 
      int ParNo; int RefParNo;
      G_pars.initialize();
      for (int ipar=1;ipar<=nclass+1;ipar++)
       if (GrowPnt(irow,ipar) != 0)
        {
         if (GrowPnt(irow,ipar) >0 && GrowPnt(irow,ipar) < 10000)
          {
           ParNo = GrowPnt(irow,ipar);
           RefParNo = GrowPnt(irefrow,ipar);
           if (igrow==1) G_pars(ipar) = G_pars_est(ParNo);
           if (igrow>0 && G_relative(ParNo)==0) G_pars(ipar) = G_pars_est(ParNo);
           if (igrow>0 && G_relative(ParNo)==1) G_pars(ipar) = G_pars_est(RefParNo)*exp(G_pars_est(ParNo));
          }
         else
          {
           if (GrowPnt(irow,ipar) > 0)
             {
             int EnvLinkVar = GrowPnt(irow,ipar) - int(GrowPnt(irow,ipar)/100.0)*100;
             int EnvLink = int(GrowPnt(irow,ipar)/100) - int(GrowPnt(irow,ipar)/10000)*100;
             int ParNo = int(GrowPnt(irow,ipar)/10000) - int(GrowPnt(irow,ipar)/1000000)*100;
             if (EnvLink==1) G_pars(ipar) = G_pars_est(RefParNo) + G_pars_est(ParNo)*EnvData(iyr,EnvLinkVar); 
              if (EnvLink==2) G_pars(ipar) = G_pars_est(RefParNo) * G_pars_est(ParNo)*EnvData(iyr,EnvLinkVar); 
             if (EnvLink==3) G_pars(ipar) = G_pars_est(RefParNo)*exp(G_pars_est(ParNo)*EnvData(iyr,EnvLinkVar)); 
           }
           else
            {
             int GrowPnt2 = -1*GrowPnt(irow,ipar);
             int Devpar = GrowPnt2  - int(GrowPnt2/100.0)*100;
              G_pars(ipar) = G_pars_est(RefParNo)*exp(par_devs(Devpar)); 
            }
          }
        
        } //-- ipar
          
      if (bUseCustomMoltProbability2(h) == LOGISTIC_PROB_MOLT)
       {
        molt_mu(h,igrow) = G_pars(1);
        molt_cv(h,igrow) = G_pars(2);
       }
      if (bUseCustomMoltProbability2(h) == FREE_PROB_MOLT  )
       {
        for (int l=1; l<=nclass;l++) molt_probability_in(h,igrow,l) = G_pars(1);
       } 
      } //-- h & igrow
   if (verbose >= 3) cout<<"--finished setting molt pars"<<endl;
      
   // Extract probability of maturing   
   int icnt = 0;
   for ( int h = 1; h <= nsex; h++ )
    if (bUseCustomMatureProbability2(h) != FIXED_PROB_MATURE)
     for (int igrow=1;igrow<=nMatureVaries(h);igrow++) 
      { 
       int OK; int irow; int irefrow; int iyr;
       OK = 0; irow = 0;
       for (int ivec=1;ivec<=nyrRetro-syr+1;ivec++)
        if (GrowPnt(2*nsex*Nyears+(h-1)*Nyears+ivec,nclass+4)==igrow && OK==0) { OK=1; irow=2*nsex*Nyears+(h-1)*Nyears+ivec; }
       iyr = GrowPnt(irow,nclass+3);
       if (igrow==1) irefrow = irow;
     
       // Extract parameters 
       int ParNo; int RefParNo;
       G_pars.initialize();
       for (int ipar=1;ipar<=nclass+1;ipar++)
        if (GrowPnt(irow,ipar) != 0)
         {
          RefParNo = GrowPnt(irefrow,ipar);
          if (GrowPnt(irow,ipar) >0 && GrowPnt(irow,ipar) < 10000)
           {
            ParNo = GrowPnt(irow,ipar);
            if (igrow==1) G_pars(ipar) = G_pars_est(ParNo);
            if (igrow>0 && G_relative(ParNo)==0) G_pars(ipar) = G_pars_est(ParNo);
            if (igrow>0 && G_relative(ParNo)==1) G_pars(ipar) = G_pars_est(RefParNo)*exp(G_pars_est(ParNo));
           } 
          else
           {
            if (GrowPnt(irow,ipar) > 0)
             {
              int EnvLinkVar = GrowPnt(irow,ipar) - int(GrowPnt(irow,ipar)/100.0)*100;
              int EnvLink = int(GrowPnt(irow,ipar)/100) - int(GrowPnt(irow,ipar)/10000)*100;
              int ParNo = int(GrowPnt(irow,ipar)/10000) - int(GrowPnt(irow,ipar)/1000000)*100;
              if (EnvLink==1) G_pars(ipar) = G_pars_est(RefParNo) + G_pars_est(ParNo)*EnvData(iyr,EnvLinkVar); 
              if (EnvLink==2) G_pars(ipar) = G_pars_est(RefParNo) * G_pars_est(ParNo)*EnvData(iyr,EnvLinkVar); 
              if (EnvLink==3) G_pars(ipar) = G_pars_est(RefParNo)*exp(G_pars_est(ParNo)*EnvData(iyr,EnvLinkVar)); 
             }
            else
             {
              int GrowPnt2 = -1*GrowPnt(irow,ipar);
              int Devpar = GrowPnt2  - int(GrowPnt2/100.0)*100;
              G_pars(ipar) = G_pars_est(RefParNo)*exp(par_devs(Devpar)); 
             }
           }
       
         } //-- ipar

       if (bUseCustomMatureProbability2(h) == LOGISTIC_PROB_MATURE)
        {
         mature_mu(h,igrow) = G_pars(1);
         mature_cv(h,igrow) = G_pars(1);
        }
       if (bUseCustomMatureProbability2(h) == FREE_PROB_MATURE  )
        {
         for (int l=1; l<=nclass;l++) mature_probability_in(h,igrow,l) = G_pars(1);
        } 
      } //-- h & Igrow
   if (verbose >= 3) cout<<"--finished setting maturity pars"<<endl;
     
   // Get selectivity parameters
   nsel_use = 0;
   S_pars.initialize();
   for (int it=1;it<=2;it++)
    for (int h=1;h<=nsex;h++)
     for (int k=1;k<=nfleet;k++)
     if ( nparSs(it,(h-1)*nfleet+k) > 0)
      {
       int is = (it-1)*nsex*nfleet+(h-1)*nfleet+k;
       for ( int isel = 1; isel<=nSelVaries(is); isel++)
        {
         nsel_use += 1;
         int OK; int irow; int irefrow; int iyr;
         OK = 0; irow = 0;
         int ipnt3 = (it-1)*nsex*nfleet*Nyears2+(h-1)*nfleet*Nyears2+(k-1)*Nyears2;

         for (int ivec=1;ivec<=nyrRetro+1-syr+1;ivec++)
          if (SelPnt(ipnt3+ivec,nclass+6)==isel && OK==0) { OK=1; irow=ipnt3+ivec; }
         iyr = SelPnt(irow,nclass+5);
         if (isel==1) irefrow = irow;
         sel_patterns2(nsel_use) = irow;

        // Extract parameters 
        int ParNo; int RefParNo;
        for (int ipar=1;ipar<=nclass+1;ipar++)
         if (SelPnt(irow,ipar) != 0)
          {
           RefParNo = SelPnt(irefrow,ipar);
           if (SelPnt(irow,ipar) >0 && SelPnt(irow,ipar) < 10000)
            {
             ParNo = SelPnt(irow,ipar);
             if (isel==1) S_pars(nsel_use,ipar) = S_pars_est(ParNo);
             if (isel>0 && S_relative(ParNo)==0) S_pars(nsel_use,ipar) = S_pars_est(ParNo);
             if (isel>0 && S_relative(ParNo)==1) S_pars(nsel_use,ipar) = S_pars_est(RefParNo)*exp(S_pars_est(ParNo));
            }
           else
            {
             if (SelPnt(irow,ipar) > 0)
              {
               int EnvLinkVar = SelPnt(irow,ipar) - int(SelPnt(irow,ipar)/100.0)*100;
               int EnvLink = int(SelPnt(irow,ipar)/100) - int(SelPnt(irow,ipar)/10000)*100;
               int ParNo = int(SelPnt(irow,ipar)/10000) - int(SelPnt(irow,ipar)/1000000)*100;
               if (EnvLink==1) S_pars(nsel_use,ipar) = S_pars_est(RefParNo) + S_pars_est(ParNo)*EnvData(iyr,EnvLinkVar); 
               if (EnvLink==2) S_pars(nsel_use,ipar) = S_pars_est(RefParNo) * S_pars_est(ParNo)*EnvData(iyr,EnvLinkVar); 
               if (EnvLink==3) S_pars(nsel_use,ipar) = S_pars_est(RefParNo)*exp(S_pars_est(ParNo)*EnvData(iyr,EnvLinkVar)); 
              }
             else
              {
               int SelPnt2 = -1*SelPnt(irow,ipar);
               int Devpar = SelPnt2  - int(SelPnt2/100.0)*100;
               S_pars(nsel_use,ipar) = S_pars_est(RefParNo)*exp(par_devs(Devpar)); 
              }
            }
          } //--ipar
        } //-is  
      }//- it, h, k    
   if (verbose >= 3) cout<<"--finished setting selectivity"<<endl;

   // Natural mortality
   dvar_matrix M_out(syr,nyrRetro,1,nclass);
   for (int h=1;h<=nsex;h++)
    for (int m=1;m<=nmature;m++)
     {
      int ig = (h-1)*nmature + m;
      if (M_mirror(ig)==0)
       {
        M(h,m) = timevarparM(3,ig, nyr, M_relative(ig), M_type(ig), 
                             M_size_breakpnts(ig), M_block(ig), M_block_fn(ig), 
                             M_env_link(ig), M_env_var(ig), 
                             M_extra(ig),M_RW(ig), M_RW_blk(ig), n_Mpar, MToIg, M_pars_est); 
        if (M_mirror_RW(ig) > 0)
         {
          int h2 = isex(M_mirror_RW(ig)); int m2 =imature(M_mirror_RW(ig));
          dvar_vector Mmult = elem_div(M(h,m,syr-1),M(h2,m2,syr-1));
          for (int iyr=syr;iyr<=nyr;iyr++) M(h,m,iyr) = elem_prod(M(h2,m2,iyr),Mmult);
         }
       }
      else
       { M(h,m) = M( isex(M_mirror(ig)),imature(M_mirror(ig)) ); }
     }
   if (verbose >= 3) cout<<"--finished setting M"<<endl;
 
   // SurveyQ
   for (int is=1;is<=nSurveys;is++)
    {
     if (q_mirror(is)==0)
      SurveyQT(is) = timevarparV(1,is, nyrRetro+1, q_block(is), q_env_link(is), q_env_var(is), 
                              q_RW(is), q_RW_blk(is), n_qpar, qToSurv,survey_q); 
     else
      SurveyQT(is) = SurveyQT(q_mirror(is));//--NOTE: index of survey that is mirrored must come before index of mirroring survey
    }
   if (verbose >= 3) cout<<"--finished survey Q"<<endl;
   
   // Additional variance
   for (int is=1;is<=nSurveys;is++)
    {
     if (add_cv_mirror(is)==0)
        AddVarQT(is) = timevarparV(2,is, nyrRetro+1, add_cv_block(is), add_cv_env_link(is), add_cv_env_var(is), 
                                   add_cv_RW(is), add_cv_RW_blk(is), n_addcv_par, AddcvToSurv, log_add_cv); 
     else
      AddVarQT(is) = AddVarQT(add_cv_mirror(is));//--NOTE: index of survey that is mirrored must come before index of mirroring survey
    }
   if (verbose >= 3) cout<<"--finished AddV"<<endl;
   //exit(1);

// =======================================================================================================================================
// =======================================================================================================================================

FUNCTION dvar_vector timevarparV(const int itype, const int ipar, const int lyear,  const int blk, 
                                const int env_link, const int env_var,
                                const int RW, const int RW_blk, 
                                const int npars, ivector parpoints, dvar_vector pars)
  dvar_vector tpar(syr,lyear);
  dvariable envpar, dev;
  int OK, jpnt, devpnt;
 
  // Initialize
  tpar.initialize();
  
  // Extract the baseline parameter
  jpnt = 1; OK = 0;
  for (int kpnt=jpnt;kpnt<=npars && OK==0;kpnt++) if (parpoints(kpnt)==ipar) { jpnt = kpnt; OK = 1; }
  for (int i=syr;i<=lyear;i++) tpar(i) = pars(jpnt);
  
  // Handle block parameters
  if (blk>0)
   for (int iblk=1;iblk<=blocks(blk);iblk++)
    {
     OK = 0;
     for (int kpnt=jpnt+1;kpnt<=npars && OK==0;kpnt++) if (parpoints(kpnt)==ipar) { jpnt = kpnt; OK = 1; }
     for (int i=blocklimits(blk,iblk,1);i<=blocklimits(blk,iblk,2);i++) tpar(i) = pars(jpnt);
    }
   // Handle environmental link parameters 
   if (env_link != 0)
    {
     OK = 0;
     for (int kpnt=jpnt+1;kpnt<=npars && OK==0;kpnt++) if (parpoints(kpnt)==ipar) { jpnt = kpnt; OK = 1; }
     envpar = pars(jpnt);   
     for (int iblk=1;iblk<=blocks(RW_blk);iblk++)
      {
       if (env_link==1) for (int i=blocklimits(RW_blk,iblk,1);i<=blocklimits(RW_blk,iblk,2);i++) tpar(i) +=envpar*EnvData(i,env_var);
       if (env_link==2) for (int i=blocklimits(RW_blk,iblk,1);i<=blocklimits(RW_blk,iblk,2);i++) tpar(i) *=envpar*EnvData(i,env_var);
       if (env_link==3) for (int i=blocklimits(RW_blk,iblk,1);i<=blocklimits(RW_blk,iblk,2);i++) tpar(i) *=exp(envpar*EnvData(i,env_var));
      }
    }
   // Handle random walk parameters
   if (RW != 0) 
    {
     OK = 0;
     for (int kpnt=1;kpnt<=100 && OK==0;kpnt++) if (devpoints(kpnt,1)==itype && devpoints(kpnt,2)==ipar) { jpnt = kpnt; OK = 1; }
     
     // Find the deviations and implement
     devpnt = devpoints(jpnt,3);
     for (int iblk=1;iblk<=blocks(RW_blk);iblk++)
      for (int i=blocklimits(RW_blk,iblk,1);i<=blocklimits(RW_blk,iblk,2);i++)
       {
        // annual or random walk
        if (i==blocklimits(RW_blk,iblk,1))
         {
          dev = par_devs(devpnt); 
         }
        else
         {
          if (RW < 10) dev = par_devs(devpnt); 
          if (RW < 10) dev += par_devs(devpnt); 
         }
        // Additive or multiplicative 
        if (RW==1 || RW==11) tpar(i) += dev;
        if (RW==2 || RW==12) tpar(i) *= dev;
        if (RW==3 || RW==13) tpar(i) *= exp(dev);
        devpnt += 1;
       }
    }
  
    
  return(tpar);

// =======================================================================================================================================
// =======================================================================================================================================

FUNCTION dvar_matrix timevarparM(const int itype, const int ipar, const int lyear,  
                                 const int isrelative, const int type, 
                                 const int sizebreaks, const int blk, const int block_fn, 
                                 const int env_link, const int env_var,
                                 const int extra,
                                 const int RW, const int RW_blk, 
                                 const int npars, ivector parpoints, dvar_vector pars)
  dvar_matrix tpar(syr-1,lyear,1,nclass);
  dvar_vector basevec(1,nclass);
  dvariable envpar, dev;
  int OK, jpnt, devpnt;
 
  // Initialize
  tpar.initialize();
  
  // Extract the baseline parameter 
  jpnt = 1; OK = 0;
  for (int kpnt=jpnt;kpnt<=npars && OK==0;kpnt++) if (parpoints(kpnt)==ipar) { jpnt = kpnt; OK = 1; }
  if (ipar==1 || isrelative==0)
   basevec = pars(jpnt);
  else
   basevec = M(isex(isrelative),imature(isrelative),syr-1)*exp(pars(jpnt)); 
  if (sizebreaks>0) 
   for (int ii=1;ii<=sizebreaks;ii++)
    {
     OK=0;for (int kpnt=jpnt+1;kpnt<=npars && OK==0;kpnt++) if (parpoints(kpnt)==ipar) { jpnt = kpnt; OK = 1; }
     if (isrelative==0)
      for (int l=Mbreaks(ipar,ii);l<=nclass;l++) basevec(l) = pars(jpnt);
     else
      for (int l=Mbreaks(ipar,ii);l<=nclass;l++) basevec(l) *= exp(pars(jpnt));
    }
  // copy for all years
  for (int i=syr-1;i<=lyear;i++) tpar(i) = basevec;
  
  // Splines
  if (type==1)
   {
    dvar_vector delta(syr,nyrRetro);
    OK=0;for (int kpnt=jpnt+1;kpnt<=npars && OK==0;kpnt++) if (parpoints(kpnt)==ipar) { jpnt = kpnt; OK = 1; }
    dvector knots(1,extra);
    dvar_vector vals(1,extra);
    for (int i=1;i<=extra;i++) { knots(i)=(M_ival(jpnt)-syr)/(nyrRetro-syr); jpnt+=1; }
    for (int i=1;i<=extra;i++) { vals(i) = pars(jpnt); jpnt+=1; }
    dvector jyr(syr,nyrRetro);
    jyr.fill_seqadd(0, 1.0 / (nyrRetro - syr));
    vcubic_spline_function csf(knots, vals);
    delta = csf(jyr);
    for (int i=syr;i<=nyrRetro;i++) tpar(i) *= exp(delta(i));
   }
  
  // Handle block parameters
  if (blk>0)
   for (int iblk=1;iblk<=blocks(blk);iblk++)
    {
     OK = 0;
     for (int kpnt=jpnt+1;kpnt<=npars && OK==0;kpnt++) if (parpoints(kpnt)==ipar) { jpnt = kpnt; OK = 1; }
     for (int i=blocklimits(blk,iblk,1);i<=blocklimits(blk,iblk,2);i++) 
      {
       if (block_fn==0) tpar(i) = pars(jpnt);
       if (block_fn==1) tpar(i) *= exp(pars(jpnt));
      } 
    }
   // Handle environmental link parameters 
   if (env_link != 0)
    {
     OK = 0;
     for (int kpnt=jpnt+1;kpnt<=npars && OK==0;kpnt++) if (parpoints(kpnt)==ipar) { jpnt = kpnt; OK = 1; }
     for (int iblk=1;iblk<=blocks(RW_blk);iblk++)
      {
       if (env_link==1) for (int i=blocklimits(RW_blk,iblk,1);i<=blocklimits(RW_blk,iblk,2);i++) tpar(i) +=envpar*EnvData(i,env_var);
       if (env_link==2) for (int i=blocklimits(RW_blk,iblk,1);i<=blocklimits(RW_blk,iblk,2);i++) tpar(i) *=envpar*EnvData(i,env_var);
       if (env_link==3) for (int i=blocklimits(RW_blk,iblk,1);i<=blocklimits(RW_blk,iblk,2);i++) tpar(i) *=exp(envpar*EnvData(i,env_var));
      }
     }
   // Handle random walk parameters
   if (RW != 0) 
    {
     OK = 0;
     for (int kpnt=1;kpnt<=100 && OK==0;kpnt++) if (devpoints(kpnt,1)==itype && devpoints(kpnt,2)==ipar) { jpnt = kpnt; OK = 1; }
     
     // Find the deviations and implement
     devpnt = devpoints(jpnt,3);
     for (int iblk=1;iblk<=blocks(RW_blk);iblk++)
      for (int i=blocklimits(RW_blk,iblk,1);i<=blocklimits(RW_blk,iblk,2);i++)
       {
        // annual or random walk
        if (i==blocklimits(RW_blk,iblk,1))
         {
          dev = par_devs(devpnt); 
         }
        else
         {
          if (RW < 10) dev = par_devs(devpnt); 
          if (RW < 10) dev += par_devs(devpnt); 
         }
        // Additive or multiplicative 
        if (RW==1 || RW==11) tpar(i) += dev;
        if (RW==2 || RW==12) tpar(i) *= dev;
        if (RW==3 || RW==13) tpar(i) *= exp(dev);
        devpnt += 1;
       }
    } //-- if (RW)  
 
  return(tpar);

// =======================================================================================================================================
// =======================================================================================================================================
  /**
   * @brief Instantiate and initialize selectivities for each gear as an array of pointers.
   * @author William Stockhausen
   * @details Selectivity "functions" are handled as classes. The class for each
   * non-mirrored selectivity function is instantiated once here (called in the PRELIMINARY_CALCS_SECTION),
   * and a pointer to it is saved to an array of pointers. Hopefully this will speed up calculating the selectivities
   * in the PROCEDURE_SECTION.
   *
   * Psuedocode:
   *  -# Loop over each gear:
   *  -# Create a pointer array with length = number of blocks
   *  -# Based on slx_type, fill pointer with parameter estimates.
   *  -# save the pointer to an array of pointers (ppSLX).
   *
   * Need to deprecate the abstract class for selectivity, 7X slower. (??)
  **/
// =======================================================================================================================================
FUNCTION init_selectivities
  dvar_vector pv;
  dvar_vector temp_slx1(1,nclass);
  dvariable p1, p2, p3, p4;

  //create pointer array
  if (ppSLX){
      for (int k=0;k<nsel_use;k++) delete ppSLX[k];
      delete ppSLX; ppSLX=0;
  }
  ppSLX = new class gsm::Selex<dvar_vector>*[nsel_use];

  // Specify non-mirrored selectivity
  class gsm::Selex<dvar_vector> *pSLX;
  for (int is=1; is<= nsel_use; is++)
   {
    int ipnt = sel_patterns2(is);
    int it = SelPnt(ipnt, nclass+2);
    int h = SelPnt(ipnt, nclass+3);
    int k = SelPnt(ipnt, nclass+4);
    int iyr = SelPnt(ipnt, nclass+5);
    //cout << is << " " << it << " " << h << " " << k << " " << iyr << endl;
    int ipnt2 = (it-1)*nsex+h;
    if (slx_type_in(ipnt2,k) < 0 || (h==2 && slx_bsex_in(it,k) ==0)) 
     {ppSLX[is-1]=0;} 
    else
     {
      dvar_vector temp_slx2(1,slx_extra_in(ipnt2,k));
      dvar_vector knots(1,slx_extra_in(ipnt2,k));
      switch ( slx_type_in(ipnt2,k) )
       {
        case SELEX_PARAMETRIC:                               ///> parametric
         for (int i = 1; i <= nclass; i++) { temp_slx1(i) = S_pars(is,i); }
         pv = temp_slx1;
         pSLX = new class gsm::ParameterPerClass<dvar_vector>(pv);
         break;
        case SELEX_COEFFICIENTS:                             ///> coefficients
         for (int i = 1; i <= slx_extra_in(ipnt2,k); i++) { temp_slx2(i) = S_pars(is,i); }
         pSLX = new class gsm::SelectivityCoefficients<dvar_vector>(temp_slx2);
         break;
        case SELEX_STANLOGISTIC:                             ///> logistic
         p1 = mfexp(S_pars(is,1));
         p2 = mfexp(S_pars(is,2));
         pSLX = new class gsm::LogisticCurve<dvar_vector,dvariable>(p1,p2);
         break;
        case SELEX_5095LOGISTIC:                             ///> logistic95
         p1 = mfexp(S_pars(is,1));
         p2 = mfexp(S_pars(is,2));
         pSLX = new class gsm::LogisticCurve95<dvar_vector,dvariable>(p1,p2);
         break;
        case SELEX_ONE_PAR_LOGISTIC:                          ///> logistic with one parameter
         p1 = mfexp(S_pars(is,1));
         pSLX = new class gsm::LogisticCurveOne<dvar_vector,dvariable>(p1);
         break;
        case SELEX_DECLLOGISTIC:                             ///> declining logistic
         p1 = mfexp(S_pars(is,1));
         p2 = mfexp(S_pars(is,2));
         for (int i = 1; i <= slx_extra_in(ipnt2,k); i++) { temp_slx2(i) = S_pars(is,2+i);  }
         pSLX = new class gsm::DeclineLogistic<dvar_vector,dvariable,dvariable,dvar_vector>(p1,p2,temp_slx2);
         break;
        case SELEX_DOUBLENORM:                               ///> double normal
         p1 = mfexp(S_pars(is,1));
         p2 = mfexp(S_pars(is,2));
         p3 = mfexp(S_pars(is,3));
         pSLX = new class gsm::DoubleNormal<dvar_vector,dvariable>(p1,p2,p3);
         break;
        case SELEX_DOUBLENORM4:                               ///> double normal4
         p1 = mfexp(S_pars(is,1));
         p2 = mfexp(S_pars(is,2));
         p3 = mfexp(S_pars(is,3));
         p4 = mfexp(S_pars(is,4));
         pSLX = new class gsm::DoubleNormal4<dvar_vector,dvariable>(p1,p2,p3,p4);
         break;
        case SELEX_UNIFORM1:                                  ///> uniform 1
         pSLX = new class gsm::UniformCurve<dvar_vector>;
         break;
        case SELEX_UNIFORM0:                                  ///> uniform 0
         pSLX = new class gsm::Uniform0Curve<dvar_vector>;
         break;
        case SELEX_CUBIC_SPLINE:                             ///> cubic spline
         for (int i = 1; i <= slx_extra_in(ipnt2,k); i++) knots(i) = mfexp(S_pars(is,i)); 
         for (int i = 1; i <= slx_extra_in(ipnt2,k); i++) temp_slx2(i) = S_pars(is,slx_extra_in(ipnt2,k)+i); 
         //need to set y_vals and x_vals below appropriately
         //y_vals are values at knots (a dvar_vector)
         //x_vals are knots           (a dvar_vector)
         pSLX = new class gsm::SelectivitySpline<dvar_vector,dvar_vector>(temp_slx2,knots);
         break;
       
       } // switch
      ppSLX[is-1] = pSLX;//save pointer to the instantiated selectivity object
      } //-- else   
   }

// =======================================================================================================================================
// =======================================================================================================================================

  /**
   * @brief Calculate selectivies for each gear.
   * @author Steve Martell, D'Arcy N. Webber
   * @details Three selectivities must be accounted for by each fleet.
   * 1) capture probability, 2) retention probability, and 3) release/discard probability.
   * Only the parameters for capture probability and retention probability are estimated.
   * The discard probability is calculated from these two probabilities.
   *
   * Maintain the possibility of estimating selectivity independently for each sex; assumes there are data to estimate female selex.
   *
   * Psuedocode:
   *  -# Loop over each gear:
   *  -# Create a pointer array with length = number of blocks
   *  -# Based on slx_type, fill pointer with parameter estimates.
   *  -# Loop over years and block-in the log_selectivity at mid points.
   *
   * Need to deprecate the abstract class for selectivity, 7X slower.
  **/ 
    
FUNCTION calc_selectivities
  if (verbose >= 3) cout<<"starting calc_selectivities"<<endl;
  //int h,i,k, k2;
  int jstore, estore, sd;
  dvar_vector pv;
  dvar_vector temp_slx1(1,nclass);
  dvariable p1, p2, p3, p4;
  dvar_vector selx(1,nclass);
  dvar_matrix sel_store(1,nsel_use,1,nclass);

  log_slx_capture.initialize();
  log_slx_retaind.initialize();
  log_slx_discard.initialize();
  selex_smooth_pen = 0;

  // Specify non-mirrored selectivity
  class gsm::Selex<dvar_vector> *pSLX;
  for (int is=1; is<= nsel_use; is++) {
    int ipnt = sel_patterns2(is);
    int it   = SelPnt(ipnt, nclass+2);
    int h    = SelPnt(ipnt, nclass+3);
    int k    = SelPnt(ipnt, nclass+4);
    int iyr  = SelPnt(ipnt, nclass+5);
    //cout << is << " " << it << " " << h << " " << k << " " << iyr << endl;
    int ipnt2 = (it-1)*nsex+h;
    if ((slx_type_in(ipnt2,k) < 0) || ((h==2) && (slx_bsex_in(it,k) ==0))) 
     {int ipnt = 1; } 
    else {
      dvar_vector temp_slx2(1,slx_extra_in(ipnt2,k));
      dvar_vector knots(1,slx_extra_in(ipnt2,k));
      switch ( slx_type_in(ipnt2,k) ) {
        case SELEX_PARAMETRIC:                               ///> parametric
         for (int i = 1; i <= nclass; i++) { temp_slx1(i) = S_pars(is,i); }
         ((gsm::ParameterPerClass<dvar_vector>*) ppSLX[is-1])->SetSelparms(temp_slx1);
         pSLX = ppSLX[is-1];
         break;
        case SELEX_COEFFICIENTS:                             ///> coefficients
         for (int i = 1; i <= slx_extra_in(ipnt2,k); i++) { temp_slx2(i) = S_pars(is,i); }
         ((gsm::SelectivityCoefficients<dvar_vector>*)ppSLX[is-1])->SetSelCoeffs(temp_slx2);
         pSLX = ppSLX[is-1];
         break;
        case SELEX_STANLOGISTIC:                             ///> logistic
         p1 = mfexp(S_pars(is,1));
         p2 = mfexp(S_pars(is,2));
         ((gsm::LogisticCurve<dvar_vector,dvariable>*) ppSLX[is-1])->SetParams(p1,p2);
         pSLX = ppSLX[is-1];
         break;
        case SELEX_5095LOGISTIC:                             ///> logistic95
         p1 = mfexp(S_pars(is,1));
         p2 = mfexp(S_pars(is,2));
         ((gsm::LogisticCurve95<dvar_vector,dvariable>*) ppSLX[is-1])->SetParams(p1,p2);
         pSLX = ppSLX[is-1];
         break;
        case SELEX_ONE_PAR_LOGISTIC:                          ///> logistic with one parameter
         p1 = mfexp(S_pars(is,1));
         ((gsm::LogisticCurveOne<dvar_vector,dvariable>*) ppSLX[is-1])->SetParams(p1);
         pSLX = ppSLX[is-1];
         break;       
        case SELEX_DECLLOGISTIC:                             ///> declining logistic
         p1 = mfexp(S_pars(is,1));
         p2 = mfexp(S_pars(is,2));
         for (int i = 1; i <= slx_extra_in(ipnt2,k); i++) { temp_slx2(i) = S_pars(is,2+i);  }
         ((gsm::DeclineLogistic<dvar_vector,dvariable,dvariable,dvar_vector>*) ppSLX[is-1])->SetParams(p1,p2,temp_slx2);
         pSLX = ppSLX[is-1];
         break;
        case SELEX_DOUBLENORM:                               ///> double normal
         p1 = mfexp(S_pars(is,1));
         p2 = mfexp(S_pars(is,2));
         p3 = mfexp(S_pars(is,3));
         ((gsm::DoubleNormal<dvar_vector,dvariable>*) ppSLX[is-1])->SetParams(p1,p2,p3);
         pSLX = ppSLX[is-1];
        case SELEX_DOUBLENORM4:                               ///> double normal4
         p1 = mfexp(S_pars(is,1));
         p2 = mfexp(S_pars(is,2));
         p3 = mfexp(S_pars(is,3));
         p4 = mfexp(S_pars(is,4));
         ((gsm::DoubleNormal4<dvar_vector,dvariable>*) ppSLX[is-1])->SetParams(p1,p2,p3,p4);
         pSLX = ppSLX[is-1];
        case SELEX_UNIFORM1:                                  ///> uniform 1
         pSLX = ppSLX[is-1];//gsm::UniformCurve<dvar_vector>
         break;
        case SELEX_UNIFORM0:                                  ///> uniform 0
         pSLX = ppSLX[is-1];//gsm::Uniform0Curve<dvar_vector>
         break;
        case SELEX_CUBIC_SPLINE:                             ///> cubic spline
         for (int i = 1; i <= slx_extra_in(ipnt2,k); i++) knots(i) = mfexp(S_pars(is,i)); 
         for (int i = 1; i <= slx_extra_in(ipnt2,k); i++) temp_slx2(i) = S_pars(is,slx_extra_in(ipnt2,k)+i); 
         //need to set y_vals and x_vals below appropriately
         //y_vals are values at knots (a dvar_vector)
         //x_vals are knots           (a dvar_vector)
         ((gsm::SelectivitySpline<dvar_vector,dvar_vector>*) ppSLX[is-1])->initSpline(temp_slx2,knots);
         pSLX = ppSLX[is-1];
         dvector knots2(1,slx_extra_in(ipnt2,k));
         dvar_vector vals(1,slx_extra_in(ipnt2,k));
         for (int i=1;i<=slx_extra_in(ipnt2,k);i++) { knots2(i)=(value(mfexp(S_pars(is,i)))-mid_points(1))/(mid_points(nclass)-mid_points(1));  }
         for (int i=1;i<=slx_extra_in(ipnt2,k);i++) { vals(i) = S_pars(is,slx_extra_in(ipnt2,k)+i); }
         dvector jyr(1,nclass);
         jyr.fill_seqadd(0, 1.0 / (nclass - 1));
         vcubic_spline_function csf(knots2, vals);
         selx = csf(jyr);
         break;
       
       } // switch
      if (slx_type_in(ipnt2,k)!=SELEX_CUBIC_SPLINE) selx = pSLX->logSelectivity(dvar_mid_points);  
      if (slx_type_in(ipnt2,k)==SELEX_PARAMETRIC || slx_type_in(ipnt2,k)==SELEX_COEFFICIENTS) selex_smooth_pen += dnorm(first_difference(selx), 1.0);
      if (slx_type_in(ipnt2,k)==SELEX_CUBIC_SPLINE) selex_smooth_pen += dnorm(first_difference(selx), 1.0);
      if (ret_max_in(ipnt2,k)>0) selx += S_pars(is,3);
      if (slx_max_at_1_in(ipnt2,k)==1) selx -= selx(nclass);
      if (slx_max_at_1_in(ipnt2,k)==0 && slx_1_at_size(ipnt2,k)!=0) selx -= selx(slx_1_at_size(ipnt2,k));
      sel_store(is) = selx;
      if (it==1) log_slx_capture(k,h,iyr) = selx;
      if (it==2) { log_slx_retaind(k,h,iyr) = selx; log_slx_discard(k,h,iyr) = log(1.0 - exp(selx) + TINY); }
     } //-- else   
   }
  
  int nsel_pnt = 0;
  for (int it=1;it<=2;it++)
   for (int h=1;h<=nsex;h++)
    for (int k=1;k<=nfleet;k++)
      {
       int ipnt2 = (it-1)*nsex+h;
        switch ( slx_type_in(ipnt2,k) )
        {
         case SELEX_UNIFORM1:                                  ///> uniform 1
          for (int iyr=syr;iyr<=nyrRetro+1;iyr++)
           {
            if (it==1) for (int i=1;i<=nclass;i++) log_slx_capture(k,h,iyr,i) = log(1.0-TINY);
            if (it==2) for (int i=1;i<=nclass;i++) { log_slx_retaind(k,h,iyr,i) = log(1.0-TINY); log_slx_discard(k,h,iyr,i) = log(TINY); }
           }
          break;
         case SELEX_UNIFORM0:                                  ///> uniform 1
          for (int iyr=syr;iyr<=nyrRetro+1;iyr++)
           {
            if (it==1) for (int i=1;i<=nclass;i++) log_slx_capture(k,h,iyr,i) = -100;
            if (it==2) for (int i=1;i<=nclass;i++) { log_slx_retaind(k,h,iyr,i) = -100; log_slx_discard(k,h,iyr,i) = log(1-TINY); }
           }
          break;
         case SELEX_PRESPECIFIED:
          for (int iyr=syr;iyr<=nyrRetro+1;iyr++)
           {
            int offset = (it-1)*nfleet*nsex*(nyr+1-syr+1)+nfleet*(nyr+1-syr+1)*(h-1)+(nyr+1-syr+1)*(k-1)+iyr-syr+1;
            if (it==1) for (int i=1;i<=nclass;i++) log_slx_capture(k,h,iyr,i) = log(CustomSelex(offset,i));
            if (it==2) for (int i=1;i<=nclass;i++) { log_slx_retaind(k,h,iyr,i) = log(CustomSelex(offset,i)); log_slx_discard(k,h,iyr,i) = log(1.0 - CustomSelex(offset,i) + TINY); }
           }
          break;
         default:
          // Mirror case
          if (slx_type_in(ipnt2,k) < 0)
           {
            for (int iyr=syr;iyr<=nyrRetro+1;iyr++)
             {
             if (it==1) log_slx_capture(k,h,iyr) = log_slx_capture(-slx_type_in(ipnt2,k),h,iyr);
             if (it==2) { log_slx_retaind(k,h,iyr) =log_slx_retaind(-slx_type_in(ipnt2,k),h,iyr); 
                          log_slx_discard(k,h,iyr) = log_slx_discard(-slx_type_in(ipnt2,k),h,iyr); }
             }              
           }
          else
           {
            int ipnt1 = (it-1)*nsex+h;
            int ipnt2 = (it-1)*nsex*nfleet+(h-1)*nfleet+k;
            if (h==1 || slx_bsex_in(it,k)==1)
             {
              for (int iyr=syr;iyr<=nyrRetro+1;iyr++)
               {
                int isel_vec = nsel_pnt+iYrsSelChanges(ipnt2,iyr);
                selx = sel_store(isel_vec);
                if (it==1) log_slx_capture(k,h,iyr) = selx;
                if (it==2) { log_slx_retaind(k,h,iyr) = selx; log_slx_discard(k,h,iyr) = log(1.0 - exp(selx) + TINY); }
               }
              nsel_pnt += nSelVaries(ipnt2);
              }
            else
             {
              for (int iyr=syr;iyr<=nyrRetro+1;iyr++)
               {
                if (it==1) selx = log_slx_capture(k,1,iyr);
                if (it==2) selx = log_slx_retaind(k,1,iyr);
                if (it==1) log_slx_capture(k,h,iyr) = selx;
                if (it==2) { log_slx_retaind(k,h,iyr) = selx; log_slx_discard(k,h,iyr) = log(1.0 - exp(selx) + TINY); }
               }
             } //--if  
            } //-if
         } //-- switch
      } //-- it,h,k
   
  // Check for one fleet inside another 
  for (int it=1;it<=1;it++)
   for (int h=1;h<=nsex;h++)
    for (int k=1;k<=nfleet;k++)
     if (slx_include_in(1,k) > 0)
      {
       for (int iyr=syr;iyr<=nyrRetro+1;iyr++)
        log_slx_capture(k,h,iyr) += log_slx_capture(slx_include_in(1,k),h,iyr);
      }
    
  //echoinput << "log_slx_capture" << endl;
  //echoinput << exp(log_slx_capture) << endl;
  //echoinput << "log_slx_retaind" << endl;
  //echoinput << exp(log_slx_retaind) << endl;
  //echoinput << "log_slx_discard" << endl;
  //echoinput << exp(log_slx_discard) << endl;
 	
// --------------------------------------------------------------------------------------------------

  /**
   * @brief Calculate fishing mortality rates for each fleet.
   * @details For each fleet estimate scaler log_fbar and deviates (f_devs). This function calculates the fishing mortality rate including deaths due to discards. Where xi is the discard mortality rate.
   *
   * In the event that there is effort data and catch data, then it's possible to estimate a catchability coefficient and predict the catch for the period of missing catch/discard data.  Best option for this would be to use F = q*E, where q = F/E.  Then in the objective function, minimize the variance in the estimates of q, and use the mean q to predict catch. Or minimize the first difference and assume a random walk in q.
   *
   * @param log_fbar are the mean fishing mortality of males parameters with dimension (1,nfleet,f_phz)
   * @param log_fdev are the male fdevs parameters with dimension (1,nfleet,1,nFparams,f_phz)
   * @param log_foff are the offset to the male fishing mortality parameters with dimension (1,nfleet,foff_phz)
   * @param log_fdov are the female fdev offset parameters with dimension (1,nfleet,1,nYparams,foff_phz)
   * @param dmr is the discard mortality rate
   * @param F is the fishing mortality with dimension (1,nsex,syr,nyr,1,nseason,1,nclass)
  **/


FUNCTION calc_fishing_mortality
  int ik,yk;
  double xi; // discard mortality rate
  dvar_vector sel(1,nclass);
  dvar_vector ret(1,nclass);
  dvar_vector vul(1,nclass);

  // Initilaize F2 with 1.0e-10
  F.initialize();
  dvariable log_ftmp;
   for ( int h = 1; h <= nsex; h++ )
    for ( int i = syr; i <= nyrRetro; i++ )
     for ( int j = 1; j <= nseason; j++ )
      for ( int l = 1; l <= nclass; l++)
       F2(h,i,j,l) = 1.0e-10;

  // fishing morrtality generally
  ft.initialize(); fout.initialize();
  for ( int k = 1; k <= nfleet; k++ )
   for ( int h = 1; h <= nsex; h++ )
    {
     ik = 1; yk = 1;
     for ( int i = syr; i <= nyrRetro; i++ )
      for ( int j = 1; j <= nseason; j++ )
       {
        if ( fhit(i,j,k)>0 )
         {
          log_ftmp = log_fbar(k) + log_fdev(k,ik++);                 ///> Male F is the reference plus the annual deviation
          fout(k,i) = exp(log_ftmp);                                 ///> Report of male F
          if (h==2) log_ftmp += log_foff(k);                         ///> Female F is an offset from male F
          if (h==2 && yhit(i,j,k)>0) log_ftmp += log_fdov(k,yk++);    ///> annual F dev
          ft(k,h,i,j) = mfexp(log_ftmp);
          xi  = dmr(i,k);                                            ///> Discard mortality rate
          sel = mfexp(log_slx_capture(k,h,i))+1.0e-10;               ///> Capture selectivity
          ret = mfexp(log_slx_retaind(k,h,i)) * slx_nret(nsex+h,k);  ///> Retention
          vul = elem_prod(sel, ret + (1.0 - ret) * xi);              ///> Vulnerability
          F(h,i,j) += ft(k,h,i,j) * vul;                             ///> Fishing mortality
          F2(h,i,j) += ft(k,h,i,j) * sel;                            ///> Contact mortality (WTS: capture [or contact] rate, not "mortality")
         }
       } // years and seasons
    } // fleet and sex

// --------------------------------------------------------------------------------------------------------------------------------------

  /**
   * @brief Calculate natural mortality array
   * @details Natural mortality (M) is a 3d array for sex, year and size.
   *
   * todo: Size-dependent mortality
  **/

FUNCTION calc_natural_mortality

// --------------------------------------------------------------------------------------------------------------------------------------

  /**
   * @brief Calculate total instantaneous mortality rate and survival rate
   * @details \f$ S = exp(-Z) \f$
   *
   * ISSUE, for some reason the diagonal of S goes to NAN if linear growth model is used. Due to F.
   *
   * @param m_prop is a vector specifying the proportion of natural mortality (M) to be applied each season
   * @return NULL
  **/

FUNCTION calc_total_mortality
  Z.initialize(); Z2.initialize();S.initialize();
 for( int m = 1; m <= nmature; m++)
  for ( int h = 1; h <= nsex; h++ )
   for ( int i = syr; i <= nyrRetro; i++ )
    for ( int j = 1; j <= nseason; j++ )
     {
      Z(h,m,i,j) = m_prop(i,j) * M(h,m,i) + F(h,i,j);
      Z2(h,m,i,j) = m_prop(i,j) * M(h,m,i) + F2(h,i,j);
      if (season_type(j) == 0) for ( int l = 1; l <= nclass; l++ ) S(h,m,i,j)(l,l) = 1.0-Z(h,m,i,j,l)/Z2(h,m,i,j,l)*(1.0-mfexp(-Z2(h,m,i,j,l)));
      if (season_type(j) == 1) for ( int l = 1; l <= nclass; l++ ) S(h,m,i,j)(l,l) = mfexp(-Z(h,m,i,j,l));
     }

// =======================================================================================================================================
// =======================================================================================================================================

  /**
   * @brief Calculate the probability of moulting by carapace width.
   * @details Note that the parameters molt_mu and molt_cv can only be estimated in cases where there is new shell and old shell data. Note that the diagonal of the P matrix != 0, otherwise the matrix is singular in inv(P).
   *
   * @param molt_mu is the mean of the distribution
   * @param molt_cv scales the variance of the distribution
  **/

FUNCTION calc_molting_probability
  double tiny = 0.000;

  molt_probability.initialize();
  for ( int i = syr; i <= nyrRetro; i++ )
   for ( int h = 1; h <= nsex; h++ )
    {
     int igrow  = iYrsMoltChanges(h,i);
     
     // Pre-specified molt probability
     if (bUseCustomMoltProbability2(h)==FIXED_PROB_MOLT)
      molt_probability(h)(i) = CustomMoltProbabilityMatrix(h,igrow);
     // Uniform probability of maturing
     if (bUseCustomMoltProbability2(h) == CONSTANT_PROB_MOLT)
      {
       for ( int i = syr; i <= nyrRetro; i++ )
        for ( int l = 1; l <= nclass; l++ )
          molt_probability(h,i,l) = 1.0;
      }
     // Estimated mature probability of maturing
     if (bUseCustomMoltProbability2(h) == LOGISTIC_PROB_MOLT)
      {
       dvariable mu = molt_mu(h,igrow);
       dvariable sd = mu * molt_cv(h,igrow);
        molt_probability(h)(i) = 1.0 - ((1.0 - 2.0 * tiny) * plogis(dvar_mid_points, mu, sd) + tiny);
      }

     // Estimated free probability of molting
     if (bUseCustomMoltProbability2(h)==FREE_PROB_MOLT)
      molt_probability(h)(i) = molt_probability_in(h,igrow);
    }


  /**
   * @brief Calculate the probability of maturing by carapace width.
   * @details Note that the parameters mature_mu and mature_cv can only be estimated in cases where there is new shell and old shell data. Note that the diagonal of the P matrix != 0, otherwise the matrix is singular in inv(P).
   *
   * @param mature_mu is the mean of the distribution
   * @param mature_cv scales the variance of the distribution
  **/

// ----------------------------------------------------------------------------------------------------------------------------------------

  /**
   * @brief Compute growth increments
   * @details Presently based on liner form
   *
   * @param vSizes is a vector of doubles of size data from which to compute predicted values
   * @param iSex is an integer vector indexing sex (1 = male, 2 = female)
   *
   * @return dvar_vector of predicted growth increments
  **/

FUNCTION dvar_vector calc_growth_increments_data(const dvector vSizes, const ivector iSex, int igrow)
  {
   if ( vSizes.indexmin() != iSex.indexmin() || vSizes.indexmax() != iSex.indexmax() )
    { cerr << "indices don't match..." << endl; ad_exit(1); }
    RETURN_ARRAYS_INCREMENT();
    dvar_vector pMoltInc(1,vSizes.indexmax());
    pMoltInc.initialize();
    int h,i;
    for ( i = 1; i <= nGrowthObs; i++ )
     {
      h = iSex(i);
      pMoltInc(i) = alpha(h,igrow) - beta(h,igrow) * vSizes(i);
     }
     
    RETURN_ARRAYS_DECREMENT();
    return pMoltInc;
  }

// ----------------------------------------------------------------------------------------------------------------------------------------

  /**
   * @brief Molt increment as a linear function of pre-molt size.
   *
   * TODO: Option for empirical molt increments.
   *
   * @param alpha
   * @param beta
   * @param mid_points
   *
   * @return molt_increment
  **/
FUNCTION calc_growth_increments

  for ( int h = 1; h <= nsex; h++ )
   {
    if (bUseGrowthIncrementModel2(h)==LINEAR_GROWTHMODEL)
     {
      for ( int igrow = 1; igrow<=nSizeIncVaries(h); igrow++)
       {
        for ( int l = 1; l <= nclass; l++ )
         molt_increment(h,igrow,l) = alpha(h,igrow) - beta(h,igrow) * mid_points(l);
         if (NfunCall==0 || NfunCall==1)
         if (molt_increment(h,igrow,int(nclass/2)) < 0)
          {
          // cout << "Growth increments seem to be too negative for initial call for matrix "<< igrow << " and sex " << h << endl;
           for ( int l = 1; l <= nclass; l++) cout << molt_increment(h,igrow,l) << endl;
          }
         } // - for h     
      } 
    if (bUseGrowthIncrementModel2(h)==PWRLAW_GROWTHMODEL)
     {
       for ( int igrow = 1; igrow<=nSizeIncVaries(h); igrow++)
        {
         for ( int l = 1; l <= nclass; l++ )
          molt_increment(h,igrow,l) = exp(alpha(h,igrow) + beta(h,igrow) * log(mid_points(l))) - mid_points(l);
         if (NfunCall==0 || NfunCall==1)
          if (molt_increment(h,igrow,int(nclass/2)) < 0)
           {
           // cout << "Growth increments seem to be too negative for initial call for matrix "<< igrow << " and sex " << h << endl;
            for ( int l = 1; l <= nclass; l++) cout << molt_increment(h,igrow,l) << endl;
           }
         } // - for h     
      }// -- if
     } //--h

// ----------------------------------------------------------------------------------------------------------------------------------------

  /**
   * @brief Calclate the growth and size transtion matrix
   * @details Calculates the size transition matrix for each sex based on growth increments, which is a linear function of the size interval, and the scale parameter for the gamma distribution.  This function does the proper integration from the lower to upper size bin, where the mode of the growth increment is scaled by the scale parameter.
   *
   * This function loops over sex, then loops over the rows of the size transition matrix for each sex.  The probability of transitioning from size l to size ll is based on the vector molt_increment and the scale parameter. In all there are three parameters that define the size transition matrix (alpha, beta, scale) for each sex. Issue 112 details some of evolution of code development here
   *
   * @param gscale
   * @param P a 3D array of molting probabilities with dimension (1,nsex,1,nclass,1,nclass)
  **/
FUNCTION calc_growth_transition
  int count68;
  dvariable mean_size_after_molt;
  dvariable Accum,CumInc,Upper_Inc;
  dvar_vector psi(1,nclass+1);
  dvar_vector sbi(1,nclass+1);
  dvar_matrix gt(1,nclass,1,nclass);
  dvariable Len1Low,Len1Hi,Len2Low,Len2Hi,total,step,prob_val,l1r;
  dvariable mlk,sigmaK2,l1,rangL,rangU,Upp1,Kr,kval,temp,temp6,scale;
  dvariable mll,sigmaL2,Linfval,Linfr,LinfU,LinfL,temp2,temp4,temp5;
  dvariable templ11,templ12,temp68,tempr,nvar,tempL1,tempL2,tempk1,tempk2;
  dvariable Temp,Val,Cum;
  dvar_vector prob_val_vec(1,1024);

  // reset the growth transition matrix
  growth_transition.initialize();

  // loop over sex
  for ( int h = 1; h <= nsex; h++ )
   {
    //  Set the growth-transition matrix (does not include molt_probability)
    if ( bUseCustomGrowthMatrix2(h) == GROWTH_FIXEDGROWTHTRANS || bUseCustomGrowthMatrix2(h) == GROWTH_FIXEDSIZETRANS)
     for (int j=1;j<=nSizeIncVaries(h);j++) growth_transition(h,j) = CustomGrowthMatrix(h,j);

    // Set the growth-transition matrix (size-increment is gamma)
    if ( bUseCustomGrowthMatrix2(h) == GROWTH_INCGAMMA )
     {
      for (int k =1; k<=nSizeIncVaries(h);k++)
       {
        gt.initialize();
        for ( int l = 1; l <= nSizeSex(h)-1; l++ )
         {
          mean_size_after_molt =  molt_increment(h,k,l) / gscale(h,k);
          Accum = 0;
          for ( int ll = l; ll <= nSizeSex(h)-1; ll++ )
           {
            Upper_Inc = (size_breaks(ll+1) - mid_points(l))/gscale(h,k);
            CumInc = cumd_gamma(Upper_Inc, mean_size_after_molt);
            gt(l,ll) = CumInc - Accum;
            Accum = CumInc;
           }
          gt(l,nSizeSex(h)) = 1.0 - Accum;
         }
        gt(nSizeSex(h),nSizeSex(h)) = 1.0;
        growth_transition(h,k) = gt;
       }
     }

	 // Set the growth-transition matrix (size after increment is gamma)
    if ( bUseCustomGrowthMatrix2(h) == GROWTH_SIZEGAMMA )
     {
      for (int k =1; k<=nSizeIncVaries(h);k++)
       {
        gt.initialize();
        sbi = size_breaks / gscale(h,k);
        for ( int l = 1; l <= nSizeSex(h); l++ )
         {
          mean_size_after_molt = (mid_points(l) + molt_increment(h,k,l)) / gscale(h,k);
          psi.initialize();
          for (int ll = l; ll <= nclass+1; ll++ )
           psi(ll) = cumd_gamma(sbi(ll), mean_size_after_molt);
          gt(l)(l,nSizeSex(h)) = first_difference(psi(l,nclass+1));
          gt(l)(l,nSizeSex(h)) = gt(l)(l,nSizeSex(h)) / sum(gt(l));
         }
        growth_transition(h,k) = gt;
       }
     }

    // Set the growth-transition matrix (size after increment is normal)
    if ( bUseCustomGrowthMatrix2(h) == GROWTH_NORMAL )
     {
      for (int k =1; k<=nSizeIncVaries(h);k++)
       {
        gt.initialize();
        sbi = size_breaks / gscale(h,k);
        for ( int l = 1; l <= nSizeSex(h)-1; l++ )
         {
          mean_size_after_molt = mid_points(l) + molt_increment(h,k,l);
          Temp = 0;
          for ( int ll = l; ll <= nclass-1; ll++ )
           {
            Val = (size_breaks(ll+1) - mean_size_after_molt)/gscale(h,k);
            Cum = cumd_norm(Val);
            gt(l)(ll) = Cum - Temp;
            Temp = Cum;
           }
          gt(l,nclass) = 1.0-Temp;
         }
        gt(nclass,nclass) = 1.0;
        growth_transition(h,k) = gt;
       }
     }

    // set the growth matrix based inidvidual variation in kappa
    if ( bUseCustomGrowthMatrix2(h) == GROWTH_VARYK )
     {
      for (int k =1; k<=nSizeIncVaries(h);k++)
       {
        mlk = log(Kappa(h,k));
        sigmaK2 = SigmaKappa(h,k)*SigmaKappa(h,k);
        tempk2 = sqrt(2.0*M_PI*sigmaK2);
        growth_transition(h,k,nSizeSex(h),nSizeSex(h)) = 1;               // No growth from the last class

        // the initial size class
        for (int l = 1; l <= nSizeSex(h)-1; l++ )
         {
          Len1Low = size_breaks(l); Len1Hi = size_breaks(l+1);
          scale = 1.0/(Len1Hi-Len1Low);
          temp = Len1Low; total = 0;
          if (Len1Low < Linf(h,k))
           {
            for(int l2c=l;l2c<=nSizeSex(h)+20;l2c++)
             {
              if (l2c<=nSizeSex(h))
               step = size_breaks(l2c+1)-size_breaks(l2c);
              else
               step = size_breaks(nSizeSex(h)+1)-size_breaks(nSizeSex(h));
              l1r = step/2.0;
              Len2Low = temp;  Len2Hi = temp + step; temp = Len2Hi;
              prob_val = 0;
              for(int evl1=1;evl1<=32;evl1++)
               {
                l1 = ((xg(evl1) + 1.0)/2.0)*(Len1Hi-Len1Low) + Len1Low;
                if (Linf(h,k) <= Len2Hi) Upp1 = Linf(h,k) - l1 - 0.001; else Upp1 = Len2Hi - l1;
                rangU = -log(1 - Upp1/(Linf(h,k) - l1));
                if(Linf(h,k) > Len2Low)
                 {
                  rangL = -log(1 - (Len2Low - l1)/(Linf(h,k) - l1));
                  Kr = (rangU-rangL)/2.0;
                  for( int evk=1; evk<=32;evk++)
                   {
                    kval = ((xg(evk) + 1.0)/2.0)*(rangU-rangL) + rangL;
                    if(kval > 0)
                     {
                      temp6 = mfexp(-((log(kval) - mlk)*(log(kval) - mlk))/(2.0*sigmaK2))/(kval*tempk2);
                      prob_val += Kr*wg(evk)*temp6*wg(evl1)*scale;
                     }
                   } // evk
                 } //if(Linf > Len2Low)
               } // evl1
              prob_val *= l1r;
              total += prob_val;
              if(l2c < nSizeSex(h))
               growth_transition(h,k,l,l2c) = prob_val;
              else
               growth_transition(h,k,l,nSizeSex(h)) += prob_val;
             } // l2c
            for(int l2c=l;l2c<=nSizeSex(h);l2c++) growth_transition(h,k,l,l2c) /= total;
           } // if (LenLow < Linf)
          else
           {
            growth_transition(h,k,l,l) = 1;
            total = 1;
           }
         } // l
       } // k
     } // if


     // Linf varies among individuals
     if ( bUseCustomGrowthMatrix2(h) == GROWTH_VARYLINF )
      {
       for (int k =1; k<=nSizeIncVaries(h);k++)
        {
         mll = log(Linf(h,k));
         sigmaL2 = SigmaLinf(h,k)*SigmaLinf(h,k);
         tempL1 = sqrt(2.0*M_PI*sigmaL2);
         growth_transition(h,k,nSizeSex(h),nSizeSex(h)) = 1;               // No growth from the last class

         // the initial size class
         for ( int l = 1; l <= nSizeSex(h)-1; l++ )
          {
           Len1Low = size_breaks(l); Len1Hi = size_breaks(l+1);
           scale = 1.0/(Len1Hi-Len1Low);
           temp = Len1Low; total = 0;
           for(int l2c=l;l2c<=nSizeSex(h)+10;l2c++)
            {
             if (l2c<=nSizeSex(h))
              step = size_breaks(l2c+1)-size_breaks(l2c);
             else
              step = size_breaks(nSizeSex(h)+1)-size_breaks(nSizeSex(h));
             l1r = step/2.0;
             Len2Low = temp;  Len2Hi = temp + step; temp = Len2Hi;
             prob_val = 0;
             for(int evl1=1;evl1<=32;evl1++)
              {
               l1 = ((xg(evl1) + 1.0)/2.0)*(Len1Hi-Len1Low) + Len1Low;
               LinfU = l1 + (Len2Hi - l1)/(1-mfexp(-Kappa(h,k)));
               if(l2c == l) LinfL = l1; else LinfL = l1 + (Len2Low - l1)/(1-mfexp(-Kappa(h,k)));
               temp2 = (log(l1) - mll)/SigmaLinf(h,k);
               temp4 = 1.0 - cumd_norm(temp2);
               Linfr = (LinfU - LinfL)/2.0;
               for(int evL=1; evL<=32;evL++)
                {
                 Linfval = ((xg(evL) + 1.0)/2.0)*(LinfU - LinfL) + LinfL;
                 temp5 = 1.0/(Linfval*tempL1)*mfexp(-((log(Linfval) - mll)*(log(Linfval) - mll))/(2*sigmaL2));
                 prob_val += Linfr*wg(evL)*temp5*wg(evl1)*scale/temp4;
                } // evl
               } // evl1
             prob_val *= l1r;
             total += prob_val;
             if(l2c < nSizeSex(h))
               growth_transition(h,k,l,l2c) = prob_val;
             else
              growth_transition(h,k,l,nSizeSex(h)) += prob_val;
            } // l2c
           for(int l2c=l;l2c<=nSizeSex(h);l2c++) growth_transition(h,k,l,l2c) /= total;

          } // l
        } // k
      }  // if

     // Linf and K vary among individuals
     if ( bUseCustomGrowthMatrix2(h) == GROWTH_VARYKLINF )
      {
       for (int k =1; k<=nSizeIncVaries(h);k++)
        {
         nvar = 15;
         mll = log(Linf(h,k));
         mlk = log(Kappa(h,k));
         sigmaK2 = SigmaKappa(h,k)*SigmaKappa(h,k);
         sigmaL2 = SigmaLinf(h,k)*SigmaLinf(h,k);
         tempL1 = sqrt(2.0*M_PI*sigmaL2);
         tempL2 = 2.0*sigmaL2;
         tempk1 = sqrt(2.0*M_PI*sigmaK2);
         tempk2 = 2.0*sigmaK2;
         temp = sqrt(mfexp(2.0*mlk+sigmaK2)*(mfexp(sigmaK2)-1.0))*nvar;
         rangU = Kappa(h,k) + temp;
         rangL = Kappa(h,k) - temp;
         if(rangL < 0) rangL = 0;
         Kr = (rangU - rangL)/2.0;
         growth_transition(h,k,nSizeSex(h),nSizeSex(h)) = 1;               // No growth from the last class

         // the initial size class
         for ( int l = 1; l <= nSizeSex(h)-1; l++ )
          {
           Len1Low = size_breaks(l); Len1Hi = size_breaks(l+1);
           temp = Len1Low; total = 0;

           scale = 1.0/(Len1Low-Len1Hi);
           for(int l2c=l;l2c<=nSizeSex(h)+20;l2c++)
            {
             if (l2c<=nSizeSex(h))
              step = size_breaks(l2c+1)-size_breaks(l2c);
             else
              step = size_breaks(nSizeSex(h)+1)-size_breaks(nSizeSex(h));
             l1r = step/2.0;
             templ11 = scale*Kr*l1r;
             Len2Low = temp;  Len2Hi = temp + step; temp = Len2Hi; prob_val = 0;
             for(int evl1=1;evl1<=32;evl1++)
              {
               l1 = l1_vec(h,l,evl1);
               temp2 = (log(l1) - mll)/SigmaLinf(h,k);
               temp4 = 1.0 - cumd_norm(temp2);
               templ12 = wg(evl1)*templ11/temp4;
               count68 = 1;
               for( int evk=1;evk<=32;evk++)
                {
                 kval = ((xg(evk) + 1.0)/2.0)*(rangU-rangL) + rangL;
                 LinfU = l1 + (Len2Hi - l1)/(1.0-mfexp(-kval));
                 if(l2c == l) LinfL = l1; else LinfL = l1 + (Len2Low - l1)/(1-mfexp(-kval));
                 Linfr = (LinfU - LinfL)/2.0;
                 temp6 = mfexp(-((log(kval) - mlk)*(log(kval) - mlk))/tempk2)/(kval*tempk1);
                 temp68 = wg(evk)*temp6*templ12;
                 for(int evL=1;evL<=32;++evL)
                  {
                   Linfval = ((xg(evL) + 1.0)/2.0)*(LinfU - LinfL) + LinfL;
                   temp5 = mfexp(-((log(Linfval) - mll)*(log(Linfval) - mll))/tempL2)/(Linfval*tempL1);
                   prob_val_vec(count68) = Linfr*wg(evL)*temp5*temp68;
                   count68 += 1;
                  }
                }
               prob_val += sum(prob_val_vec);
              }

             total += prob_val;
             if(l2c < nSizeSex(h))
              growth_transition(h,k,l,l2c) = prob_val;
             else
              growth_transition(h,k,l,nSizeSex(h)) += prob_val;
            } // l2c
           for(int l2c=l;l2c<=nSizeSex(h);l2c++) growth_transition(h,k,l,l2c) /= total;
          } // l
        } // k
      }  // if
   } // h

// =======================================================================================================================================
// =======================================================================================================================================

FUNCTION calc_mature_probability
  double tiny = 0.000;

  mature_probability.initialize();
  for ( int i = syr; i <= nyrRetro; i++ )
   for ( int h = 1; h <= nsex; h++ )
    {
     int igrow  = iYrsMatureChanges(h,i);
     
     // Pre-specified mature probability
     if (bUseCustomMatureProbability2(h)==FIXED_PROB_MATURE)
      mature_probability(h)(i) = CustomMatureProbabilityMatrix(h,igrow);
     // Estimated logistic probability of maturing
     if (bUseCustomMatureProbability2(h) == LOGISTIC_PROB_MATURE)
      {
       dvariable mu = mature_mu(h,igrow);
       dvariable sd = mu * mature_cv(h,igrow);
       mature_probability(h)(i) = 1.0 - ((1.0 - 2.0 * tiny) * plogis(dvar_mid_points, mu, sd) + tiny);
      }

     // Estimated free probability of maturing
     if (bUseCustomMatureProbability2(h)==FREE_PROB_MATURE)
      mature_probability(h)(i) = mature_probability_in(h,igrow);
    }


// ============================================================================================================================================

  /**
   * @brief calculate size distribution for new recuits.
   * @details Based on the gamma distribution, calculates the probability of a new recruit being in size-interval size.
   *
   * @param ra is the mean of the distribution
   * @param rbeta scales the variance of the distribution
   * @return rec_sdd the recruitment size distribution vector
  **/
FUNCTION calc_recruitment_size_distribution
  dvariable ralpha;
  dvar_vector x(1,nclass+1);

  rec_sdd.initialize();
  for ( int h=1; h <=nsex; h++)
   {
    ralpha = ra(h) / rbeta(h);
    for ( int l = 1; l <= nclass+1; l++ )  x(l) = cumd_gamma(size_breaks(l) / rbeta(h), ralpha);
    rec_sdd(h) = first_difference(x);
    for (int l=nSizeClassRec(h)+1;l<=nclass;l++) rec_sdd(h,l) = 0;
    rec_sdd(h) /= sum(rec_sdd(h)); // Standardize so each row sums to 1.0
   }
   
// ============================================================================================================================================

  /**
   * @brief initialiaze populations numbers-at-length in syr
   * @author Steve Martell
   * @details This function initializes the populations numbers-at-length in the initial year of the model.
   *
   * Psuedocode: See note from Dave Fournier.
   *
   * For the initial numbers-at-length a vector of deviates is estimated, one for each size class, and have the option to initialize the model at unfished equilibrium, or some other steady state condition.
   *
   *  Dec 11, 2014. Martell & Ianelli at snowgoose.  We had a discussion regarding how to deal with the joint probability of molting and growing to a new size
   *  interval for a given length, and the probability of not molting.  We settled on using the size-tranistion matrix to represent this joint probability, where the diagonal of the matrix to represent the probability of surviving and molting to a new size interval. The upper diagonal of the size-transition matrix represent the probability of growing to size interval j' given size interval j.
   *
   *  Oldshell crabs are then the column vector of 1-molt_probabiltiy times the numbers-at-length, and the Newshell crabs is the column vector of molt_probability times the number-at-length.
   *
   *  Jan 1, 2015.  Changed how the equilibrium calculation is done. Use a numerical approach to solve the newshell oldshell initial abundance.
   *
   *  Jan 3, 2015.  Working with John Levitt on analytical solution instead of the numerical approach.  Think we have a soln.
   *
   *  Notation:
   *      n = vector of newshell crabs
   *      o = vector of oldshell crabs
   *      P = diagonal matrix of molting probabilities by size
   *      S = diagonal matrix of survival rates by size
   *      A = Size transition matrix.
   *      r = vector of new recruits (newshell)
   *      I = identity matrix.
   *
   *  The following equations represent the dynamics of newshell and oldshell crabs.
   *      n = nSPA + oSPA + r                     (1)
   *      o = oS(I-P)A + nS(I-P)A                 (2)
   *  Objective is to solve the above equations for n and o repsectively. Starting with o:
   *      o = n(I-P)S[I-(I-P)S]^(-1)              (3)
   *  next substitute (3) into (1) and solve for n
   *      n = nPSA + n(I-P)S[I-(I-P)S]^(-1)PSA + r
   *  let B = [I-(I-P)S]^(-1)
   *      n - nPSA - n(I-P)SBPSA = r
   *      n(I - PSA - (I-P)SBPSA) = r
   *  let C = (I - PSA - (I-P)SBPSA)
   *  then n = C^(-1) r                           (4)
   *
   *  April 28, 2015. There is no case here for initializing the model at unfished equilibrium conditions. Need to fix this for SRA purposes. SJDM.
   *
   * @param bInitializeUnfished
   * @param logR0
   * @param logRini
   * @param rec_sdd is the vector of recruitment size proportions. It has dimension (1,nclass)
   * @param M is a 3D array of the natural mortality. It has dimension (1,nsex,syr,nyrRetro,1,nclass)
   * @param S is a 5D array of the survival rate (where S=exp(-Z)). It has dimension (1,nsex,syr,nyrRetro,1,nseason,1,nclass,1,nclass)
   * @param d4_N is the numbers in each group (sex/maturity/shell), year, season and length. It has dimension (1,n_grp,syr,nyrRetro+1,1,nseason,1,nclass)
  **/
FUNCTION calc_initial_numbers_at_length
  dvariable log_initial_recruits, scale;

  // Reset the probability of molting to first year value
  ProbMolt.initialize();
  for (int h = 1; h <= nsex; h++ )
   for (int l=1;l<=nclass;l++)
    ProbMolt(h,l,l) = molt_probability(h,syr,l);

  // Initial recruitment
  switch( bInitializeUnfished )
   {
    case UNFISHEDEQN:                                      ///> Unfished conditions
      log_initial_recruits = logR0;
      break;
    case FISHEDEQN:                                        ///> Steady-state fished conditions
      log_initial_recruits = logRini;
      break;
    case FREEPARS:                                         //> Free parameters
      log_initial_recruits = logN0(1,1);
      break;
    case FREEPARSSCALED:                                   ///> Free parameters revised
      log_initial_recruits = logRini;
      break;
   }
  for ( int h = 1; h <= nsex; h++ )
   { recruits(h)(syr) = mfexp(log_initial_recruits); }
  totrecruits(syr) = float(nsex)*mfexp(log_initial_recruits);

  // Analytical equilibrium soln
  int ig;
  d4_N.initialize();
  dmatrix Id = identity_matrix(1,nclass);
  dvar_matrix  x(1,n_grp,1,nclass);
  dvar_vector  y(1,nclass);
  dvar_matrix  A(1,nclass,1,nclass);
  dvar_matrix _S(1,nclass,1,nclass);
  _S.initialize();

  Eqn_basis = CONSTANTREC;                                ///> Need to run brute force with constant recruitment
  switch( bInitializeUnfished )
   {
    case UNFISHEDEQN:                                     ///> Unfished conditions
     bSteadyState = UNFISHEDEQN;
     for (int k=1;k<=nfleet;k++) log_fimpbar(k) = -100;
     x = calc_brute_equilibrium(syr,syr,syr,syr,syr,syr,syr,syr,syr,syr,NyrEquil);
     for ( int ig = 1; ig <= n_grp; ig++ ) d4_N(ig)(syr)(1) = x(ig);
     break;
    case FISHEDEQN:                                       ///> Steady-state fished conditions
     bSteadyState = FISHEDEQN;
     for (int k=1;k<=nfleet;k++) log_fimpbar(k) = log(finit(k)+1.0e-10);
     x = calc_brute_equilibrium(syr,syr,syr,syr,syr,syr,syr,syr,syr,syr,NyrEquil);
     for ( int ig = 1; ig <= n_grp; ig++ ) d4_N(ig)(syr)(1) = x(ig);
     break;
    case FREEPARS:                                        ///> Free parameters
     // Single shell condition and sex
     for ( int h = 1; h <= nsex; h++ )
      for ( int m = 1; m <= nmature; m++ )
       for ( int o = 1; o <= nshell; o++ )
        {
         int ig = pntr_hmo(h,m,o);
         d4_N(ig)(syr)(1) = mfexp(logN0(ig));
        }
     break;
    case FREEPARSSCALED:                                 ///> Free parameters (revised)
     scale = sum(exp(logN0));
     for ( int h = 1; h <= nsex; h++ )
      for ( int m = 1; m <= nmature; m++ )
       for ( int o = 1; o <= nshell; o++ )
        {
         int ig = pntr_hmo(h,m,o);
         d4_N(ig)(syr)(1) = mfexp(log_initial_recruits+logN0(ig))/scale;
        }
     break;
   }

// --------------------------------------------------------------------------------------------------------------------------------------

  /**
   * @brief Update numbers-at-length
   * @author Team
   * @details Numbers at length are propagated each year for each sex based on the size transition matrix and a vector of size-specifc survival rates. 
   * This is for one season
   * The columns of the size-transition matrix are multiplied by the size-specific survival rate (a scalar). 
   * New recruits are added based on the estimated average recruitment and annual deviate, multiplied by a vector of size-proportions (rec_sdd).
   **/

FUNCTION void update_population_numbers_at_length_season(const int i, const int j, const int Case)
  int h,o,m,isizeTrans;

  dvar_vector rt(1,nclass);
  dvar_vector  x(1,nclass);
  dvar_vector  y(1,nclass);
  dvar_vector  z(1,nclass);
  dvar_vector  t1(1,nclass);
  dvar_vector  t2(1,nclass);
  dvar_matrix next(1,n_grp,1,nclass);

  // reset next
  next.initialize();
  
  // Loop over groupds
  for (int ig = 1; ig <= n_grp; ig++)
   {
   
    // Extract group
    h = isex(ig);
    isizeTrans  = isizeTrans_pass(h);
    m = imature(ig);
    o = ishell(ig);

    // Numbers-at-age for this group
    if (Case==1) x = d4_N(ig)(i)(j);
    if (Case==2) x = d4_N_init(ig,i,j);
    if (Case==3) x = numbers_proj_gytl(ig,i,j);
    if (Case==4) x = numbers_proj_gytl(ig,i,j);
    // Mortality (natural and fishing)
    if (Case==1) x = x * S(h,m)(i)(j);
    if (Case==2) x = x * SS_pass(h,m,j);
    if (Case==3) x = x * SS_pass(h,m,j);
    if (Case==4) x = x * SS_pass(h,m,j);
    
    // What to do next depends on which group (shell and maturity) we are in
    // ======================================================================
    
    // Case-A: one shell condition and one maturity state
    if (nshell == 1 && nmature == 1) 
     {
      // Molting and growth
      if (j == season_growth) {
       y = elem_prod(x, 1.0 - molt_prob_pass(h));                                        // did not molt, become oldshell
       x = elem_prod(x, molt_prob_pass(h)) * growth_transition(h,isizeTrans);            // molted and grew, stay newshell
       x = x + y;                                                                       // only one shell type so combine
       }
      // Recruitment
      if (j == season_recruitment) x += rec_pass(h);
      next(ig) += x;
      if (verbose==4 && i==syr) cout << "Case-A: one shell condition and one maturity state" << endl;
     } // nshell == 1 && nmature == 1


    //-------------------------------------------------------------------------------------------------------------------------------
    // Case-B && C: One shell condition, two maturity stages

    // Terminal molt does not impact imature animals
    if (nshell == 1 && nmature == 2 && m == IMMATURE) 
     { 
      // Molting and growth
      z.initialize();
//      This works
//      if (j == season_growth) {
//       z = elem_prod(x * growth_transition(h,isizeTrans), mature_prob_pass(h)) ; 		// molted to maturity
//       x = elem_prod(x * growth_transition(h,isizeTrans), 1.0 - mature_prob_pass(h)) ;     // molted, but immature
//       }
       // This does not work!
       if (j == season_growth) {
         y = elem_prod(x, 1.0 - molt_prob_pass(h));                                        // did not molt
         x = elem_prod(x, molt_prob_pass(h)) * growth_transition(h,isizeTrans);            // molted and grew
                                                                                             // only one shell type so combine
       
         z = elem_prod(x , mature_prob_pass(h)) ; 		                                // molted to maturity
         x = elem_prod(x , 1.0 - mature_prob_pass(h)) ;                                    // did not molt to maturity (and stayed immature)
         x = x + y;  
         }
      if (j == season_recruitment) x += rec_pass(h);
      next(ig-1) += z; next(ig) += x;
      if (Term_molt==0 && verbose==4 && i==syr) cout << "Case-B1: no terminal molt, one shell condition, and two maturity states; IMMATURE" << endl;
      if (Term_molt==1 && verbose==4 && i==syr) cout << "Case-C1: Terminal molt, one shell condition, and two maturity states; IMMATURE" << endl;
     } // Term_molt==0 or 1 &&  nshell == 1 && nmature == 2 && m == IMMATURE

    if (Term_molt==0 && nshell == 1 && nmature == 2 && m == MATURE) 
     {
      // Molting and growth
      if (j == season_growth) {
       y = elem_prod(x, 1.0 - molt_prob_pass(h));                                       // did not molt, become oldshell
       x = elem_prod(x, molt_prob_pass(h)) * growth_transition(h,isizeTrans);           // molted and grew, stay newshell
       x = x + y;                                                                       // only one shell type so combine
       }
      next(ig) += x;
      if (verbose==4 && i==syr) cout << "Case-B2: no terminal molt, one shell condition, and two maturity states; MATURE" << endl;
     } // Term_molt==0 && nshell == 1 && nmature == 2 && m == MATURE

    // Terminal molt: No molting, growth, or recruitment for mature animals if there is a terminal motl
    if (Term_molt==1 && nshell == 1 && nmature == 2 && m == MATURE) 
     {
      next(ig) += x;
      if (verbose==4 && i==syr) cout << "Case-C2: Terminal molt, one shell condition, and two maturity states; MATURE" << endl;
     } // Term-Molt == 1 && nshell == 1 && nmature == 2 && m == MATURE
         
    //-------------------------------------------------------------------------------------------------------------------------------
    // Case-D: No-terminal molt; two shell conditions, one maturity stage
    if (Term_molt==0 && nshell == 2  && nmature == 1 && o == NEW_SHELL) 
     {
      // Molting and growth
      if (j == season_growth){
       y = elem_prod(x, 1.0 - molt_prob_pass(h));                              // did not molt, become oldshell
       x = elem_prod(x, molt_prob_pass(h)) * growth_transition(h,isizeTrans);  // molted and grew, stay newshell
       }
      // Recruitment
      if (j == season_recruitment) x += rec_pass(h);
      next(ig) += x;
      if (verbose==4 && i==syr) cout << "Case-D1: No-terminal molt, two shell condition, and one maturity state; NEW_SHELL" << endl;
     } // Term_molt==0 && nshell == 0 && o == NEW_SHELL
         
    if (Term_molt==0 && nshell == 2  && nmature == 1 && o == OLD_SHELL) 
     {
      // Molting and growth
      z.initialize();
      if (j == season_growth) {
       z = elem_prod(x, molt_prob_pass(h)) * growth_transition(h,isizeTrans); // molted and grew, become newshell
       x = elem_prod(x, 1 - molt_prob_pass(h)) + y;                           // did not molt, remain oldshell and add the newshell that become oldshell
       }
      next(ig-1) += z; next(ig) += x;
      if (verbose==4 && i==syr) cout << "Case-D2: No-terminal molt, two shell condition, and one maturity state; OLD_SHELL" << endl;
     } // Term_molt==0 && nshell == 0 && o == OLD_SHELL

    //-------------------------------------------------------------------------------------------------------------------------------
    // Cases-E and F: Two shell conditions, two maturity stages
    if (verbose==4 && i==syr) cout << Term_molt << " " << j << " " << ig << " " << h << " " << o << " " << m << endl;
    if (nshell == 2 && nmature == 2 && o == NEW_SHELL && m == IMMATURE) 
     {
      // Molting and growth
      z.initialize();
      y.initialize();
       if (j == season_growth) {
         y = elem_prod(x, 1.0 - molt_prob_pass(h));                                                // did not molt (immature old shell)
         x = elem_prod(x, molt_prob_pass(h)) * growth_transition(h,isizeTrans);                    // molted and grew (new shell)
         z = elem_prod(x , mature_prob_pass(h)) ; 		                                        // molted to maturity (mature new shell)
         x = elem_prod(x , 1.0 - mature_prob_pass(h)) ;                                            // did not molt to maturity (immature new shell)
        if (Term_molt==0 && verbose==4 && i==syr) cout << "Case-E1: no terminal molt, two shell condition, and two maturity states; NEW_SHELL & IMMATURE " << ig << endl;
        if (Term_molt==1 && verbose==4 && i==syr) cout << "Case-F1: Terminal molt, two shell condition, and two maturity states; NEW_SHELL & IMMATURE " << ig << endl;
       }
      if (j == season_recruitment) x += rec_pass(h);
      next(ig-2) += z; next(ig) += x; next(ig+1) += y;
      }
    if (Term_molt==0 && nshell == 2 && nmature == 2 && o == NEW_SHELL && m == MATURE) 
     {
      // Molting and growth
      y.initialize();
       if (j == season_growth) {
         y = elem_prod(x, 1.0 - molt_prob_pass(h));                                                // did not molt (mature old shell)
         x = elem_prod(x, molt_prob_pass(h)) * growth_transition(h,isizeTrans);                    // molted and grew (mature new shell)
        if (Term_molt==0 && verbose==4 && i==syr) cout << "Case-E2: no terminal molt, two shell condition, and two maturity states; NEW_SHELL & MATURE " << ig << endl;
       }
      if (j == season_recruitment) x += rec_pass(h);
      next(ig) += x; next(ig+1) += y;
     }
    if (Term_molt==1 && nshell == 2 && nmature == 2 && o == NEW_SHELL && m == MATURE) 
     {
      // Only become oldshell
      y.initialize();
      if (j == season_growth) {
       y = x;
       x.initialize();
       if (Term_molt==1 && verbose==4 && i==syr) cout << "Case-F2: Terminal molt, two shell condition, and two maturity states; NEW_SHELL & MATURE " << ig << endl;
       }
      next(ig+1) += y;  next(ig) += x;
     }
    
    if (nshell == 2 && nmature == 2 && o == OLD_SHELL && m==IMMATURE) 
     {
      // Molting and growth
      z.initialize();
      y.initialize();
      if (j == season_growth) {
         y = elem_prod(x, 1.0 - molt_prob_pass(h));                                                // did not molt (immature old shell)
         x = elem_prod(x, molt_prob_pass(h)) * growth_transition(h,isizeTrans);                    // molted and grew (new shell)
         z = elem_prod(x , mature_prob_pass(h)) ; 		                                        // molted to maturity (mature new shell)
         x = elem_prod(x , 1.0 - mature_prob_pass(h)) ;                                            // did not molt to maturity (immature new shell)
         if (Term_molt==0 && verbose==4 && i==syr) cout << "Case-E3: no terminal molt, two shell condition, and two maturity states; OLD_SHELL & IMMATURE " << ig << endl;
         if (Term_molt==1 && verbose==4 && i==syr) cout << "Case-F3: Terminal molt, two shell condition, and two maturity states; OLD_SHELL & IMMATURE " << ig << endl;
       }
      next(ig-3) += z; next(ig-1) += x; next(ig) += y;
     }
     
    if (Term_molt==0 && nshell == 2 && nmature == 2 && o == OLD_SHELL && m==MATURE) 
     {
      // Molting and growth
      y.initialize();
      if (j == season_growth) {
         y = elem_prod(x, molt_prob_pass(h)) * growth_transition(h,isizeTrans);                    // molted and grew (mature new shell)
         x = elem_prod(x, 1.0 - molt_prob_pass(h));                                                // did not molt (mature old shell)
         if (verbose==4 && i==syr) cout << "Case-E4: No-terminal molt, two shell condition, and two maturity states; OLD_SHELL & MATURE " << ig << endl;
       }
      next(ig) += x; next(ig-1) += y;
     }
    
    if (Term_molt==1 && nshell == 2 && nmature == 2 && o == OLD_SHELL && m==MATURE) 
     {
      if (j == season_growth) {
       if (verbose==4 && i==syr) cout << "Case-F4: Terminal molt, rwo shell condition, and two maturity states; OLD_SHELL & MATURE " << ig << endl;
       }
      next(ig) += x;
     }
   
   } // grp

   // update the n-matrix
   if (Case==1) 
    for (int ig=1;ig<=n_grp;ig++)
    if (j == nseason)
     { d4_N(ig)(i+1)(1) = next(ig); }
     else 
     { d4_N(ig)(i)(j+1) = next(ig); }
   if (Case==2) 
    for (int ig=1;ig<=n_grp;ig++)
    if (j == nseason)
     { d4_N_init(ig)(i+1)(1) = next(ig); }
     else 
     { d4_N_init(ig)(i)(j+1) = next(ig); }
   if (Case==3 || Case==4) 
    for (int ig=1;ig<=n_grp;ig++)
    if (j == nseason)
     { numbers_proj_gytl(ig)(i+1)(1) = next(ig); }
     else 
     { numbers_proj_gytl(ig)(i)(j+1) = next(ig); }

// --------------------------------------------------------------------------------------------------------------------------------------

  /**
   * @brief Update numbers-at-length
   * @author Team
   * @details Projections for entire period
   *
   * @param bInitializeUnfished
   * @param logR0
   * @param logRbar
   * @param d4_N is the numbers in each group (sex/maturity/shell), year, season and length. It has dimension (1,n_grp,syr,nyrRetro+1,1,nseason,1,nclass)
   * @param recruits is the vector of average recruits each year. It has dimension (syr,nyrRetro)
   * @param rec_dev is an init_bounded_dev_vector of recruitment deviation parameters. It has dimension (syr+1,nyrRetro,-7.0,7.0,rdv_phz)
   * @param rec_sdd is the vector of recruitment size proportions. It has dimension (1,nclass)
  **/
FUNCTION update_population_numbers_at_length
  int isizeTrans;
  
  dmatrix Id = identity_matrix(1,nclass);
  dvar_vector rt(1,nclass);
  dvar_vector  x(1,nclass);
  dvar_vector  y(1,nclass);
  dvar_vector  z(1,nclass);

  // Specify recuitment by year
  for (int i = syr; i <= nyrRetro; i++ ){
   for (int h = 1; h <= nsex; h++ )
    {
     if ( bInitializeUnfished == UNFISHEDEQN )
      recruits(h,i) = mfexp(logR0)*float(nsex);
     else
      recruits(h,i) = mfexp(logRbar)*float(nsex);
     // This splits recruitment out proportionately into males and females
     totrecruits(i) = recruits(h)(i)*mfexp(rec_dev(i))/float(nsex);
     if (nsex == 1) recruits(h)(i) *= mfexp(rec_dev(i));
     if (nsex == 2 && h == MALES) recruits(h)(i) *= mfexp(rec_dev(i)) * 1.0 / (1.0 + mfexp(-logit_rec_prop(i)));
     if (h == FEMALES) recruits(h)(i) *= mfexp(rec_dev(i)) * (1.0 - 1.0 / (1.0 + mfexp(-logit_rec_prop(i))));
     }//--h
  }//--i

  // Now loop over year and season 
  for (int i = syr; i <= nyrRetro; i++)
   {
    // Pass the molt probabilities
    for (int h=1;h<=nsex;h++)
     {
      isizeTrans_pass(h) = iYrsIncChanges(h,i);
      rec_pass(h) = recruits(h,i) * rec_sdd(h);                                                ///> recruitment as a function of class 
      molt_prob_pass(h) = molt_probability(h,i);                                               ///> probability of molting
      for (int l=1;l<=nclass;l++)
      if (nmature==2) mature_prob_pass(h) = mature_probability(h,i);                           ///> probability of maturity
      }  
    // Now fo the year-update
    for (int j = 1; j <= nseason; j++) update_population_numbers_at_length_season(i,j,1);     ///> Update the sesonal-dynamics
   } //--i
   
// =================================================================================================================================================

  /**
   * @brief Calculate predicted catch observations
   * @details The function uses the Baranov catch equation to predict the retained and discarded catch.
   *
   * Assumptions:
   *  1) retained (landed catch) is assume to be newshell male only.
   *  2) discards are all females (new and old) and male only crab.
   *  3) Natural and fishing mortality occur simultaneously.
   *  4) discard is the total number of crab caught and discarded.
  **/
FUNCTION calc_predicted_catch
  int nhit;                                                          ///> number of values for computing q
  double cobs, effort;                                               ///> used when computing q
  dvariable tmp_ft,totalnalobs,totalnalpre;                          ///> temp variables
  dvar_vector sel(1,nclass);                                         ///> capture selectivity
  dvar_vector ret(1,nclass);                                         ///> retention ogive
  dvar_vector vul(1,nclass);                                         ///> overall vulnerability
  dvar_vector selret(1,nclass);                                      ///> product of selectivity and vulnerability
  dvar_vector nal(1,nclass);                                         ///> numbers or biomass at length.
  dvar_vector tempZ1(1,nclass);                                      ///> total mortality
  dvariable xi;                                                      ///> DIscard mortality

  // First need to calculate a catchability (q) for each catch data frame if there is any catch and effort (must be both)
  log_q_catch.initialize();
  for ( int kk = 1; kk <= nCatchDF; kk++ )
   {
    nhit = 0;
    for ( int jj = 1; jj <= nCatchRows(kk); jj++ )
     if (dCatchData(kk,jj,1) <= nyrRetro && dCatchData(kk,jj,1) >= syr)
      {
       cobs =   obs_catch(kk,jj);                                     ///> catch data
       effort = dCatchData(kk,jj,10);                                 ///> Effort data

       if (cobs > 0.0 && effort > 0.0)                                ///> There are catch and effort data
        {
         int i    =     dCatchData(kk,jj,1);                          ///> year index
         int j    =     dCatchData(kk,jj,2);                          ///> season index
         int k    =     dCatchData(kk,jj,3);                          ///> fleet/gear index
         int h    =     dCatchData(kk,jj,4);                          ///> sex index
         int type = int(dCatchData(kk,jj,7));                         ///> Type of catch (total= 0, retained = 1, discard = 2)
         int unit = int(dCatchData(kk,jj,8));                         ///> Units of catch equation (1 = biomass, 2 = numbers)
		 
         if ( h != UNDET_SEX )                                          ///> sex specific
          {
           log_q_catch(kk) += log(ft(k,h,i,j) / effort);
           nhit += 1;
          }
         else // sexes combinded
          {
           totalnalobs = 0; totalnalpre = 0;
           for ( h = 1; h <= nsex; h++ )
            {
             sel = log_slx_capture(k,h,i);                            ///> Capture seletiity
             switch( type )
              {
               case RETAINED: // retained catch
                sel = mfexp(sel + log_slx_retaind(k,h,i));
                break;
               case DISCARDED: // discarded catch
                sel = elem_prod(mfexp(sel), 1.0 - mfexp(log_slx_retaind(k,h,i)));
                break;
               case TOTALCATCH: // total catch
                sel = mfexp(sel);
                break;
               }
             nal.initialize();                                        ///> Compute numbers
             for ( int m = 1; m <= nmature; m++ )
              for ( int o = 1; o <= nshell; o++ )
               {
		        int ig = pntr_hmo(h,m,o); 
			    nal = d4_N(ig,i,j);
				nal = (unit == 1) ? elem_prod(nal, mean_wt(h,m,i)) : nal;
                tmp_ft = ft(k,h,i,j);

                if (season_type(j)==INSTANT_F) tempZ1 = Z2(h,m,i,j); else tempZ1 = Z(h,m,i,j);
				if (season_type(j)==INSTANT_F || season_type(j)==CONTINUOUS_F)
				{
					totalnalobs += nal * elem_div(elem_prod(tmp_ft * sel, 1.0 - mfexp(-tempZ1)), tempZ1);
					totalnalpre += nal * elem_div(elem_prod(effort * sel, 1.0 - mfexp(-tempZ1)), tempZ1);
				}
				if (season_type(j)==EXPLOIT_F)
				{
					totalnalobs += nal * tmp_ft * sel;
					totalnalpre += nal * effort * sel;
				}
			   }
			}
           log_q_catch(kk) += log(totalnalobs / totalnalpre);
           nhit += 1;
          } // h
        } // cobs
      } // jj
    if ( nhit > 0 ) log_q_catch(kk) /= nhit;
   }
   
  // Now make predictions
  res_catch.initialize();
  pre_catch.initialize();
  obs_catch_effort.initialize();
  for ( int kk = 1; kk <= nCatchDF; kk++ )
   {
    for ( int jj = 1; jj <= nCatchRows(kk); jj++ )
     if (dCatchData(kk,jj,1) <= nyrRetro && dCatchData(kk,jj,1) >= syr)
      {
       int i    =     dCatchData(kk,jj,1);                            ///> year index
       int j    =     dCatchData(kk,jj,2);                            ///> season index
       int k    =     dCatchData(kk,jj,3);                            ///> fleet/gear index
       int h    =     dCatchData(kk,jj,4);                            ///> sex index
       int type = int(dCatchData(kk,jj,7));                           ///> Type of catch (total= 0, retained = 1, discard = 2)
       int unit = int(dCatchData(kk,jj,8));                           ///> Units of catch equation (1 = biomass, 2 = numbers)
       effort   =     dCatchData(kk,jj,10);                           ///> Effort data
       cobs     =        obs_catch(kk,jj);                            ///> catch data

       if ( h!=UNDET_SEX ) // sex specific
        {
         sel = log_slx_capture(k,h,i);                                  ///> Capture selectivity
         //ret = log_slx_retaind(k,h,i);                                ///> Retention probability
         //dis = log_slx_discard(k,h,i);                                ///> Discard fraction
         switch ( type )
          {
           case RETAINED:                                             ///> retained catch
            sel = mfexp(sel + log_slx_retaind(k,h,i));
            break;
           case DISCARDED:                                            ///> discarded catch
            sel = elem_prod(mfexp(sel), 1.0 - mfexp(log_slx_retaind(k,h,i)));
            break;
           case TOTALCATCH:                                           ///> total catch
            sel = mfexp(sel);
            break;
          }
         // sum of nals
         nal.initialize();                                            ///> Computer numbers
         for ( int m = 1; m <= nmature; m++ )
          for ( int o = 1; o <= nshell; o++ )
           { 
	        int ig = pntr_hmo(h,m,o); 
			nal = d4_N(ig,i,j);
            nal = (unit == 1) ? elem_prod(nal, mean_wt(h,m,i)) : nal;
            if (season_type(j)==INSTANT_F) tempZ1 = Z2(h,m,i,j); else tempZ1 = Z(h,m,i,j);
 
			// predict catch
			tmp_ft = ft(k,h,i,j);                                       /// > Extract F
			if (season_type(j)==INSTANT_F || season_type(j)==CONTINUOUS_F)
			{
				pre_catch(kk,jj) += nal * elem_div(elem_prod(tmp_ft * sel, 1.0 - mfexp(-tempZ1)), tempZ1);
				if (cobs == 0 && effort > 0.0)
					obs_catch_effort(kk,jj) += nal * elem_div(elem_prod(mfexp(log_q_catch(kk)) * effort * sel, 1.0 - mfexp(-tempZ1)), tempZ1);
			}
			if (season_type(j)==EXPLOIT_F)
			{
				pre_catch(kk,jj) += nal * tmp_ft * sel;
				if (cobs == 0 && effort > 0.0)
					obs_catch_effort(kk,jj) += nal * mfexp(log_q_catch(kk)) * effort * sel;
			}
		   }
		}
       else  // sexes combined
        {
         for ( h = 1; h <= nsex; h++ )
          {
           sel = log_slx_capture(k)(h)(i);
           switch( type )
            {
             case RETAINED: // retained catch
              sel = mfexp(sel + log_slx_retaind(k,h,i));
              break;
             case DISCARDED: // discarded catch
              sel = elem_prod(mfexp(sel), 1.0 - mfexp(log_slx_retaind(k,h,i)));
              break;
             case TOTALCATCH: // total catch
              sel = mfexp(sel);
              break;
             }
           // sum of nals
           nal.initialize();
           for ( int m = 1; m <= nmature; m++ )
            for ( int o = 1; o <= nshell; o++ )
             { 
		      int ig = pntr_hmo(h,m,o);
			  nal = d4_N(ig,i,j);
              nal = (unit == 1) ? elem_prod(nal, mean_wt(h,m,i)) : nal;

			 tmp_ft = ft(k,h,i,j);                                      /// > Extract F
			 if (season_type(j)==INSTANT_F) tempZ1 = Z2(h,m,i,j); else tempZ1 = Z(h,m,i,j);
			 if (season_type(j)==INSTANT_F || season_type(j)==CONTINUOUS_F)
			 {
				pre_catch(kk,jj) += nal * elem_div(elem_prod(tmp_ft * sel, 1.0 - mfexp(-tempZ1)), tempZ1);
				if (cobs == 0 && effort > 0.0)
					obs_catch_effort(kk,jj) +=  nal * elem_div(elem_prod(mfexp(log_q_catch(kk)) * effort * sel, 1.0 - mfexp(-tempZ1)), tempZ1);
			 }
			 if (season_type(j)==EXPLOIT_F)
			 {
				pre_catch(kk,jj) += nal * tmp_ft * sel;
				if (cobs == 0 && effort > 0.0)
					obs_catch_effort(kk,jj) +=  nal * mfexp(log_q_catch(kk)) * effort * sel;
			 }
			}
		  }
		} // sex-specific
		
       // Catch residuals
       // In first case (obs_catch > 0) then if there is only catch data, calculate the residual as per usual; if there is catch and effort data, then still use observed catch to calculate the residual, despite the predicted catch being calculated differently.
       // In second case, when effort > 0 then the residual is the pred catch using Fs - pred catch using q
       if ( obs_catch(kk,jj) > 0.0 )
        {
         res_catch(kk,jj) = log(obs_catch(kk,jj)) - log(pre_catch(kk,jj));
        }
       else
        if (effort > 0.0)
         {
          res_catch(kk,jj) = log(obs_catch_effort(kk,jj)) - log(pre_catch(kk,jj));
         }
      } // lines of catch
   } // data block


   
  // Now make predictions of catch mortality
   histcat.initialize();
   for (int i=syr;i<=nyrRetro;i++)
   for ( int j = 1; j <= nseason; j++ )
    {
     for ( int m = 1; m <= nmature; m++ )
      for ( int h = 1; h <= nsex; h++ )
       {
        nal.initialize();
	 
        for ( int o = 1; o <= nshell; o++ )
         { int ig = pntr_hmo(h,m,o); nal += d4_N(ig,i,j); }
        nal = elem_prod(nal, mean_wt(h,m,i));
        for ( int k = 1; k <= nfleet; k++ )
         {
          sel.initialize(); ret.initialize(); vul.initialize();
          sel = mfexp(log_slx_capture(k,h,i))+1.0e-10;                          // Selectivity
          ret = mfexp(log_slx_retaind(k,h,i)) * slx_nret(nsex+h,k);             // Retention
          xi  = dmr(i,k);          
          vul = elem_prod(sel, ret + (1.0 - ret) * xi);                         // Vulnerability
          selret = elem_prod(sel,ret);
          tmp_ft = ft(k,h,i,j);
          if (season_type(j)==0) tempZ1 = Z(h,m,i,j); else tempZ1 = Z2(h,m,i,j);
          if (tmp_ft > 0)
	   {
            histcat(1,i) += nal * elem_div(elem_prod(tmp_ft * selret, 1.0 - mfexp(-tempZ1)), tempZ1);
            // Total dead
            histcat(2,i) += nal * elem_div(elem_prod(tmp_ft * vul, 1.0 - mfexp(-tempZ1)), tempZ1);
            // fleet-specific dead crab
            histcat(2+k,i) += nal * elem_div(elem_prod(tmp_ft * vul, 1.0 - mfexp(-tempZ1)), tempZ1);
	   } // -- tmp_ft
	 } // --k
       } // - m and h	 
   } // -- i and j
 
// ----------------------------------------------------------------------------------------------

  /**
   * @brief Calculate predicted catch for a combination of years
   * @author Andre Punt
   * @details The function uses the Baranov catch equation to predict the retained, discarded, or total catch
   * year i; season j; sex h; gear k; type (1=retained;2=discards;3=total); unit (1=mass;2=numbers)
  **/
FUNCTION dvariable calc_predicted_catch_det(const int i, const int j, const int h, const int k, const int type, const int unit)
 {
  dvariable tmp_ft,out;
  dvar_vector sel(1,nclass);                                         ///> capture selectivity
  dvar_vector nal(1,nclass);                                         ///> numbers or biomass at length.
  dvar_vector tempZ1(1,nclass);                                      ///> total mortality

  nal.initialize();
  sel = log_slx_capture(k,h,i);
  switch( type )
    {
     case RETAINED: // retained catch
      sel = mfexp(sel + log_slx_retaind(k,h,i));
      break;
     case DISCARDED: // discarded catch
      sel = elem_prod(mfexp(sel), 1.0 - mfexp(log_slx_retaind(k,h,i)));
      break;
     case TOTALCATCH: // total catch
      sel = mfexp(sel);
      break;
    }

  nal.initialize();
  out.initialize();
  for ( int m = 1; m <= nmature; m++ )
   for ( int o = 1; o <= nshell; o++ )
    { 
	int ig = pntr_hmo(h,m,o);
	nal = d4_N(ig,i,j);
	nal = (unit == 1) ? elem_prod(nal, mean_wt(h,m,i)) : nal;

	tmp_ft = ft(k,h,i,j);                                              /// > Extract F
	if (season_type(j) == INSTANT_F) tempZ1 = Z2(h,m,i,j); else tempZ1 = Z(h,m,i,j);
	if (season_type(j)==INSTANT_F || season_type(j)==CONTINUOUS_F)
	{
		out += nal * elem_div(elem_prod(tmp_ft * sel, 1.0 - mfexp(-tempZ1)), tempZ1);
	}
	if (season_type(j)==EXPLOIT_F)
	{
//		out = nal * tmp_ft * sel; // from Andre's Version
		out += nal * tmp_ft * sel;
	}
	} // end loop on nshell
  return(out);
 }

// ----------------------------------------------------------------------------------------------

  /**
   * @brief Calculate predicted catch for all years (not just data years)
   * @author D'Arcy N. Webber
   * @details The function uses the Baranov catch equation to predict the retained and discarded catch for all model years (not just those years for which we have observations). This is used for plotting purposes only.
  **/
FUNCTION calc_predicted_catch_out
  dvariable tmp_ft,out2;
  dvar_vector sel(1,nclass);                                         ///> capture selectivity
  dvar_vector nal(1,nclass);                                         ///> numbers or biomass at length.
  dvar_vector tempZ1(1,nclass);                                      ///> total mortality

  pre_catch_out.initialize();
  for ( int i = syr; i <= nyrRetro; i++ )
   {
    for ( int kk = 1; kk <= nCatchDF; kk++ )
     {
      int j    =     dCatchData_out(kk,i,2);                         ///> season index
      int k    =     dCatchData_out(kk,i,3);                         ///> fleet/gear index
      int h    =     dCatchData_out(kk,i,4);                         ///> sex index
      int type = int(dCatchData_out(kk,i,7));                        ///> Type of catch (total= 0, retained = 1, discard = 2)
      int unit = int(dCatchData_out(kk,i,8));                        ///> Units of catch equation (1 = biomass, 2 = numbers)

      if ( h != UNDET_SEX )                                            ///> sex specific
       {
        sel = log_slx_capture(k,h,i);
        switch ( type )
         {
          case RETAINED: // retained catch
           sel = mfexp(sel + log_slx_retaind(k,h,i));
           break;
          case DISCARDED: // discarded catch
           sel = elem_prod(mfexp(sel), 1.0 - mfexp(log_slx_retaind(k,h,i)));
           break;
          case TOTALCATCH: // total catch
           sel = mfexp(sel);
           break;
         }

        nal.initialize();
        for ( int m = 1; m <= nmature; m++ )
         for ( int o = 1; o <= nshell; o++ )
          { 
			int ig = pntr_hmo(h,m,o); 
			nal = d4_N(ig,i,j); 

			tmp_ft = ft(k,h,i,j);
			nal = (unit == 1) ? elem_prod(nal, mean_wt(h,m,i)) : nal;
			if (season_type(j)==INSTANT_F) tempZ1 = Z2(h,m,i,j); else tempZ1 = Z(h,m,i,j)+1.0e-10;
			if (season_type(j)==INSTANT_F || season_type(j)==CONTINUOUS_F)
			{
				pre_catch_out(kk,i) += nal * elem_div(elem_prod(tmp_ft * sel, 1.0 - mfexp(-tempZ1)), tempZ1);
			}
			if (season_type(j)==EXPLOIT_F)
			{
				pre_catch_out(kk,i) += nal * tmp_ft * sel;
			}
		}
       }
      else
       {
        // sexes combined
        out2 = 0;
        for ( int h = 1; h <= nsex; h++ )
         {
          sel = log_slx_capture(k)(h)(i);
          switch( type )
           {
            case RETAINED: // retained catch
             sel = mfexp(sel + log_slx_retaind(k)(h)(i));
             break;
            case DISCARDED: // discarded catch
             sel = elem_prod(mfexp(sel), 1.0 - mfexp(log_slx_retaind(k)(h)(i)));
             break;
            case TOTALCATCH: // total catch
             sel = mfexp(sel);
             break;
           }

          nal.initialize();
          for ( int m = 1; m <= nmature; m++ )
           for ( int o = 1; o <= nshell; o++ )
            {
				int ig = pntr_hmo(h,m,o);
				nal = d4_N(ig,i,j); 
				nal = (unit == 1) ? elem_prod(nal, mean_wt(h,m,i)) : nal;

				tmp_ft = ft(k,h,i,j);
				if (season_type(j)==INSTANT_F) tempZ1 = Z2(h,m,i,j); else tempZ1 = Z(h,m,i,j)+1.0e-10;
				if (season_type(j)==INSTANT_F || season_type(j)==CONTINUOUS_F)
				{
					pre_catch_out(kk,i) += nal * elem_div(elem_prod(tmp_ft * sel, 1.0 - mfexp(-tempZ1)), tempZ1);
				}
				if (season_type(j)==EXPLOIT_F)
				{
					pre_catch_out(kk,i) += nal * tmp_ft * sel;
				}
			}
          //out2 += calc_predicted_catch_det(i, j, h, k, type, unit);
         } // h
       } // sex
     } // kk
    } // i

  res_catch_out.initialize();
  for ( int kk = 1; kk <= nCatchDF; kk++ )
   for ( int i = syr; i <= nyrRetro; i++ )
    if ( obs_catch_out(kk,i) > 0.0 && pre_catch_out(kk,i) > 0.0 )
     res_catch_out(kk,i) = log(obs_catch_out(kk,i)) - log(pre_catch_out(kk,i));          ///> Catch residuals

// =================================================================================================================================================

  /**
   * @brief Calculate predicted relative abundance and residuals
   * @author Steve Martell, D'Arcy Webber
   *
   * @details This function uses the conditional mle for q to scale the population to the relative abundance index. 
   * Assumed errors in relative abundance are lognormal.  
   * Currently assumes that the CPUE index is made up of both retained and discarded crabs.
   *
   * Question regarding use of shell condition in the relative abundance index. 
   * Currently there is no shell condition information in the CPUE data, should there be? 
   * Similarly, there is no mature immature information, should there be?
   * 
  **/
FUNCTION calc_relative_abundance
  int unit;
  dvar_vector sel(1,nclass);                                         ///> capture selectivity
  dvar_vector ret(1,nclass);                                         ///> retention
  dvar_vector nal(1,nclass);                                         ///> numbers or biomass at length.
  dvar_vector tempZ1(1,nclass);                                      ///> total mortality
  dvar_vector V(1,nSurveyRows);                                      ///> Predicted survey index
   
  V.initialize();
  for ( int k = 1; k <= nSurveys; k++ ){
    for ( int jj = 1; jj <= nSurveyRows; jj++ ){
      if (dSurveyData(jj,0) == k) {
        if (((dSurveyData(jj,1) <= nyrRetro) || ((dSurveyData(jj,1) == nyrRetro+1) && (dSurveyData(jj,2) == 1))) && (dSurveyData(jj,1) >= syr)) {
          nal.initialize();
          int i = dSurveyData(jj,1);                                     ///> year index
          int j = dSurveyData(jj,2);                                     ///> season index
          int g = dSurveyData(jj,3);                                     ///> fleet/gear index
          int h1 = dSurveyData(jj,4);                                    ///> sex index
          int m1 = dSurveyData(jj,5);                                    ///> maturity index
          int unit = dSurveyData(jj,8);                                  ///> units 1 = biomass 2 = numbers

          if (nmature == 1) {
            //=========================================================================
            //==============Calculate index for NO TERMINAL MOLT cases=================
            //=========maturity state is summed over in index============
            if (m1 == 0){
              for (int h = 1; h <= nsex; h++ ){                               ///> Select sex
                if ((h==h1) || (h== UNDET_SEX)) {
                sel = mfexp(log_slx_capture(g)(h)(i));
                ret = mfexp(log_slx_retaind(g)(h)(i));
                for ( int m = 1; m <= nmature; m++ ){        //this doesn't really need to be here
                  for ( int o = 1; o <= nshell; o++ ) {
                    int ig = pntr_hmo(h,m,o);
                    nal += ( unit == 1 ) ? elem_prod(d4_N(ig,i,j), mean_wt(h,m,i)) : d4_N(ig,i,j);
                  }//--o loop
                }//--m loop
                // V(jj) = nal * sel;
                tempZ1.initialize();
                if (cpue_time(jj) > 0){
                  if (season_type(j)==INSTANT_F) 
                    tempZ1 = Z2(h,1,i,j)*cpue_time(jj); 
                  else 
                    tempZ1 = Z(h,1,i,j)*cpue_time(jj)+1.0e-10;
                }
                if (season_type(j)==INSTANT_F || season_type(j)==CONTINUOUS_F) {
                  if (SurveyType(k)==1) V(jj) = sum(elem_prod(elem_prod(nal,sel),mfexp(-tempZ1)));
                  if (SurveyType(k)==2) V(jj) = sum(elem_prod(elem_prod(elem_prod(nal,sel), ret),mfexp(-tempZ1)));
                }
                if (season_type(j)==EXPLOIT_F) {
                  if (SurveyType(k)==1) V(jj) = sum(elem_prod(elem_prod(nal,sel),mfexp(-tempZ1)));
                  if (SurveyType(k)==2) V(jj) = sum(elem_prod(elem_prod(elem_prod(nal,sel), ret),mfexp(-tempZ1)));
                  cout << "not coded yet" << endl; exit(1);
                }
                } /// end if(h==h1 || h== UNDET_SEX)
              }//--h loop
            }// m1==0


            if (m1 == 1){
              //=========index is only MATURE crab============
              //===this uses an input maturity at size vector 
              for (int h = 1; h <= nsex; h++ ){                             
                if ((h==h1) || (h== UNDET_SEX)) {
                  sel = mfexp(log_slx_capture(g)(h)(i));
                  ret = mfexp(log_slx_retaind(g)(h)(i));
                  for ( int m = 1; m <= nmature; m++ ){        //this doesn't really need to be here
                    for ( int o = 1; o <= nshell; o++ ){        //mature crab can be both old and new shell
                      int ig = pntr_hmo(h,m,o);
                      nal += ( unit == 1 ) ? elem_prod(maturity(h),elem_prod(d4_N(ig,i,j), mean_wt(h,m,i))) : elem_prod(d4_N(ig,i,j),maturity(h));
                    }//--o loop
                  }//--m loop
                  // V(jj) = nal * sel;
                  tempZ1.initialize();
                  if (cpue_time(jj) > 0){
                  if (season_type(j)==INSTANT_F) 
                    tempZ1 = Z2(h,1,i,j)*cpue_time(jj); 
                  else 
                    tempZ1 = Z(h,1,i,j)*cpue_time(jj)+1.0e-10;
                  }
                  if ((season_type(j)==INSTANT_F) || (season_type(j)==CONTINUOUS_F)){
                    if (SurveyType(k)==1) V(jj) = sum(elem_prod(elem_prod(nal,sel),mfexp(-tempZ1)));
                    if (SurveyType(k)==2) V(jj) = sum(elem_prod(elem_prod(elem_prod(nal,sel), ret),mfexp(-tempZ1)));
                  }
                  if (season_type(j)==EXPLOIT_F) {
                    if (SurveyType(k)==1) V(jj) = sum(elem_prod(elem_prod(nal,sel),mfexp(-tempZ1)));
                    if (SurveyType(k)==2) V(jj) = sum(elem_prod(elem_prod(elem_prod(nal,sel), ret),mfexp(-tempZ1)));
                    cout << "not coded yet" << endl; exit(1);
                  }
                } /// end if(h==h1 || h== UNDET_SEX)
              }//--h loop
            }// m1 == 1

            if(m1 ==2){
              //=========insert case for immature only crab...if anyone would actually do this============  
              cout<<"there is no case for immature indices currently"<<endl;
              exit(1);
            }        
          }// nmature == 1

          //==============================================================================
          if (nmature == 2) {
            //================calculate index for TERMINAL MOLT cases=======================
            if (m1 == 0){
              //=========maturity state is summed over in index============
              for (int h = 1; h <= nsex; h++ ){                               
                if ((h==h1) || (h== UNDET_SEX)) {
                  sel = mfexp(log_slx_capture(g)(h)(i));
                  ret = mfexp(log_slx_retaind(g)(h)(i));
                  for ( int m = 1; m <= nmature; m++ ){
                    for ( int o = 1; o <= nshell; o++ ) {
                      int ig = pntr_hmo(h,m,o);
                      nal += ( unit == 1 ) ? elem_prod(d4_N(ig,i,j), mean_wt(h,m,i)) : d4_N(ig,i,j);
                      }//--o loop
                  }//--m loop  
                  // V(jj) = nal * sel;
                  tempZ1.initialize();
                  if (cpue_time(jj) > 0){
                    if (season_type(j)==INSTANT_F) 
                      tempZ1 = Z2(h,1,i,j)*cpue_time(jj); 
                    else 
                      tempZ1 = Z(h,1,i,j)*cpue_time(jj)+1.0e-10;
                  }
                  if ((season_type(j)==INSTANT_F) || (season_type(j)==CONTINUOUS_F)) {
                    if (SurveyType(k)==1) V(jj) = sum(elem_prod(elem_prod(nal,sel),mfexp(-tempZ1)));
                    if (SurveyType(k)==2) V(jj) = sum(elem_prod(elem_prod(elem_prod(nal,sel), ret),mfexp(-tempZ1)));
                  }
                  if (season_type(j)==EXPLOIT_F) {
                    if (SurveyType(k)==1) V(jj) = sum(elem_prod(elem_prod(nal,sel),mfexp(-tempZ1)));
                    if (SurveyType(k)==2) V(jj) = sum(elem_prod(elem_prod(elem_prod(nal,sel), ret),mfexp(-tempZ1)));
                    cout << "not coded yet" << endl; exit(1);
                  }
                } /// end if(h==h1 || h== UNDET_SEX)
              }//--h loop
            }// m1==0

            if (m1 == 1) {
              //===only mature crab in index =================================
              //==this uses the separate arrays for immature and mature crab
              //==to calculate mature biomass--this is different than above
              for (int h = 1; h <= nsex; h++ ) {                               
                if ((h==h1) || (h== UNDET_SEX)) {
                  sel = mfexp(log_slx_capture(g)(h)(i));
                  ret = mfexp(log_slx_retaind(g)(h)(i));
                  for ( int m = 1; m <= 1; m++ ){
                    for ( int o = 1; o <= nshell; o++ ) {
                      int ig = pntr_hmo(h,m,o);
                      nal += ( unit == 1 ) ? elem_prod(d4_N(ig,i,j), mean_wt(h,m,i)) : d4_N(ig,i,j);
                    }//--o loop
                  }//--m loop
                  // V(jj) = nal * sel;
                  tempZ1.initialize();
                  if (cpue_time(jj) > 0){
                    if (season_type(j)==INSTANT_F) 
                     tempZ1 = Z2(h,1,i,j)*cpue_time(jj); 
                    else 
                     tempZ1 = Z(h,1,i,j)*cpue_time(jj)+1.0e-10;
                  }
                  if ((season_type(j)==INSTANT_F) || (season_type(j)==CONTINUOUS_F)) {
                    if (SurveyType(k)==1) V(jj) = sum(elem_prod(elem_prod(nal,sel),mfexp(-tempZ1)));
                    if (SurveyType(k)==2) V(jj) = sum(elem_prod(elem_prod(elem_prod(nal,sel), ret),mfexp(-tempZ1)));
                  }
                  if (season_type(j)==EXPLOIT_F) {
                    if (SurveyType(k)==1) V(jj) = sum(elem_prod(elem_prod(nal,sel),mfexp(-tempZ1)));
                    if (SurveyType(k)==2) V(jj) = sum(elem_prod(elem_prod(elem_prod(nal,sel), ret),mfexp(-tempZ1)));
                    cout << "not coded yet" << endl; exit(1);
                  }            
                } /// end if(h==h1 || h== UNDET_SEX)
              }//--h loop
            }// m1==1

            if (m1 ==2) {
              //=========insert case for immature only crab...if anyone would actually do this============  
              //cout<<"there is no case for immature indices currently"<<endl;
              //exit(1);
              //==this uses the separate arrays for immature and mature crab
              //==to calculate immature biomass--this is different than above
              for (int h = 1; h <= nsex; h++ ) {                               
                if ((h==h1) || (h== UNDET_SEX)) {
                  sel = mfexp(log_slx_capture(g)(h)(i));
                  ret = mfexp(log_slx_retaind(g)(h)(i));
                  for ( int m = 2; m <= 2; m++ ){
                    for ( int o = 1; o <= nshell; o++ ) {
                      int ig = pntr_hmo(h,m,o);
                      nal += ( unit == 1 ) ? elem_prod(d4_N(ig,i,j), mean_wt(h,m,i)) : d4_N(ig,i,j);
                    }//--o loop
                  }//--m loop
                  // V(jj) = nal * sel;
                  tempZ1.initialize();
                  if (cpue_time(jj) > 0){
                    if (season_type(j)==INSTANT_F) 
                     tempZ1 = Z2(h,1,i,j)*cpue_time(jj); 
                    else 
                     tempZ1 = Z(h,1,i,j)*cpue_time(jj)+1.0e-10;
                  }
                  if ((season_type(j)==INSTANT_F) || (season_type(j)==CONTINUOUS_F)) {
                    if (SurveyType(k)==1) V(jj) = sum(elem_prod(elem_prod(nal,sel),mfexp(-tempZ1)));
                    if (SurveyType(k)==2) V(jj) = sum(elem_prod(elem_prod(elem_prod(nal,sel), ret),mfexp(-tempZ1)));
                  }
                  if (season_type(j)==EXPLOIT_F) {
                    if (SurveyType(k)==1) V(jj) = sum(elem_prod(elem_prod(nal,sel),mfexp(-tempZ1)));
                    if (SurveyType(k)==2) V(jj) = sum(elem_prod(elem_prod(elem_prod(nal,sel), ret),mfexp(-tempZ1)));
                    cout << "not coded yet" << endl; exit(1);
                  }            
                } /// end if(h==h1 || h== UNDET_SEX)
              }//--h loop
            }// m1==2

          }// nmature==2

        }// ((dSurveyData(jj,1) <= nyrRetro) || ((dSurveyData(jj,1) == nyrRetro+1 && dSurveyData(jj,2) == 1))) && (dSurveyData(jj,1) >= syr)
      }// dSurveyData(jj,0) == k
    }//--jj loop

    // Do we need an analytical Q
    if (q_anal(k) == 1) {
      dvariable zt; dvariable ztot1; dvariable ztot2; dvariable cvobs2; dvariable cvadd2;
      ztot1 = 0;
      ztot2 = 0;
      if (prior_qtype(k)== LOGNORMAL_PRIOR) {
        ztot1 += log(prior_q_p1(k))/square(prior_q_p2(k)); ztot2 += 1.0/square(prior_q_p2(k));
      }      
      //cout << "QP  " << cvobs2 << " " << cvadd2 << " " << zt << " " << ztot1 << " " << ztot2 << endl;      
      
      for ( int jj = 1; jj <= nSurveyRows; jj++ ){
        if (dSurveyData(jj,0) == k){
         if (((dSurveyData(jj,1) <= nyrRetro) || ((dSurveyData(jj,1) == nyrRetro+1) && (dSurveyData(jj,2) == 1))) && (dSurveyData(jj,1) >= syr)) {
           zt = log(obs_cpue(jj)) - log(V(jj));
           int i = dSurveyData(jj,1);                                     ///> year index
           cvadd2 = log(1.0 + square(mfexp(AddVarQT(k,i))));
           cvobs2 = log(1.0 + square(cpue_cv(jj)))/ cpue_lambda(k);
           dvariable stdtmp = cvobs2 + cvadd2;
           ztot1 += zt/stdtmp; ztot2 += 1.0/stdtmp;
          }
        }// dSurveyData(jj,0) == k
       survey_q(k) = mfexp(ztot1/ztot2);
      }//--jj loop
    }// q_anal(k) == 1

    for ( int jj = 1; jj <= nSurveyRows; jj++ ){
      if (dSurveyData(jj,0) == k){
        if (((dSurveyData(jj,1) <= nyrRetro) || ((dSurveyData(jj,1) == nyrRetro+1) && (dSurveyData(jj,2) == 1))) && (dSurveyData(jj,1) >= syr)) {
          int i = dSurveyData(jj,1);                                     ///> year index
          pre_cpue(jj) = SurveyQT(k,i) * V(jj);
          res_cpue(jj) = log(obs_cpue(jj)) - log(pre_cpue(jj));
        }
      }// dSurveyData(jj,0) == k
    }//--jj loop

  } //--k loop

// =================================================================================================================================================
  /**
   * @brief Calculate predicted size composition data.
   *
   * @details Predicted size composition data are given in proportions.
   * Size composition strata:
   *  - sex  (0 = both sexes, 1 = male, 2 = female)
   *  - type (0 = all catch, 1 = retained, 2 = discard)
   *  - shell condition (0 = all, 1 = new shell, 2 = oldshell)
   *  - mature or immature (0 = both, 1 = immature, 2 = mature)
   *
   *  Jan 5, 2015.
   *  Size compostion data can come in a number of forms.
   *  Given sex, maturity and 3 shell conditions, there are 12 possible
   *  combinations for adding up the numbers at length (nal).
   *
   *                          Shell
   *    Sex     Maturity        condition   Description
   *    _____________________________________________________________
   *    Male    0               1           immature, new shell
   * !  Male    0               2           immature, old shell
   * !  Male    0               0           immature, new & old shell               1               Male, immature, new shell
   *    Male    1               1             mature, new shell
   *    Male    1               2             mature, old shell
   *    Male    1               0             mature, new & old shell
   *  Female    0               1           immature, new shell
   * !Female    0               2           immature, old shell
   * !Female    0               0           immature, new & old shell
   *  Female    1               1             mature, new shell
   *  Female    1               2             mature, old shell
   *  Female    1               0             mature, new & old shell
   *    _____________________________________________________________
   *
   *  Call function to get the appropriate numbers-at-length.
   *
   *  TODO:
   *  [ ] Add maturity component for data sets with mature old and mature new.
  **/
FUNCTION calc_predicted_composition
   dvar_vector dNtmp(1,nclass);                                      ///> temporary Ns
   dvar_vector nal(1,nclass);                                        ///> numbers or biomass at length.
   dvar_vector tempZ1(1,nclass);                                     ///> total mortality
   dvariable qmult;                                                  ///> Q multiplier for comps
   dvariable cumsum;                                                 ///> used for tail compression

   d3_pre_size_comps_in.initialize();
   d3_pre_size_comps.initialize();
   for ( int ii = 1; ii <= nSizeComps_in; ii++ )
    {
	 int nbins = nSizeCompCols_in(ii);
     for ( int jj = 1; jj <= nSizeCompRows_in(ii); jj++ )
      if ( (d3_SizeComps_in(ii,jj,-7) <= nyrRetro || (d3_SizeComps_in(ii,jj,-7) == nyrRetro+1 && d3_SizeComps_in(ii,jj,-6) == 1) ) && 
           d3_SizeComps_in(ii,jj,-7) >= syr)
       {
        dNtmp.initialize();
        int i       = d3_SizeComps_in(ii)(jj,-7);                     ///> year
        int j       = d3_SizeComps_in(ii)(jj,-6);                     ///> seas
        int k       = d3_SizeComps_in(ii)(jj,-5);                     ///> gear (a.k.a. fleet)
        int h       = d3_SizeComps_in(ii)(jj,-4);                     ///> sex
        int type    = d3_SizeComps_in(ii)(jj,-3);                     ///> retained or discard
        int shell   = d3_SizeComps_in(ii)(jj,-2);                     ///> shell condition
        int bmature = d3_SizeComps_in(ii)(jj,-1);                     ///> boolean for maturity

        if ( h != UNDET_SEX )                                           ///> sex specific
         {
          dvar_vector sel = mfexp(log_slx_capture(k,h,i));
          dvar_vector ret = mfexp(log_slx_retaind(k,h,i));
          dvar_vector dis = mfexp(log_slx_discard(k,h,i));

           // AEPCAL--check the maturity index for Z2 and Z1
		   
		   if (lf_catch_in(ii)==CATCH_COMP)
		   {
            // if (season_type(j) == INSTANT_F) tempZ1 = Z2(h,1,i,j); else tempZ1 = Z(h,1,i,j)+1.0e-10;
            // tempZ1 = elem_div(1.0 - mfexp(-tempZ1), tempZ1);
			if (season_type(j)==INSTANT_F) tempZ1 = Z2(h,1,i,j); else tempZ1 = Z(h,1,i,j)+1.0e-10;
			
            if (season_type(j)==INSTANT_F || season_type(j)==CONTINUOUS_F)
             {
              tempZ1 = elem_div(1.0 - mfexp(-tempZ1), tempZ1);
             }
            if (season_type(j)==EXPLOIT_F)
             {
              tempZ1 = elem_div(1.0 - mfexp(-tempZ1), tempZ1);
              cout << "not coded yet" << endl; exit(1);
             }
		   }
          if (lf_catch_in(ii)==SURVEY_COMP) for (int i=1;i<=nclass; i++) tempZ1(i) = 1;

          nal.initialize();                                           ///> Numbers by sex

		  // need cases for when maturity changes and when shell condition changes
		  if(nmature == 1)
		  {
		   for ( int m = 1; m <= nmature; m++ )
		    for ( int o = 1; o <= nshell; o++ )
            {
             int ig = pntr_hmo(h,m,o);
             if ( shell == 0 ) nal += d4_N(ig,i,j);
             if ( shell == o ) nal += d4_N(ig,i,j);
            }
		  }

		  if(nmature == 2)
		  {
		   for ( int m = 1; m <= nmature; m++ )
		    for ( int o = 1; o <= nshell; o++ )
            {
             int ig = pntr_hmo(h,m,o);
             if ( bmature == 0 ) nal += d4_N(ig,i,j);
             if ( bmature == m ) nal += d4_N(ig,i,j);
            }
		  }
	  
          switch ( type )
           {
            case RETAINED:                                            ///> retained
             dNtmp += elem_prod(elem_prod(nal, elem_prod(sel, ret)),tempZ1);
            break;
            case DISCARDED:                                           ///> discarded
             dNtmp += elem_prod(elem_prod(nal, elem_prod(sel, dis)),tempZ1);
            break;
            case TOTALCATCH:                                          ///> both retained and discarded
             dNtmp += elem_prod(elem_prod(nal, sel),tempZ1);
            break;
           }
         }
        else
         { // sexes combined in the observations
          for ( int h = 1; h <= nsex; h++ )
           {
            dvar_vector sel = mfexp(log_slx_capture(k,h,i));
            dvar_vector ret = mfexp(log_slx_retaind(k,h,i));
            dvar_vector dis = mfexp(log_slx_discard(k,h,i));
           // AEPCAL--check the maturity index
		  if (lf_catch_in(ii)==CATCH_COMP)
		   {
          // if (season_type(j) == INSTANT_F) tempZ1 = Z2(h,1,i,j); else tempZ1 = Z(h,1,i,j)+1.0e-10;
          // tempZ1 = elem_div(1.0 - mfexp(-tempZ1), tempZ1);
			if (season_type(j)==INSTANT_F) tempZ1 = Z2(h,1,i,j); else tempZ1 = Z(h,1,i,j)+1.0e-10;
			
            if (season_type(j)==INSTANT_F || season_type(j)==CONTINUOUS_F)
             {
              tempZ1 = elem_div(1.0 - mfexp(-tempZ1), tempZ1);
             }
            if (season_type(j)==EXPLOIT_F)
             {
              tempZ1 = elem_div(1.0 - mfexp(-tempZ1), tempZ1);
              cout << "not coded yet" << endl; exit(1);
             }
           }
    	  if (lf_catch_in(ii)==SURVEY_COMP) for (int i=1;i<=nclass; i++) tempZ1(i) = 1;

            nal.initialize();                                         ///> Numbers by sex
            for ( int m = 1; m <= nmature; m++ )
             for ( int o = 1; o <= nshell; o++ )
              {
               int ig = pntr_hmo(h,m,o);
               if ( shell == 0 ) nal += d4_N(ig,i,j);
               if ( shell == o ) nal += d4_N(ig,i,j);
              }
 
            switch ( type )
             {
           case RETAINED:                                            ///> retained
             dNtmp += elem_prod(elem_prod(nal, elem_prod(sel, ret)),tempZ1);
            break;
            case DISCARDED:                                           ///> discarded
             dNtmp += elem_prod(elem_prod(nal, elem_prod(sel, dis)),tempZ1);
            break;
            case TOTALCATCH:                                          ///> both retained and discarded
             dNtmp += elem_prod(elem_prod(nal, sel),tempZ1);
            break;
             }
           }
         }
        d3_pre_size_comps_in(ii)(jj)        = dNtmp(1,nbins);
        d3_pre_size_comps_in(ii)(jj)(nbins) = sum(dNtmp(nbins,nclass));
        // Now apply tail compression (perhaps)
        if (bTailCompression_in(ii) == 1)
         {
          //cout << "doing" << endl;
          cumsum = 0;
          for (int kk=1;kk<=tailcompind(ii,jj,1);kk++)
           {
            cumsum += d3_pre_size_comps_in(ii,jj,kk);
            d3_pre_size_comps_in(ii,jj,kk) = 0;
           }
          d3_pre_size_comps_in(ii,jj,tailcompind(ii,jj,1)) = cumsum;
          cumsum = 0;
          for (int kk=nbins;kk>=tailcompind(ii,jj,2);kk--)
           {
            cumsum += d3_pre_size_comps_in(ii,jj,kk);
            d3_pre_size_comps_in(ii,jj,kk) = 0;
           }
          d3_pre_size_comps_in(ii,jj,tailcompind(ii,jj,2)) = cumsum;
         }
        
	} // jj (years)
    } // ii (sizecomp)

   // This aggregates the size composition data by appending size compositions horizontally
   int oldk = 9999; int j; int i;
   for ( int kk = 1; kk <= nSizeComps_in; kk++ )
    {
     int k = iCompAggregator(kk);
     if ( oldk != k ) j = 0;
     oldk = k;
     for ( int jj = 1; jj <= nSizeCompCols_in(kk); jj++ )
      {
       j += 1;
       for ( int ii = 1; ii <= nSizeCompRows_in(kk); ii++ )
        {
         int iyr = d3_SizeComps_in(kk,ii,-7) ;
         if (iyr <= nyrRetro || (iyr == nyrRetro+1 && d3_SizeComps_in(kk,ii,-6) == 1) )
          { 
           i = ii; 
           qmult = 1;
           if (survey_for_q_in(kk) >0) qmult = SurveyQT(survey_for_q_in(kk),iyr);
           d3_pre_size_comps(k,i,j) = qmult*d3_pre_size_comps_in(kk,ii,jj); 
          } // iyr
        }
      }
    }
 
   // This normalizes all observations by row
   for ( int k = 1; k <= nSizeComps; k++ )
    for ( int i = 1; i <= nSizeCompRows(k); i++ )
     if (size_comp_year(k,i) <= nyrRetro || (size_comp_year(k,i) == nyrRetro+1 && size_comp_season(k,i) == 1) )
      d3_pre_size_comps(k,i) /= sum(d3_pre_size_comps(k,i));

  if (verbose >= 3) {
    ECHO(d3_pre_size_comps_in)
    ECHO(d3_pre_size_comps)
  }
    

// =================================================================================================================================================

  /**
   * @brief Calculate stock recruitment relationship.
   * @details  Assuming a Beverton-Holt relationship between the mature biomass (user defined) and the annual recruits.
   * Note that we derive so and bb in R = so MB / (1 + bb * Mb) from Ro and steepness (leading parameters defined in theta).
   *
   * NOTES: if nSRR_flag == 1 then use a Beverton-Holt model to compute the recruitment deviations for minimization.
  **/
FUNCTION calc_stock_recruitment_relationship
  dvariable so, bb;
  dvariable ro = mfexp(logR0);
  dvariable phiB;
  double lam;
  dvariable reck = 4.*steepness/(1.-steepness);
  dvar_matrix _A(1,nclass,1,nclass);
  dvar_matrix _S(1,nclass,1,nclass);

  if (nmature == 1)
   {

    // Reset the probability of molting to first year value
    ProbMolt.initialize();
    for (int h = 1; h <= nsex; h++ )
     for (int l=1;l<=nclass;l++)
      ProbMolt(h,l,l) = molt_probability(h,syr,l);

    // get unfished mature male biomass per recruit.
    phiB = 0.0;
    _A.initialize();
    _S.initialize();
    for( int h = 1; h <= nsex; h++ )
     {
      for ( int l = 1; l <= nclass; ++l )  _S(l,l) = mfexp(-M(h,1)(syr)(l));
      _A = growth_transition(h,1);
      dvar_vector x(1,nclass);
      dvar_vector y(1,nclass);

      h <= 1 ? lam = spr_lambda: lam = (1.0 - spr_lambda);

      // Single shell condition
      if ( nshell == 1 && nmature == 1 )
       {
        calc_equilibrium(x,_A,_S,rec_sdd(h));
        phiB += lam * x * elem_prod(mean_wt(h,nmature)(syr), maturity(h));
       }
      // Continuous molt (newshell/oldshell)
      if ( nshell == 2 && nmature == 1 )
       {
        calc_equilibrium(x,y,_A,_S,ProbMolt(h),rec_sdd(h));
        phiB += lam * x * elem_prod(mean_wt(h,nmature)(syr), maturity(h)) +  lam * y * elem_prod(mean_wt(h,nmature)(syr), maturity(h));
       }
      // Insert terminal molt case here

    }
    dvariable bo = ro * phiB;

    so = reck * ro / bo;
    bb = (reck - 1.0) / bo;
   } 

  dvar_vector ssb = calc_ssb().shift(syr+1);
  dvar_vector rhat = elem_div(so * ssb , 1.0 + bb* ssb);

  // residuals
  int byr = syr + 1;
  res_recruit.initialize();
  dvariable sigR = mfexp(logSigmaR);
  dvariable sig2R = 0.5 * sigR * sigR;
 
  switch ( nSRR_flag )
   {
    case 0: // NO SRR
	if ( bInitializeUnfished == UNFISHEDEQN )
	{
		res_recruit(syr) = log(totrecruits(syr)) - 1.0 * logR0 + sig2R*Rec_bias(syr);
		res_recruit(byr,nyrRetro) = log(totrecruits(byr,nyrRetro)) - (1.0-rho) * logR0 - rho * log(++totrecruits(byr-1,nyrRetro-1)) + sig2R*Rec_bias(byr);
	}
	if ( bInitializeUnfished != UNFISHEDEQN )
	{
		res_recruit(syr) = log(totrecruits(syr)) - 1.0 * logRbar + sig2R*Rec_bias(syr);
		res_recruit(byr,nyrRetro) = log(totrecruits(byr,nyrRetro)) - (1.0-rho) * logRbar - rho * log(++totrecruits(byr-1,nyrRetro-1)) + sig2R*Rec_bias(byr);
	}
     break;
    case 1: // SRR model
     res_recruit(byr,nyrRetro) = log(totrecruits(byr,nyrRetro)) - (1.0-rho) * log(rhat(byr,nyrRetro)) - rho * log(++totrecruits(byr-1,nyrRetro-1)) + sig2R*Rec_bias(byr);
     break;
   }

// --------------------------------------------------------------------------------------------------------------------------------------------

  /**
   * @brief Calculate prior pdf
   * @details Function to calculate prior pdf
   * @param pType the type of prior
   * @param theta the parameter
   * @param p1 the first prior parameter
   * @param p2 the second prior parameter
  **/
FUNCTION dvariable get_prior_pdf(const int &pType, const dvariable &_theta, const double &p1, const double &p2)
  {
   dvariable prior_pdf;
   switch(pType)
    {
      case UNIFORM_PRIOR: // uniform
       prior_pdf = dunif(_theta,p1,p2);
       break;
      case NORMAL_PRIOR: // normal
       prior_pdf = dnorm(_theta,p1,p2);
       break;
      case LOGNORMAL_PRIOR: // lognormal
       prior_pdf = dlnorm(_theta,log(p1),p2);
       break;
      case BETA_PRIOR: // beta
       prior_pdf = dbeta(_theta,p1,p2);
       break;
      case GAMMA_PRIOR: // gamma
       prior_pdf = dgamma(_theta,p1,p2);
       break;
    }
   return prior_pdf;
  }

// --------------------------------------------------------------------------------------------------------------------------------------------------

  /**
   * @brief Calculate prior density functions for leading parameters.
   * @details
   *  - case 0 is a uniform density between the lower and upper bounds.
   *  - case 1 is a normal density with mean = p1 and sd = p2
   *  - case 2 is a lognormal density with mean = log(p1) and sd = p2
   *  - case 3 is a beta density bounded between lb-ub with p1 and p2 as alpha & beta
   *  - case 4 is a gamma density with parameters p1 and p2.
   *
   *  TODO
   *  Make this a generic function.
   *  Agrs would be vector of parameters, and matrix of controls
   *  @param theta a vector of parameters
   *  @param C matrix of controls (priorType, p1, p2, lb, ub)
   *  @return vector of prior densities for each parameter
  **/
FUNCTION calc_prior_densities
  double p1,p2;
  double lb,ub;
  int iprior,itype;
  dvariable x;

  // Initialize
  priorDensity.initialize();
  if (verbose>10) ECHOSTR("starting calc_prior_densities")

  // Key parameter priors
  iprior = 1;
  for ( int i = 1; i <= ntheta; i++ )
   {
    if (verbose>10) echoinput << "looping over thetas. i = "<<i<<endl;
    if ( theta_phz(i) > 0 && theta_phz(i) <= current_phase() )
     {
      itype = prior_theta_type(i);
      p1 = prior_theta_p1(i);
      p2 = prior_theta_p2(i);
      dvariable x = theta(i);
      if ( itype == 3 )
       { lb = theta_lb(i); ub = theta_ub(i); x = (x - lb) / (ub - lb); }
      priorDensity(iprior) = get_prior_pdf(itype, x, p1, p2);
      iprior += 1;
     }
   }

  // Growth parameter priors
  for ( int i = 1; i <= n_Gpar; i++ )
   {
    if (verbose>10) echoinput << "looping over growth parameters. i = "<<i<<endl;
    if ( G_phz(i) > 0 && G_phz(i) <= current_phase() )
     {
      itype = int(prior_Gtype(i));
      p1 = prior_G_p1(i);
      p2 = prior_G_p2(i);
      dvariable x = G_pars_est(i);
      if ( itype == 3 )
       { lb = G_lb(i); ub = G_ub(i); x = (x - lb) / (ub - lb); }
      priorDensity(iprior) = get_prior_pdf(itype, x, p1, p2);
      iprior += 1;
    }
   }

  // Natural parameter priors
  for ( int i = 1; i <= n_Mpar; i++ )
   {
    if (verbose>10) echoinput << "looping over Ms. i = "<<i<<endl;
    if ( M_phz(i) > 0 && M_phz(i) <= current_phase() )
     {
      itype = prior_Mtype(i);
      p1 = prior_M_p1(i);
      p2 = prior_M_p2(i);
      dvariable x = M_pars_est(i);
      if ( itype == 3 )
       { lb = M_lb(i); ub = M_ub(i); x = (x - lb) / (ub - lb); }
      priorDensity(iprior) = get_prior_pdf(itype, x, p1, p2);
      iprior+=1;
     }
   } //-- i

  // Selectivity parameter priors
  for ( int i = 1; i <= n_Spar; i++ )
    {
    if (verbose>10) echoinput << "looping over selectivity parameters. i = "<<i<<endl;
     if ( S_phz(i) > 0 && S_phz(i) <= current_phase() )
      {
       itype = prior_Stype(i);
       p1 = prior_S_p1(i);
       p2 = prior_S_p2(i);
       dvariable x = S_pars_est(i);
       if (StoIG(i,3)==0) { p1 = exp(p1); p2=exp(p2); x = exp(x); }
       if ( itype == 3 )
        { lb = S_lb(i); ub = S_ub(i); x = (x - lb) / (ub - lb); }
       priorDensity(iprior) = get_prior_pdf(itype, x, p1, p2);
       iprior+=1;
      }
    }

  // No priors on fbar and foff
  for (int i=1; i<=nfleet; i++) if (f_phz(i) > 0 && f_phz(i) <= current_phase()) iprior += 1;
  for (int i=1; i<=nfleet; i++) if (f_phz(i) > 0 && f_phz(i) <= current_phase()) iprior += nFparams(i);
  for (int i=1; i<=nfleet; i++) if (foff_phz(i) > 0 && foff_phz(i) <= current_phase()) iprior += 1;
  for (int i=1; i<=nfleet; i++) if (foff_phz(i) > 0 && foff_phz(i) <= current_phase()) iprior += nYparams(i);

  // no priors on the recruitments (well apart from the later ones)
  if (rdv_phz > 0 && rdv_phz <= current_phase()) iprior += (rdv_eyr-rdv_syr+1);
  if (rec_prop_phz > 0 && rec_prop_phz <= current_phase()) iprior += (rdv_eyr-rdv_syr+1);

  // Effective sample sizes
  for (int i=1;i<=nSizeComps; i++) {
   if (verbose>10) echoinput << "looping over effective sample size parameters. i = "<<i<<endl;
   if (log_vn_phz(i) > 0 && log_vn_phz(i) <= current_phase()) 
    {
     itype = prior_log_vn_type(i);
     p1 = prior_log_vn_p1(i);
     p2 = prior_log_vn_p2(i);
     dvariable x = log_vn(i);
     if ( itype == 3 )
      { lb = log_vn_lb(i); ub = log_vn_ub(i); x = (x - lb) / (ub - lb); }
     priorDensity(iprior) = get_prior_pdf(itype, x, p1, p2);
     iprior+=1;
    }
  }
  // Catchability parameter priors
  for ( int i = 1; i <= n_qpar; i++ ){ //need to respect mirroring
   if (verbose>10) echoinput << "looping over catchability parameters. i = "<<i<<endl;
   if (q_phz(i) > 0 && q_phz(i) <= current_phase() )
    {
     itype = prior_qtype(i);
     p1 = prior_q_p1(i);
     p2 = prior_q_p2(i);
     dvariable x = survey_q(i);
     if ( itype == 3 )
      { lb = q_lb(i); ub = q_ub(i); x = (x - lb) / (ub - lb); }
     priorDensity(iprior) = get_prior_pdf(itype, x, p1, p2);
     if ( last_phase() )
      priorDensity(iprior) = priorDensity(iprior) ;
     else
      priorDensity(iprior) = 0.1 * priorDensity(iprior) ;
     iprior++;
    }
  }

  // Additional CV parameter priors
  for ( int i = 1; i <= n_addcv_par; i++ ){ //need to respect mirroring
   if (verbose>10) echoinput << "looping over thetas. i = "<<i<<endl;
   {
    if ( cv_phz(i) > 0 && cv_phz(i) <= current_phase() )
     {
      itype = prior_add_cv_type(i);
      p1 = prior_add_cv_p1(i);
      p2 = prior_add_cv_p2(i);
      if (AddcvType(i)==0) dvariable x = mfexp(log_add_cv(i));
      if (AddcvType(1)==0) dvariable x = log_add_cv(i);
      if ( itype == 3 )
       { lb = add_cv_lb(i); ub = add_cv_ub(i); x = (x - lb) / (ub - lb); }
      priorDensity(iprior) = get_prior_pdf(itype, x, p1, p2);
      iprior += 1;
     }
   }
  }
  if (verbose>10) echoinput << "finished calc_prior_densities"<<endl;

   
// -------------------------------------------------------------------------------------------------- 
// Label 401: catch_likelihood
FUNCTION catch_likelihood
 dvariable effort;
// dvariable pi;
//  pi = 3.14159265359;

  // 1) Likelihood of the catch data.
  res_catch.initialize();
  for ( int k = 1; k <= nCatchDF; k++ )
   {
    for ( int jj = 1; jj <= nCatchRows(k); jj++ )
     if (dCatchData(k,jj,1) <= nyrRetro && dCatchData(k,jj,1) >= syr)
      {
       effort =   dCatchData(k,jj,10);                                ///> Effort data
       // In first case (obs_catch > 0) then if there is only catch data, calculate the residual as per usual; if there is catch and effort data, then still use observed catch to calculate the residual, despite the predicted catch being calculated differently.
       // In second case, when effort > 0 then the residual is the pred catch using Fs - pred catch using q
       if ( obs_catch(k,jj) > 0.0 )
        {
         res_catch(k,jj) = log(obs_catch(k,jj)) - log(pre_catch(k,jj));
        }
       else
        if (effort > 0.0)
         {
          res_catch(k,jj) = log(obs_catch_effort(k,jj)) - log(pre_catch(k,jj));
         }
      }
     dvector catch_sd = sqrt(log(1.0 + square(catch_cv(k))));
     nloglike(1,k) += dnorm(res_catch(k), catch_sd);
//	 for ( int jj = 1; jj <= nCatchRows(k); jj++ )
//     if (dCatchData(k,jj,1) <= nyrRetro)
//      nloglike(1,k) += log(sqrt(2.0*pi)*catch_sd(jj)) + 0.5*square(res_catch(k,jj)/catch_sd(jj));
   }
  if ( verbose >= 3 ) cout << "Ok after catch likelihood ..." << endl;

// --------------------------------------------------------------------------------------------------
// Label 402: index_likelihood
FUNCTION index_likelihood
  dvariable cvobs2,cvadd2,pi;
  // 2) Likelihood of the relative abundance data.
  for ( int k = 1; k <= nSurveys; k++ )
   {
    for ( int jj = 1; jj <= nSurveyRows; jj++ )
     if (dSurveyData(jj,0) == k && (dSurveyData(jj,1) <= nyrRetro || (dSurveyData(jj,1) == nyrRetro+1 && dSurveyData(jj,2) == 1)) && 
         dSurveyData(jj,1) >= syr)
      {
       int i = dSurveyData(jj,1);
       cvadd2 = log(1.0 + square(mfexp(AddVarQT(k,i))));
       cvobs2 = log(1.0 + square(cpue_cv(jj)))/ cpue_lambda(k);
       dvariable stdtmp = sqrt(cvobs2 + cvadd2);
       res_cpue_stdzd(jj) = (res_cpue(jj) / stdtmp);
       nloglike(2,k) += log(stdtmp) + 0.5 * square(res_cpue(jj) / stdtmp);
      }
   }
  if ( verbose >= 3 ) cout << "Ok after survey index likelihood ..." << endl;

// --------------------------------------------------------------------------------------------------
// Label 403: length_likelihood
FUNCTION length_likelihood

  // 3) Likelihood for size composition data.
  if (verbose >= 3) ECHOSTR("Starting length-likelihood")
  d3_res_size_comps.initialize();
  for ( int ii = 1; ii <= nSizeComps; ii++ )
   {
    dmatrix O = d3_obs_size_comps(ii);                                                        ///> Observed length frequency
    dvar_matrix P = d3_pre_size_comps(ii);                                                    ///> Predicted length-frequency
    dvar_vector log_effn = log(mfexp(log_vn(ii)) * size_comp_sample_size(ii) * lf_lambda(ii));///> Effective sample size
    for (int jrow=1;jrow<=nSizeCompRows(ii);jrow++)
     {
      if (size_comp_year(ii,jrow) < syr) 
      { 
       for (int k=1;k<=nSizeCompCols(ii);k++)
         { O(jrow,k) = 1.0/float(nclass); P(jrow,k) = 1.0/float(nclass); }
       }
     } // -- jrow

    bool bCmp = 0;
    class acl::negativeLogLikelihood *ploglike;                                               ///> Negative log-likelihood

    switch ( iSizeCompType(ii) )                                                               ///> Select option for size-comp data
     {
      case 0:                                                                                 ///> ignore composition data in model fitting.
       ploglike = NULL;
       break;
      case 1:                                                                                 ///> multinomial with fixed or estimated n
       ploglike = new class acl::multinomial(O, bCmp);
       break;
      case 2:                                                                                 ///> robust approximation to the multinomial
       ploglike = new class acl::robust_multi(O, bCmp);
       break;
      case 5:                                                                                 ///> Dirichlet
       ploglike = new class acl::dirichlet(O, bCmp);
       break;
      case 6:                                                                                 ///> Dirichlet-multinomial with Thorson 2016 rec'd parameterization
       dvariable log_th = log_vn(ii);//--log-scale theta parameter
       dvector iss = size_comp_sample_size(ii) * lf_lambda(ii);
       ploglike = new class acl::dirichlet_alt(O, log_th, iss, bCmp);
       break;
     }

    if ( ploglike != NULL )                                                                   ///> extract the residuals
     d3_res_size_comps(ii) = ploglike->residual(log_effn, P);

    if ( ploglike != NULL )                                                                   ///> Compute the likelihood
     {
      dvariable nll = ploglike->nloglike(log_effn, P);
      nloglike(3,ii) += nll;
      if (verbose >= 3) ECHO(nll)
      delete ploglike;
     }
   }//--loop ii
  if ( verbose >= 3 ) cout << "Ok after composition likelihood ..." << endl;

// --------------------------------------------------------------------------------------------------
// Label 404: recruitment_likelihood
FUNCTION recruitment_likelihood

  // 4) Likelihood for recruitment deviations.
  dvariable sigR = mfexp(logSigmaR);
  nloglike(4,1) = dnorm(res_recruit, sigR);                          ///> Post first year devs
  switch ( nSRR_flag )
    {
     case 0:                                                         ///> Constant recruitment
      break;
     case 1:
        //nloglike(4,1) = dnorm(res_recruit, sigR);                  ///> Stock-recruitment relationship (not used)
      break;
    }
  if ( active(logit_rec_prop_est) )                                  ///> Sex-ratio devs
   nloglike(4,3) = dnorm(logit_rec_prop_est, 2.0);
  if ( verbose >= 3 ) cout << "Ok after recruitment likelihood ..." << endl;

// --------------------------------------------------------------------------------------------------
// Label 405: growth_likelihood
FUNCTION growth_likelihood
  dvariable Prob;
  dvar_matrix YY(1,nclass,1,nclass);

  //  5) Likelihood for the size-class change data #2
  if (GrowthObsType==GROWTHCLASS_DATA || GrowthObsType==GROWTHCLASS_VALS)
   {
    // First find all FullY matrices
    FullY.initialize();
    for (int h = 1; h <=nsex; h++)
	{
     for (int k = 1; k<=nSizeIncVaries(h);k++)
      {
        // AEP: Note that the molt_probability is based on syr  
        for (int ii=1;ii<=nclass;ii++)
         for (int jj=1;jj<=nclass;jj++)
          if (ii == jj)
           YY(ii,jj) = 1.0-molt_probability(h,syr,ii)+growth_transition(h,k,ii,jj)*molt_probability(h,syr,ii);
          else
           YY(ii,jj) = growth_transition(h,k,ii,jj)*molt_probability(h,syr,ii);
        FullY(h,k,1) = YY;
        for (int itime=2;itime<=MaxGrowTimeLibSex(h);itime++) FullY(h,k,itime) = FullY(h,k,itime-1)*YY;
      }
	}

    for (int i=1;i<=nGrowthObs;i++)
     {
      int h = iMoltIncSex(i);
      int k = iMoltTrans(i);
      int iclassRel = iMoltInitSizeClass(i);
      int iclassRec = iMoltEndSizeClass(i);
      int itimeLib = iMoltTimeAtLib(i);
      int ifleetRec = iMoltFleetRecap(i);
      int iyearRec = iMoltYearRecap(i);
      double freq = float(iMoltSampSize(i));
      Prob = FullY(h,k,itimeLib,iclassRel,iclassRec)*exp(log_slx_capture(ifleetRec,h,iyearRec,iclassRec))+1.0e-20;
      dvariable total = 0;
      for (int i=1;i<=nSizeSex(h);i++) total += FullY(h,k,itimeLib,iclassRel,i)*exp(log_slx_capture(ifleetRec,h,iyearRec,i));
      nloglike(5,h) -= log(Prob/total+0.00001)*freq;
     }
   } // Growth data
  if ( verbose >= 3 ) cout << "Ok after increment likelihood 2 ..." << endl;

  // 5) Likelihood for growth increment data #1
  if (bUseGrowthIncrementModel2(1)==LINEAR_GROWTHMODEL && bUseGrowthIncrementModel2(1)==PWRLAW_GROWTHMODEL && GrowthObsType==GROWTHINC_DATA)
    {
    // Predictions are for matrix 1
    dvar_vector MoltIncPred = calc_growth_increments_data(dPreMoltSize, iMoltIncSex,1);
    nloglike(5,1) = dnorm(log(dMoltInc) - log(MoltIncPred), dMoltIncCV);
   }
  if ( verbose >= 3 ) cout << "Ok after increment likelihood 1 ..." << endl;


// --------------------------------------------------------------------------------------------------
  /**
   * @brief calculate objective function
   * @details
   *
   * Likelihood components
   *  -# likelihood of the catch data (assume lognormal error)
   *  -# likelihood of relative abundance data
   *  -# likelihood of size composition data
   *
   * Penalty components
   *  -# Penalty on log_fdev to ensure they sum to zero.
   *  -# Penalty to regularize values of log_fbar.
   *  -# Penalty to constrain random walk in natural mortaliy rates
  **/
// Label 400: calc_objective_function
FUNCTION calc_objective_function
  // |---------------------------------------------------------------------------------|
  // | NEGATIVE LOGLIKELIHOOD COMPONENTS FOR THE OBJECTIVE FUNCTION                    |
  // |---------------------------------------------------------------------------------|
  dvariable w_nloglike;
  dvariable SumRecF, SumRecM;

  // Reset the likelihood
  nloglike.initialize();

  catch_likelihood();
  index_likelihood();
  length_likelihood();
  recruitment_likelihood();
  growth_likelihood();

  // |---------------------------------------------------------------------------------|
  // | PENALTIES AND CONSTRAINTS                                                       |
  // |---------------------------------------------------------------------------------|
  nlogPenalty.initialize();

  // 1) Penalty on log_fdev (male+combined; female) to ensure they sum to zero
  for ( int k = 1; k <= nfleet; k++ )
   {
    dvariable s     = mean(log_fdev(k));
    nlogPenalty(1) += Penalty_fdevs(k,1)*s*s;
    if (nsex > 1)
     {
      dvariable r     = mean(log_fdov(k));
      nlogPenalty(1) += Penalty_fdevs(k,2)*r*r;
     }
   }
   if (verbose >= 3) cout<<"finished penalties on log_fdev"<<endl;

  // 2) Penalty on mean F to regularize the solution.
  int irow = 1;
  if ( last_phase() ) irow = 2;
  dvariable fbar;
  dvariable ln_fbar;
  for ( int k = 1; k <= nfleet; k++ )
   for ( int j = 1; j <= nseason; j++ )
    {
     fbar = mean( trans(ft(k,1))(j) );
     if ( init_fbar(k) > 0 && fbar != 0 )
      {
       ln_fbar = log(fbar);
       nlogPenalty(2) += dnorm(ln_fbar, log(init_fbar(k)), pen_fstd(irow,k));
      }
     if (nsex==2)
      {
       fbar = mean( trans(ft(k,2))(j) );
       if ( fbar != 0 )
        {
         ln_fbar = log(fbar);
         nlogPenalty(2) += dnorm(ln_fbar, log_init_fbar_foff(k), pen_fstd(irow,k));
        }
      } 
    }
   
   if (verbose >= 3) cout<<"finished penalties on mean F"<<endl;

  // 5-6) Penalties on recruitment devs.
  //if ( !last_phase() )
   {
    if ( active(rec_dev_est) ) nlogPenalty(6) = dnorm(first_difference(rec_dev), 1.0);
   }
   if (verbose >= 3) cout<<"finished penalties on rec_devs"<<endl;

  // 7) Smoothness penalty on the recruitment devs
  if (nsex > 1) {
    SumRecF = 0; SumRecM = 0;
    for ( int i = syr; i <= nyrRetro; i++ )
     { SumRecF += recruits(2)(i); SumRecM += recruits(1)(i); }
    nlogPenalty(7) = square(log(SumRecF) - log(SumRecM));
  }
  if (verbose >= 3) cout<<"finished penalties on sex-specific recruitment"<<endl;

  // 8) Smoothness penalty on molting probability
  for (int h=1;h<=nsex;h++)
   if (bUseCustomMoltProbability2(h)==FREE_PROB_MOLT)
    for (int igrow=1;igrow<=nMoltVaries(h);igrow++)
     nlogPenalty(8) += dnorm(first_difference(molt_probability_in(1,igrow)), 1.0);  
  if (verbose >= 3) cout<<"finished Smoothness penalty on molting probability"<<endl;
   
  // 9) Smoothness penalty on selectivity patterns with class-specific coefficients
  nlogPenalty(9) = selex_smooth_pen;
  if (verbose >= 3) cout<<"Finished smoothness penalty on free selectivity"<<endl;

  // 10) Smoothness penalty on initial numbers at length
  for ( int k = 1; k <= n_grp; k++ ) 
   nlogPenalty(10) += dnorm(first_difference(logN0(k)), 1.0); 
  if (verbose >= 3) cout<<"Finished smoothness penalty on initial Ns"<<endl;

  // 11) Penalty on annual F-devs for males by fleet
  for ( int k = 1; k <= nfleet; k++ )
   nlogPenalty(11) += Penalty_fdevs(k,3)*sum(square(log_fdev(k)));
  if (verbose >= 3) cout<<"Finished smoothness penalty on annual devs"<<endl;

  // 12) Penalty on annual F-devs for females by fleet
  if (nsex > 1)
   for ( int k = 1; k <= nfleet; k++ )
    nlogPenalty(12) += Penalty_fdevs(k,4)*sum(square(log_fdov(k)));
  if (verbose >= 3) cout<<"Finished penalties on sex-specific devs"<<endl;
 
  // 13) Penality on deviation parameters
  nlogPenalty(13) = 0;
  if (n_deviations > 0)
   for (int is=1;is<=100;is++)
    if (devpoints(is,1)>0)
     {
      for (int ii=devpoints(is,3);ii<=devpoints(is,4);ii++) nlogPenalty(13) += dnorm(par_devs(ii),0.0,rdevpoints(is,1));
     }

  w_nloglike = sum(elem_prod(nloglike(1),catch_emphasis)) + sum(elem_prod(nloglike(2),cpue_emphasis)) + sum(elem_prod(nloglike(3),lf_emphasis));
  w_nloglike += sum(nloglike(4));
  w_nloglike += sum(nloglike(5))*tag_emphasis;

  objfun =  w_nloglike + sum(elem_prod(nlogPenalty,Penalty_emphasis))+ sum(priorDensity) + TempSS;

  // Summary tables
  if ( verbose >= 2 ) cout << "Priors: " << priorDensity << endl;
  if ( verbose >= 2 ) cout << "TempSS: " << TempSS << endl;
  if ( verbose >= 2 ) cout << "Penalties: " << nlogPenalty << endl;
  if ( verbose >= 2 ) cout << "Penalties: " << elem_prod(nlogPenalty,Penalty_emphasis) << " " << TempSS << endl;
  if ( verbose >= 2 ) cout << "Likelihoods: " << endl;
  if ( verbose >= 2 ) cout << nloglike << endl;

  if ( verbose >= 1 && !sd_phase()) cout  << "fn Call: " << current_phase() << " " << NfunCall << " " << objfun << " " << w_nloglike << " " << sum(elem_prod(nlogPenalty,Penalty_emphasis)) << " " << sum(priorDensity)+TempSS << endl;

// ==================================================================================================================================================
// === Main routines ended
// ==================================================================================================================================================
  /**
   * @brief Simulation model
   * @details Uses many of the same routines as the assessment model, over-writes the observed data in memory with simulated data.
  **/
FUNCTION simulation_model
  // random number generator
  random_number_generator rng(rseed);

  // Initialize model parameters
  initialize_model_parameters();

  // Fishing fleet dynamics ...
  calc_selectivities();
  calc_fishing_mortality();

  dvector drec_dev(syr+1,nyrRetro);
  drec_dev.fill_randn(rng);
  rec_dev = mfexp(logSigmaR) * drec_dev;

  // Population dynamics ...
  calc_growth_increments();
  calc_molting_probability();
  calc_mature_probability();
  calc_growth_transition();
  calc_natural_mortality();
  calc_total_mortality();
  calc_recruitment_size_distribution();
  calc_initial_numbers_at_length();
  update_population_numbers_at_length();

  // observation models ...
  calc_predicted_catch();
  calc_relative_abundance();
  calc_predicted_composition();

  // add observation errors to catch.
  dmatrix err_catch(1,nCatchDF,1,nCatchRows);
  err_catch.fill_randn(rng);
  dmatrix catch_sd(1,nCatchDF,1,nCatchRows);
  for ( int k = 1; k <= nCatchDF; k++ )
   {
    catch_sd(k)  = sqrt(log(1.0 + square(catch_cv(k))));
    obs_catch(k) = value(pre_catch(k));
    err_catch(k) = elem_prod(catch_sd(k), err_catch(k)) - 0.5*square(catch_sd(k));
    obs_catch(k) = elem_prod(obs_catch(k), mfexp(err_catch(k)));
    for ( int i = syr; i <= nyrRetro; i++ )
     for ( int ii = 1; ii <= nCatchRows(k); ii++ )
      {
       if ( dCatchData(k,ii,1) == dCatchData_out(k,i,1) ) // year index
        {
         obs_catch_out(k,i) = obs_catch(k,ii);
         dCatchData_out(k,i,5) = obs_catch(k,ii);
        }
       }
   }

  // add observation errors to cpue && fill in dSurveyData column 5
  dvector err_cpue(1,nSurveyRows);
  dvector cpue_sd_sim = sqrt(log(1.0 + square(cpue_cv))); // Note if this should include add_cv
  err_cpue.fill_randn(rng);
  obs_cpue = value(pre_cpue);
  err_cpue = elem_prod(cpue_sd_sim,err_cpue) - 0.5*square(cpue_sd_sim);
  obs_cpue = elem_prod(obs_cpue,mfexp(err_cpue));
  for ( int k = 1; k <= nSurveyRows; k++ )
   dSurveyData(k,6) = obs_cpue(k);

  // add sampling errors to size-composition.
  double tau;
  for ( int k = 1; k <= nSizeComps; k++ )
   for ( int i = 1; i <= nSizeCompRows(k); i++ )
    {
     tau = sqrt(1.0 / size_comp_sample_size(k)(i));
     dvector p = value(d3_pre_size_comps(k)(i));
     d3_obs_size_comps(k)(i) = rmvlogistic(p,tau,rseed+k+i);
    }

// ==========================================================================================================================================

  /**
   * @brief Calculate mature male biomass (MMB)
   * @details Calculation of the mature male biomass is based on the numbers-at-length summed over each shell condition.
   *
   * TODO: Add female component if lamda < 1
   *
   * @return dvar_vector ssb (model mature biomass).
  **/

FUNCTION dvar_vector calc_ssb()
  int ig,h,m,o;
  dvar_vector ssb(syr,nyrRetro);

  ssb.initialize();
  for ( int i = syr; i <= nyrRetro; i++ )
   for ( ig = 1; ig <= n_grp; ig++ )
    {
     h = isex(ig);
     o = ishell(ig);
     m = imature(ig);
     double lam;
     h <= 1 ? lam = spr_lambda : lam = (1.0 - spr_lambda);
     if(nmature==1)
      ssb(i) += lam * d4_N(ig)(i)(season_ssb) * elem_prod(mean_wt(h,m)(i), maturity(h));
     if(nmature==2 && use_func_mat==0)
      if(m==MATURE)
       ssb(i) += lam * d4_N(ig)(i)(season_ssb) * mean_wt(h,m)(i);
     if(nmature==2 && use_func_mat==1)
      if(m==MATURE)
        ssb(i) += lam * d4_N(ig)(i)(season_ssb) * elem_prod(mean_wt(h,m)(i), maturity(h));
    }
  return(ssb);

// ==========================================================================================================================================

  /**
   * @brief Calculate mature male abundance (MMA)
   * @details Calculation of the mature male abundance is based on the numbers-at-length summed over each shell condition.
   *
   * TODO: Add female component if lamda < 1
   *
   * @return dvar_vector ssb (model mature biomass).
  **/

FUNCTION dvar_vector calc_ssba()
  int ig,h,m,o;
  dvar_vector ssba(syr,nyrRetro);

  ssba.initialize();
  for ( int i = syr; i <= nyrRetro; i++ )
   for ( ig = 1; ig <= n_grp; ig++ )
    {
     h = isex(ig);
     o = ishell(ig);
     m = imature(ig);
     double lam;
     h <= 1 ? lam = spr_lambda : lam = (1.0 - spr_lambda);
     if(nmature==1)
      ssba(i) += lam * sum(elem_prod(d4_N(ig)(i)(season_ssb), maturity(h)));
     if(nmature==2 && use_func_mat==0)
      if(m==MATURE)
       ssba(i) += lam * sum(d4_N(ig)(i)(season_ssb));
     if(nmature==2 && use_func_mat==1)
      if(m==MATURE)
       ssba(i) += lam * sum(elem_prod(d4_N(ig)(i)(season_ssb), maturity(h)));
    }
  return(ssba);

// ======================================================================================================================================

  // Andre

  /**
   * @brief Calculate equilibrium initial conditions
   *
   * @return dvar_matrix
  **/
// Label 501: calc_brute_equilibrium
FUNCTION dvar_matrix calc_brute_equilibrium(const int YrRefSexR1, const int YrRefSexR2, const int YrRef, const int YrRefGrow, 
											const int YrRefM1, const int YrRefM2, const int YrRefSea1, const int YrRefSea2,
											const int YrRefSel1, const int YrRefSel2, const int ninit)
  int isizeTrans;
  double xi;                                                               ///> discard mortality rate
  dvariable log_ftmp;
  dvariable ssb_use;
  dvariable TotalRec;
  dvariable TotalSex1,TotalAll,SexRatio;                                   ///> used to compute the sex ratio for future recruitment
  dvar_matrix rtt(1,nsex,1,nclass);                                        ///> constant recruitment
  dvar3_array d4_Npass(1,n_grp,1,nseason,1,nclass);                        ///> Use to compute reference points
  dvar_matrix equilibrium_numbers(1,n_grp,1,nclass);                       ///> Final numbers-at-size
  dvar_vector x(1,nclass);                                                 ///> Temp vector for numbers
  dvar_vector y(1,nclass);                                                 ///> Temp vector for numbers
  dvar_vector z(1,nclass);                                                 ///> Temp vector for numbers
  dvar3_array _ft(1,nfleet,1,nsex,1,nseason);                              ///> Fishing mortality by gear (fleet)
  dvar3_array FF1(1,nsex,1,nseason,1,nclass);                              ///> Fishing mortality (continuous)
  dvar3_array FF2(1,nsex,1,nseason,1,nclass);                              ///> Fishing mortality (instantaneous)
  dvar4_array ZZ1(1,nsex,1,nmature,1,nseason,1,nclass);                              ///> Total mortality (continuous)
  dvar4_array ZZ2(1,nsex,1,nmature,1,nseason,1,nclass);                              ///> Total mortality (instananeous)

  dvar_vector ssb_prj(syr,nyr+ninit);                                      ///> projected spawning biomass
  dvar_vector hist_ssb(syr,nyrRetro);                                      ///> Historical SSB
  dvar_vector Rec_use(1,nsex);                                             ///> Recruitment
  dvar_vector sel(1,nclass);                                               ///> Capture selectivity
  dvar_vector sel1(1,nclass);                                              ///> Capture selectivity
  dvar_vector selret(1,nclass);                                            ///> Selectivity x retained
  dvar_vector ret(1,nclass);                                               ///> Retained probability
  dvar_vector ret1(1,nclass);                                              ///> Retained probability
  dvar_vector vul(1,nclass);                                               ///> Total vulnerability
  dvar_vector nal(1,nclass);                                               ///> Numbers-at-length
  dvar_vector Mbar(1,nclass);                                              ///> Natural mortality
  dvariable Mprop;                                                         ///> Season before removals
  dvar_vector tempZ1(1,nclass);                                            ///> Total mortality
  dvar_vector out(1,2+nfleet);

  // Initialize
  d4_N_init.initialize();

  // copy SSB into projection SSB
  hist_ssb = calc_ssb();
  ssb_prj.initialize();
  for (int i = syr; i<=nyrRetro;i++) ssb_prj(i) = hist_ssb(i);

  // set the molt probability (depends on first vs last year)
  //for (int h = 1; h <= nsex; h++ )
  // for (int l=1;l<=nclass;l++)
  //  molt_prob_pass(h,l) = molt_probability(h,YrRefGrow,l);

  // Initialize the Fs
  FF1.initialize();
  for ( int h = 1; h <= nsex; h++ )
   for ( int j = 1; j <= nseason; j++ )
    for ( int l = 1; l <= nclass; l++)
     FF2(h,j,l) = 1.0e-10;

  // compute the F matrix
  for ( int k = 1; k <= nfleet; k++ )
   for ( int h = 1; h <= nsex; h++ )
    for ( int j = 1; j <= nseason; j++ )
     if ( fhit(YrRef,j,k) )
      {
       log_ftmp = log_fimpbar(k);
       if (h==2) log_ftmp += log_foff(k);
       _ft(k,h,j) = mfexp(log_ftmp);
       
       // Discard mortality rate
       sel.initialize(); ret.initialize(); vul.initialize();
       for (int iy=YrRefSel1; iy<=YrRefSel2;iy++)
        {
         sel1 = mfexp(log_slx_capture(k,h,iy))+1.0e-10;                          // Selectivity
         ret1 = mfexp(log_slx_retaind(k,h,iy)) * slx_nret(nsex+h,k);             // Retention
         xi  = dmr(iy,k);          
         sel += sel1;                                                            // Selectivity
         ret += ret1;                                                            // Retention
         vul += elem_prod(sel1, ret1 + (1.0 - ret1) * xi);                       // Vulnerability
        }
       sel /= float(YrRefSel2-YrRefSel1+1);
       ret /= float(YrRefSel2-YrRefSel1+1);
       vul /= float(YrRefSel2-YrRefSel1+1);
       FF1(h,j) += _ft(k,h,j) * vul;
       FF2(h,j) += _ft(k,h,j) * sel;
     }
  // computer the total mortality
  ZZ1.initialize(); ZZ2.initialize(); SS_pass.initialize();
  
  for(int m = 1; m <=nmature;m++)
  for ( int h = 1; h <= nsex; h++ )
   for ( int j = 1; j <= nseason; j++ )
    {
     Mbar.initialize();
     for (int iy=YrRefM1; iy<=YrRefM2;iy++) Mbar += M(h,m,iy);
     Mbar /= float(YrRefM2-YrRefM1+1);
     Mprop = 0;
     for (int iy=YrRefSea1; iy<=YrRefSea2;iy++) Mprop += m_prop(iy,j);
     Mprop /= float(YrRefSea2-YrRefSea1+1);
     ZZ1(h,m,j) = Mprop * Mbar + FF1(h,j);
     ZZ2(h,m,j) = Mprop * Mbar + FF2(h,j);
     if (season_type(j) == 0) for ( int l = 1; l <= nclass; l++ ) SS_pass(h,m,j)(l,l) = 1.0-ZZ1(h,m,j,l)/ZZ2(h,m,j,l)*(1.0-mfexp(-ZZ2(h,m,j,l)));
     if (season_type(j) == 1) for ( int l = 1; l <= nclass; l++ ) SS_pass(h,m,j)(l,l) = mfexp(-ZZ1(h,m,j,l));
    }
	
  // recruitment distribution
  if (nsex>1)
   {
    TotalSex1 = 0; TotalAll = 0;
    for (int i=YrRefSexR1;i<=YrRefSexR2;i++)
     {
      TotalSex1 += 1 / (1 + mfexp(-logit_rec_prop(i)));
      TotalAll += 1;
     }
    SexRatio = TotalSex1/TotalAll;
    spr_sexr = SexRatio;
	
    // Reset
    switch( bSteadyState )
     {
      case UNFISHEDEQN: // Unfished conditions
       rtt(1) = mfexp(logR0) * SexRatio * rec_sdd(1);
       rtt(2) = mfexp(logR0) * (1 - SexRatio) * rec_sdd(2);
       break;
      case FISHEDEQN: // Steady-state fished conditions
       rtt(1) = mfexp(logRini) * SexRatio * rec_sdd(1);
       rtt(2) = mfexp(logRini) * (1 - SexRatio) * rec_sdd(2);
       break;
      case FREEPARS: // Free parameters
       rtt(1) = mfexp(logRbar) * SexRatio * rec_sdd(1);
       rtt(2) = mfexp(logRbar) * (1 - SexRatio) * rec_sdd(2);
       break;
      case FREEPARSSCALED: // Free parameters (revised)
       rtt(1) = mfexp(logRbar) * SexRatio * rec_sdd(1);
       rtt(2) = mfexp(logRbar) * (1 - SexRatio) * rec_sdd(2);
       break;
      case REFPOINTS: // Reference points
       rtt(1) = spr_rbar(1) * rec_sdd(1);
       rtt(2) = spr_rbar(2) * rec_sdd(2);
       break;
     }
   }
  else
   {
    spr_sexr = 1;
    switch( bSteadyState )
     {
      case UNFISHEDEQN: // Unfished conditions
       rtt(1) = mfexp(logR0) * rec_sdd(1);
       break;
      case FISHEDEQN: // Steady-state fished conditions
       rtt(1) = mfexp(logRini) * rec_sdd(1);
       break;
      case FREEPARS: // Free parameters
       rtt(1) = mfexp(logRbar) * rec_sdd(1);
       break;
      case FREEPARSSCALED: // Free parameters (revised)
       rtt(1) = mfexp(logRbar) * rec_sdd(1);
       break;
      case REFPOINTS: // Reference points
       rtt(1) = spr_rbar(1) * rec_sdd(1);
       break;
     }
   }

 // Pass the molt probabilities
 for (int h=1;h<=nsex;h++)
  {
   isizeTrans_pass(h) = iYrsIncChanges(h,YrRefGrow);
   molt_prob_pass(h) = molt_probability(h,YrRefGrow);                              ///> probability of molting
   if (nmature==2) mature_prob_pass(h) = mature_probability(h,YrRefGrow);          ///> probability of maturity
  } //-- j  


  // Now project to find the equilibrium
  for ( int i = 1; i < ninit; i++ )
   {
    // Recruitment
    if (Eqn_basis != CONSTANTREC)
     {
      if (Stock_rec_prj==RICKER)
       {
        ssb_use = ssb_prj(nyrRetro+i-Age_at_rec_prj);
        TotalRec = SR_alpha_prj*ssb_use*exp(-1*SR_beta_prj*ssb_use);
        if (nsex>1)
         {
	  if(BRP_rec_sexR == 0)
	   {
	    rtt(1) = TotalRec * 1 / (1 + mfexp(-logit_rec_prop(YrRef))) * rec_sdd(1);
	    rtt(2) = TotalRec * (1 - 1 / (1 + mfexp(-logit_rec_prop(YrRef)))) * rec_sdd(2);
	   }
	  else
	   {
	    rtt(1) = TotalRec * SexRatio * rec_sdd(1);
	    rtt(2) = TotalRec * (1 - SexRatio) * rec_sdd(2);
	   }
         }
        else
         rtt(1) = TotalRec * rec_sdd(1);
       }
      if (Stock_rec_prj==BEVHOLT)
       {
        ssb_use = ssb_prj(nyrRetro+i-Age_at_rec_prj);
        TotalRec = SR_alpha_prj*ssb_use/(SR_beta_prj+ssb_use);
        if (nsex>1)
         {
          if(BRP_rec_sexR == 0)
	   {
            rtt(1) = TotalRec * 1 / (1 + mfexp(-logit_rec_prop(YrRef))) * rec_sdd(1);
	    rtt(2) = TotalRec * (1 - 1 / (1 + mfexp(-logit_rec_prop(YrRef)))) * rec_sdd(2);
	   }
	  else
	   {
            rtt(1) = TotalRec * SexRatio * rec_sdd(1);
	    rtt(2) = TotalRec * (1 - SexRatio) * rec_sdd(2);
	   }
         }
        else
         rtt(1) = TotalRec * rec_sdd(1);
       }
     }
  
    // Projections for Case 2
    // Pass the molt probabilities
    for (int h=1;h<=nsex;h++) rec_pass(h) = rtt(h);                                                           ///> recruitment as a function of class 
    // Now fo the year-update
    for (int j = 1; j <= nseason; j++) update_population_numbers_at_length_season(i,j,2);                     ///> Update the seasonal-dynamics
     
    // Project SSB
    for ( int ig = 1; ig <= n_grp; ig++ )
     {
      int h = isex(ig);
      int o = ishell(ig);
      int m = imature(ig);
      double lam;
      h <= 1 ? lam = spr_lambda: lam = (1.0 - spr_lambda);
     if (nmature ==1)
      ssb_prj(nyrRetro+i) += lam * d4_N_init(ig)(i)(season_ssb) * elem_prod(mean_wt(h,m,YrRefGrow), maturity(h));
      if(nmature ==2 && use_func_mat==0)
    	if (m==1)
    	 {
         ssb_prj(nyrRetro+i) += lam * d4_N_init(ig)(i)(season_ssb) * mean_wt(h,m,YrRef);
    	  }
    	if (nmature ==2 && use_func_mat==1)
    	 if(m==1)
    	  {
          ssb_prj(nyrRetro+i) += lam * d4_N_init(ig)(i)(season_ssb) * elem_prod(mean_wt(h,m,YrRefGrow), maturity(h));
         }
      } //--ig

   } //--i

  // Extract the equilibrium numbers (for return)
  for ( int ig = 1; ig <= n_grp; ig++ ) equilibrium_numbers(ig) = d4_N_init(ig)(ninit)(1);

  // ssb to reurn
  ssb_pass = ssb_prj(nyrRetro+ninit-1);

  // Projected catches
  for ( int j = 1; j <= nseason; j++ )
   for ( int ig = 1; ig <= n_grp; ig++ )
    d4_Npass(ig,j) = d4_N_init(ig)(ninit-1)(j);
  out = calc_predicted_project(nyrRetro, YrRefGrow, YrRefSel1, YrRefSel2, d4_Npass, _ft, ZZ1, ZZ2);
  oflret_pass = out(1); ofltot_pass = out(2);
  
  return(equilibrium_numbers);

// -----------------------------------------------------------------------------------------------------------------------------------

// Label 504: project_biomass
FUNCTION dvar_vector project_biomass(const int YrRef2, const int YrRefGrow, const int YrRefM1, const int YrRefM2, const int YrRefSea1,
									 const int YrRefSea2, const int YrRefSexR1, const int YrRefSexR2, const int YrRefSel1,
									 const int YrRefSel2, dvar_vector Rbar, const int iproj)
  double lam,TACType;
  int isizeTrans;
  dvariable TargetC,StateTAC;                            ///> Various temps
  dvariable ssb_use,TotalRec,Fmin,Fmax,Fmult;                             ///> More temps
  dvar_vector FederalStuff(1,4);                                          ///> OFLs, ABCs etc
  dvar_matrix rtt(1,nsex,1,nclass);                                       ///> Constant recuitment
  dvar_vector ssb_prj(syr,nyr+iproj);                                     ///> projected spawning biomass
  dvar_vector hist_ssb(syr,nyr);                                          ///> Historical SSB
  dvar_vector Rec_use(1,nsex);                                            ///> Recruitment
  dvar_matrix d4_Pass(1,n_grp,1,nclass);                                  ///> Numbers-at-sex/mature/shell/length.
  dvariable TotalSex1,TotalAll,SexRatio;                                  ///> used to compute the sex ratio for future recruitment

  // Copy N from the end of the assessment into the first projection year
  numbers_proj_gytl.initialize();
  for ( int ig = 1; ig <= n_grp; ig++ ) numbers_proj_gytl(ig)(1)(1) = d4_N(ig)(nyrRetro+1)(1);
   
  // copy SSB into projection SSB
  hist_ssb = calc_ssb();
  ssb_prj.initialize();
  for (int i = syr; i<=nyrRetro;i++) ssb_prj(i) = hist_ssb(i);
  
  // recruitment distribution (constant recruitment)
  if (nsex>1)
   {
    rtt(1) = Rbar(1) * rec_sdd(1);
    rtt(2) = Rbar(2) * rec_sdd(2);
   }
  else
   rtt(1) = Rbar(1) * rec_sdd(1);

  if (nsex>1)
   {
    TotalSex1 = 0; TotalAll = 0;
    for (int i=YrRefSexR1;i<=YrRefSexR2;i++)
     {
      TotalSex1 += 1 / (1 + mfexp(-logit_rec_prop(i)));
      TotalAll += 1;
     }
    SexRatio = TotalSex1/TotalAll;
   }
   
  // Now project forward
  for ( int i = 1; i <= iproj; i++ )
   {
    if (Stock_rec_prj==1)                           // Constant recruitment
     {
      for (int h=1; h<=nsex;h++) Rec_use(h) = fut_recruits(h,i);
     }
    if (Stock_rec_prj==RICKER)                      // Ricker
     {
      ssb_use = ssb_prj(nyrRetro+i-Age_at_rec_prj);
      TotalRec = SR_alpha_prj*ssb_use*exp(-1*SR_beta_prj*ssb_use)*fut_recruits(1,i);
      if (nsex>1)
       {
	Rec_use(1) = TotalRec * SexRatio;
	Rec_use(2) = TotalRec * (1 - SexRatio);
       }
      else
       Rec_use(1) = TotalRec;
     }
    if (Stock_rec_prj==BEVHOLT)                      // Beveton-Holt
     {
      ssb_use = ssb_prj(nyr+i-Age_at_rec_prj);
      TotalRec = SR_alpha_prj*ssb_use/(SR_beta_prj+ssb_use)*fut_recruits(1,i);
      if (nsex>1)
       {
	Rec_use(1) = TotalRec * SexRatio;
	Rec_use(2) = TotalRec * (1 - SexRatio);
       }
      else
       Rec_use(1) = TotalRec;
     }
    if (Stock_rec_prj==MEAN_RECRUIT)                    // Mean recruitment
     {
      TotalRec = mean_rec_prj;
      if (nsex>1)
       {
        Rec_use(1) = TotalRec * SexRatio;
        Rec_use(2) = TotalRec * (1 - SexRatio);
       }
      else
       Rec_use(1) = TotalRec;
     }
	 
    // Store start-year N-at-size
    d4_Pass.initialize();
    for ( int ig = 1; ig <= n_grp; ig++ )  d4_Pass(ig) = numbers_proj_gytl(ig,i,1);

    // Compute the ABC and OFL
    FederalStuff = compute_OFL_and_ABC(nyr+i, YrRefGrow, YrRefM1, YrRefM2, YrRefSea1, YrRefSea2, YrRefSel1, YrRefSel2, Rbar, d4_Pass);
    
    // Should the project consuder the state TAC
    if (Apply_StateHCR_prj==1)
     {     

      // Compute the State TAC
      StateTAC = CalcStateTAC(i,iproj,YrRefGrow);

      // Adjust so that the TAC is not larger than the ABC
      if (FederalStuff(3) < StateTAC)
       { TACType = 1; TargetC = FederalStuff(2); }                    /// > Hit the total catch OFL
      else
       { TACType = 2; TargetC = StateTAC; }                           /// > Hit the retained catc OFL
      mcoutDIAG << nyr+i << " OFL " << FederalStuff(1) << " Total ABC " << FederalStuff(2) << " Retained ABC " << FederalStuff(3) << " StateTAC " << StateTAC << " Final Decision: " << TACType << " " << TargetC << endl;
     }
     else
      {
       TACType= 1; TargetC = FederalStuff(2);
       mcoutDIAG << nyr+i << " OFL " << FederalStuff(1) << " Total ABC " << FederalStuff(2) << " Retained ABC " << FederalStuff(3) << " Final Decision: " << TACType << " " << TargetC << endl;
      }

     // DO a projection for the current F
     log_fimpbarPass = log_fimpbar;
     mcoutDIAG << nyr+i << " Default F " << exp(log_fimpbarPass) << endl;
     project_one_year(i, iproj, YrRef2, YrRefGrow, YrRefM1, YrRefM2, YrRefSea1, YrRefSea2, YrRefSel1, YrRefSel2, rtt, rec_sdd, Rec_use, d4_Pass);
     mcoutDIAG << nyr+i << " Default C (ret, total, by fleet) " << catch_pass << endl;
	
     int NeedToTune;
     if (Apply_HCR_prj==1) NeedToTune = YES;
     if (Apply_HCR_prj==0) NeedToTune = NO;
     if (TACType==1 && catch_pass(2)-1.0e-5 < TargetC) NeedToTune = NO;
     if (TACType==2 && catch_pass(1)-1.0e-5 < TargetC) NeedToTune = NO;

     // Apply bisection to find the target F for the directed fishery
     if (NeedToTune==YES)
      {
       Fmin = 0; Fmax =1;
       for (int ii=1; ii<=20;ii++)
        {
         Fmult = (Fmin+Fmax)/2.0;
         for (int k=1;k<=nfleet;k++)
          if (Ffixed(k) != 1) log_fimpbarPass(k) = log(mfexp(log_fimpbar(k))*Fmult);
         project_one_year(i, iproj, YrRef2, YrRefGrow, YrRefM1, YrRefM2, YrRefSea1, YrRefSea2, YrRefSel1, YrRefSel2, rtt, rec_sdd, Rec_use, d4_Pass);
         if (TACType == 1)
          {
           if (catch_pass(2) > TargetC) Fmax = Fmult; else Fmin = Fmult;
          }
         if (TACType == 2)
          {
           if (catch_pass(1) > TargetC) Fmax = Fmult; else Fmin = Fmult;
          }
        }
       mcoutDIAG << nyr+i << "CTUNE " << Fmult << " " << TargetC << " " << catch_pass << exp(log_fimpbarPass) << endl;
       mcoutDIAG << nyr+i << "Final F " << exp(log_fimpbarPass) << endl;
       mcoutDIAG << nyr+i << "Final C (ret, total, by fleet) " << catch_pass << endl;
      }
	  
     // Store catches during the projection
     for (int k=1;k<=nfleet+2;k++) catch_summary(k,i) = catch_pass(k);
     catch_summary(nfleet+3,i) = FederalStuff(1);
     catch_summary(nfleet+4,i) = FederalStuff(2);
     catch_summary(nfleet+5,i) = StateTAC;
     ssb_prj(nyr+i) = ssb_pass;

    } // i

  // return
  ssb_pass = ssb_prj(nyr+iproj);

  return(ssb_prj);

// -----------------------------------------------------------------------------------------------------------------------------------
// Label 506: project_one_year
FUNCTION void project_one_year(const int i, const int iproj, const int YrRef2, const int YrRefGrow, const int YrRefM1,
									  const int YrRefM2, const int YrRefSea1, const int YrRefSea2, const int YrRefSel1,
									  const int YrRefSel2, dvar_matrix rtt, dvar_matrix  rec_sdd, 
									  dvar_vector Rec_use, dvar_matrix d4_Pass)
 {
  int isizeTrans;
  double xi;                                                               ///> discard mortality rate
  dvariable log_ftmp;
  dvar_vector x(1,nclass);                                                 ///> Temp vector for numbers
  dvar_vector y(1,nclass);                                                 ///> Temp vector for numbers
  dvar_vector z(1,nclass);                                                 ///> Temp vector for numbers
  dvar3_array _F1(1,nsex,1,nseason,1,nclass);                              ///> Fishing mortality
  dvar3_array _F2(1,nsex,1,nseason,1,nclass);                              ///> Fishing mortality
  dvar4_array _Z1(1,nsex,1,nmature,1,nseason,1,nclass);                              ///> Total mortality
  dvar4_array _Z2(1,nsex,1,nmature,1,nseason,1,nclass);                              ///> Total mortality
  dvar3_array _ft(1,nfleet,1,nsex,1,nseason);                              ///> Fishing mortality by gear
  dvar3_array d4_Npass(1,n_grp,1,nseason,1,nclass);                        ///> For passing out
  dvar_vector sel(1,nclass);                                               ///> Capture selectivity
  dvar_vector sel1(1,nclass);                                              ///> Capture selectivity
  dvar_vector selret(1,nclass);                                            ///> Selectivity x retained
  dvar_vector ret(1,nclass);                                               ///> Retained probability
  dvar_vector ret1(1,nclass);                                              ///> Retained probability
  dvar_vector vul(1,nclass);                                               ///> Total vulnerability
  dvar_vector nal(1,nclass);                                               ///> Numbers-at-length
  dvar_vector Mbar(1,nclass);                                              ///> Natural mortality
  dvariable Mprop;                                                         ///> time before  catch

  // Initialize the Fs
  _F1.initialize();
  for ( int h = 1; h <= nsex; h++ )
   for ( int j = 1; j <= nseason; j++ )
    for ( int l = 1; l <= nclass; l++)
     _F2(h,j,l) = 1.0e-10;

  _ft.initialize();
  for ( int k = 1; k <= nfleet; k++ )
   for ( int h = 1; h <= nsex; h++ )
    for ( int j = 1; j <= nseason; j++ )
     if ( fhitfut(j,k)==1 )
     {
       log_ftmp = log_fimpbarPass(k);
       if (h==2) log_ftmp += log_foff(k);
       _ft(k,h,j) = mfexp(log_ftmp);
        sel.initialize(); ret.initialize(); vul.initialize();
       for (int iy=YrRefSel1; iy<=YrRefSel2;iy++)
        {
         sel1 = mfexp(log_slx_capture(k,h,iy))+1.0e-10;                          // Selectivity
         ret1 = mfexp(log_slx_retaind(k,h,iy)) * slx_nret(nsex+h,k);             // Retention
         xi  = dmr(iy,k);          
         sel += sel1;                                                            // Selectivity
         ret += ret1;                                                            // Retention
         vul += elem_prod(sel1, ret1 + (1.0 - ret1) * xi);                       // Vulnerability
        }
       sel /= float(YrRefSel2-YrRefSel1+1);
       ret /= float(YrRefSel2-YrRefSel1+1);
       vul /= float(YrRefSel2-YrRefSel1+1);
       _F1(h,j) += _ft(k,h,j) * vul;
       _F2(h,j) += _ft(k,h,j) * sel;
       if (full_prj_diag==1) mcoutDIAG << nyr+i << " " << k << " " << h << " " << j << " " << "Sel " << sel << endl;  
       if (full_prj_diag==1) mcoutDIAG << nyr+i << " " << k << " " << h << " " << j << " " << "Ret " << ret << endl;  
       if (full_prj_diag==1) mcoutDIAG << nyr+i << " " << k << " " << h << " " << j << " " << "Vul " << vul << endl;  
     }
	 
  // computer the total mortality
  _Z1.initialize();  _Z2.initialize(); SS_pass.initialize();
  for( int m =1; m <= nmature; m++)
  for ( int h = 1; h <= nsex; h++ )
   for ( int j = 1; j <= nseason; j++ )
    {
     Mbar.initialize();
     for (int iy=YrRefM1; iy<=YrRefM2;iy++) Mbar += M(h,m,iy);
     Mbar /= float(YrRefM2-YrRefM1+1);
     Mprop = 0;
     for (int iy=YrRefSea1; iy<=YrRefSea2;iy++) Mprop += m_prop(iy,j);
     Mprop /= float(YrRefSea2-YrRefSea1+1);
     if (full_prj_diag==1) mcoutDIAG << nyr+i << " " << h << " " << j << " " << "Mprop/Bar" << " " << Mprop << " " << Mbar << endl;
     _Z1(h,m,j) = Mprop * Mbar + _F1(h,j);
     _Z2(h,m,j) = Mprop * Mbar + _F2(h,j);
     if (season_type(j) == 0) for ( int l = 1; l <= nclass; l++ ) SS_pass(h,m,j)(l,l) = 1.0-_Z1(h,m,j,l)/_Z2(h,m,j,l)*(1.0-mfexp(-_Z2(h,m,j,l)));
     if (season_type(j) == 1) for ( int l = 1; l <= nclass; l++ ) SS_pass(h,m,j)(l,l) = mfexp(-_Z1(h,m,j,l));
    }
 	
  // Update the dynamics
  for (int h=1;h<=nsex;h++)
   {
    isizeTrans_pass(h) = iYrsIncChanges(h,YrRefGrow);
    if (IsProject==NOPROJECT) rec_pass(h) = rtt(h);                                   ///> recruitment as a function of class 
    if (IsProject==PROJECT) rec_pass(h) = Rec_use(h)*rec_sdd(h);                      ///> recruitment as a function of class 
    molt_prob_pass(h) = molt_probability(h,YrRefGrow);                                ///> probability of molting
    mature_prob_pass(h) = mature_probability(h,YrRefGrow);                            ///> probability of maturity
    } //-- h 
  // Now fo the year-update
  for (int j = 1; j <= nseason; j++) update_population_numbers_at_length_season(i,j,3);     ///> Update the sesonal-dynamics
 
  // Project SSB
  ssb_pass = 0;
  for ( int ig = 1; ig <= n_grp; ig++ )
   {
    int h = isex(ig);
    int o = ishell(ig);
    int m = imature(ig);
    double lam;
    h <= 1 ? lam = spr_lambda: lam = (1.0 - spr_lambda);
    if(nmature==1)
     ssb_pass += lam * numbers_proj_gytl(ig,i,season_ssb) * elem_prod(mean_wt(h,m,YrRefGrow), maturity(h));
    if(nmature==2 && use_func_mat==0)
    if(m==MATURE)
      ssb_pass += lam * numbers_proj_gytl(ig,i,season_ssb) * mean_wt(h,m,YrRefGrow);
    if(nmature==2 && use_func_mat==1)
     if(m==MATURE)
      ssb_pass += lam * numbers_proj_gytl(ig,i,season_ssb) * elem_prod(mean_wt(h,m,YrRefGrow), maturity(h));
   }

  // Calculate the catch
  for ( int j = 1; j <= nseason; j++ )
   for ( int ig = 1; ig <= n_grp; ig++ )
    d4_Npass(ig,j) = numbers_proj_gytl(ig,i,j);
  catch_pass = calc_predicted_project(nyr, YrRefGrow, YrRefSel1, YrRefSel2, d4_Npass, _ft, _Z1, _Z2);
 }

// -----------------------------------------------------------------------------------------------------------------------------------

// Label 503: calc_predicted_project
FUNCTION dvar_vector calc_predicted_project(const int YrRef2, const int YrRefGrow, const int YrRefSel1, const int YrRefSel2,
					    dvar3_array d4_Npass, dvar3_array _ft, dvar4_array _Z1, dvar4_array _Z2)
 {
  //int h,i,j,k,ig,type,unit;
  double xi;                                                               ///> Discard rate
  dvar_vector out(1,2+nfleet);                                             ///> Output
  dvariable tmp_ft,out2;                                                   ///> Temp
  dvar_vector sel(1,nclass);                                               ///> Capture selectivity
  dvar_vector sel1(1,nclass);                                              ///> Capture selectivity
  dvar_vector selret(1,nclass);                                            ///> Selectivity x retained
  dvar_vector ret(1,nclass);                                               ///> Retained probability
  dvar_vector ret1(1,nclass);                                              ///> Retained probability
  dvar_vector vul(1,nclass);                                               ///> Total vulnerability
  dvar_vector nal(1,nclass);                                               ///> Numbers-at-length
  dvar_vector tempZ1(1,nclass);                                            ///> total mortality

  // out(1): retained catch
  // out(2): dead total catch
  // out(2+k): dead animals

  out.initialize();
  for ( int m = 1; m <= nmature; m++ )
   for ( int h = 1; h <= nsex; h++ )
    for ( int j = 1; j <= nseason; j++ )
    {
     nal.initialize();
	 
     for ( int o = 1; o <= nshell; o++ )
      { int ig = pntr_hmo(h,m,o); nal += d4_Npass(ig)(j); }
      nal = elem_prod(nal, mean_wt(h,m)(YrRefGrow));
      for ( int k = 1; k <= nfleet; k++ )
       {
        sel.initialize(); ret.initialize(); vul.initialize();
        for (int iy=YrRefSel1; iy<=YrRefSel2;iy++)
         {
          sel1 = mfexp(log_slx_capture(k,h,iy))+1.0e-10;                          // Selectivity
          ret1 = mfexp(log_slx_retaind(k,h,iy)) * slx_nret(nsex+h,k);             // Retention
          xi  = dmr(iy,k);          
          sel += sel1;                                                            // Selectivity
          ret += ret1;                                                            // Retention
          vul += elem_prod(sel1, ret1 + (1.0 - ret1) * xi);                       // Vulnerability
         }
	sel /= float(YrRefSel2-YrRefSel1+1);
        ret /= float(YrRefSel2-YrRefSel1+1);
        vul /= float(YrRefSel2-YrRefSel1+1);
        selret = elem_prod(sel,ret);

        if (season_type(j)==0) tempZ1 = _Z1(h,m,j); else tempZ1 = _Z2(h,m,j);
        if (_ft(k,h,j) > 0)
	 {
          out(1) += nal * elem_div(elem_prod(_ft(k,h,j) * selret, 1.0 - mfexp(-tempZ1)), tempZ1);
          // Total dead
          out(2) += nal * elem_div(elem_prod(_ft(k,h,j) * vul, 1.0 - mfexp(-tempZ1)), tempZ1);
          // fleet-specific dead crab
          out(2+k) += nal * elem_div(elem_prod(_ft(k,h,j) * vul, 1.0 - mfexp(-tempZ1)), tempZ1);
	 }
       }
    }
  return(out);
 }

// ---------------------------------------------------------------------------------------------------------------------------------------
// Label 505: compute_OFL_and_ABC,
FUNCTION dvar_vector compute_OFL_and_ABC(const int iyr, const int YrRefGrow, const int YrRefM1, const int YrRefM2,
										 const int YrRefSea1, const int YrRefSea2,const int YrRefSel1, const int YrRefSel2,
										 dvar_vector Rbar, dvar_matrix d4_Npass)
 {
  int IsProjectSave;                                                 ///> Variable to save the projection pointer
  dvariable Bproj;                                                 ///> Projected biomass (one year)
  dvar_vector return_vec(1,4);                                       ///> Material to return
  dvariable Fmsy, Bmsy, Fmult2, FF;                                  ///> Teps

  IsProjectSave = IsProject;
  IsProject = NOPROJECT;

  // Extract reference points
  Fmsy = 1; Bmsy = spr_bmsy;

  // Set F to Fmsy (by fleet)
  log_fimpbarOFL = log(sd_fmsy);
  Bproj = project_biomass_OFL(iyr-nyr,nyr, YrRefGrow, YrRefM1, YrRefM2, YrRefSea1, YrRefSea2, YrRefSel1, YrRefSel2, Rbar, 1,d4_Npass);
  
  if (ssb_pass > Bmsy)
   {
    FF = 1.0;
   }
  else
   {
    // It is not above Bmsy so check if F=0 leads to a stock above Beta*Bmsy
    FF = 1.0e-10;
    for (int k=1;k<=nfleet;k++) if (Ffixed(k) != 1) log_fimpbarOFL(k) = log(sd_fmsy(k)*FF);
    Bproj = project_biomass_OFL(iyr-nyr,nyr,YrRefGrow, YrRefM1, YrRefM2, YrRefSea1, YrRefSea2, YrRefSel1, YrRefSel2,spr_rbar,1,d4_Npass);
    if ( ssb_pass <= OFLbeta * Bmsy)
     {
      FF = 1.0e-10;
     }
    else
     {
      // Adjust F if below target since it's a function biomass needs to be interated
      for( int iloop = 1; iloop <= 10; iloop++)
       {
        Fmult2 = Fmsy * (ssb_pass / Bmsy - OFLalpha) / (1 - OFLalpha);
        if (Fmult2 < 0.1*FF)
         FF = 0.1*FF;
        else
         FF = Fmult2;
        if (FF < 0.00001) FF = 0.00001;
        for (int k=1;k<=nfleet;k++) if (Ffixed(k) != 1) log_fimpbarOFL(k) = log(sd_fmsy(k)*FF);
        Bproj = project_biomass_OFL(iyr-nyr,nyr,YrRefGrow, YrRefM1, YrRefM2, YrRefSea1, YrRefSea2, YrRefSel1, YrRefSel2,spr_rbar,1, d4_Npass);
       }
     } 
   }

  // save the OFL
  return_vec(1) = ofltot_pass;
  return_vec(2) = ofltot_pass*ABCBuffer;
  return_vec(3) = oflret_pass*ABCBuffer;
  return_vec(4) = oflret_pass;
  IsProject = IsProjectSave;                                         ///> Return back to normal

  return(return_vec);
 }

// -----------------------------------------------------------------------------------------------------------------------------------

// Label 502: project_biomass_OFL
FUNCTION dvariable project_biomass_OFL(const int iyr, const int YrRef2, const int YrRefGrow, 
        const int YrRefM1, const int YrRefM2, const int YrRefSea1, const int YrRefSea2, 
        const int YrRefSel1, const int YrRefSel2, dvar_vector Rbar, const int iproj, dvar_matrix d4_Npass)
  int isizeTrans;                                                          ///> Size-transition matrix
  dvariable log_ftmp;                                                      ///> Temp
  double xi;                                                               ///> Discard mortality
  dvar_matrix rtt(1,nsex,1,nclass);                                        ///> Constant recruitment
  dvar_vector x(1,nclass);                                                 ///> Temp vector for numbers
  dvar_vector y(1,nclass);                                                 ///> Temp vector for numbers
  dvar_vector z(1,nclass);                                                 ///> Temp vector for numbers
  dvar3_array _F1(1,nsex,1,nseason,1,nclass);                              ///> Fishing mortality
  dvar3_array _F2(1,nsex,1,nseason,1,nclass);                              ///> Fishing mortality
  dvar4_array _Z1(1,nsex,1,nmature,1,nseason,1,nclass);                              ///> Total mortality
  dvar4_array _Z2(1,nsex,1,nmature,1,nseason,1,nclass);                              ///> Total mortality
  dvar3_array _ft(1,nfleet,1,nsex,1,nseason);                              ///> Fishing mortality by gear
  dvar3_array d4_Npass_2(1,n_grp,1,nseason,1,nclass);                      ///> Pass variable
  dvar_vector sel(1,nclass);                                               ///> Capture selectivity
  dvar_vector sel1(1,nclass);                                              ///> Capture selectivity
  dvar_vector ret(1,nclass);                                               ///> Retained probability
  dvar_vector ret1(1,nclass);                                              ///> Retained probability
  dvar_vector vul(1,nclass);                                               ///> Total vulnerability
  dvar_vector Mbar(1,nclass);                                              ///> Natural mortality
  dvariable Mprop;                                                         ///> time before  catch
  dvar_vector nal(1,nclass);                                               ///> Numbers-at-length
  dvar_vector out(1,2+nfleet);                                             ///> Output

  // Copy N from the end of the assessment into the first projection year
  numbers_proj_gytl.initialize();
  for ( int ig = 1; ig <= n_grp; ig++ ) numbers_proj_gytl(ig)(iyr)(1) = d4_Npass(ig);
  
  // recruitment distribution
  if (nsex>1)
   {
    rtt(1) = Rbar(1) * rec_sdd(1);
    rtt(2) = Rbar(2) * rec_sdd(2);
   }
  else
   rtt(1) = Rbar(1) * rec_sdd(1);

  // Initialize the Fs
  _F1.initialize();
  for ( int h = 1; h <= nsex; h++ )
   for ( int j = 1; j <= nseason; j++ )
    for ( int l = 1; l <= nclass; l++)
     _F2(h,j,l) = 1.0e-10;

  _ft.initialize();
  for ( int k = 1; k <= nfleet; k++ )
   for ( int h = 1; h <= nsex; h++ )
    for ( int j = 1; j <= nseason; j++ )
     if ( fhitfut(j,k)==1 )
      {
       log_ftmp = log_fimpbarOFL(k);
       if (h==2) log_ftmp += log_foff(k);
       _ft(k,h,j) = mfexp(log_ftmp);
       sel.initialize(); ret.initialize(); vul.initialize();
       for (int iy=YrRefSel1; iy<=YrRefSel2;iy++)
        {
         sel1 = mfexp(log_slx_capture(k,h,iy))+1.0e-10;                          // Selectivity
         ret1 = mfexp(log_slx_retaind(k,h,iy)) * slx_nret(nsex+h,k);             // Retention
         xi  = dmr(iy,k);          
         sel += sel1;                                                            // Selectivity
         ret += ret1;                                                            // Retention
         vul += elem_prod(sel1, ret1 + (1.0 - ret1) * xi);                       // Vulnerability
        }
       sel /= float(YrRefSel2-YrRefSel1+1);
       ret /= float(YrRefSel2-YrRefSel1+1);
       vul /= float(YrRefSel2-YrRefSel1+1);
       _F1(h,j) += _ft(k,h,j) * vul;
       _F2(h,j) += _ft(k,h,j) * sel;
     }
   
  // computer the total mortality
  _Z1.initialize();  _Z2.initialize(); SS_pass.initialize();
  for( int m = 1; m <=nmature; m++)
  for ( int h = 1; h <= nsex; h++ )
   for ( int j = 1; j <= nseason; j++ )
    {
     Mbar.initialize();
     for (int iy=YrRefM1; iy<=YrRefM2;iy++) Mbar += M(h,m,iy);
     Mbar /= float(YrRefM2-YrRefM1+1);
     Mprop = 0;
     for (int iy=YrRefSea1; iy<=YrRefSea2;iy++) Mprop += m_prop(iy,j);
     Mprop /= float(YrRefSea2-YrRefSea1+1);
     _Z1(h,m,j) = Mprop * Mbar + _F1(h,j);
     _Z2(h,m,j) = Mprop * Mbar + _F2(h,j);
     if (season_type(j) == 0) for ( int l = 1; l <= nclass; l++ ) SS_pass(h,m,j)(l,l) = 1.0-_Z1(h,m,j,l)/_Z2(h,m,j,l)*(1.0-mfexp(-_Z2(h,m,j,l)));
     if (season_type(j) == 1) for ( int l = 1; l <= nclass; l++ ) SS_pass(h,m,j)(l,l) = mfexp(-_Z1(h,m,j,l));
    }
  
  // Projections for Case 3
  dvar_vector ssb(1,iyr+iproj-1);
  ssb.initialize();
  for (int i = iyr; i <= iyr+iproj-1; i++)
   {
    // Pass the molt probabilities
    for (int h=1;h<=nsex;h++)
     {
      isizeTrans_pass(h) = iYrsIncChanges(h,YrRefGrow);
      for (int l=1;l<=nclass;l++)
       {
        rec_pass(h,l) = rtt(h,l);                                                           ///> recruitment as a function of class 
        molt_prob_pass(h,l) = molt_probability(h,YrRefGrow,l);                              ///> probability of molting
        if (nmature==2) mature_prob_pass(h,l) = mature_probability(h,YrRefGrow,l);           ///> probability of maturity
       }
     } //-- h 
     // Now fo the year-update
    for (int j = 1; j <= nseason; j++) update_population_numbers_at_length_season(i,j,3);     ///> Update the seasonal-dynamics
    for ( int ig = 1; ig <= n_grp; ig++ )
     {
      int h = isex(ig);
      int o = ishell(ig);
      int m = imature(ig);
      double lam;
      h <= 1 ? lam = spr_lambda: lam = (1.0 - spr_lambda);
      if(nmature==1)
       ssb(i) += lam * numbers_proj_gytl(ig)(i)(season_ssb) * elem_prod(mean_wt(h,m)(YrRefGrow), maturity(h));
      if(nmature==2 && use_func_mat==0)
       if(m == MATURE)
 	ssb(i) += lam * numbers_proj_gytl(ig)(i)(season_ssb) * mean_wt(h,m)(YrRefGrow); 
       if(nmature==2 && use_func_mat==1)
        if(m == MATURE)
 	ssb(i) += lam * numbers_proj_gytl(ig)(i)(season_ssb) * elem_prod(mean_wt(h,m)(YrRefGrow), maturity(h));
     } //--ig
     
   } // i
 	
  // return material
  ssb_pass = ssb(iyr+iproj-1);
  for ( int j = 1; j <= nseason; j++ )
   for ( int ig = 1; ig <= n_grp; ig++ )
    d4_Npass_2(ig,j) = numbers_proj_gytl(ig)(iyr+iproj-1)(j);
  out = calc_predicted_project(nyr, YrRefGrow, YrRefSel1, YrRefSel2, d4_Npass_2, _ft, _Z1, _Z2);
  oflret_pass = out(1); ofltot_pass = out(2);
  OFLoutpass = out;

  return(ssb_pass);

// ----------------------------------------------------------------------------------------------------------------------------------------
// Label 500: calc_spr_reference_points2

FUNCTION void calc_spr_reference_points2(const int DoProfile)
  int iproj;
  dvar_matrix equilibrium_numbers(1,n_grp,1,nclass);
  dvariable FF;
  dvariable Fmsy;
  dvariable MeanF,NF;
  dvariable Fmult, Fmult2, SSBV0, SSBV1a,SSBV1b,Deriv, Adjust, R1;
  dvariable SteepMin,SteepMax;
  dvar_vector Fave(1,nfleet);
  dvar_matrix d4_Npass(1,n_grp,1,nclass);       ///> Numbers-at-sex/mature/shell/length.
  dvar_vector tst(1,3);

  bSteadyState = REFPOINTS;
  IsProject = NOPROJECT;
  iproj = 1;
  dvar_vector Bproj(1,iproj);
  Eqn_basis = CONSTANTREC;

  // Find mean recruitment
  if (nsex==1) spr_rbar(1) = mean(recruits(1)(spr_syr,spr_nyr));
  if (nsex==2) { spr_rbar(1) = mean(recruits(1)(spr_syr,spr_nyr)); spr_rbar(2) = mean(recruits(2)(spr_syr,spr_nyr)); }
  
  // Find mean recruitment for projections
  if (nsex==1) proj_rbar(1) = mean(recruits(1)(proj_syr,proj_nyr));
  if (nsex==2)
   { proj_rbar(1) = mean(recruits(1)(proj_syr,proj_nyr)); proj_rbar(2) = mean(recruits(2)(proj_syr,proj_nyr));}
  
  // Find the average F by fleet over the last 4 years
  for (int k = 1; k <= nfleet; k++)
   {
    MeanF = 0; NF = 0;
    for (int i = spr_aveF_syr; i <= spr_aveF_nyr; i++) { MeanF += fout(k,i); NF += 1; }
    Fave(k) = (MeanF+1.0e-10)/NF;
   }
  // Find SSB for F=0 for all fleets
  for (int k=1;k<=nfleet;k++) log_fimpbar(k) = -100;
  equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
  ssbF0 = ssb_pass;
  if (verbose>=3) cout << ssbF0 << endl;

  // Solve for F35% and hence the Fmsy proxy (Tier 3 analysis)
  if (OFLTier==3)
   {
    // Find Fmsy (=F35%) when adjusting the Fs for some fleets
    for (int k=1;k<=nfleet;k++) log_fimpbar(k) = log(Fave(k));
    Fmult = 1.0;
    for (int i=1;i<=10;i++)
     {
      // Set F
      for (int k=1;k<=nfleet;k++)
       if (Ffixed(k) != 1) log_fimpbar(k) = log(Fave(k)*Fmult);
      equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
      SSBV0 = ssb_pass/ssbF0-spr_target;
      for (int k=1;k<=nfleet;k++)
       if (Ffixed(k) != 1) log_fimpbar(k) = log(Fave(k)*(Fmult+0.001));
      equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
      SSBV1a = ssb_pass/ssbF0-spr_target;

      for (int k=1;k<=nfleet;k++)
       if (Ffixed(k) != 1) log_fimpbar(k) = log(Fave(k)*(Fmult-0.001));
      equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
      SSBV1b = ssb_pass/ssbF0-spr_target;
      Deriv = (SSBV1a-SSBV1b)/0.002;
      Fmult2 = Fmult - SSBV0/Deriv;
      if (Fmult2 < 0.01) Fmult2 = 0.01;
      if (Fmult2 < 0.1*Fmult)
       Fmult = 0.1*Fmult;
      else
       Fmult = Fmult2;
      }
  	 
    for (int k=1;k<=nfleet;k++)
     if (Ffixed(k) != 1) log_fimpbar(k) = log(Fave(k)*Fmult);
 
    equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
    Bmsy = ssb_pass;
   }
  
  // Tier 4 control rule
  if (OFLTier==4)
   {
    // BMSY is the mean SSB over a set of years
    Bmsy = mean(calc_ssb()(spr_syr,spr_nyr));
    Fmsy = OFLgamma * M_pars_est(1);
    for (int k=1;k<=nfleet;k++) log_fimpbar(k) = log(Fave(k));
    for (int k=1;k<=nfleet;k++)
     if (Ffixed(k) != 1) log_fimpbar(k) = log(Fmsy);
   }

  // Save FMSY
  for (int k=1;k<=nfleet;k++) sd_fmsy(k) = mfexp(log_fimpbar(k));
  if (OutRefPars==YES)
   for (int k=1;k<=nfleet;k++) ParsOut(NRefPars+6+k) = sd_fmsy(k);
  if (verbose >=3) cout << sd_fmsy << endl;

  // Store reference points
  Fmsy = 1;
  spr_bmsy = Bmsy;

  // Store the N from the last year
  for ( int ig = 1; ig <= n_grp; ig++ ) d4_Npass(ig) = d4_N(ig)(nyrRetro+1)(1);
  if (verbose >=3) cout << d4_Npass << endl;
  
  // Check if above Bmsy when F=FOFL 
  log_fimpbarOFL = log(sd_fmsy);
  Bproj = project_biomass_OFL(1,nyrRetro, spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr, spr_rbar, iproj,d4_Npass);
  if (verbose>=3) cout << Bproj << endl;
  if (ssb_pass > Bmsy)
   {
    spr_fofl = 1.0;
    spr_depl = ssb_pass / Bmsy;
   }
  else
   {
    // It is not above Bmsy so check if F=0 leads to a stock above Beta*Bmsy
    FF = 1.0e-10;
    for (int k=1;k<=nfleet;k++) if (Ffixed(k) != 1) log_fimpbarOFL(k) = log(sd_fmsy(k)*FF);
    Bproj = project_biomass_OFL(1,nyrRetro,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,spr_rbar,iproj,d4_Npass);
    if (verbose>=3) cout << Bproj << endl;
   
    // Even under zero F the OFL is zero 
    if (ssb_pass < OFLbeta * Bmsy)
     {
      spr_fofl = FF/Fmsy;
      spr_depl = ssb_pass / Bmsy;
     }
    else
      {
       // Adjust F if below target since it's a function biomass needs to be interated
       for( int iloop = 1; iloop <= 10; iloop++)
        {
         Fmult2 = Fmsy * (ssb_pass / Bmsy - OFLalpha) / (1 - OFLalpha);
         if (Fmult2 < 0.1*FF)
          FF = 0.1*FF;
         else
          FF = Fmult2;
         if (FF < 0.00001) FF = 0.00001;
         for (int k=1;k<=nfleet;k++) if (Ffixed(k) != 1) log_fimpbarOFL(k) = log(sd_fmsy(k)*FF);
	 Bproj = project_biomass_OFL(1,nyrRetro,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,spr_rbar, iproj,d4_Npass);
        }
       spr_fofl = FF/Fmsy;
       spr_depl = ssb_pass / Bmsy;
      }
   }

  // save fofl
  for (int k=1;k<=nfleet;k++) sd_fofl(k) = mfexp(log_fimpbarOFL(k));
  if (OutRefPars==YES)
   for (int k=1;k<=nfleet;k++) ParsOut(NRefPars+6+nfleet+k) = sd_fofl(k);
  if (verbose >=3) cout << sd_fofl << endl;

  // save the OFL
  spr_cofl = ofltot_pass;
  spr_cofl_ret = oflret_pass;
  if (OutRefPars==YES)
   for (int k=1;k<=nfleet;k++) ParsOut(NRefPars+6+k+2*nfleet) = OFLoutpass(k+2);
  if (verbose >=3) cout << NRefPars+6+2*nfleet << endl;
  if (verbose >=3) cout << OFLoutpass << endl;
 
  // Continue only calc_MSY is YES
  if (Calc_MSY == YES && (Stock_rec_prj==RICKER || Stock_rec_prj==BEVHOLT))
   {

    // Find Steepness and R0
    cout << "Computing steepness" << endl;
    Eqn_basis = STOCKRECREC;
    log_fimpbar = log(sd_fmsy);

    SteepMin = 0.2; SteepMax = 5.0;
    for (int ii=1;ii<=30;ii++)
     {
      Steepness = SteepMin+(SteepMax-SteepMin)/29.0*float(ii-1);
      if (Stock_rec_prj==RICKER)
       {
        SR_alpha_prj = spr_rbar(1)/ssbF0*exp(log(5.0*Steepness)/0.8);
        SR_beta_prj = log(5.0*Steepness)/(0.8*ssbF0);
       }
      if (Stock_rec_prj==BEVHOLT)
       {
        SR_alpha_prj = 4.0*Steepness*spr_rbar(1)/(5*Steepness-1.0);
        SR_beta_prj = (1.0-Steepness)*ssbF0/(5*Steepness-1.0);
       }

      for (int k=1;k<=nfleet;k++)
      if (Ffixed(k) != 1) log_fimpbar(k) = log(sd_fmsy(k)*1.001);
      equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
       SSBV1a = oflret_pass;
      for (int k=1;k<=nfleet;k++)
       if (Ffixed(k) != 1) log_fimpbar(k) = log(sd_fmsy(k)*0.999);
      equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
      SSBV1b = oflret_pass;
      Deriv = (SSBV1a-SSBV1b)/0.002;
      //cout << "Solve2 " << ii << " " << Steepness << " " << Deriv << endl;
      if (Deriv > 0)
       {
        SteepMin = Steepness - (SteepMax-SteepMin)/29.0;
        SteepMax = Steepness + (SteepMax-SteepMin)/29.0;
        ii = 40;
       }
     }
  
    //SteepMin = 0.2; SteepMax = 5.0;
    for (int ii=1;ii<=30;ii++)
     {
      Steepness = (SteepMin+SteepMax)/2.0;
      if (Stock_rec_prj==RICKER)
       {
        SR_alpha_prj = spr_rbar(1)/ssbF0*exp(log(5.0*Steepness)/0.8);
        SR_beta_prj = log(5.0*Steepness)/(0.8*ssbF0);
       }
      if (Stock_rec_prj==BEVHOLT)
       {
        SR_alpha_prj = 4.0*Steepness*spr_rbar(1)/(5*Steepness-1.0);
        SR_beta_prj = (1.0-Steepness)*ssbF0/(5*Steepness-1.0);
       }

      for (int k=1;k<=nfleet;k++)
      if (Ffixed(k) != 1) log_fimpbar(k) = log(sd_fmsy(k)*1.001);
      equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
      SSBV1a = oflret_pass;
      for (int k=1;k<=nfleet;k++)
       if (Ffixed(k) != 1) log_fimpbar(k) = log(sd_fmsy(k)*0.999);
      equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
      SSBV1b = oflret_pass;
      Deriv = (SSBV1a-SSBV1b)/0.002;
      //cout << "Solve " << ii << " " << SteepMin << " " << SteepMax << " " << Deriv << endl;
      if (Deriv < 0) SteepMin = Steepness; else SteepMax = Steepness;
     }
    //cout << Steepness << " " << Deriv << " " << ssbF0 << endl;
    if (Stock_rec_prj==RICKER)
     {
      SR_alpha_prj = spr_rbar(1)/ssbF0*exp(log(5.0*Steepness)/0.8);
      SR_beta_prj = log(5.0*Steepness)/(0.8*ssbF0);
     }
    if (Stock_rec_prj==BEVHOLT)
     {
      SR_alpha_prj = 4.0*Steepness*spr_rbar(1)/(5*Steepness-1.0);
      SR_beta_prj = (1.0-Steepness)*ssbF0/(5*Steepness-1.0);
     }
    log_fimpbar = log(sd_fmsy);
    equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
  
    Adjust = spr_bmsy/ssb_pass;
    if (Stock_rec_prj==RICKER)
     {
      SR_alpha_prj = spr_rbar(1)/ssbF0*exp(log(5.0*Steepness)/0.8);
      SR_beta_prj = log(5.0*Steepness)/(0.8*ssbF0*Adjust);
     }
    if (Stock_rec_prj==BEVHOLT)
     {
      SR_alpha_prj = 4.0*Steepness*spr_rbar(1)*Adjust/(5*Steepness-1.0);
      SR_beta_prj = (1.0-Steepness)*ssbF0*Adjust/(5*Steepness-1.0);
     }

    // Find SSB for F=0 for all fleets
    for (int k=1;k<=nfleet;k++) log_fimpbar(k) = -100;
    equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
    ssbF0 = ssb_pass;

    // Check derivative
    log_fimpbar = log(sd_fmsy);
    for (int k=1;k<=nfleet;k++)
     if (Ffixed(k) != 1) log_fimpbar(k) = log(sd_fmsy(k)*1.001);
    equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
    SSBV1a = oflret_pass;
    for (int k=1;k<=nfleet;k++)
     if (Ffixed(k) != 1) log_fimpbar(k) = log(sd_fmsy(k)*0.999);
    equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
    SSBV1b = oflret_pass;
    Deriv = (SSBV1a-SSBV1b)/0.002;

    log_fimpbar = log(sd_fmsy);
    equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
    cout << "Final Yield" << ssb_pass/ssbF0 << " " << ssb_pass/spr_bmsy << " " << exp(log_fimpbar) << " " << oflret_pass << " " << Steepness << " " << Deriv << " " << ssbF0 << " " << spr_bmsy << endl;

    if (Compute_yield_prj==YES && DoProfile==YES)
     for (int ii=0;ii<=100;ii++)
      {
       if (ii==0) FF = 1.0e-10; else FF = float(ii)/20;
       for (int k=1;k<=nfleet;k++) if (Ffixed(k) != 1) log_fimpbar(k) = log(sd_fmsy(k)*FF);
       equilibrium_numbers = calc_brute_equilibrium(spr_SexR_syr,spr_SexR_nyr,spr_grow_yr,spr_grow_yr,spr_M_syr,spr_M_nyr,spr_Prop_syr,spr_Prop_nyr,spr_sel_syr,spr_sel_nyr,NyrEquil);
       spr_yield(ii,1) = ssb_pass/ssbF0;
       spr_yield(ii,2) = ssb_pass/spr_bmsy;
       spr_yield(ii,3) = exp(log_fimpbar(1));
       spr_yield(ii,4) = oflret_pass;
       cout << ii << " " << spr_yield(ii) << endl;
      } //--ii
     exit(1); 
   } 
// =======================================================================================================================================

  /**
   * @brief Conduct projections
  **/

// andre
// Label 700: write_eval
FUNCTION write_eval
  int index;                                                         ///> Counters
  dvariable MeanF,NF,Fmult,Bmsy_out,eps1;                            ///> Temp variables
  dvar_vector Bproj(syr,nyr+nproj);                                  ///> Biomass outout
  dvar_vector Fave(1,nfleet);                                        ///> Average F
  dvar_vector log_fimpbarI(1,nfleet);                                ///> Log F by fleet  

  // Header
  if (NfunCall==1)
   {
		mcoutPROJSSB << "Draw Replicate F_val ";
		for (int k=1;k<=nfleet;k++) mcoutPROJSSB << "f_for_fleet_" << k << " ";
		mcoutPROJSSB << "BMSY ";
		for (int i=syr;i<=nyr+nproj;i++) mcoutPROJSSB << "SSB_" << i << " ";
		mcoutPROJSSB << endl;
		mcoutPROJCAT << "Draw Replicate F_val Fleet ";
		for (int i=syr;i<=nyr+nproj;i++) mcoutPROJCAT << "Catch_" << i << " ";
		mcoutPROJCAT << endl;
		
		mcoutREF << "Draw Mean_rec SSB(F=0) BMSY BMSY/B0 OFL F35_mult";
		for (int k=1;k<=nfleet;k++) mcoutREF << "f35_for_fleet_" << k << " ";
		for (int k=1;k<=nfleet;k++) mcoutREF << "fOFL_for_fleet_" << k << " ";
		mcoutREF << endl;
		for (int i=syr;i<=nyrRetro;i++) mcoutSSB << "SSB_" << i << " ";
		mcoutSSB << endl;
		for (int i=syr;i<=nyrRetro;i++) mcoutREC << "Rec_" << i << " ";
		mcoutREC << endl;

		mcoutDIAG << "Projection type: " << Apply_HCR_prj << endl;
		mcoutDIAG << "SR relationship: " << Stock_rec_prj << endl;
		mcoutDIAG << "Year_for_growth M_yr_1 M_yr_2 Mprop_yr_1 Mprop_yr_2 Sexr_yr_1 Sexr_yr_2 Sel_yr_1 Sel_y2" << endl;
		mcoutDIAG << proj_grow_yr << " " << proj_M_syr << " " << proj_M_nyr << " " << proj_Prop_syr << " " << proj_Prop_nyr << " " 
			<< proj_SexR_syr  << " " << proj_SexR_nyr << " " << proj_sel_syr << " " << proj_sel_nyr <<  endl;
   }

// Darcy MCMC output
  MCout(theta);

  /**
   * @brief calculate sd_report variables in final phase
  **/
 calc_spr_reference_points2(0);
 
 mcoutSSB << calc_ssb() << endl;
 if (nsex==1) mcoutREC << recruits(1) << endl;
 if (nsex==2) mcoutREC << recruits(1)+recruits(2) << endl;
 mcoutREF << NfunCall << " " << spr_rbar << " " << ssbF0 << " " << spr_bmsy << " " << spr_depl << " " << spr_cofl << " " << sd_fmsy << " " << sd_fofl << endl;

 // Find the average F by fleet over the last 4 years
 for (int k = 1; k <= nfleet; k++)
  {
   MeanF = 0; NF = 0;
   for (int i = spr_aveF_syr; i <= spr_aveF_nyr; i++) { MeanF += fout(k,i); NF += 1; }
   Fave(k) = (MeanF+1.0e-10)/NF;
  }

 // Set the average Fs for the non-adjusted fleets
 if (prj_bycatch_on==NO)
  for (int k=1;k<=nfleet;k++) { if (Ffixed(k) == 1) log_fimpbarI(k) = log(1.0e-10); }
 else
  for (int k=1;k<=nfleet;k++) log_fimpbarI(k) = log(Fave(k));

 // Should Bmsy be simulatation-specific or a pre-specified value
 if (Fixed_prj_Bmsy < 0) Bmsy_out = spr_bmsy; else Bmsy_out = Fixed_prj_Bmsy;
 
 // Do projections
 IsProject = PROJECT;
 if (prj_Nstrat > 0 && prj_replicates > 0)
  for (int isim=1;isim<=prj_replicates;isim++)
   {
    // generate future recruitment
    if (Initial_eps < -998) eps1 = randn(rng); else eps1 = Initial_eps;
    for (int iproj=1;iproj<=nproj;iproj++)
     {
      if (Stock_rec_prj==UNIFORMSR)
       {
        index = prj_futRec_syr+(int)floor((float(prj_futRec_nyr)-float(prj_futRec_syr)+1.0)*randu(rng));
        fut_recruits(1,iproj) = recruits(1,index);
        if (nsex==2) fut_recruits(2,iproj) = recruits(2,index);
       }
      if (Stock_rec_prj==RICKER || Stock_rec_prj==BEVHOLT || Stock_rec_prj==MEAN_RECRUIT)
       {
        fut_recruits(1,iproj) = mfexp(eps1*SigmaR_prj-SigmaR_prj*SigmaR_prj/2.0);
        if (iproj != nproj) eps1 = Prow_prj*eps1 + sqrt(1.0-square(Prow_prj))*randn(rng);
        if (nsex==2) fut_recruits(2,iproj) = fut_recruits(1,iproj);
       }
     }
	
    for (int irun=1;irun<=prj_Nstrat;irun++)
     {
      // Set F
      Fmult = 1.e-10 + Proj_Levels(irun);
      for (int k=1;k<=nfleet;k++) log_fimpbar(k) = log_fimpbarI(k);
      if (Project_type==1) // Fixed F
       for (int k=1;k<=nfleet;k++) if (Ffixed(k) != 1) log_fimpbar(k) = log(Fmult);
      if (Project_type==2) // multilier on average F
       for (int k=1;k<=nfleet;k++) if (Ffixed(k) != 1) log_fimpbar(k) = log_fimpbarI(k)+log(Fmult);
      mcoutDIAG << "Draw Replicate F_val ";
      for (int k=1;k<=nfleet;k++) mcoutDIAG << "f_for_fleet_" << k << " ";
      mcoutDIAG << "BMSY ";
      mcoutDIAG << endl;
      mcoutDIAG << NfunCall << " " << isim << " " << irun << " " << prj_bycatch_on << " " << Stock_rec_prj << " " << exp(log_fimpbar) << " " << Bmsy_out << " " << endl;

      Bproj = project_biomass(nyr, proj_grow_yr,proj_M_syr,proj_M_nyr,proj_Prop_syr,proj_Prop_nyr,proj_SexR_syr, proj_SexR_nyr,proj_sel_syr,proj_sel_nyr, proj_rbar, nproj);
      mcoutPROJSSB << NfunCall << " " << isim << " " << irun << " " << exp(log_fimpbar) << " " << Bmsy_out << " ";
      dvar_vector ssb_old(syr,nyrRetro);
      ssb_old = calc_ssb();
      for (int i=syr;i<=nyr;i++) mcoutPROJSSB << ssb_old(i) << " ";
      for (int i=nyr+1;i<=nyr+nproj;i++) mcoutPROJSSB <<  Bproj(i) << " ";
      mcoutPROJSSB <<endl;
      for (int k=1;k<=nfleet+5;k++)
       {
        mcoutPROJCAT << NfunCall << " " << isim << " " << irun << " ";
        if (k==1) mcoutPROJCAT << "Retained_catch ";
        if (k==2) mcoutPROJCAT << "Total_catch ";
        if (k>2 && k <=2+nfleet) mcoutPROJCAT << fleetname(k-2);
        if (k==3+nfleet) mcoutPROJCAT << "OFL ";
        if (k==4+nfleet) mcoutPROJCAT << "ABC ";
        if (k==5+nfleet) mcoutPROJCAT << "State_TAC ";
        if (k==3+nfleet || k==4+nfleet || k==5+nfleet) for (int i=syr;i<=nyr;i++) mcoutPROJCAT << "-1 ";
        if (k <=2+nfleet) mcoutPROJCAT << histcat(k);
        mcoutPROJCAT << catch_summary(k) << endl;
        }
      
     } //-natrial
   } //--isim
 if (NfunCall == max_prj) exit(1);

// ---------------------------------------------------------------------------------------------------------------------------------------

FUNCTION calc_sdreport
  dvar4_array ftmp(1,nsex,syr,nyrRetro,1,nseason,1,nclass);           ///> Fishing mortality
  dvar4_array ftmp2(1,nsex,syr,nyrRetro,1,nseason,1,nclass);          ///> Fishing mortality

  // save the fishing mortality rates
  ftmp = F;  ftmp2 = F2;

  // standard deviations of assessment outcomes
  sd_log_recruits = log(recruits);
  
  int Ipnt = NRecPar;
  if (OutRecruit==YES)
   for (int h=1;h<=nsex;h++)
    for (int y=syr;y<=nyrRetro;y++)
     { ParsOut(Ipnt) = log(recruits(h,y)); Ipnt +=1; }
  sd_log_ssb = log(calc_ssb());
  Ipnt = NSSBPar;
  if (OutSSB==YES) 
   for (int y=syr;y<=nyrRetro;y++)
    { ParsOut(NSSBPar+y-syr) = sd_log_ssb(y); }

  //Added 13 lines by Jie
  sd_last_ssb = spr_depl * Bmsy;
  if (Outfbar==YES)
   for ( int y = syr; y <= nyrRetro; y++ )  ParsOut(NfbarPar+y-syr) = mean(F(1,y));

  // projection outcomes
  if (OutRefPars==YES)
   {
    ParsOut(NRefPars+1) = spr_rbar(1);
    ParsOut(NRefPars+2) = spr_rbar(2);
    ParsOut(NRefPars+3) = ssbF0;
    ParsOut(NRefPars+4) = Bmsy;
    ParsOut(NRefPars+5) = spr_depl;
    ParsOut(NRefPars+6) = spr_cofl;
   }

  // Zero catch
  F.initialize();
  for ( int h = 1; h <= nsex; h++ )
   for ( int i = syr; i <= nyrRetro; i++ )
    for ( int j = 1; j <= nseason; j++ )
     for ( int l = 1; l <= nclass; l++)
      F2(h,i,j,l) = 1.0e-10;
  calc_total_mortality();
  calc_initial_numbers_at_length();
  update_population_numbers_at_length();
  dyn_Bzero = calc_ssb()(syr,nyrRetro);

  if (OutDynB0==YES)
   for (int y=syr;y<=nyrRetro;y++)
    ParsOut(NB0Par+y-syr) = log(dyn_Bzero(y));

  // Actual catch
  F = ftmp;
  F2 = ftmp2;
  cout << "Here99" << endl;
  calc_total_mortality();
  calc_initial_numbers_at_length();
  update_population_numbers_at_length();

// =====================================================================================================================================

  /**
   * @brief Calculate sdnr and MAR
  **/
FUNCTION void get_all_sdnr_MAR()
  {
   for ( int k = 1; k <= nSurveys; k++ )
    {
     //dvector stdtmp = cpue_sd(k) * 1.0 / cpue_lambda(k);
     //dvar_vector restmp = elem_div(log(elem_div(obs_cpue(k), pre_cpue(k))), stdtmp) + 0.5 * stdtmp;
     //sdnr_MAR_cpue(k) = calc_sdnr_MAR(value(restmp));
    }
   for ( int k = 1; k <= nSizeComps; k++ )
    {
     sdnr_MAR_lf(k) = calc_sdnr_MAR(value(d3_res_size_comps(k)));
    }
   Francis_weights = calc_Francis_weights();
  }

// ---------------------------------------------------------------------------------------------------------

  /**
   * @brief find the standard deviation of the standardized residuals and their median
  **/
FUNCTION dvector calc_sdnr_MAR(dvector tmpVec)
  {
    dvector out(1,2);
    dvector tmp = fabs(tmpVec);
    dvector w = sort(tmp);
    out(1) = std_dev(tmpVec);                 // sdnr
    out(2) = w(floor(0.5*(size_count(w)+1))); // MAR
    return out;
  }

FUNCTION dvector calc_sdnr_MAR(dmatrix tmpMat)
  {
    dvector tmpVec(1,size_count(tmpMat));
    dvector out(1,2);
    int dmin,dmax;
    dmin = 1;
    for ( int ii = tmpMat.indexmin(); ii <= tmpMat.indexmax(); ii++ )
     {
      dmax = dmin + size_count(tmpMat(ii)) - 1;
      tmpVec(dmin,dmax) = tmpMat(ii).shift(dmin);
      dmin = dmax + 1;
     }
    dvector tmp = fabs(tmpVec);
    dvector w = sort(tmp);
    out(1) = std_dev(tmpVec);                 // sdnr
    out(2) = w(floor(0.5*(size_count(w)+1))); // MAR
    return out;
  }

// -------------------------------------------------------------------------------------------------------------------------------------------------

  /**
   * @brief Calculate Francis weights
   * @details this code based on equation TA1.8 in Francis(2011) should be changed so separate weights if by sex
   *
   * Produces the new weight that should be used.
  **/
FUNCTION dvector calc_Francis_weights()
  {
   int j,nobs;
   double Obs, Pre, Var;
   dvector lfwt(1,nSizeComps);

   for ( int k = 1; k <= nSizeComps; k++ )
    {
     nobs = nSizeCompRows(k);
     dvector resid(1,nobs);
     j = 1;
     resid.initialize();
     for ( int i = 1; i <= nSizeCompRows(k); i++ )
      {
       //cout << k << " " << i << " " << nSizeCompCols(k) << " "<< nclass << endl;
       //cout << d3_obs_size_comps(k,i) << endl;
       //cout << d3_pre_size_comps(k,i) << endl;
       //cout << mid_points << endl;
       Obs=0;Pre=0;Var=0;
       for (int l=1;l<=min(nSizeCompCols(k),nclass);l++)
        {
         Obs += d3_obs_size_comps(k,i,l)*mid_points(l);
         Pre += value(d3_pre_size_comps(k,i,l))*mid_points(l);
         Var += value(d3_pre_size_comps(k,i,l))*mid_points(l)*mid_points(l);
        }
       // Combined sex comps
       if (nSizeCompCols(k)>nclass)
       for (int l=nclass+1;l<=nSizeCompCols(k);l++)
        {
         Obs += d3_obs_size_comps(k,i,l)*mid_points(l-nclass);
         Pre += value(d3_pre_size_comps(k,i,l))*mid_points(l-nclass);
         Var += value(d3_pre_size_comps(k,i,l))*mid_points(l-nclass)*mid_points(l-nclass);
        }
       Var -= square(Pre);
       //cout << Obs << " " << Pre << " " << Var << endl;
       resid(j++) = (Obs - Pre) / sqrt(Var / size_comp_sample_size(k,i));
      }
     lfwt(k) = 1.0 / (square(std_dev(resid)) * ((nobs - 1.0) / (nobs * 1.0)));
    }
    return lfwt;
   }

  /**
   * @brief calculate effective sample size
   * @details Calculate the effective sample size
   *
   * @param observed proportions
   * @param predicted proportions
  **/

// -------------------------------------------------------------------------------------------------------------------------------------------------
  /**
  * Function to format a double using 'g'-type fprmatting in sprintf().
  * 
  * @param d
  * @return g-formatted adstring representation of d
  */
FUNCTION adstring strg(double d)
      char  buffer[50];
      sprintf(buffer,"%g",d);
      adstring tmp(buffer);
      return tmp;

  /**
  * Convert dvector to string of unquoted, space-separated values
  * @param v - dvector to format as csv string
  * @return - adstring
  */
FUNCTION adstring to_str(const dvector& v)
      int g=1;
      int mn = v.indexmin();
      int mx = v.indexmax();
      adstring s;
      if (g){
          s = strg(v(mn));
          for (int i=mn;i<mx;i++) s = s+" "+strg(v(i+1));
      } else {
          s = str(v(mn));
          for (int i=mn;i<mx;i++) s = s+" "+str(v(i+1));
      }
      return s;
  /**
  * Convert dvar_vector to string of unquoted, space-separated values
  * @param v - dvar_vector to format as csv string
  * @return - adstring
  */
FUNCTION adstring to_str(const dvar_vector& v)
      dvector vp = value(v);
      adstring s = to_str(vp);
      return s;

// =====================================================================================================================================

// Label 600: CreateOutput
FUNCTION CreateOutput
  int Ipar,Jpar,Npar,NparEst;
  int nnnn;                                                          //
  dvariable MaxGrad;                                                 //> Maximum gradient
  dvar_matrix SummaryTable(syr,nyr,1,5);
  dvar_matrix SummaryTableSD(syr,nyr,1,5);

  time(&finish);
  elapsed_time = difftime(finish,start);
  hour = long(elapsed_time)/3600;
  minute = long(elapsed_time)%3600/60;
  second = (long(elapsed_time)%3600)%60;

  adstring strMidpoints = to_str(mid_points);    ///> string with space-separated size bin midpoints

  get_all_sdnr_MAR();                                                ///> Output specific to diagnostics

  cout << "+--------------------------+" << endl;
  cout << "| Beginning report section |" << endl;
  cout << "+--------------------------+" << endl;
  //--Note on formatting Gmacsall.out (OutputFile1)---------------
  //--This output is formatted for human readability and R functionality. 
  //--All lines starting with "#" will be regarded in R as comments and dropped
  //--Scalars and short vectors should be written with the format
  //      OutFile1 << "descriptive name:    " << values << endl; 
  //--Long vectors should be written with the format (might be a bit more readable)
  //      OutFile1 << "descriptive name: vector" << endl;
  //      OutFile1 << values << endl;
  //--Matrices shiould be written with the format
  //      OutFile1 << "descriptive name: matrix" << endl;
  //      for (int r=1; r<=nrows; r++) OutFile1 << values(r) << endl;
  //      OutFile1 << ">EOM<" << endl; 
  //--Dataframes (mixed text and numbers) should be written with the format
  //      OutFile1 << "descriptive name: dataframe" << endl;
  //      for (int c=1; r<=ncols; c++) {OutFile1 << column_names(c) << " ";} OutFile1 << endl;
  //      for (int r=1; r<=nrows; r++) OutFile1 << values(r) << endl;
  //      OutFile1 << ">EOD<" << endl; 
  //--Lists of scalars, vectors, matrices, dataframes, and other lists can be achieved using the format
  //      OutFile1 << "descriptive name: list" << endl;
  //        statements to write scalars, vectors, etc. 
  //      OutFile1 << ">EOL<" << endl;
  //--Note that the appropriate termination indicator (">EOM<", ">EOD<", or ">EOL<") must be written 
  //--to the line folllowing the end of each matrix, dataframe, or list to inidcate the end of the object.
  //--
  //--The macros REPVEC and REPMAT can be used to simplify writing a scalar or vector (REPVEC) or matrix (REPMAT) 
  //--"simultaneously" to OutFile1 (Gmacsall.out), OutFile2 (gmacs.rep), and RepFile1 (gmacs.rep1) as 
  //       REPVEC(object) or REPMAT(object) 
  //--These macros automatically add the ": vector" or ": matrix" and ">EOM<" notations to the output to 
  //--OutFile1 and RepFile1.
  OutFile1.close();
  OutFile1.open("Gmacsall.out");
  OutFile2.close();
  OutFile2.open("gmacs.rep");
  RepFile1.close();
  RepFile1.open("gmacs.rep1");
  OutFile3.close();
  OutFile3.open("personal.rep");
  OutFile4.close();
  OutFile4.open("simdata.out");
  OutFile5.close();
  OutFile5.open("Gmacsall.std");
  
  // The header material
  OutFile1 << TheHeader << endl << endl;;
  RepFile1 << TheHeader << endl << endl;;
  OutFile1 << "#--Start time: " << ctime(&start) << endl;
  OutFile1 << "#--Finish time: " << ctime(&finish) << endl;
  OutFile1 << "#--Runtime: ";
  OutFile1 << hour << " hours, " << minute << " minutes, " << second << " seconds" << endl;
  OutFile1 << "#--Number of function evaluations: " << NfunCall << endl;
  OutFile1 << "#*******************************************" << endl;
 
  OutFile1 <<  setw(12) << setprecision(8) << setfixed() << endl;
  RepFile1 <<  setw(12) << setprecision(8) << setfixed() << endl;
  // The header material
  OutFile5 << TheHeader << endl;
  OutFile5 << "Par_No Est_No Paramter Estimate Standard Error" << endl;
  
  OutFile1 << "Stock being assessed: " << StockName << endl << endl;
  OutFile1 << "#--General information" << endl;
  OutFile1 << "Weight unit:                \t " << weightunit << endl;
  OutFile1 << "Numbers unit:               \t " << numbersunit << endl;
  OutFile1 << "Year_range:                 \t " << syr << " " << nyrRetro << " # actual data file end year is " << nyr << endl;
  OutFile1 << "Number of seasons:          \t " << nseason << endl;
  OutFile1 << "Number_of_fleets:           \t " << nfleet << endl;
  OutFile1 << "Fleets:                     \t "; for (int k=1;k<=nfleet;k++) OutFile1 << fleetname(k) << " "; OutFile1 << endl;
  OutFile1 << "Number of sexes:            \t " << nsex << endl;
  OutFile1 << "Number of shell conditions: \t " << nshell << endl;
  OutFile1 << "Number of maturity states:  \t " << nmature << endl;
  OutFile1 << "Number of size classes:     \t " << nclass << endl;
  OutFile1 << "Max size classes:           \t " << nSizeSex << endl;
  OutFile1 << "size_breaks:                \t " << size_breaks << endl;
  OutFile1 << "size_midpoints:             \t " << mid_points << endl;

  RepFile1 << "Stock being assessed: " << StockName << endl << endl;
  RepFile1 << "#--General information" << endl;
  RepFile1 << "Weight unit:                \t " << weightunit << endl;
  RepFile1 << "Numbers unit:               \t " << numbersunit << endl;
  RepFile1 << "Year_range:                 \t " << syr << " " << nyrRetro << " # actual data file end year is " << nyr << endl;
  RepFile1 << "Number of seasons:          \t " << nseason << endl;
  RepFile1 << "Number_of_fleets:           \t " << nfleet << endl;
  RepFile1 << "Fleets:                     \t "; for (int k=1;k<=nfleet;k++) RepFile1 << fleetname(k) << " "; RepFile1 << endl;
  RepFile1 << "Number of sexes:            \t " << nsex << endl;
  RepFile1 << "Number of shell conditions: \t " << nshell << endl;
  RepFile1 << "Number of maturity states:  \t " << nmature << endl;
  RepFile1 << "Number of size classes:     \t " << nclass << endl;
  RepFile1 << "Max size classes:           \t " << nSizeSex << endl;
  RepFile1 << "size_breaks:                \t " << size_breaks << endl;
  RepFile1 << "size_midpoints:             \t " << mid_points << endl;
  
  // Likelihood summary
  OutFile1 << endl << "#--Likelihoods-by-type (raw and weighted)" << endl;
  OutFile1 << "Likelihoods_by_type: list"<<endl;
  OutFile1 << "Catch_data: " << sum(nloglike(1)) << " " << sum(elem_prod(nloglike(1),catch_emphasis)) << endl;
  OutFile1 << "Index_data: " << sum(nloglike(2)) << " " << sum(elem_prod(nloglike(2),cpue_emphasis)) << endl;
  OutFile1 << "Size_data: " << sum(nloglike(3)) << " " << sum(elem_prod(nloglike(3),lf_emphasis)) << endl;
  OutFile1 << "Stock_recruitment: " << sum(nloglike(4)) << " " << sum(nloglike(4)) << endl;
  OutFile1 << "Tagging_data: " << sum(nloglike(5)) << " " << sum(nloglike(5)) << endl;
  OutFile1 << "Penalties: " << sum(elem_prod(nlogPenalty,Penalty_emphasis)) << endl;
  OutFile1 << "Priors: " << sum(priorDensity) << endl;
  OutFile1 << "Initial_size_structure: " << TempSS << endl;
  OutFile1 << "Total: " << objfun << endl;
  OutFile1 << ">EOL<"<<endl;
  OutFile1 << endl;

  // Likelihood summary
  OutFile1 << "#Likelihoods_by_type_and_fleet" << endl;
  OutFile1 << "--Likelihoods_by_type_and_fleet: list"<<endl;
    OutFile1 << "--Catches: list" << endl;
      OutFile1 << "Raw_likelihood: " << nloglike(1) << endl;
      OutFile1 << "Emphasis      : " << catch_emphasis << endl;
      OutFile1 << "Net_likelihood: " << elem_prod(nloglike(1),catch_emphasis) << endl;
    OutFile1 << ">EOL<"<<endl;
    OutFile1 << "--Index: list" << endl;
      OutFile1 << "Raw_likelihood: " << nloglike(2) << endl;
      OutFile1 << "Emphasis      : " << cpue_emphasis << endl;
      OutFile1 << "Net_likelihood: " << elem_prod(nloglike(2),cpue_emphasis) << endl;
    OutFile1 << ">EOL<"<<endl;
    OutFile1 << "--Size_composition: list" << endl;
      OutFile1 << "Raw_likelihood: " << nloglike(3) << endl;
      OutFile1 << "Emphasis      : " << lf_emphasis << endl;
      OutFile1 << "Net_likelihood: " << elem_prod(nloglike(3),lf_emphasis) << endl;
    OutFile1 << ">EOL<"<<endl;
    OutFile1 << "--Recruitment_penalities: list" << endl;
      OutFile1 << "Penalities    : " << nloglike(4) << endl;
    OutFile1 << ">EOL<"<<endl;
    OutFile1 << "--Tagging: list" << endl;
      OutFile1 << "Raw_likelihood: " << nloglike(5) << endl;
      OutFile1 << "Emphasis      : " << tag_emphasis << endl;
      OutFile1 << "Net_likelihood: " << nloglike(5)*tag_emphasis << endl;
    OutFile1 << ">EOL<"<<endl;
    OutFile1 << "--Growth_likelihood: list" << endl;
      OutFile1 << "Raw_likelihood    : " << nloglike(5) << endl;
    OutFile1 << ">EOL<"<<endl;
  OutFile1 << ">EOL<"<<endl<<endl;

  OutFile1 << "--Penalties: list" << endl;
    OutFile1 << "1. Mean_Fbar=0: " << nlogPenalty(1) << " " << Penalty_emphasis(1) << " " << nlogPenalty(1)*Penalty_emphasis(1) << endl;
    OutFile1 << "2. Mean_Fdev: " << nlogPenalty(2) << " " << Penalty_emphasis(2) << " " << nlogPenalty(2)*Penalty_emphasis(2) << endl;
    OutFile1 << "6. Rec_dev: " << nlogPenalty(6) << " " << Penalty_emphasis(6) << " " << nlogPenalty(6)*Penalty_emphasis(6) << endl;
    OutFile1 << "7. Sex_ratio: " << nlogPenalty(7) << " " << Penalty_emphasis(7) << " " << nlogPenalty(7)*Penalty_emphasis(7) << endl;
    OutFile1 << "8. Molt_prob: " << nlogPenalty(8) << " " << Penalty_emphasis(8) << " " << nlogPenalty(8)*Penalty_emphasis(8) << endl;
    OutFile1 << "9. Smooth_select: " << nlogPenalty(9) << " " << Penalty_emphasis(9) << " " << nlogPenalty(9)*Penalty_emphasis(9) << endl;
    OutFile1 << "10. Init_numbers: " << nlogPenalty(10) << " " << Penalty_emphasis(10) << " " << nlogPenalty(10)*Penalty_emphasis(10) << endl;
    OutFile1 << "11. Fdevs_(flt): " << nlogPenalty(11) << " " << Penalty_emphasis(11) << " " << nlogPenalty(11)*Penalty_emphasis(11) << endl;
    OutFile1 << "12. Fdovs_(flt): " << nlogPenalty(12) << " " << Penalty_emphasis(12) << " " << nlogPenalty(12)*Penalty_emphasis(12) << endl;
    OutFile1 << "13. SelDevs: " << nlogPenalty(13) << " " << Penalty_emphasis(13) << " " << nlogPenalty(13)*Penalty_emphasis(13) << endl;
    OutFile1 << endl;
    
    MaxGrad = 0;
    for (int i=1;i<=NEstPars;i++) if (fabs(gradientOut(i)) > fabs(MaxGrad)) MaxGrad = gradientOut(i);
    OutFile1 << "Maximum gradient: " << MaxGrad << endl;
  OutFile1 << ">EOL<" <<endl<<endl;
 
  
  // Estimated parameters
  // ====================
  OutFile1 << "--Estimated parameters: dataframe" << endl;
  OutFile1 << "Parameter_count Parameter_type Estimate Phase Lower_bound Upper_bound Status Penalty Gradient Standard_error Estimated_parameter_count" << endl;
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "Estimated parameters: dataframe" << endl;
  RepFile1 << "par_count par_type est phz lb ub status pen grd se est_par_cnt" << endl;

  Npar = 0; NparEst = 0;
  for (Ipar=1;Ipar<=ntheta;Ipar++)
   {
    Npar +=1;
    OutFile1 << Npar << " " << parname1(Npar) << ": " << theta(Ipar) << " " << theta_phz(Ipar) << " ";
    RepFile1 << Npar << " " << parname1(Npar) << "  " << theta(Ipar) << " " << theta_phz(Ipar) << " ";
    if ((theta_phz(Ipar) < 0) || (theta_phz(Ipar) > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if ((theta_phz(Ipar) > 0) && (theta_phz(Ipar) <= current_phase())) 
     { 
      NparEst +=1; CheckBounds(theta(Ipar),theta_lb(Ipar),theta_ub(Ipar));  
      OutFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << parname1(Npar) << " " << theta(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
  for (Ipar=1;Ipar<=n_Gpar;Ipar++)
   {
    Npar +=1;
    OutFile1 << Npar << " " << parname1(Npar)<< ": " << G_pars_est(Ipar) << " " << G_phz(Ipar) << " ";
    RepFile1 << Npar << " " << parname1(Npar)<< "  " << G_pars_est(Ipar) << " " << G_phz(Ipar) << " ";
    if ((G_phz(Ipar) < 0) || (G_phz(Ipar) > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if ((G_phz(Ipar) > 0) && (G_phz(Ipar) <= current_phase())) 
     { 
      NparEst +=1; CheckBounds(G_pars_est(Ipar),G_lb(Ipar),G_ub(Ipar));  
      OutFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << parname1(Npar) << " " << G_pars_est(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
   for (Ipar=1;Ipar<=n_Mpar;Ipar++)
   {
    Npar +=1;
    OutFile1 << Npar << " " << parname1(Npar)<< ": " << M_pars_est(Ipar) << " " << M_phz(Ipar) << " ";
    RepFile1 << Npar << " " << parname1(Npar)<< "  " << M_pars_est(Ipar) << " " << M_phz(Ipar) << " ";
    if ((M_phz(Ipar) < 0) || (M_phz(Ipar) > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if (M_phz(Ipar) > 0 && M_phz(Ipar) <= current_phase()) 
     { 
      NparEst +=1; CheckBounds(M_pars_est(Ipar),M_lb(Ipar),M_ub(Ipar));  
      OutFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << parname1(Npar) << " " << M_pars_est(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
  for (Ipar=1;Ipar<=n_Spar;Ipar++)
   {
    Npar +=1;
    OutFile1 << Npar << " " << parname1(Npar)<< ": " << S_pars_est(Ipar) << " " << S_phz(Ipar) << " ";
    RepFile1 << Npar << " " << parname1(Npar)<< "  " << S_pars_est(Ipar) << " " << S_phz(Ipar) << " ";
    if ((S_phz(Ipar) < 0) || (S_phz(Ipar) > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if (S_phz(Ipar) > 0 && S_phz(Ipar) <= current_phase()) 
     { 
      NparEst +=1; CheckBounds(S_pars_est(Ipar),S_lb(Ipar),S_ub(Ipar));  
      OutFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << parname1(Npar) << " " << S_pars_est(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
  for (Ipar=1;Ipar<=nfleet;Ipar++)
   {
    Npar +=1;
    anystring = "Log_fbar_"+fleetname(Ipar);
    OutFile1 << Npar << " " << anystring << ": " << log_fbar(Ipar) << " " << f_phz(Ipar) << " ";
    RepFile1 << Npar << " " << anystring << "  " << log_fbar(Ipar) << " " << f_phz(Ipar) << " ";
    if ((f_phz(Ipar) < 0) || (f_phz(Ipar) > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if (f_phz(Ipar) > 0 && f_phz(Ipar) <= current_phase()) 
     { 
      NparEst +=1; CheckBounds(log_fbar(Ipar),-1000.0,1000.0);  
      OutFile1 << priorDensity(NparEst) << " "<< gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " "<< gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << anystring << " " << log_fbar(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
  for (Ipar=1;Ipar<=nfleet;Ipar++)
   {
    Jpar = 0;
    for (int iy=syr;iy<=nyrRetro;iy++)
     for (int j=1;j<=nseason;j++)
      if (fhit(iy,j,Ipar) >0)
       {
        Jpar +=1;
        Npar +=1;
        anystring = "Log_fdev_"+fleetname(Ipar)+"_year_"+str(iy)+"_season_"+str(j);
        OutFile1 << Npar << " " << anystring << ": " << log_fdev(Ipar,Jpar) << " " << f_phz(Ipar) << " ";
        RepFile1 << Npar << " " << anystring << "  " << log_fdev(Ipar,Jpar) << " " << f_phz(Ipar) << " ";
        if ((f_phz(Ipar) < 0) || (f_phz(Ipar) > current_phase())) {
          RepFile1 << "NA NA NA NA NA NA NA " << endl;
        }
        if (f_phz(Ipar) > 0 && f_phz(Ipar) <= current_phase()) 
         { 
          NparEst +=1; CheckBounds(log_fdev(Ipar,Jpar),-1000.0,1000.0);  
          OutFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
          RepFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
          OutFile5 << Npar << " " << NparEst << " " << anystring << " " << log_fdev(Ipar,Jpar) << " " << ParsOut.sd(NparEst) << endl;
         }
        OutFile1 << endl;
        RepFile1 << endl;
      }  
    }
  for (Ipar=1;Ipar<=nfleet;Ipar++)
   {
    Npar +=1;
    anystring = "Log_foff_"+fleetname(Ipar);
    OutFile1 << Npar << " " << anystring << ": " << log_foff(Ipar) << " " << foff_phz(Ipar) << " ";
    RepFile1 << Npar << " " << anystring << "  " << log_foff(Ipar) << " " << foff_phz(Ipar) << " ";
    if ((foff_phz(Ipar) < 0) || (foff_phz(Ipar) > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if ((foff_phz(Ipar) > 0) && (foff_phz(Ipar) <= current_phase())) 
     { 
      NparEst +=1; CheckBounds(log_foff(Ipar),-1000.0,1000.0);  
      OutFile1 << priorDensity(NparEst) << " "<< gradientOut(NparEst) << " " << ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " "<< gradientOut(NparEst) << " " << ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << anystring << " " << log_foff(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
  for (Ipar=1;Ipar<=nfleet;Ipar++)
   {
    Jpar = 0;
    for (int iy=syr;iy<=nyrRetro;iy++)
     for (int j=1;j<=nseason;j++)
      if (yhit(iy,j,Ipar) >0)
       {
        Jpar +=1;
        Npar +=1;
        anystring = "Log_fdov_"+fleetname(Ipar)+"_year_"+str(iy)+"_season_"+str(j);
        OutFile1 << Npar << " " << anystring << ": " << log_fdov(Ipar,Jpar) << " " << foff_phz(Ipar) << " ";
        RepFile1 << Npar << " " << anystring << "  " << log_fdov(Ipar,Jpar) << " " << foff_phz(Ipar) << " ";
        if ((f_phz(Ipar) < 0) || (f_phz(Ipar) > current_phase())) {
          RepFile1 << "NA NA NA NA NA NA NA " << endl;
        }
        if (f_phz(Ipar) > 0 && f_phz(Ipar) <= current_phase()) 
         { 
          NparEst +=1; CheckBounds(log_fdov(Ipar,Jpar),-1000.0,1000.0);  
          OutFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
          RepFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
          OutFile5 << Npar << " " << NparEst << " " << anystring << " " << log_fdov(Ipar,Jpar) << " " << ParsOut.sd(NparEst) << endl;
         }
        OutFile1 << endl;
        RepFile1 << endl;
      }  
    }
  if (Jpar!=sum(nYparams))  
  for (int i=1;i<=sum(nYparams)-Jpar;i++)Npar = Npar + 1;
  for (Ipar=rdv_syr;Ipar<=rdv_eyr;Ipar++)
   {
    Npar +=1;
    OutFile1 << Npar << " Rec_dev_est_" << Ipar << ": " << rec_dev_est(Ipar) << " " << rdv_phz << " ";
    RepFile1 << Npar << " Rec_dev_est_" << Ipar << "  " << rec_dev_est(Ipar) << " " << rdv_phz << " ";
    if ((rdv_phz < 0) || (rdv_phz > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if (rdv_phz > 0 && rdv_phz <= current_phase()) 
     { 
      NparEst +=1; CheckBounds(rec_dev_est(Ipar),-8.0,8.0);  
      OutFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << "Rec_dev_est_"+str(Ipar) << " " << rec_dev_est(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
  for (Ipar=rdv_syr;Ipar<=rdv_eyr;Ipar++)
   {
    Npar +=1;
    OutFile1 << Npar << " Logit_rec_prop_est_" << Ipar << ": " << logit_rec_prop_est(Ipar) << " " << rec_prop_phz << " ";
    RepFile1 << Npar << " Logit_rec_prop_est_" << Ipar << "  " << logit_rec_prop_est(Ipar) << " " << rec_prop_phz << " ";
    if ((rec_prop_phz < 0) || (rec_prop_phz > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if (rec_prop_phz > 0 && rec_prop_phz <= current_phase()) 
     { 
      NparEst +=1; CheckBounds(logit_rec_prop_est(Ipar),-100.0,100.0);  
      OutFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << "Logit_rec_prop_est_"+str(Ipar) << " " << logit_rec_prop_est(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
  for (Ipar=1;Ipar<=nSizeComps;Ipar++)
   {
    Npar +=1;
    anystring = "Log_vn_size_comp_"+str(Ipar);
    OutFile1 << Npar << " " << anystring << " :  " << log_vn(Ipar) << " " << log_vn_phz(Ipar) << " ";
    RepFile1 << Npar << " " << anystring << "    " << log_vn(Ipar) << " " << log_vn_phz(Ipar) << " ";
    if ((log_vn_phz(Ipar) < 0) || (log_vn_phz(Ipar) > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if (log_vn_phz(Ipar) > 0 && log_vn_phz(Ipar) <= current_phase()) 
     { 
      NparEst +=1; CheckBounds(log_vn(Ipar),log_vn_lb(Ipar),log_vn_ub(Ipar));  
      OutFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << anystring << " " << log_vn(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
  for (Ipar=1;Ipar<=n_qpar;Ipar++)
   {
    Npar +=1;
    anystring = "Survey_q_survey_"+str(Ipar);
    OutFile1 << Npar << " " << anystring << ": " << survey_q(Ipar) << " " << q_phz(Ipar) << " ";
    RepFile1 << Npar << " " << anystring << "  " << survey_q(Ipar) << " " << q_phz(Ipar) << " ";
    if ((q_phz(Ipar) < 0) || (q_phz(Ipar) > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if (q_phz(Ipar) > 0 && q_phz(Ipar) <= current_phase()) 
     { 
      NparEst +=1; CheckBounds(survey_q(Ipar),q_lb(Ipar),q_ub(Ipar));  
      OutFile1 << priorDensity(NparEst) << " " <<gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " " <<gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << anystring << " " << survey_q(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
  for (Ipar=1;Ipar<=n_addcv_par;Ipar++)
   {
    Npar +=1;
    anystring = "Log_add_cvt_survey_"+str(Ipar);
    OutFile1 << Npar << " " << anystring << ": " << log_add_cv(Ipar) << " " << cv_phz(Ipar) << " ";
    RepFile1 << Npar << " " << anystring << "  " << log_add_cv(Ipar) << " " << cv_phz(Ipar) << " ";
    if ((cv_phz(Ipar) < 0) || (cv_phz(Ipar) > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if (cv_phz(Ipar) > 0 && cv_phz(Ipar) <= current_phase()) 
     { 
      NparEst +=1; CheckBounds(log_add_cv(Ipar),log_add_cv_lb(Ipar),log_add_cv_ub(Ipar));  
      OutFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " << ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " << ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << anystring << " " << log_add_cv(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
  for (Ipar=1;Ipar<=n_deviations_est;Ipar++)
   {
    Npar +=1;
    OutFile1 << Npar << " " << devnames1(Ipar) << ": " << par_devs(Ipar) << " " << deviations_phz(Ipar) << " ";
    RepFile1 << Npar << " " << devnames1(Ipar) << "  " << par_devs(Ipar) << " " << deviations_phz(Ipar) << " ";
    if ((deviations_phz(Ipar) < 0) || (deviations_phz(Ipar) > current_phase())) {
      RepFile1 << "NA NA NA NA NA NA NA " << endl;
    }
    if (deviations_phz(Ipar) > 0 && deviations_phz(Ipar) <= current_phase()) 
     { 
      NparEst +=1; CheckBounds(par_devs(Ipar),-12.0,12.0);  
      OutFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      RepFile1 << priorDensity(NparEst) << " " << gradientOut(NparEst) << " " <<ParsOut.sd(NparEst) << " " << NparEst; 
      OutFile5 << Npar << " " << NparEst << " " << devnames1(Ipar) << " " << par_devs(Ipar) << " " << ParsOut.sd(NparEst) << endl;
     }
    OutFile1 << endl;
    RepFile1 << endl;
   }
  OutFile1 << endl;
  OutFile1 << ">EOD<" <<endl;
  RepFile1 << endl;
  RepFile1 << ">EOD<" <<endl;
  OutFile1 << "#--------------------------------------------------------------------------------------------" << endl;

  // Derived quantities
  // ====================
  OutFile1 << "--Derived quatities: dataframe"<<endl;
  OutFile1 << "Parameter_name Estimate Standard_error Estimated_quantity_count" << endl;
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "Derived quatities: dataframe"<<endl;
  RepFile1 << "param est se qty_cnt" << endl;
  if (OutRefPars==YES)
   {
    OutFile1 << "Male Spr_rbar : "   << ParsOut(NparEst+1) << " " << ParsOut.sd(NparEst+1) << " " << NparEst+1 << endl;
    OutFile1 << "Female Spr_rbar : " << ParsOut(NparEst+2) << " " << ParsOut.sd(NparEst+2) << " " << NparEst+2 << endl;
    OutFile1 << "SSSB/R(F=0) : "     << ParsOut(NparEst+3) << " " << ParsOut.sd(NparEst+3) << " " << NparEst+3 << endl;
    OutFile1 << "BMSY : "            << ParsOut(NparEst+4) << " " << ParsOut.sd(NparEst+4) << " " << NparEst+4 << endl;
    OutFile1 << "Bcurr/BMSY : "      << ParsOut(NparEst+5) << " " << ParsOut.sd(NparEst+5) << " " << NparEst+5 << endl;
    OutFile1 << "OFL(tot) : "        << ParsOut(NparEst+6) << " " << ParsOut.sd(NparEst+6) << " " << NparEst+6 << endl;
    for (int k=1;k<=nfleet;k++)
      OutFile1 << "Fmsy (" << k <<") : " << ParsOut(NparEst+6+k)<< " " << ParsOut.sd(NparEst+6+k) << " " << NparEst+6+k << endl;
    for (int k=1;k<=nfleet;k++)
      OutFile1 << "Fofl (" << k <<") : " << ParsOut(NparEst+6+nfleet+k)<< " " << ParsOut.sd(NparEst+6+nfleet+k) << " " << NparEst+6+nfleet+k << endl;
    for (int k=1;k<=nfleet;k++)
      OutFile1 << "Ofl (" << k <<") : " << ParsOut(NparEst+6+2*nfleet+k)<< " " << ParsOut.sd(NparEst+6+2*nfleet+k) << " " << NparEst+6+2*nfleet+k << endl;
    //NparEst += 6+3*nfleet;  
    RepFile1 << "male_spr_rbar "   << ParsOut(NparEst+1) << " " << ParsOut.sd(NparEst+1) << " " << NparEst+1 << endl;
    RepFile1 << "female_spr_rbar " << ParsOut(NparEst+2) << " " << ParsOut.sd(NparEst+2) << " " << NparEst+2 << endl;
    RepFile1 << "SSSB/R(F=0) "     << ParsOut(NparEst+3) << " " << ParsOut.sd(NparEst+3) << " " << NparEst+3 << endl;
    RepFile1 << "BMSY "            << ParsOut(NparEst+4) << " " << ParsOut.sd(NparEst+4) << " " << NparEst+4 << endl;
    RepFile1 << "Bcurr/BMSY "      << ParsOut(NparEst+5) << " " << ParsOut.sd(NparEst+5) << " " << NparEst+5 << endl;
    RepFile1 << "OFL(tot) "        << ParsOut(NparEst+6) << " " << ParsOut.sd(NparEst+6) << " " << NparEst+6 << endl;
    for (int k=1;k<=nfleet;k++)
      RepFile1 << "Fmsy(" << k <<") " << ParsOut(NparEst+6+k)         << " " << ParsOut.sd(NparEst+6+k)          << " " << NparEst+6+k << endl;
    for (int k=1;k<=nfleet;k++)
      RepFile1 << "Fofl(" << k <<") " << ParsOut(NparEst+6+nfleet+k)  << " " << ParsOut.sd(NparEst+6+nfleet+k)   << " " << NparEst+6+nfleet+k << endl;
    for (int k=1;k<=nfleet;k++)
      RepFile1 << "OFL(" << k <<") "  << ParsOut(NparEst+6+2*nfleet+k)<< " " << ParsOut.sd(NparEst+6+2*nfleet+k) << " " << NparEst+6+2*nfleet+k << endl;
    NparEst += 6+3*nfleet;  
   }
  
  int IpntOut = 0;
  if (OutRecruit==YES) 
   {
    for (int h=1;h<=nsex;h++)
     for (int y=syr;y<=nyr;y++)
      {
 //      OutFile1 << "Log(rec) (" << h <<"," <<y<< ") : " << ParsOut(NRecPar+IpntOut)<< " " << ParsOut.sd(NRecPar+IpntOut) << " " << NRecPar+IpntOut << endl;
       SummaryTable(y,h) = ParsOut(NRecPar+IpntOut);
       SummaryTableSD(y,h) = ParsOut.sd(NRecPar+IpntOut);
       IpntOut += 1;
      }
     NparEst += IpntOut; 
   }  
  IpntOut = 0;   
  if (OutSSB==YES) 
   {
    for (int y=syr;y<=nyr;y++)
     {
 //     OutFile1 << "Log(ssb) (" <<y<< ") : " << ParsOut(NSSBPar+IpntOut)<< " " << ParsOut.sd(NSSBPar+IpntOut) << " " << NSSBPar+IpntOut << endl;
      SummaryTable(y,3) = ParsOut(NSSBPar+IpntOut);
      SummaryTableSD(y,3) = ParsOut.sd(NSSBPar+IpntOut);
      IpntOut += 1;
     }
     NparEst += IpntOut; 
   }  
  IpntOut = 0;   
  if (Outfbar==YES)
   {
    for (int y=syr;y<=nyr;y++)
     {
 //     OutFile1 << "Mean(f) (" <<y<< ") : " << ParsOut(NfbarPar+IpntOut)<< " " << ParsOut.sd(NfbarPar+IpntOut) << " " << NfbarPar+IpntOut << endl;
      SummaryTable(y,4) = ParsOut(NfbarPar+IpntOut);
      SummaryTableSD(y,4) = ParsOut.sd(NfbarPar+IpntOut);
      IpntOut += 1;
     }
     NparEst += IpntOut; 
   }  
  IpntOut = 0;   
  if (OutDynB0==YES)
   {
    for (int y=syr;y<=nyr;y++)
     {
 //     OutFile1 << "log(dyn ssb) (" <<y<< ") : " << ParsOut(NB0Par+IpntOut)<< " " << ParsOut.sd(NB0Par+IpntOut) << " " << NB0Par+IpntOut << endl;
      SummaryTable(y,5) = ParsOut(NB0Par+IpntOut);
      SummaryTableSD(y,5) = ParsOut.sd(NB0Par+IpntOut);
      IpntOut += 1;
     }
     NparEst += IpntOut; 
   }  
  OutFile1 << ">EOD<"<<endl<<endl;
  RepFile1 << ">EOD<"<<endl<<endl;
  dvariable sigR = mfexp(logSigmaR);
  OutFile1 << "SigmaR : " << sigR << endl;
  OutFile1 << " Weight : " << 0.5/(sigR*sigR) << endl;
  RepFile1 << "SigmaR: " << sigR << endl;
  RepFile1 << "Weight: " << 0.5/(sigR*sigR) << endl;

//=========================================================================================================================

  // Big summary
  OutFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile1 << "#Overall_summary" << endl;
  calc_predicted_catch_out();
  dvector ssb = value(calc_ssb());
  dvector ssba = value(calc_ssba());
  OutFile1 << "Summary: dataframe" << endl;
  OutFile1 << "Year SSB log(SSB) SD(log(SSB)) SSA Dynamic_B0 log(DynB0) SD(log(DynB0)) ";
  for (int h=1;h<=nsex;h++) OutFile1 << "Recruit_" << sexes(h) << " log(Recruits) SD(log(Recruits))" << " ";
  OutFile1 << "log(f)  SD(log(f)) ";
  OutFile1 << "Retained_mortality  Total_mortality ";
  for (int k=1;k<=nfleet;k++) OutFile1 << fleetname(k) << " ";
  OutFile1 << "Rec_dev logit_rec_prop res_recruit ";
  OutFile1 << endl;
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "Summary: dataframe" << endl;
  RepFile1 << "year SSB log(SSB) SD(log(SSB)) SSA DynB0 log(DynB0) SD(log(DynB0)) ";
  for (int h=1;h<=nsex;h++) RepFile1 << "rec_" << sexes(h) << " log(rec_" << sexes(h) << ") SD(log(rec_" << sexes(h) << "))" << " ";
  RepFile1 << "log(f)  SD(log(f)) ";
  RepFile1 << "ret_mortality  tot_mortality ";
  for (int k=1;k<=nfleet;k++) RepFile1 << fleetname(k) << " ";
  RepFile1 << "rec_dev logit_rec_prop res_rec ";
  RepFile1 << endl;
  for (int i=syr;i<=nyrRetro;i++)
   {
    OutFile1 << i << " " << ssb(i) << " " << SummaryTable(i,3) << " " << SummaryTableSD(i,3) << " " << ssba(i) << " ";
    OutFile1 << dyn_Bzero(i) << " " << SummaryTable(i,5) << " " << SummaryTableSD(i,5) << " ";
    for (int h=1;h<=nsex;h++) OutFile1 << recruits(h,i) << " " << SummaryTable(i,h) << " " << SummaryTableSD(i,h) << " ";
    OutFile1 << SummaryTable(i,4) << " " << SummaryTableSD(i,4) << " ";
    for (int k=1;k<=2+nfleet;k++) OutFile1 << histcat(k,i) << " ";
    OutFile1 << rec_dev(i) << " " << logit_rec_prop(i) << " " << res_recruit(i);
    OutFile1 << endl;

    RepFile1 << i << " " 
             << ssb(i) << " " 
             << SummaryTable(i,3) << " " 
             << SummaryTableSD(i,3) << " " 
             << ssba(i) << " "
             << dyn_Bzero(i) << " " 
             << SummaryTable(i,5) << " " 
             << SummaryTableSD(i,5) << " ";
    for (int h=1;h<=nsex;h++) RepFile1 << recruits(h,i) << " " << SummaryTable(i,h) << " " << SummaryTableSD(i,h) << " ";
    RepFile1 << SummaryTable(i,4) << " " 
             << SummaryTableSD(i,4) << " ";
    for (int k=1;k<=2+nfleet;k++) RepFile1 << histcat(k,i) << " ";
    RepFile1 << rec_dev(i) << " " 
             << logit_rec_prop(i) << " " 
             << res_recruit(i)
             << endl;
   }
   OutFile1 << ">EOD<" << endl;
   RepFile1 << ">EOD<" << endl;

//=========================================================================================================================

  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "R_z: dataframe" << endl;
  RepFile1 << "sex size est " << endl;
  for (int h=1;h<=nsex;h++) 
    for (int k = 1; k<=nclass;k++)
      RepFile1 << sexes(h) << " " << mid_points(k) << " " << rec_sdd(h,k) << endl;
  RepFile1 << ">EOD<" << endl;
  RepFile1 << "R_y: dataframe" << endl;
  RepFile1 << "year   est " << endl;
  for (int i=syr;i<=nyrRetro;i++) 
    RepFile1 << i << " " << totrecruits(i) << endl;
  RepFile1 << ">EOD<" << endl;
  RepFile1 << "R_yx: dataframe" << endl;
  RepFile1 << "year  sex  est " << endl;
  for (int i=syr;i<=nyrRetro;i++) 
   for (int h=1;h<=nsex;h++)
    RepFile1 << i << " " << sexes(h) << " " << recruits(h,i) << endl;
  RepFile1 << ">EOD<" << endl;

//=========================================================================================================================
   
  OutFile1 << endl;
  OutFile1 << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile1 << "BiomassByXM: dataframe" << endl;
  OutFile1 << endl << "Sex Maturity Year " << strMidpoints << endl; 
  OutFile1 << "#                  "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "#--the following individual crab weights are in kg" << endl;
  RepFile1 << "IndivWeightByXM: dataframe" << endl;
  RepFile1 << "Sex Maturity Year " << strMidpoints << endl; 
  for (int h=1;h<=nsex;h++)
   for (int m=1;m<=nmature;m++)
    for (int i=syr;i<=nyrRetro;i++){
     OutFile1 << sexes(h) << " " << m << " " << i << " " << mean_wt(h,m,i) << endl;
     RepFile1 << sexes(h) << " " << maturestate(m) << " " << i << " " << 1000000*mean_wt(h,m,i) << endl;
    }
  OutFile1 << ">EOD<" << endl;
  RepFile1 << ">EOD<" << endl;

  REPMAT(maturity);

//=========================================================================================================================

  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "logFM_parameters: dataframe"<<endl;
  RepFile1 << "param fleet index sex est" << endl;
  for (int k=1;k<=nfleet;k++) {
    RepFile1 << "log_fbar " << fleetname(k) << "  NA  " << " male " << log_fbar(k) << endl;
    RepFile1 << "log_foff " << fleetname(k) << "  NA  " << " female " << log_foff(k) << endl;
    for (int f=1;f<=nFparams(k);f++) 
      RepFile1 << "log_fdev " << fleetname(k) << " " << f << " " << " male " << log_fdev(k,f) << endl;
    for (int f=1;f<=nYparams(k);f++) 
      RepFile1 << "log_fdov " << fleetname(k) << " " << f << " " << " female " << log_fdov(k,f) << endl;
  }
  RepFile1 << ">EOD<" <<endl;

  // catches
  OutFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile1 << "Catch_fit_summary: dataframe" << endl;
  OutFile1 << "Series Year Fleet Season Sex Catch CV Type Units Mult Effort HM Predicted Residual" << endl;
  for (int iCatOut=1;iCatOut<=nCatchDF;iCatOut++)
   for (int irow=1;irow<=nCatchRows(iCatOut); irow++)
    if (int(dCatchData(iCatOut,irow,1)) >= syr && int(dCatchData(iCatOut,irow,1)) <= nyrRetro)
    {
     OutFile1 << iCatOut << " " << int(dCatchData(iCatOut,irow,1)) << " " << fleetname(dCatchData(iCatOut,irow,3)) << " " << int(dCatchData(iCatOut,irow,2));
     if (dCatchData(iCatOut,irow,4)==1) OutFile1 << " Male ";
     if (dCatchData(iCatOut,irow,4)==2) OutFile1 << " Female ";
     if (dCatchData(iCatOut,irow,4)==0) OutFile1 << " Both ";
     OutFile1 << dCatchData(iCatOut,irow,5) << " " << dCatchData(iCatOut,irow,6) << " ";
     if (dCatchData(iCatOut,irow,7)==1) OutFile1 << " Retained ";
     if (dCatchData(iCatOut,irow,7)==2) OutFile1 << " Discarded ";
     if (dCatchData(iCatOut,irow,7)==0) OutFile1 << " All ";
     if (dCatchData(iCatOut,irow,8)==1) OutFile1 << " Mass ";
     if (dCatchData(iCatOut,irow,8)==2) OutFile1 << " Numbers ";
     OutFile1 << dCatchData(iCatOut,irow,9) << " " << dCatchData(iCatOut,irow,10) << " " << dCatchData(iCatOut,irow,11) << " ";
     OutFile1 << pre_catch(iCatOut,irow) << " " << res_catch(iCatOut,irow);
     OutFile1 << endl;
    } // -- iCatOut and irow
  OutFile1 << ">EOD<" << endl;
  
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "Catch_fit_summary: dataframe" << endl;
  RepFile1 << "series year fleet season sex obs cv type units mult effort HM prd rsd" << endl;
  for (int iCatOut=1;iCatOut<=nCatchDF;iCatOut++)
   for (int irow=1;irow<=nCatchRows(iCatOut); irow++)
    if ((int(dCatchData(iCatOut,irow,1)) >= syr) && int(dCatchData(iCatOut,irow,1)) <= nyrRetro)
    {
     RepFile1 << iCatOut << " " << int(dCatchData(iCatOut,irow,1)) << " " 
                                << fleetname(dCatchData(iCatOut,irow,3)) << " "
                                << int(dCatchData(iCatOut,irow,2)) << " "
                                << sexes(dCatchData(iCatOut,irow,4)) << " "
                                << dCatchData(iCatOut,irow,5) << " " 
                                << dCatchData(iCatOut,irow,6) << " "
                                << catchtypes(dCatchData(iCatOut,irow,7)) << " "
                                << unitstypes(dCatchData(iCatOut,irow,8)) << " "
                                << dCatchData(iCatOut,irow,9) << " " 
                                << dCatchData(iCatOut,irow,10) << " " 
                                << dCatchData(iCatOut,irow,11) << " "
                                << pre_catch(iCatOut,irow) << " " 
                                << res_catch(iCatOut,irow) << endl;
    } // -- iCatOut and irow
  RepFile1 << ">EOD<" << endl;
  
  OutFile4 <<  setw(25) << setprecision(10) << setfixed() << endl;
  OutFile4 << "# pre_catch" << endl;
  OutFile4 << pre_catch << endl;

  REPVEC(log_q_catch);
  
  // index data
  OutFile1 << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile1 << "Index_fit_summary: dataframe" << endl;
  OutFile1 << "Series Year Fleet Season Sex Maturity Index base_CV actual_CV Units q  Time Predicted" << endl;
  RepFile1 << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "Index_fit_summary: dataframe" << endl;
  RepFile1 << "series year fleet season sex maturity obs base_CV actual_CV units q  time prd prsn_res" << endl;  
  for ( int k = 1; k <= nSurveyRows; k++ )
   if (((dSurveyData(k,1) <= nyrRetro) || ((dSurveyData(k,1) == nyrRetro+1) && (dSurveyData(k,2) == 1))) && dSurveyData(k,1) >= syr)
    {
     int i = dSurveyData(k,0);
     int j = dSurveyData(k,1);
     if ( cpue_lambda(i) != 1.0 )
       cpue_cv_add(k) = sqrt(exp(square(cpue_sd(k) * 1.0 / cpue_lambda(i))) - 1.0);
     else
       cpue_cv_add(k) = cpue_cv(k) + value(mfexp(AddVarQT(i,j)));
     OutFile1 << i << " " 
              << int(dSurveyData(k,1)) << " " 
              << fleetname(dSurveyData(k,3)) << " " 
              << int(dSurveyData(k,2))   << " "
              << sexes(dSurveyData(k,4)) << " "
              << maturestate(dSurveyData(k,5)) << " "
              << dSurveyData(k,6) << " " 
              << cpue_cv(k) << " " 
              << cpue_cv_add(k) << " "
              << unitstypes(dSurveyData(k,8)) << " "
              << SurveyQT(i,j) << " "
              << dSurveyData(k,9) << " " 
              << pre_cpue(k) << endl;
     RepFile1 << i << " " 
              << int(dSurveyData(k,1)) << " " 
              << fleetname(dSurveyData(k,3)) << " " 
              << int(dSurveyData(k,2))   << " "
              << sexes(dSurveyData(k,4)) << " "
              << maturestate(dSurveyData(k,5)) << " "
              << dSurveyData(k,6) << " " 
              << cpue_cv(k) << " " 
              << cpue_cv_add(k) << " "
              << unitstypes(dSurveyData(k,8)) << " "
              << SurveyQT(i,j) << " "
              << dSurveyData(k,9) << " " 
              << pre_cpue(k) << " " 
              << res_cpue_stdzd(k) << " "
              << endl;
   }
  OutFile1 << ">EOD<" << endl;
  RepFile1 << ">EOD<" << endl;

  OutFile4 <<  setw(25) << setprecision(10) << setfixed() << endl;
  OutFile4 << "# pre_cpue" << endl;
  OutFile4 << pre_cpue << endl;

  REPMAT(sdnr_MAR_cpue);

  // size data
  adstring MatName;
  adstring ShellName;
  OutFile1 << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile1 << "Size_fit_summary: dataframe" << endl;
  OutFile1 << "Original_series Modified_series Year Fleet  Season Sex  Type Shell  Maturity  Nsamp  DataVec_(obs) DataVec_(pred)" << endl;
  int oldk = 0;
  for (int ii=1; ii<=nSizeComps_in;ii++)
   {
    int k = iCompAggregator(ii);
    if ( oldk != k )
     for (int jj=1;jj<=nSizeCompRows_in(ii);jj++)
      if (d3_SizeComps_in(ii,jj,-7) <= nyrRetro || (d3_SizeComps_in(ii,jj,-7) == nyrRetro+1 && d3_SizeComps_in(ii,jj,-6) == 1) )
       {
        OutFile1 << ii << " " 
                 << k << " " 
                 << int(d3_SizeComps_in(ii,jj,-7)) << " " 
                 << fleetname(int(d3_SizeComps_in(ii,jj,-5))) << " " 
                 << int(d3_SizeComps_in(ii,jj,-6)) << " "
                 << sexes(d3_SizeComps_in(ii,jj,-4)) << " "
                 << catchtypes(d3_SizeComps_in(ii,jj,-3)) << " "
                 << shellstate(d3_SizeComps_in(ii,jj,-2)) << " "
                 << maturestate(d3_SizeComps_in(ii,jj,-1)) << " ";
        ShellName = shellstate(d3_SizeComps_in(ii,jj,-2));
        MatName   = maturestate(d3_SizeComps_in(ii,jj,-1));
        for (int kk=1;kk<=nSizeComps_in;kk++)
          if (kk!=ii && k == iCompAggregator(kk)) 
          {
            if (d3_SizeComps_in(kk,jj,-2)!=d3_SizeComps_in(ii,jj,-2)) ShellName = shellstate(0);
            if (d3_SizeComps_in(kk,jj,-1)!=d3_SizeComps_in(ii,jj,-1)) MatName   = maturestate(0);
          }
        OutFile1 << ShellName << " " 
                 << MatName << "  " 
                 << size_comp_sample_size(k,jj) << "   " 
                 << d3_obs_size_comps(k,jj) << "   " 
                 << d3_pre_size_comps(k,jj) << endl;
       }
      oldk = k;
    }//--ii loop
  OutFile1 << ">EOD<" << endl;
  
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "Size_fit_summary: dataframe" << endl;
  RepFile1 << "origID aggID year season fleet comp_type sex maturity shell_cond size inpSS inpN aggObs aggPrd aggRes" << endl;
  for (int idx=1;idx<=nMapInpToAggSizeComps;idx++){
    int kk = mapInpToAggSizeComps(idx)(1);//--input size comp df index
    int ii = mapInpToAggSizeComps(idx)(2);//--input size comp df row
    int jj = mapInpToAggSizeComps(idx)(3);//--input size comp df column
    int k  = mapInpToAggSizeComps(idx)(4);//--corresponding aggregated size comp df index
    int i  = mapInpToAggSizeComps(idx)(5);//--corresponding aggregated size comp df row
    int j  = mapInpToAggSizeComps(idx)(6);//--corresponding aggregated size comp df column
    int yr  = d3_SizeComps_in(kk,ii,-7);
    int ssn = d3_SizeComps_in(kk,ii,-6);
    int flt = d3_SizeComps_in(kk,ii,-5);
    int sex = d3_SizeComps_in(kk,ii,-4);
    int typ = d3_SizeComps_in(kk,ii,-3);
    int shl = d3_SizeComps_in(kk,ii,-2);
    int mat = d3_SizeComps_in(kk,ii,-1);
    int inN = d3_SizeComps_in(kk,ii, 0);
    RepFile1 << kk << " " << k << " " << yr << " " << ssn << " " 
             << fleetname(flt) << " " << catchtypes(typ) << " " 
             << sexes(sex) << " " << maturestate(mat) << " " << shellstate(shl) << " "
             << mid_points(jj) << " "
             << inN << " "
             << d3_SizeComps_in(kk,ii,jj) << " "
             << d3_obs_size_comps(k,i,j) << " "
             << d3_pre_size_comps(k,i,j) << " "
             << d3_res_size_comps(k,i,j) << " "
             << endl;
  }
  RepFile1 << ">EOD<" << endl;

//  int oldk = 0;
//  for (int ii=1; ii<=nSizeComps_in;ii++){
//    int iOrigSeries = ii;
//    int k = iCompAggregator(ii);
//    int iAggSeries = k;
//    if ( oldk != k ){
//      for (int jj=1;jj<=nSizeCompRows_in(ii);jj++){
//        int yr  = int(d3_SizeComps_in(ii,jj,-7));
//        int ssn = int(d3_SizeComps_in(ii,jj,-6));
//        if ((yr <= nyrRetro) || ((yr == nyrRetro+1) && ssn == 1) ){
//          RepFile1  << iOrigSeries << " " 
//                    << iAggSeries << " " 
//                    << yr << " " 
//                    << fleetname(int(d3_SizeComps_in(ii,jj,-5))) << " " 
//                    << ssn << " "
//                    << sexes(d3_SizeComps_in(ii,jj,-4)) << " "
//                    << catchtypes(d3_SizeComps_in(ii,jj,-3)) << " "
//                    << shellstate(d3_SizeComps_in(ii,jj,-2)) << " "
//                    << maturestate(d3_SizeComps_in(ii,jj,-1)) << " ";
//          ShellName = shellstate(d3_SizeComps_in(ii,jj,-2));
//          MatName   = maturestate(d3_SizeComps_in(ii,jj,-1));
//          for (int kk=1;kk<=nSizeComps_in;kk++){
//            //--loop back over size comp datasets to find whether aggregated size comp is over shell condition and/or maturity state
//            //--skip current size comp (kk==ii) and match input size comp with same aggregatror code (k == iCompAggregator(kk))
//            if (kk!=ii && k == iCompAggregator(kk)) {
//              if (d3_SizeComps_in(kk,jj,-2)!=d3_SizeComps_in(ii,jj,-2)) ShellName = shellstate(0);//--must be aggregating over shell condition
//              if (d3_SizeComps_in(kk,jj,-1)!=d3_SizeComps_in(ii,jj,-1)) MatName   = maturestate(0);//--must be aggregating over maturity
//              //--does above imply you can't aggregate over sex?
//            }
//          }
//          RepFile1 << ShellName << " " 
//                  << MatName << "  " 
//                  << size_comp_sample_size(k,jj) << "   " 
//                  << d3_obs_size_comps(k,jj) << "   " 
//                  << d3_pre_size_comps(k,jj) << endl;
//        }//--if
//      }//--jj
//    }//--oldk != k
//    oldk = k;
//  }//--ii: loop over input size comp datasets
  
  OutFile4 << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile4 << "# Size_data_summary1" << endl;
  OutFile4 << "#Year Season Fleet  Sex  Type  Shell  Maturity  Nsamp  DataVec_(obs) DataVec_(pred)" << endl;
  oldk = 0;
  for (int ii=1; ii<=nSizeComps_in;ii++)
   {
    int k = iCompAggregator(ii);
    if ( oldk != k )
     for (int jj=1;jj<=nSizeCompRows_in(ii);jj++)
      if (d3_SizeComps_in(ii,jj,-7) <= nyrRetro || (d3_SizeComps_in(ii,jj,-7) == nyrRetro+1 && d3_SizeComps_in(ii,jj,-6) == 1) )
       {
        for (int kk=-7;kk<=1;kk++) OutFile4 << int(d3_SizeComps_in(ii,jj,kk)) << " ";
        OutFile4 << size_comp_sample_size(k,jj) << "   ";
        OutFile4 << d3_obs_size_comps(k,jj) << "   ";
        OutFile4 << d3_pre_size_comps(k,jj) << endl;
       }
      oldk = k;
    }
  OutFile4 << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile4 << "# Size_data_summary2" << endl;
  OutFile4 << "#Year, Seas, Fleet,  Sex,  Type, Shell,  Maturity, Nsamp,  DataVec (obs), DataVec (pred)" << endl;
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   for ( int ii = 1; ii <= nSizeCompRows_in(kk); ii++ )
    {
     d3_obs_size_comps_out(kk,ii) = d3_obs_size_comps_in(kk,ii) / sum(d3_obs_size_comps_in(kk,ii));
     OutFile4 << d3_pre_size_comps_out(kk,ii) << endl;
     d3_pre_size_comps_out(kk,ii) = d3_pre_size_comps_in(kk,ii) / sum(d3_pre_size_comps_in(kk,ii));
     d3_res_size_comps_out(kk,ii) = d3_obs_size_comps_out(kk,ii) - d3_pre_size_comps_out(kk,ii); // WRONG, DARCY 29 jULY 2016
    }

   for ( int ii = 1; ii <= nSizeComps; ii++ )
   {
    // Set final sample-size for composition data for comparisons
    // size_comp_sample_size(ii) = value(mfexp(log_vn(ii))) * size_comp_sample_size(ii);//--20240723WTS: should not be doing this!
   }
  
  //output sample size multipliers for DM likelihoods: 20240723WTS
  OutFile1 << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile1 << "Sample_size_multipliers: dataframe" << endl;
  OutFile1 << "series  row  multiplier effective_ss  input_ss" << endl;
  for (int kk = 1; kk <= nSizeComps; kk++ ){
    //cout<<"kk = "<<kk<<"  th = ";
    double th = value(mfexp(log_vn(kk)));
    //cout<<th<< "  nSizeCompRows(kk) = " << nSizeCompRows(kk) << endl;
    for (int ii=1;ii<=nSizeCompRows(kk);ii++){
      double m = th; //--default (= 1 for most types)
      int    n = size_comp_sample_size(kk,ii)*lf_lambda(kk);//input sample size
      double e = m*n; 
      if (iSizeCompType(kk)==6) {
        //--DM alt type
        e = (1.0+n*th)/(1+th);
        m = 0; if (n>0) {m = e/n;}
      }
      OutFile1 << kk << "  " << ii << "  " << m << "  " << e << "  " << n << endl;
    }//--ii loop
  }//--kk loop
  OutFile1 << ">EOD<" << endl;

  OutFile1 << "#Size data: standard deviation and median" << endl;
  REPMAT(sdnr_MAR_lf); 
  OutFile1 << "#Size data: Francis multipliers" << endl;
  REPVEC(Francis_weights);

  // Selectivity-related outouts
  OutFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile1 << "#--Selectivity" << endl; //TODO: turn into a list of dataframes(?)

  OutFile1 << "slx_capture: dataframe" << endl;
  OutFile1 << "Year Sex Fleet Selectivity" << endl;
  for ( int i = syr; i <= nyrRetro+1; i++ ) for ( int h = 1; h <= nsex; h++ ) for ( int j = 1; j <= nfleet; j++ )
    OutFile1 << i << " " << sexes(h) << " " << fleetname(j) << " " << setw(12) << setprecision(8) << setfixed() << mfexp(log_slx_capture(j,h,i)) << endl;
  OutFile1 << ">EOD<" <<endl;

  OutFile1 << "slx_retaind: dataframe" << endl;
  OutFile1 << "Year Sex Fleet Retention" << endl;
  for ( int i = syr; i <= nyrRetro+1; i++ ) for ( int h = 1; h <= nsex; h++ ) for ( int j = 1; j <= nfleet; j++ )
    OutFile1 << i << " " << sexes(h) << " " << fleetname(j) << " " << setw(12) << setprecision(8) << setfixed() << mfexp(log_slx_retaind(j,h,i)) << endl;
  OutFile1 << ">EOD<" <<endl;

  OutFile1 << "slx_discard: dataframe" << endl;
  OutFile1 << "Year Sex Fleet Discard" << endl;
  for ( int i = syr; i <= nyrRetro+1; i++ ) for ( int h = 1; h <= nsex; h++ ) for ( int j = 1; j <= nfleet; j++ )
    OutFile1 << i << " " << sexes(h) << " " << fleetname(j) << " " << setw(12) << setprecision(8) << setfixed() << mfexp(log_slx_discard(j,h,i)) << endl;
  OutFile1 << endl;
  OutFile1 << ">EOD<" <<endl;

  OutFile2 << "slx_capture" << endl;
  for ( int i = syr; i <= nyrRetro; i++ ) for ( int h = 1; h <= nsex; h++ ) for ( int j = 1; j <= nfleet; j++ )
    OutFile2 << i << " " << sexes(h) << " " << fleetname(j) << " " << mfexp(log_slx_capture(j,h,i)) << endl;
  OutFile2 << "slx_retaind" << endl;
  for ( int i = syr; i <= nyrRetro; i++ ) for ( int h = 1; h <= nsex; h++ ) for ( int j = 1; j <= nfleet; j++ )
    OutFile2 << i << " " << sexes(h) << " " << fleetname(j) << " " << mfexp(log_slx_retaind(j,h,i)) << endl;
  OutFile2 << "slx_discard" << endl;
  for ( int i = syr; i <= nyrRetro; i++ ) for ( int h = 1; h <= nsex; h++ ) for ( int j = 1; j <= nfleet; j++ )
    OutFile2 << i << " " << sexes(h) << " " << fleetname(j) << " " << mfexp(log_slx_discard(j,h,i)) << endl;
  OutFile2 << endl;
    
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "selfcns: dataframe" << endl;
  RepFile1 << "type year sex fleet " << strMidpoints << endl;
  for ( int i = syr; i <= nyrRetro; i++ ) 
    for ( int h = 1; h <= nsex; h++ ) 
      for ( int j = 1; j <= nfleet; j++ ) {
        RepFile1 << "capture "  << i << " " << sexes(h) << " " << fleetname(j) << " " << mfexp(log_slx_capture(j,h,i)) << endl;
        RepFile1 << "retained " << i << " " << sexes(h) << " " << fleetname(j) << " " << mfexp(log_slx_retaind(j,h,i)) << endl;
        RepFile1 << "discard "  << i << " " << sexes(h) << " " << fleetname(j) << " " << mfexp(log_slx_discard(j,h,i)) << endl;
      }
  RepFile1 << ">EOD<" << endl;
    
  
  // Outout the selex controls 
  //AEP
  //OutFile1 << "# Select_control" << endl;
  //OutFile1 << "# Selex_no first_par_no Phase Start_block End_block Env_Link Env_Link_Var Rand_Walk Start_year_RW End_year_RW Sigma_RW" << endl;  
  //for (int i=1;i<=nslx;i++)
  // {
  //  OutFile1 <<  slx_control(i,1) << " " << slx_control(i,2);
  //  for (int j=11;j<=nslx_cols_in;j++) OutFile1 << " " << slx_control(i,j); 
  //  OutFile1 << endl;
  // }
    
  OutFile2 << endl << "Selectivity" << endl; 
  for ( int h = 1; h <= nsex; h++ ) for ( int j = 1; j <= nfleet; j++ )
   OutFile2 << syr << " " << h << " " << j << " " << mfexp(log_slx_capture(j,h,syr)) << endl; 
  for ( int h = 1; h <= nsex; h++ ) for ( int j = 1; j <= nfleet; j++ )
   OutFile2 << nyr << " " << h << " " << j << " " << mfexp(log_slx_capture(j,h,nyrRetro)) << endl; 
  OutFile2 << "retained" << endl; 
  OutFile2 << syr << " " << "1" << " " << "1" << " " << mfexp(log_slx_retaind(1,1,syr)) << endl;  
  OutFile2 << nyrRetro << " " << "1" << " " << "1" << " " << mfexp(log_slx_retaind(1,1,nyrRetro)) << endl;               
  
  OutFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile1 << "# Natural, Fishing and Total mortality" << endl;
  OutFile1 << endl << "# Proportion of M by season" << endl;
  OutFile1 << "m_prop: dataframe" << endl;
  OutFile1 << "Year" << " "; for (int i=1;i<=nseason;i++) OutFile1 << i << " "; OutFile1 << endl;
  for (int iyr=syr;iyr<=nyrRetro;iyr++)
   { OutFile1 << iyr << " " << m_prop(iyr) << endl; }
  OutFile1 << ">EOD<" << endl;

  OutFile1 << endl << "Natural_mortality-by-class: dataframe" << endl;
  OutFile1 << "Year Sex Maturity "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << endl << "Natural_mortality-by-class: dataframe" << endl;
  RepFile1 << "year sex maturity " << strMidpoints << endl;
  for (int h=1;h<=nsex;h++)
   for (int m=1;m<=nmature;m++)
    for (int iyr=syr;iyr<=nyrRetro;iyr++) { 
      OutFile1 << iyr << " " << sexes(h) << " " << maturestate(m) << " " << M(h,m,iyr) << endl; 
      RepFile1 << iyr << " " << sexes(h) << " " << maturestate(m) << " " << M(h,m,iyr) << endl; 
    }
  OutFile1 << ">EOD<" << endl;
  RepFile1 << ">EOD<" << endl << endl;

  OutFile1 << endl << "# Fully-selected fishing mortality-by-season by sex and fishery" << endl;
  OutFile1 << "Fully-selected_FM_by_season_sex_and_fishery: dataframe" << endl;
  OutFile1 << "Sex Fleet Year "; for (int i=1;i<=nseason;i++) OutFile1 << i << " "; OutFile1 << endl;
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "Fully-selected_FM_by_season_sex_and_fishery: dataframe" << endl;
  RepFile1 << "sex fleet year "; for (int i=1;i<=nseason;i++) RepFile1 << i << " "; RepFile1 << endl;
  for (int h=1;h<=nsex;h++)
   for (int k=1;k<=nfleet;k++)
    for (int iyr=syr;iyr<=nyrRetro;iyr++) { 
      OutFile1 << sexes(h) << " " << fleetname(k) << " " << iyr << " " << ft(k,h,iyr) << endl; 
      RepFile1 << sexes(h) << " " << fleetname(k) << " " << iyr << " " << ft(k,h,iyr) << endl; 
    } 
  OutFile1 << ">EOD<" << endl;
  RepFile1 << ">EOD<" << endl << endl;

  OutFile1 << endl << "# Fully-selected_fishing mortality by fleet" << endl;
  OutFile1 << "Fully-selected_FM_by_fleet: dataframe" << endl;
  OutFile1 << "Sex Year Season "; for (int i=1;i<=nfleet;i++) OutFile1 << fleetname(i) << " "; OutFile1 << endl;
  for (int h=1;h<=nsex;h++)
   for (int i=syr;i<=nyrRetro;i++)
    for (int j=1;j<=nseason;j++)
     {
      OutFile1 << sexes(h) << " " << i << " " << j << " ";
       for (int k=1;k<=nfleet;k++) OutFile1 << ft(k,h,i,j) << " ";
      OutFile1 << endl;
     }
  OutFile1 << ">EOD<" << endl;

  OutFile1 << endl << "# Fishing mortality-at-size by sex and season (Continuous)" << endl;
  OutFile1 << "FM-at-size_by_sex_and_season_(continuous): dataframe" << endl;
  OutFile1 << "Sex Year Season " << strMidpoints << endl;
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "FM-at-size_by_sex_and_season_(continuous): dataframe" << endl;
  RepFile1 << "sex year season " << strMidpoints << endl;
  for (int h=1;h<=nsex;h++)
   for (int iyr=syr;iyr<=nyrRetro;iyr++)
    for (int is=1;is<=nseason;is++) { 
      OutFile1 << sexes(h) << " " << iyr << " " << is << " " << F(h,iyr,is) << endl; 
      RepFile1 << sexes(h) << " " << iyr << " " << is << " " << F(h,iyr,is) << endl; 
    } 
  OutFile1 << ">EOD<" << endl;
  RepFile1 << ">EOD<" << endl << endl;

  OutFile1 << endl << "# Fishing mortality-at-size by sex and season (Discrete)" << endl;
  OutFile1 << "FM-at-size_by_sex_and_season_(discrete): dataframe" << endl;
  OutFile1 << "Sex Year Season "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
  for (int h=1;h<=nsex;h++)
   for (int iyr=syr;iyr<=nyrRetro;iyr++)
    for (int is=1;is<=nseason;is++)
     { OutFile1 << sexes(h) << " " << iyr << " " << is << " " << F2(h,iyr,is) << endl; } 
  OutFile1 << ">EOD<" << endl;

  
  OutFile1 << endl << "# Total mortality by size-class (continuous)" << endl;
  OutFile1 << "TM-by-size-class_(continuous): dataframe" << endl;
  OutFile1 << "Sex Maturity Year Season Total_mortality " << strMidpoints << endl;
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "TM-by-size-class_(continuous): dataframe" << endl;
  RepFile1 << "sex maturity year season " << strMidpoints << endl;
  for (int h=1;h<=nsex;h++)
   for(int m=1;m<=nmature;m++)
    for (int i=syr;i<=nyrRetro;i++)
     for (int j=1;j<=nseason;j++){
      OutFile1 << sexes(h) << " " << maturestate(m) << " " << i << " " << j << " " << Z(h,m,i,j) << endl;
      RepFile1 << sexes(h) << " " << maturestate(m) << " " << i << " " << j << " " << Z(h,m,i,j) << endl;
     }
  OutFile1 << ">EOD<" << endl;
  RepFile1 << ">EOD<" << endl;
  
  OutFile1 << endl << "# Total mortality by size-class (discrete)" << endl;
  OutFile1 << "TM-by-size-class_(discrete): dataframe" << endl;
  OutFile1 << "Sex Maturity Year Season Total_mortality "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
  for (int h=1;h<=nsex;h++)
   for( int m=1;m<=nmature;m++)
    for (int i=syr;i<=nyrRetro;i++)
     for (int j=1;j<=nseason;j++)
      OutFile1 << sexes(h) << " " << m << " " << i << " " << j << " " << Z2(h,m,i,j) << endl;
  OutFile1 << ">EOD<" << endl;
  
  OutFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile1 << "# Numbers-at-size" << endl;

  // Print total numbers at length
  dvar_matrix N_initial(1,n_grp,1,nclass);
  dvar_matrix N_total(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_males(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_females(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_males_new(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_females_new(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_males_old(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_females_old(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_males_mature(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_females_mature(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_males_imature(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_females_imature(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_males_imature_new(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_males_imature_old(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_males_mature_new(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_males_mature_old(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_females_imature_new(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_females_imature_old(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_females_mature_new(syr,nyrRetro+1,1,nclass);
  dvar_matrix N_females_mature_old(syr,nyrRetro+1,1,nclass);
  N_total.initialize();
  N_males.initialize();
  N_females.initialize();
  N_males_new.initialize();
  N_females_new.initialize();
  N_males_old.initialize();
  N_females_old.initialize();
  N_males_mature.initialize();
  N_males_imature.initialize();
  N_females_mature.initialize();
  N_females_imature.initialize();
  N_males_imature_new.initialize();
  N_males_imature_old.initialize();
  N_males_mature_new.initialize();
  N_males_mature_old.initialize();
  N_females_imature_new.initialize();
  N_females_imature_old.initialize();
  N_females_mature_new.initialize();
  N_females_mature_old.initialize();
  for ( int i = syr; i <= nyrRetro+1; i++ )
   for ( int l = 1; l <= nclass; l++ )
    for ( int k = 1; k <= n_grp; k++ )
     {
      if ( isex(k) == 1 )
       {
        N_males(i,l) += d4_N(k,i,season_N,l);
        if ( ishell(k) == 1 )
         N_males_new(i,l) += d4_N(k,i,season_N,l);
        if ( ishell(k) == 2 )
         N_males_old(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 1 )
         N_males_mature(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 2 )
         N_males_imature(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 2 && ishell(k)==1)
         N_males_imature_new(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 2 && ishell(k)==2)
         N_males_imature_old(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 1 && ishell(k)==1)
         N_males_mature_new(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 1 && ishell(k)==2)
         N_males_mature_old(i,l) += d4_N(k,i,season_N,l);
       }
      else
       {
        N_females(i,l) += d4_N(k,i,season_N,l);
        if ( ishell(k) == 1 )
         N_females_new(i,l) += d4_N(k,i,season_N,l);
        if ( ishell(k) == 2 )
         N_females_old(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 1 )
         N_females_mature(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 2 )
         N_females_mature(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 2 && ishell(k)==1)
         N_females_imature_new(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 2 && ishell(k)==2)
         N_females_imature_old(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 1 && ishell(k)==1)
         N_females_mature_new(i,l) += d4_N(k,i,season_N,l);
        if ( imature(k) == 1 && ishell(k)==2)
         N_females_mature_old(i,l) += d4_N(k,i,season_N,l);
       }
      N_total(i,l) += d4_N(k,i,season_N,l);
     }

  for ( int k = 1; k <= n_grp; k++ )  N_initial(k) = d4_N(k)(syr)(1);

  int LastYrforN; 
  LastYrforN =nyrRetro; if (season_N==1) LastYrforN =nyrRetro+1;
  OutFile1 << endl << "# N(total)" << endl;
  OutFile1 << endl << "N(total): dataframe" << endl;
  OutFile1 << "Year "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
  for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " " << N_total(i) << endl;
  OutFile1 << ">EOD<" << endl;

  OutFile1 << endl << "# N(males)" << endl;
  OutFile1 << endl << "N(males): dataframe" << endl;
  OutFile1 << "Year "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
  for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " " << N_males(i) << endl;
  OutFile1 << ">EOD<" << endl;
  if (nsex > 1) 
   {
    OutFile1 << endl << "# N(females)" << endl;
    OutFile1 << endl << "N(females): dataframe" << endl;
    OutFile1 << "Year "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " " << N_females(i) << endl;
    OutFile1 << ">EOD<" << endl;
   }
  OutFile1 << endl << "# N(males_new)" << endl;
  OutFile1 << endl << "N(males_new): dataframe" << endl;
  OutFile1 << "Year "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
  for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " " << N_males_new(i) << endl;
  OutFile1 << ">EOD<" << endl;
  if (nsex > 1) 
   {
    OutFile1 << endl << "# N(females_new)" << endl;
    OutFile1 << endl << "N(females_new): dataframe" << endl;
    OutFile1 << "Year "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " " << N_females_new(i) << endl;
    OutFile1 << ">EOD<" << endl;
   }
  OutFile1 << endl << "# N(males_old)" << endl;
  OutFile1 << endl << "N(males_old): dataframe" << endl;
  OutFile1 << "Year "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
  for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " " << N_males_old(i) << endl;
  OutFile1 << ">EOD<" << endl;
  if (nsex > 1) 
   {
    OutFile1 << endl << "# N(females_old)" << endl;
    OutFile1 << endl << "N(females_old): dataframe" << endl;
    OutFile1 << "Year "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " " << N_females_old(i) << endl;
    OutFile1 << ">EOD<" << endl;
   }
  OutFile1 << endl << "# N(males_mature)" << endl;
  OutFile1 << endl << "N(males_mature): dataframe" << endl;
  OutFile1 << "Year "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
  for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " " << N_males_mature(i) << endl;
  OutFile1 << ">EOD<" << endl;
  if (nsex > 1) 
   {
    OutFile1 << endl << "# N(females_mature)" << endl;
    OutFile1 << endl << "N(females_mature): dataframe" << endl;
    OutFile1 << "Year "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " " << N_females_mature(i) << endl;
    OutFile1 << ">EOD<" << endl;
   }
  OutFile1 << endl << "# N(males_immature)" << endl;
  OutFile1 << endl << "N(males_immature): dataframe" << endl;
  OutFile1 << "Year "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
  for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " " << N_males_imature(i) << endl;
  OutFile1 << ">EOD<" << endl;
  if (nsex > 1) 
   {
    OutFile1 << endl << "# N(females_immature)" << endl;
    OutFile1 << "N(females_immature): dataframe" << endl;
    OutFile1 << "Year "; for (int i=1;i<=nclass;i++) OutFile1 << i << " "; OutFile1 << endl;
     for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " " << N_females_imature(i) << endl;
    OutFile1 << ">EOD<" << endl;
   }
  
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "N_YXMSZ: dataframe" << endl;
  RepFile1 << "year sex maturity shell_con " << strMidpoints << endl;
  for (int ig=1;ig<=n_grp;ig++){
    int ix = isex(ig); int im = imature(ig); int ic = ishell(ig);
    for (int i=syr;i<=LastYrforN;i++)
      RepFile1 << i << " " << sexes(ix) << " " << maturestate(im) << " " << shellstate(ic) << " " 
               << d4_N(ig,i,season_N) << endl;
  }
  RepFile1 << ">EOD<" << endl;

  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "B_YXMSZ: dataframe" << endl;
  RepFile1 << "year sex maturity shell_con " << strMidpoints << endl;
  for (int ig=1;ig<=n_grp;ig++){
    int ix = isex(ig); int im = imature(ig); int ic = ishell(ig);
    for (int i=syr;i<=LastYrforN;i++) {
      RepFile1 << i << " " << sexes(ix) << " " << maturestate(im) << " " << shellstate(ic) << " " 
               << elem_prod(d4_N(ig,i,season_N),mean_wt(ix,im,i)) << endl;
    }
  }
  RepFile1 << ">EOD<" << endl;
  
  OutFile1 << "N(sex_maturity_shell_con): dataframe" << endl;
  OutFile1 << "year sex maturity shell_con " << strMidpoints << endl;
  for (int ig=1;ig<=n_grp;ig++)
   if (isex(ig)==1 && ishell(ig)==1 && imature(ig)==2)
   {
    OutFile1 << endl << "# N(males_imature_new)" << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " male immature new_shell " << N_males_imature_new(i) << endl;
   }
  for (int ig=1;ig<=n_grp;ig++)
   if (isex(ig)==1 && ishell(ig)==2 && imature(ig)==2)
   {
    OutFile1 << endl << "# N(males_imature_old)" << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " male immature old_shell " << N_males_imature_old(i) << endl;
   }
  for (int ig=1;ig<=n_grp;ig++)
   if (isex(ig)==1 && ishell(ig)==1 && imature(ig)==1)
   {
    OutFile1 << endl << "# N(males_mature_new)" << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " male mature new_shell " << N_males_mature_new(i) << endl;
   }
  for (int ig=1;ig<=n_grp;ig++)
   if (isex(ig)==1 && ishell(ig)==2 && imature(ig)==1)
   {
    OutFile1 << endl << "# N(males_mature_old)" << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " male mature old_shell " << N_males_mature_old(i) << endl;
   }
  for (int ig=1;ig<=n_grp;ig++)
   if (isex(ig)==2 && ishell(ig)==1 && imature(ig)==2)
   {
    OutFile1 << endl << "# N(females_imature_new)" << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " female immature new_shell " << N_females_imature_new(i) << endl;
   }
  for (int ig=1;ig<=n_grp;ig++)
   if (isex(ig)==1 && ishell(ig)==2 && imature(ig)==2)
   {
    OutFile1 << endl << "# N(females_imature_old)" << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " female immature old_shell " << N_females_imature_old(i) << endl;
   }
  for (int ig=1;ig<=n_grp;ig++)
   if (isex(ig)==1 && ishell(ig)==1 && imature(ig)==1)
   {
    OutFile1 << endl << "# N(females_mature_new)" << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " female mature new_shell " << N_females_mature_new(i) << endl;
   }
  for (int ig=1;ig<=n_grp;ig++)
   if (isex(ig)==1 && ishell(ig)==2 && imature(ig)==1)
   {
    OutFile1 << endl << "# N(females_mature_old)" << endl;
    for (int i=syr;i<=LastYrforN;i++) OutFile1 << i << " female mature old_shell " << N_females_mature_old(i) << endl;
   }
  OutFile1 << ">EOD<" << endl;
  
  
  OutFile1 << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile1 << "#Molting and growth" << endl;
  OutFile1 << endl << "Molt probability: dataframe" << endl;
  OutFile1 << "Sex Year " << strMidpoints << endl; 
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "Molt probability: dataframe" << endl;
  RepFile1 << "sex year " << strMidpoints << endl; 
  for (int h=1; h<=nsex; h++)
   for (int i=syr;i<=nyrRetro;i++){
    OutFile1 << sexes(h) << " " << i << " " << molt_probability(h,i) << endl;
    RepFile1 << sexes(h) << " " << i << " " << molt_probability(h,i) << endl;
   }
  OutFile1 << ">EOD<" << endl;
  RepFile1 << ">EOD<" << endl;

  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "Mean growth: dataframe" << endl;
  RepFile1 << "sex block premolt_size mean_increment  mean_postmolt_size" << endl; 
  for (int h=1; h<=nsex; h++)
   for (int k =1; k<=nSizeIncVaries(h);k++)
    for (int l=1;l<=nclass; l++)
      RepFile1 << sexes(h) << " " 
               << k << " " 
               << mid_points(l) << " "
               << molt_increment(h,k,l) << " " 
               << molt_increment(h,k,l) + mid_points(l) << " " 
               << endl;
  RepFile1 << ">EOD<" << endl;

  OutFile1 << endl << "# Growth_transition_matrix" << endl;
  for (int h=1; h<=nsex; h++)
   for (int i=1;i<=nSizeIncVaries(h);i++)
    {
     OutFile1 << "#growth_matrix for (sex, increment_no): " << sexes(h) << " " << i << endl;
     OutFile1 << "growth_matrix_"<<sexes(h)<<"_"<<i<<": matrix" << endl;
     OutFile1 << trans(growth_transition(h,i)) << endl;
     OutFile1 << ">EOM<" << endl;
     OutFile2 << "#growth_matrix_" << sexes(h) << "_" << i << endl;
     OutFile2 << trans(growth_transition(h,i)) << endl;
    }
  OutFile1 << endl;

  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "growth_matrix: dataframe" << endl;
  RepFile1 << "sex block premolt_size " << strMidpoints <<endl; 
  for (int h=1; h<=nsex; h++) {
    for (int i=1;i<=nSizeIncVaries(h);i++){ 
      for (int j=1;j<=nclass;j++)
        RepFile1 << sexes(h) << " " << i << " " << mid_points(j) << " " << to_str(growth_transition(h,i,j)) << endl;
    }
  }
  RepFile1 << ">EOD<" << endl;

  OutFile1 << "# Size_transition_matrices" << endl;
  for (int h=1; h <= nsex; h++)
   for (int i=1;i<=nSizeIncVaries(h);i++)
    {
     OutFile1 << "#size_matrix for (sex, increment_no): " << sexes(h) << " " << i << endl;
     OutFile1 << "size_matrix_"<<sexes(h)<<"_"<<i << ": matrix" << endl;
     for (int k1=1;k1<=nclass;k1++)
      {
       for (int k2=1;k2<=nclass;k2++) 
        if (k2<k1)
         OutFile1 << 0 << " ";
        else 
         if (k2==k1)
          OutFile1 << 1.0-molt_probability(h,syr,k1)+growth_transition(h,i,k1,k2)*molt_probability(h,syr,k1) << " ";
         else 
          OutFile1 << growth_transition(h,i,k1,k2)*molt_probability(h,syr,k1) << " ";
       OutFile1 << endl;
      }
      OutFile1 << ">EOM<" << endl;
    }

  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl;
  RepFile1 << "size_matrix: dataframe" << endl;
  RepFile1 << "sex block premolt_size " << strMidpoints << endl;
  for (int h=1; h <= nsex; h++)
   for (int i=1;i<=nSizeIncVaries(h);i++)
    {
     for (int k1=1;k1<=nclass;k1++)
      {
       RepFile1 << sexes(h) << " " << i << " " << mid_points(k1) << " ";
       for (int k2=1;k2<=nclass;k2++) 
        if (k2<k1)
         RepFile1 << 0 << " ";
        else 
         if (k2==k1)
          RepFile1 << 1.0-molt_probability(h,syr,k1)+growth_transition(h,i,k1,k2)*molt_probability(h,syr,k1) << " ";
         else 
          RepFile1 << growth_transition(h,i,k1,k2)*molt_probability(h,syr,k1) << " ";
       RepFile1 << endl;
      }//--k1
    }//--i, h
    RepFile1 << ">EOD<" << endl;

  // Mature probability
  if (nmature==2)
   {
    OutFile1 << endl << "# Mature probability" << endl;
    OutFile1 << "mature_probability: dataframe" << endl;
    OutFile1 << "Sex Year " << strMidpoints << endl; 
    RepFile1 << "prMature: dataframe" << endl;
    RepFile1 << "sex year " << strMidpoints << endl; 
    for (int h=1; h<=nsex; h++)
     for (int i=syr;i<=nyrRetro;i++){
      OutFile1 << sexes(h) << " " << i << " " << mature_probability(h,i) << endl;
      RepFile1 << sexes(h) << " " << i << " " << mature_probability(h,i) << endl;
     }
    OutFile1 << ">EOD<" << endl;
    RepFile1 << ">EOD<" << endl;
   }

	
// Special output
  if (verbose > 3) cout<<"writing MyOutput"<<endl;
  MyOutput();
  if (verbose > 3) cout<<"Finished MyOutput"<<endl;

  // Projection stuff
  if ( last_phase() || NfunCall == StopAfterFnCall)
   {
    cout<<"last phase"<<endl;
    OutFile1 << endl;

    OutFile1 << "#--------------------------------------------------------------------------------------------" << endl;
    OutFile1 << "# Reference points" << endl;

    OutFile1 << "# Which combinations of season (rows) and fleet (column) have F>0 in the forecast?" << endl;
    OutFile1 << "fhitfut: matrix" <<endl;
    for (int j=1;j<=nseason;j++)
     {
      OutFile1 << " " << j << " ";
      for (int g=1;g<=nfleet;g++) OutFile1 << fhitfut(j,g) << " ";
      OutFile1 << endl;
     }
     OutFile1 << ">EOM<" << endl;

    // calculate the reference points
    if (CalcRefPoints!=0 && nyrRetroNo==0) calc_spr_reference_points2(1);

    OutFile1 << "#----------------------------" << endl;
    OutFile1 << "#- Reference points and OFL -" << endl;
    OutFile1 << "#----------------------------" << endl;

    REPVEC(spr_syr);
    REPVEC(spr_nyr);
    REPVEC(spr_rbar);
    REPVEC(proj_rbar);
    REPVEC(spr_sexr);
    OutFile1 << "SR_alpha_prj: ";
    OutFile1 << setw(15) << setprecision(8) << setfixed() << SR_alpha_prj << endl;
    OutFile1 << "SR_beta_prj: ";
    OutFile1 << setw(15) << setprecision(8) << setfixed() <<  SR_beta_prj << endl;
    REPVEC2(spr_fofl);
    REPVEC(spr_cofl_ret);
    if (Compute_yield_prj==1) {
      REPMAT(spr_yield);
      //OutFile1 << ">EOM<" << endl;
    }
   }

  OutFile1 << "#--------------------------------------------------------------------------------------------" << endl;
  OutFile1 << "#Simple likelihood" << endl;

  for (int j=1;j<=nlikes;j++){
    OutFile1 << "nloglike[" <<j<<"]: "<< nloglike[j] <<endl;
    OutFile2 << "nloglike[" <<j<<"]: "<< nloglike[j] <<endl;
  }
  REPVEC(nlogPenalty);
  REPVEC(priorDensity);
  OutFile1 << endl;

  //================================================
  //==Report likelihood to .REP file  
    // Likelihood summary
  OutFile2 << "Catches_like" << endl;
  OutFile2 <<  elem_prod(nloglike(1),catch_emphasis) << endl;
  OutFile2 << "Index_like" << endl;
  OutFile2 << elem_prod(nloglike(2),cpue_emphasis) << endl;
  OutFile2 << "Size_comp_like" << endl;
  OutFile2 << elem_prod(nloglike(3),lf_emphasis) << endl;
  OutFile2 << "Recruit_pen" << endl;
  OutFile2 <<  nloglike(4) << endl;
  OutFile2 << "Growth_like" << endl;
  OutFile2 <<  nloglike(5) << endl;

  OutFile2 << "MeanF_pen " << endl;
  OutFile2 << nlogPenalty(1)*Penalty_emphasis(1) << endl;
  OutFile2 << "MeanF_dev"  <<endl;
  OutFile2 << nlogPenalty(2)*Penalty_emphasis(2) << endl;
  OutFile2 << "Rec_dev" << endl;
  OutFile2 << nlogPenalty(6)*Penalty_emphasis(6) << endl;
  OutFile2 << "Sex_ratio" << endl;
  OutFile2 << nlogPenalty(7)*Penalty_emphasis(7) << endl;
  OutFile2 << "Molt_prob_smooth" <<endl;
  OutFile2 << nlogPenalty(8)*Penalty_emphasis(8) << endl;
  OutFile2 << "Free_sel_smooth" <<endl;
  OutFile2 << nlogPenalty(9)*Penalty_emphasis(9) << endl;
  OutFile2 << "Initial_estimated_numbers_at_length" <<endl;
  OutFile2 << nlogPenalty(10)*Penalty_emphasis(10) << endl;
  OutFile2 << "Fevs (flt)" <<endl;
  OutFile2 << nlogPenalty(11)*Penalty_emphasis(11) << endl;
  OutFile2 << "Fdovs (flt)" <<endl;
  OutFile2 << nlogPenalty(12)*Penalty_emphasis(12) << endl;
  OutFile2 << endl;

  WriteFiles();
   
// =====================================================================================================================================

// Andre done from here

REPORT_SECTION
  CreateOutput();
  save_gradients(gradients);
  if (last_phase()) for (int i=1;i<=NEstPars;i++) gradientOut(i) = gradients(i);
  
  cout<<"Finished REPORT_SECTION"<<endl;

// =====================================================================================================================================

FUNCTION WriteFiles

  OutInpFile1.close();
  OutInpFile1.open("gmacs_out.dat");
  
  OutInpFile1 << "#========================================================================================================" << endl;
  OutInpFile1 << " # Gmacs Main Data File" << endl;
  OutInpFile1 << syr << " # Start year" << endl;
  OutInpFile1 << nyr << " # End year" << endl;
  OutInpFile1 << nseason << " # Number of seasons" << endl;
  OutInpFile1 << nfleet << " # Number of distinct data groups (fleet, among fishing fleets and surveys)" << endl;
  OutInpFile1 << nsex << " # Number of sexes" << endl;
  OutInpFile1 << nshell << " # Number of shell condition types" << endl;
  OutInpFile1 << nmature << " # Number of maturity types" << endl;
  OutInpFile1 << nclass << " # Number of size-classes in the model" << endl;
  OutInpFile1 << season_recruitment << " # Season recruitment occurs" << endl;
  OutInpFile1 << season_growth << " # Season molting and growth occurs" << endl;
  OutInpFile1 << season_ssb << " # Season to calculate SSB (changed to match Feb mating)" << endl;
  OutInpFile1 << season_N << " # Season for N output" << endl;

  OutInpFile1 << "# maximum size-class (males then females)" << endl;
  OutInpFile1 << nSizeSex << endl;
  OutInpFile1 << "# size_breaks (a vector giving the break points between size intervals with dimension nclass+1)" << endl;
  OutInpFile1 << size_breaks << endl;
  OutInpFile1 << "# Natural mortality per season input type (1 = vector by season, 2 = matrix by season/year)" << endl;
  OutInpFile1 << m_prop_type << endl;
  OutInpFile1 << "# Proportion of the total natural mortality to be applied each season" << endl;
  OutInpFile1 << m_prop_in << endl << endl;
  OutInpFile1 << "# Fishing fleet and survey names" << endl;
  OutInpFile1 << fleetname << endl;
  OutInpFile1 << "# Are the seasons instantaneous (0) or continuous (1)" << endl;
  OutInpFile1 << season_type << endl;
  
  OutInpFile1 << "\n"<<endl;
  OutInpFile1 << "##------------------------------------------------------------" << endl;
  OutInpFile1 << "##--CATCH DATA------------------------------------------------" << endl;
  OutInpFile1 << "##------------------------------------------------------------" << endl;
  OutInpFile1 << " 0 #--input catch data format (0: old format, 1: new format)" << endl;
  OutInpFile1 << "# Number of catch data frames" << endl;
  OutInpFile1 << nCatchDF << endl;
  OutInpFile1 << "# Number of rows in each data frame" << endl;
  OutInpFile1 << nCatchRows << endl << endl;
  
  OutInpFile1 << endl << "##  CATCH DATA" << endl;
  OutInpFile1 << "##  Type of catch: 1 = retained, 2 = discard" << endl;
  OutInpFile1 << "##  Units of catch: 1 = biomass, 2 = numbers" << endl;
  OutInpFile1 << "# year  seas    fleet   sex     obs     cv      type    units   mult    effort  discard_mortality # original" << endl;
  for (int iCatOut=1;iCatOut<=nCatchDF;iCatOut++)
   for (int irow=1;irow<=nCatchRows(iCatOut); irow++)
    {
     for (int j=1;j<=4;j++) OutInpFile1 << dCatchData(iCatOut,irow,j) << "\t ";
     OutInpFile1 << pre_catch(iCatOut,irow) << "\t ";
     for (int j=6;j<=11;j++) OutInpFile1 << dCatchData(iCatOut,irow,j) << "\t ";
     OutInpFile1 << " # " << dCatchData(iCatOut,irow,5) << endl;
    }

  OutInpFile1 << "\n" << endl;
  OutInpFile1 << "##------------------------------------------------------------" << endl;
  OutInpFile1 << "##--RELATIVE ABUNDANCE DATA-----------------------------------" << endl;
  OutInpFile1 << "##------------------------------------------------------------" << endl;
  OutInpFile1 << "0  #--input format type (0: old format, 1: new format)" << endl;
  OutInpFile1 << "## Index: One q is estimated for each index (the number of index values should match nSurveys" << endl;
  OutInpFile1 << "## Sex: 1 = male, 2 = female, 0 = both" << endl;
  OutInpFile1 << "## Maturity: 1 = mature, 2 = immature, 0 = both" << endl;
  OutInpFile1 << "## Units of survey: 1 = biomass, 2 = numbers" << endl;
  OutInpFile1 << "##  Number  of  relative  abundance indicies" << endl;
  OutInpFile1 << nSurveys << endl;
  OutInpFile1 << "# Type of 'survey' catchability (1=Selectivity; 2=Selectivity+Retention), by data frame" << endl;
  OutInpFile1 << SurveyType << endl;
  OutInpFile1 << "##  Number of rows in index" << endl;
  OutInpFile1 << nSurveyRows << endl;
  OutInpFile1 << "#Index	Year	Season	Fleet	Sex	Maturity	Value	CV	Type	Time # original" << endl;
  for (int i=1;i<=nSurveyRows;i++)
   {
    for(int j=0;j<=5;j++) OutInpFile1 << dSurveyData(i,j) << "\t ";
    OutInpFile1 << pre_cpue(i) << "\t ";
    for(int j=7;j<=9;j++) OutInpFile1 << dSurveyData(i,j) << "\t ";
    OutInpFile1 << "# " << dSurveyData(i,6) << endl;
   } 

  OutInpFile1 << "\n" << endl;
  OutInpFile1 << "##------------------------------------------------------------" << endl;
  OutInpFile1 << "##--SIZE COMPOSITION DATA-------------------------------------" << endl;
  OutInpFile1 << "##------------------------------------------------------------" << endl;
  OutInpFile1 << "0   #--format flag (0=old style, 1=new style)" << endl;
  OutInpFile1 << "#  Number  of  length  frequency matrices" << endl;
  OutInpFile1 << nSizeComps_in << endl;
  OutInpFile1 << "##  Number of rows in each matrix" << endl;
  OutInpFile1 << nSizeCompRows_in << endl;
  OutInpFile1 << "##  Number of bins in each matrix (columns of size data)" << endl;
  OutInpFile1 << nSizeCompCols_in << endl;
  OutInpFile1 <<  "## Sex: 1 = male, 2 = female, 0 = both" << endl;
  OutInpFile1 <<  "## Type of catch: 1 = retained, 2 = discard, 0 = total" << endl;
  OutInpFile1 <<  "## Shell: 1 = newshell, 2 = oldshell, 0 = both" << endl;
  OutInpFile1 <<  "## Maturity: 1 = immature, 2 = mature, 0 = both" << endl;
  OutInpFile1 <<  "## Stage1_EffN: the stage-1 effective sample size (this can be modified in the CTL file)" << endl;
  OutInpFile1 <<  "# Year Season Fleet Sex Type Shell Maturity Stage1_EffN Data" << endl;
  for (int i=1; i<=nSizeComps_in; i++)
   for (int j=1;j<=nSizeCompRows_in(i);j++)
    {
     for (int k=-7;k<=0;k++) OutInpFile1 << d3_SizeComps_in(i,j,k) << "\t ";
     for (int k=1;k<=nSizeCompCols_in(i);k++) OutInpFile1 << d3_pre_size_comps_out(i,j,k) << "\t ";
     OutInpFile1 << "\t # ";
     for (int k=1;k<=nSizeCompCols_in(i);k++)OutInpFile1 << d3_SizeComps_in(i,j,k) << "\t ";
     OutInpFile1 << endl;
    }

  OutInpFile1 << endl << "##  Growth data (increment)" << endl;
  OutInpFile1 << "# Type of growth increment (0=no growth data;1=size-at-release; 2= size-class-at-release)" << endl;
  OutInpFile1 << GrowthObsType << endl;
  OutInpFile1 << "# nobs_growth" << endl;
  OutInpFile1 << nGrowthObs << endl;
  OutInpFile1 << "# Growth data" << endl;
  OutInpFile1 << dGrowthData << endl;
  
  OutInpFile1 << endl << "# Environmental data" << endl;
  OutInpFile1 << "# Number of series" << endl;
  OutInpFile1 << NenvIndics << endl;
  OutInpFile1 << "# Year ranges" << endl;
  if (NenvIndics>0) OutInpFile1 << EnvYrs << endl; else OutInpFile1 << "#--none" << endl;
  OutInpFile1 << "# Indices" << endl;
  OutInpFile1 << "# Index Year Value" << endl;
  if (NenvIndics>0) OutInpFile1 << EnvDataInp << endl;  else OutInpFile1 << "#--none" << endl;
  
  OutInpFile1 << endl << "## eof" << endl;
  OutInpFile1 << 9999 << endl;

  OutInpFile1.close();
  OutInpFile1.open("gmacs_out.ctl");

  OutInpFile1 << TheHeader << endl << endl;

  OutInpFile1 << "# Block structure" << endl;
  OutInpFile1 << "# Number of block groups" << endl;
  OutInpFile1 << nblocks << endl;
  OutInpFile1 << "# Block structure (number of blocks per block group)" << endl;
  for (int ii=1;ii<=nblocks;ii++) OutInpFile1 <<  blocks(ii) << " # block group " << ii << endl; 
 
  OutInpFile1  << "# The blocks" << endl;
  for (int ii=1;ii<=nblocks;ii++) 
   {
    OutInpFile1 << "#Block " << ii << ": "<< endl;
    for (int j=1;j<=blocks(ii);j++) OutInpFile1 << int(blocklimits(ii,j,1)) << " " << int(blocklimits(ii,j,2)) << " # block_group_"<< ii << "_block_" << j << endl;
   }

  OutInpFile1 << endl << "##  ------------------------------------------------------------------------------------ ##" << endl;
  OutInpFile1 << "##  OTHER  CONTROLS" << endl;
  OutInpFile1 << "##  ------------------------------------------------------------------------------------ ##" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(1)) << " # First year of recruitment estimation" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(2)) << " # Last year of recruitment estimation" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(3)) << " # Consider terminal molting (0 = off, 1 = on). If on, the calc_stock_recruitment_relationship() isn't called in the procedure" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(4)) << " # Phase for recruitment estimation" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(5)) << " # Phase for recruitment sex-ratio estimation" << endl;
  OutInpFile1 << setw(4) << setprecision(2) << setfixed()<< model_controls(6) << " # Initial value for recruitment sex-ratio" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(7)) << " # Initial conditions (0 = Unfished, 1 = Steady-state fished, 2 = Free parameters, 3 = Free parameters (revised))" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(8)) << " # ILambda (proportion of mature male biomass for SPR reference points)" << endl;
  OutInpFile1 << setw(4) << setprecision(2) << setfixed()<< model_controls(9) << " # Lambda (proportion of mature male biomass for SPR reference points)" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(10)) << " # Stock-Recruit-Relationship (0 = none, 1 = Beverton-Holt)" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(11)) << " # Use years specified to computed average sex ratio in the calculation of average recruitment for reference points (0 = off -i.e. Rec based on End year, 1 = on)" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(12)) << " # Years to compute equilibria" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(13)) << " # Phase for deviation parameters" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(14)) << " # First year of bias-correction" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(15)) << " # First full bias-correction" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(16)) << " # Last full bias-correction" << endl;
  OutInpFile1 << setw(4) << setfixed()<< int(model_controls(17)) << " # Last year of bias-correction" << endl;
  OutInpFile1 << endl;

  OutInpFile1 << "# Expecting " << ntheta << " theta parameters" << endl;
  OutInpFile1 << "# Core parameters" << endl;
  OutInpFile1 << "## Initial: Initial value for the parameter (must lie between lower and upper)" << endl;
  OutInpFile1 << "## Lower & Upper: Range for the parameter" << endl;
  OutInpFile1 << "## Phase: Set equal to a negative number not to estimate" << endl;
  OutInpFile1 << "## Prior type:"  << endl;
  OutInpFile1 << "## 0: Uniform   - parameters are the range of the uniform prior"  << endl;
  OutInpFile1 << "## 1: Normal    - parameters are the mean and sd" << endl;
  OutInpFile1 << "## 2: Lognormal - parameters are the mean and sd of the log" << endl;
  OutInpFile1 << "## 3: Beta      - parameters are the two beta parameters [see dbeta]" << endl;
  OutInpFile1 << "## 4: Gamma     - parameters are the two gamma parameters [see dgamma]" << endl;
  OutInpFile1 << "# Initial_value    Lower_bound    Upper_bound Phase Prior_type        Prior_1        Prior_2" << endl;
  for (int i=1;i<=ntheta;i++) {
   OutInpFile1 << setw(15) << setprecision(8) <<  setfixed() << theta(i) << " ";
   OutInpFile1 << setw(14) << setprecision(8) <<  setfixed() << theta_control(i,2) << " ";
   OutInpFile1 << setw(14) << setprecision(8) <<  setfixed() << theta_control(i,3) << " ";
   OutInpFile1 << setw(5) << setfixed() << (int) theta_control(i,4) << " ";
   OutInpFile1 << setw(10) << setfixed() << (int) theta_control(i,5) << " ";
   OutInpFile1 << setw(14) << setprecision(8) << setfixed() << theta_control(i,6) << " ";
   OutInpFile1 << setw(14) << setprecision(8) << setfixed() << theta_control(i,7) <<  " # " << parname1(i) << endl;
  }
 
  OutInpFile1 << endl << " ##Allometry" << endl;
  OutInpFile1 << "# weight-at-length input  method  (1 = allometry  [w_l = a*l^b],  2 = vector by sex; 3= matrix by sex)" << endl;
  OutInpFile1 << 3 << endl;
  for ( int h = 1; h <= nsex; h++ )
   for ( int m = 1; m <= nmature; m++)
    for ( int i = syr; i <= nyrRetro+1; i++ )
      OutInpFile1 << setw(14) << setprecision(8) <<  setfixed() << mean_wt(h,m,i) << endl;
  OutInpFile1 << "# Proportion mature by sex and size" << endl;
  OutInpFile1 << maturity << endl;
  OutInpFile1 << "# Proportion legal by sex and size" << endl;
  OutInpFile1 << legal << endl;
  OutInpFile1 << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## GROWTH PARAMETER CONTROLS                                                            ##" << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## " << endl;
  OutInpFile1 << "# Maximum number of size-classes to which recruitment must occur" << endl;
  OutInpFile1 <<nSizeClassRec << endl;
  OutInpFile1 << "# Use functional maturity for terminally molting animals (0=no; 1=Yes)?" << endl;
  OutInpFile1 << use_func_mat << endl;
  
  OutInpFile1 << "# Growth transition" << endl;
  OutInpFile1 << "##Type_1: Options for the growth matrix" << endl;
  OutInpFile1 << "#  1: Pre-specified growth transition matrix (requires molt probability)" << endl;
  OutInpFile1 << "#  2: Pre-specified size transition matrix (molt probability is ignored)" << endl;
  OutInpFile1 << "#  3: Growth increment is gamma distributed (requires molt probability)" << endl;
  OutInpFile1 << "#  4: Post-molt size is gamma distributed (requires molt probability)" << endl;
  OutInpFile1 << "#  5: Von Bert.: kappa varies among individuals (requires molt probability)" << endl;
  OutInpFile1 << "#  6: Von Bert.: Linf varies among individuals (requires molt probability)" << endl;
  OutInpFile1 << "#  7: Von Bert.: kappa and Linf varies among individuals (requires molt probability)" << endl;
  OutInpFile1 << "#  8: Growth increment is normally distributed (requires molt probability)" << endl;
  OutInpFile1 << "## Type_2: Options for the growth increment model matrix" << endl;
  OutInpFile1 << "#  1: Linear" << endl;
  OutInpFile1 << "#  2: Individual" << endl;
  OutInpFile1 << "#  3: Individual (Same as 2)" << endl;
  OutInpFile1 << "#  4: Power law for mean post-molt size" << endl;
  OutInpFile1 << "#  Block: Block number for time-varying growth   " << endl;
  OutInpFile1 << "## Type_1 Type_2  Block" << endl;
  for (int ig=1;ig<=nsex;ig++) {  OutInpFile1 << "   "; for (int ii=1;ii<=3;ii++)  OutInpFile1 << setw(6) << setfixed() << Growth_controls(ig,ii) << " ";  OutInpFile1 << endl; }
  OutInpFile1 << "# Molt probability" << endl;
  OutInpFile1 << "# Type: Options for the molt probability function" << endl;
  OutInpFile1 << "#  0: Pre-specified" << endl;
  OutInpFile1 << "#  1: Constant at 1" << endl;
  OutInpFile1 << "#  2: Logistic" << endl;
  OutInpFile1 << "#  3: Individual" << endl;
  OutInpFile1 << "#  Block: Block number for time-varying growth   " << endl;
  OutInpFile1 << "## Type Block" << endl;
  for (int ig=1;ig<=nsex;ig++) 
   { OutInpFile1 << "  " << setw(5) << setfixed() << Growth_controls(nsex+ig,1) << " " << setw(5) << setfixed() << Growth_controls(nsex+ig,3) << " "; OutInpFile1 << endl; }
  if (nmature==2)
   {
    OutInpFile1 << "# Mature probability" << endl;
    OutInpFile1 << "# Type: Options for the mature probability function" << endl;
    OutInpFile1 << "#  0: Pre-specified" << endl;
    OutInpFile1 << "#  1: Constant at 1" << endl;
    OutInpFile1 << "#  2: Logistic" << endl;
    OutInpFile1 << "#  3: Individual" << endl;
    OutInpFile1 << "# Block: Block number for time-varying growth   " << endl;
    OutInpFile1 << "## Type Block" << endl;
    for (int ig=1;ig<=nsex;ig++) 
     { OutInpFile1 << "  " << setw(5) << setfixed() << Growth_controls(2*nsex+ig,1) << " " << setw(5) << setfixed() << Growth_controls(2*nsex+ig,3) << " "; OutInpFile1 << endl; }
   } //-- if (nmature==2)

  OutInpFile1 << endl;
  OutInpFile1 << "## General parameter specificiations " << endl;
  OutInpFile1 << "##  Initial: Initial value for the parameter (must lie between lower and upper)" << endl;
  OutInpFile1 << "##  Lower & Upper: Range for the parameter" << endl;
  OutInpFile1 << "##  Prior type:"  << endl;
  OutInpFile1 << "##   0: Uniform   - parameters are the range of the uniform prior"  << endl;
  OutInpFile1 << "##   1: Normal    - parameters are the mean and sd" << endl;
  OutInpFile1 << "##   2: Lognormal - parameters are the mean and sd of the log" << endl;
  OutInpFile1 << "##   3: Beta      - parameters are the two beta parameters [see dbeta]" << endl;
  OutInpFile1 << "##   4: Gamma     - parameters are the two gamma parameters [see dgamma]" << endl;
  OutInpFile1 << "##  Phase: Set equal to a negative number not to estimate" << endl;
  OutInpFile1 << "##  Relative: 0: absolute; 1 relative " << endl;
  OutInpFile1 << "##  Block: Block number for time-varying selectivity   " << endl;
  OutInpFile1 << "##  Block_fn: 0:absolute values; 1:exponential" << endl;
  OutInpFile1 << "##  Env_L: Environmental link - options are 0:none; 1:additive; 2:multiplicative; 3:exponential" << endl;
  OutInpFile1 << "##  EnvL_var: Environmental variable" << endl;
  OutInpFile1 << "##  RW: 0 for no random walk changes; 1 otherwise" << endl;
  OutInpFile1 << "##  RW_blk: Block number for random walks" << endl;
  OutInpFile1 << "##  Sigma_RW: Sigma used for the random walk" << endl;
  OutInpFile1 << endl;
  
  int n_Gpar; 
  n_Gpar = 0;
  int n_Gpar2; int h; int iblock;
  for (int ig=1;ig<=3*nsex;ig++)
   {
    if (nparGs(ig) > 0) OutInpFile1 << "# Inputs for sex * type " << ig << endl;
    if (nparGs(ig) > 0) OutInpFile1 << "# MAIN PARS: Initial  Lower_bound  Upper_bound Prior_type       Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma" << endl;
    n_Gpar2 = n_Gpar;
    if (nsex==1) h = 1;
    if (nsex==2 && (ig==1 || ig==3)) h = 1;
    if (nsex==2 && (ig==2 || ig==4)) h = 2;
    for (int ipar=1; ipar<=nparGs(ig);ipar++)
     {
      n_Gpar += 1;
      iblock = 1;
      OutInpFile1 << "         "; OutInpFile1<<  setw(12) << setprecision(6) << setfixed() <<G_pars_est(n_Gpar)<< " "; for (int ii=2;ii<=3;ii++) OutInpFile1<< setw(12) << setprecision(6) << setfixed() << Gpar_control(n_Gpar,ii) << " ";
      OutInpFile1 << setw(10) << setfixed() << int(Gpar_control(n_Gpar,4)) << " ";
      for (int ii=5;ii<=6;ii++) OutInpFile1 << setw(12) << setprecision(6) << setfixed() << Gpar_control(n_Gpar,ii) << " ";
      for (int ii=7;ii<=13;ii++) OutInpFile1 << setw(6) << setfixed() << int(Gpar_control(n_Gpar,ii)) << " ";
      OutInpFile1 << setw(8) << setprecision(4) << setfixed() << Gpar_control(n_Gpar,14) << " # " << parname1(PPstoreG+n_Gpar); OutInpFile1 << endl;
     }
    if (nparGs(ig) > 0)  OutInpFile1 << "# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1      Prior_2  Phase Reltve " << endl;
     
    for (int ipar=1; ipar<=nparGs(ig);ipar++)
     {
      // Are there blocks
      int jpar = n_Gpar2+ipar;
      int IgBlock = int(Gpar_control(jpar,8));
      int IgBlockFn = int(Gpar_control(jpar,9));
      int IgEnvLink = int(Gpar_control(jpar,10));
      int IgEnvLinkVar = int(Gpar_control(jpar,11));
      int IgRW = int(Gpar_control(jpar,12));
      int IgRWBlock = int(Gpar_control(jpar,13));
      float SigmaRW = Gpar_control(jpar,15);
      if (IgBlock !=0)
       {
        // Environmental link
        for (int kpar=1;kpar<=blocks(IgBlock);kpar++)
         {
          iblock = kpar + 1;
          n_Gpar += 1;
          OutInpFile1 << "         "; OutInpFile1<<  setw(12) << setprecision(6) << setfixed() <<G_pars_est(n_Gpar)<< " "; for (int ii=2;ii<=3;ii++) OutInpFile1<< setw(12) << setprecision(6) << setfixed() << Gpar_control(n_Gpar,ii) << " ";
	  OutInpFile1 << setw(10) << setfixed() << int(Gpar_control(n_Gpar,4)) << " ";
	  for (int ii=5;ii<=6;ii++) OutInpFile1 << setw(12) << setprecision(6) << setfixed() << Gpar_control(n_Gpar,ii) << " ";
	  for (int ii=7;ii<=8;ii++) OutInpFile1 << setw(6) << setfixed() << int(Gpar_control(n_Gpar,ii)) << " ";
	  OutInpFile1 << "# " << parname1(PPstoreG+n_Gpar); OutInpFile1 << endl;
         } //-- kpar
       } //-- blocks 
     if (IgEnvLink !=0) 
      {
       n_Gpar += 1;
        OutInpFile1 << G_pars_est(n_Gpar) << " "; for (int ii=2;ii<=7;ii++) OutInpFile1 << Gpar_control(n_Gpar,ii) << " ";  OutInpFile1 << Gpar_control(n_Gpar,15) << endl;
      } //--Env link
    } //--ipar
      
   } //--ig
  
  for (int ig=1;ig<=nsex;ig++)
   if (bUseCustomGrowthMatrix2(ig)==GROWTH_FIXEDGROWTHTRANS || bUseCustomGrowthMatrix2(ig)==GROWTH_FIXEDSIZETRANS)
    {
     if (bUseCustomGrowthMatrix2(ig)==GROWTH_FIXEDGROWTHTRANS) OutInpFile1 << "\n# Using custom growth matrix" << endl;
     if (bUseCustomGrowthMatrix2(ig)==GROWTH_FIXEDSIZETRANS)  OutInpFile1 << "\n# Using custom size transition matrix" << endl;
     for (int i=1;i<=nSizeIncVaries(ig);i++)
      {
       OutInpFile1 << setw(6) << setprecision(4) << setfixed() << trans(CustomGrowthMatrix(ig,i)) << endl;
      }
    }

  // Read pre-specified molt probability matrices 
  for (int ig=1;ig<=nsex;ig++)
   if (bUseCustomMoltProbability2(ig)==FIXED_PROB_MOLT)
    {
     OutInpFile1 << "\n# Using custom molt probability" << endl;
     OutInpFile1 << "#Pre-specified molt probability" << endl;;
     for (int i=1;i<=nMoltVaries(ig);i++)
      {
       for (int l=1;l<= nSizeSex(ig);l++) OutInpFile1 << setw(6) << setprecision(4) << setfixed() << CustomMoltProbabilityMatrix(ig,i,l) << " ";
       OutInpFile1 << endl;
      }
    }

  // Read pre-specified probability of maturing matrices 
  for (int ig=1;ig<=nsex;ig++)
   if (nmature==2 && bUseCustomMatureProbability2(ig)==FIXED_PROB_MATURE)
    {
     OutInpFile1 << "\n# Using custom mature probability" << endl;
     OutInpFile1 << "#Pre-specified mature probability" << endl;
     for (int i=1;i<=nMatureVaries(ig);i++)
      {
       for (int l=1;l<= nSizeSex(ig);l++)  OutInpFile1 << setw(6) << setprecision(4) << setfixed() << CustomMatureProbabilityMatrix(ig,i,l) << " ";
       OutInpFile1 << endl;
      }
    }

  OutInpFile1<<  setw(14) << setprecision(8) << setfixed() << endl;
  OutInpFile1<< endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## NATURAL MORTALITY PARAMETER CONTROLS                                                 ##" << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## " << endl;
  OutInpFile1 <<"# Relative: 0 - absolute values; 1+ - based on another M-at-size vector (indexed by ig)" << endl;
  OutInpFile1 <<"# Type: 0 for standard; 1: Spline" << endl;
  OutInpFile1 <<"#  For spline: set extra to the number of knots, the parameters are the knots (phase -1) and the log-differences from base M" << endl;
  OutInpFile1 <<"# Extra: control the number of knots for splines" << endl;
  OutInpFile1 <<"# Brkpts: number of changes in M by size" << endl;
  OutInpFile1 <<"# Mirror: Mirror M-at-size over to that for another partition (indexed by ig)" << endl;
  OutInpFile1 <<"# Block: Block number for time-varying M-at-size" << endl;
  OutInpFile1 <<"# Block_fn: 0:absolute values; 1:exponential" << endl;
  OutInpFile1 <<"# Env_L: Environmental link - options are 0: none; 1:additive; 2:multiplicative; 3:exponential" << endl;;
  OutInpFile1 <<"# EnvL_var: Environmental variable" << endl;
  OutInpFile1 <<"# RW: 0 for no random walk changes; 1 otherwise" << endl;
  OutInpFile1 <<"# RW_blk: Block number for random walks" << endl;
  OutInpFile1 <<"# Sigma_RW: Sigma for the random walk parameters" << endl;
  OutInpFile1 <<"# Mirror_RW: Should time-varying aspects be mirrored (Indexed by ig)" << endl;
  OutInpFile1 <<"## Relative?   Type   Extra  Brkpts  Mirror   Block  Blk_fn Env_L   EnvL_Vr      RW  RW_blk Sigma_RW Mirr_RW" << endl;
  for (int b=1; b<=nmature*nsex;b++)
   {
    OutInpFile1 << "    "; for (int ii=1;ii<=11;ii++) OutInpFile1 << setw(7) << setfixed() << int(M_controls(b,ii)) << " " ;
    OutInpFile1 << setw(8) << setprecision(4) << setfixed() << M_controls(b,12) << " ";
    OutInpFile1 << setw(7) << setfixed() << int(M_controls(b,13)) << endl;
   }

  if (MaxMbreaks > 0) OutInpFile1 <<"# MaxMbreaks" << endl;
  for (int h=1;h<=nsex;h++)
   for (int m=1;m<=nmature;m++)
    {
     int ig = (h-1)*nmature+m;
     for (int ii=1;ii<=M_size_breakpnts(ig);ii++) OutInpFile1 << Mbreaks(ig,ii) << " "; OutInpFile1 << " # sex*maturity state: " << sexes(h) << " & " << m << endl;
    } 

  OutInpFile1 << endl;
  OutInpFile1 << "#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase " << endl;
  for (int b=1; b<=n_Mpar;b++)
   {
    OutInpFile1 << setw(14) << setprecision(8) << setfixed() << M_pars_est(b) << " ";
    for (int ii=2;ii<=3;ii++) OutInpFile1 << setw(14) << setprecision(8) << setfixed() << M_pars(b,ii) << " ";
    OutInpFile1 << setw(11) << setfixed() << int(M_pars(b,4)) << " ";
    for (int ii=5;ii<=6;ii++) OutInpFile1 << setw(14) << setprecision(8) << setfixed() << M_pars(b,ii) << " ";
    OutInpFile1 << setw(6) << setfixed() << int(M_pars(b,7)) << " # " << parname1(PPstoreM+b) << endl;;
   }
  
  OutInpFile1  << endl;
  OutInpFile1  <<"## ==================================================================================== ##" << endl;
  OutInpFile1  <<"## SELECTIVITY PARAMETERS CONTROLS                                                      ##" << endl;
  OutInpFile1  <<"## ==================================================================================== ##" << endl;
  OutInpFile1  <<"## " << endl;
  anystring = "";
  OutInpFile1  << "# ## Selectivity parameter controls" << endl;
  OutInpFile1  << "# ## Selectivity (and retention) types" << endl;
  OutInpFile1  << "# ##  <0: Mirror selectivity" << endl;;
  OutInpFile1  << "# ##   0: Nonparametric selectivity (one parameter per class)" << endl;
  OutInpFile1  << "# ##   1: Nonparametric selectivity (one parameter per class, constant from last specified class)" << endl;
  OutInpFile1  << "# ##   2: Logistic selectivity (inflection point and width (i.e. 1/slope))" << endl;;
  OutInpFile1  << "# ##   3: Logistic selectivity (50% and 95% selection)" << endl;
  OutInpFile1  << "# ##   4: Double normal selectivity (3 parameters)" << endl;
  OutInpFile1  << "# ##   5: Flat equal to zero (1 parameter; phase must be negative)" << endl;
  OutInpFile1  << "# ##   6: Flat equal to one (1 parameter; phase must be negative)" << endl;;
  OutInpFile1  << "# ##   7: Flat-topped double normal selectivity (4 parameters)" << endl;
  OutInpFile1  << "# ##   8: Declining logistic selectivity with initial values (50% and 95% selection plus extra)" << endl;;
  OutInpFile1  << "# ##   9: Cubic-spline (specified with knots and values at knots)" << endl;
  OutInpFile1  << "# ##      Inputs: knots (in length units); values at knots (0-1) - at least one should have phase -1" << endl;
  OutInpFile1  << "# ##  10: One parameter logistic selectivity (inflection point and slope)" << endl;;
  OutInpFile1  << "# ##  11: Pre-specified selectivity (matrix by year and class)" << endl;
  OutInpFile1  << "## Selectivity specifications --" << endl;

  OutInpFile1  << "# ## Extra (type 1): number of selectivity parameters to estimated" << endl;
  anystring = "# # ";
  for ( int kk = 1; kk <= nfleet; kk++ ) anystring = anystring + " " + fleetname(kk);
  OutInpFile1 << anystring << endl;
  
  OutInpFile1 << slx_bsex_in(1)  << " # is selectivity sex=specific? (1=Yes; 0=No)"  << endl;
  for (int h=1;h<=nsex;h++) OutInpFile1 << slx_type_in(h)  << " # " <<sexes(h) << " selectivity type"  << endl;
  OutInpFile1 <<slx_include_in(1)  << " # selectivity within another gear"  << endl;
  for (int h=1;h<=nsex;h++) OutInpFile1 << slx_extra_in(h)  << " # " << sexes(h) << " extra parameters for each pattern"  << endl;
  for (int h=1;h<=nsex;h++) OutInpFile1 << slx_max_at_1_in(h)  << " # " << sexes(h) << ": is maximum selectivity at size forced to equal 1 (1) or not (0)"  << endl;
  for (int h=1;h<=nsex;h++) OutInpFile1 << slx_1_at_size(h)  << " # size-class at which selectivity is forced to equal 1 (ignored if the previous input is 1)" << endl;
  
  OutInpFile1 << "## Retention specifications --" << endl;
  OutInpFile1 << slx_bsex_in(2)  << " # is retention sex=specific? (1=Yes; 0=No)"  << endl;
  for (int h=1;h<=nsex;h++) OutInpFile1 << slx_type_in(nsex+h)  << " # " << sexes(h) << " retention type"  << endl;
  for (int h=1;h<=nsex;h++) OutInpFile1 << slx_nret(nsex+h)  << " # " << sexes(h) << " retention flag (0 = no, 1 = yes)"  << endl;
  for (int h=1;h<=nsex;h++) OutInpFile1 << slx_extra_in(nsex+h)  << " # " << sexes(h) << " extra parameters for each pattern"  << endl;
  for (int h=1;h<=nsex;h++) OutInpFile1 << ret_max_in(nsex+h)  << " # " << sexes(h) << " - should maximum retention be estimated for " <<sexes(h) << "s (1=Yes; 0=No)" << endl;
  OutInpFile1 << endl;
 
  //CATCH
  int n_Spar;
  n_Spar = 0;
  int n_Spar2; 
  OutInpFile1<< "## General parameter specificiations " << endl;
  OutInpFile1 << "##  Initial: Initial value for the parameter (must lie between lower and upper)" << endl;
  OutInpFile1 << "##  Lower & Upper: Range for the parameter" << endl;
  OutInpFile1 << "##  Prior type:"  << endl;
  OutInpFile1 << "##   0: Uniform   - parameters are the range of the uniform prior"  << endl;
  OutInpFile1 << "##   1: Normal    - parameters are the mean and sd" << endl;
  OutInpFile1 << "##   2: Lognormal - parameters are the mean and sd of the log" << endl;
  OutInpFile1 << "##   3: Beta      - parameters are the two beta parameters [see dbeta]" << endl;
  OutInpFile1 << "##   4: Gamma     - parameters are the two gamma parameters [see dgamma]" << endl;
  OutInpFile1 << "##  Phase: Set equal to a negative number not to estimate" << endl;
  OutInpFile1 << "##  Relative: 0: absolute; 1 relative " << endl;
  OutInpFile1 << "##  Block: Block number for time-varying selectivity   " << endl;
  OutInpFile1 << "##  Block_fn: 0:absolute values; 1:exponential" << endl;
  OutInpFile1 << "##  Env_L: Environmental link - options are 0:none; 1:additive; 2:multiplicative; 3:exponential" << endl;
  OutInpFile1 << "##  EnvL_var: Environmental variable" << endl;
  OutInpFile1 << "##  RW: 0 for no random walk changes; 1 otherwise" << endl;
  OutInpFile1 << "##  RW_blk: Block number for random walks" << endl;
  OutInpFile1 << "##  Sigma_RW: Sigma used for the random walk" << endl;
  OutInpFile1 << endl;

 for (int it=1;it<=2;it++)
   for (int h=1;h<=nsex;h++)
    for (int k=1;k<=nfleet;k++)
     if ( nparSs(it,(h-1)*nfleet+k) > 0)
      {
       int ipnt1 = (h-1)*nfleet+k;
       int ipnt2 = (it-1)*nsex*nfleet+(h-1)*nfleet+k;
       int ipnt3 = (it-1)*nsex*nfleet*Nyears2+(h-1)*nfleet*Nyears2+(k-1)*Nyears2;
       if (nparSs(it,ipnt1) > 0)  OutInpFile1 << "# Inputs for type*sex*fleet: " << seltypes(it) << " " << sexes(h) << " " << fleetname(k) << endl;
       if (nparSs(it,ipnt1) > 0)  OutInpFile1 << "# MAIN PARS:  Initial  Lower_bound  Upper_bound Prior_type     Prior_1      Prior_2  Phase  Block Blk_fn  Env_L Env_vr     RW RW_Blk RW_Sigma" << endl;
       n_Spar2 = n_Spar;
       int ExtraStuff;
       ExtraStuff = 0;
       for (int ipar=1;ipar<=nparSs(it,ipnt1);ipar++)
        {
         n_Spar += 1;
         iblock = 1;
  	 OutInpFile1 << "         "; OutInpFile1 << setw(12) << setprecision(6) << setfixed() << exp(S_pars_est(n_Spar)) << " ";
	 for (int ii=2;ii<=3;ii++) OutInpFile1 << setw(12) << setprecision(6) << setfixed() << Spar_control(n_Spar,ii) << " ";
	 OutInpFile1 << setw(10) << setfixed() << int(Spar_control(n_Spar,4)) << " ";
	 for (int ii=5;ii<=6;ii++) OutInpFile1 << setw(12) << setprecision(6) << setfixed() << Spar_control(n_Spar,ii) << " ";
	 for (int ii=7;ii<=13;ii++) OutInpFile1 << setw(6) << setfixed() << int(Spar_control(n_Spar,ii)) << " ";
	 OutInpFile1 << setw(8) << setprecision(4) << setfixed() << Spar_control(n_Spar,14) << " # " << parname1(PPstoreS+n_Spar); OutInpFile1 << endl;
	 if (int(Spar_control(n_Spar,8)) > 0 || int(Spar_control(n_Spar,10)) > 0 || int(Spar_control(n_Spar,12)) > 0) ExtraStuff = 1;
        }
       if (ExtraStuff==1) OutInpFile1 << "# EXTRA PARS: Initial  Lower_bound  Upper_bound Prior_type      Prior_1     Prior_2  Phase Reltve " << endl;
       for (int ipar=1; ipar<=nparSs(it,ipnt1);ipar++)
        {
         // Are there blocks
         int jpar = n_Spar2+ipar;
         int IgBlock = int(Spar_control(jpar,8));
         int IgBlockFn = int(Spar_control(jpar,9));
         int IgEnvLink = int(Spar_control(jpar,10));
         int IgEnvLinkVar = int(Spar_control(jpar,11));
         int IgRW = int(Spar_control(jpar,12));
         int IgRWBlock = int(Spar_control(jpar,13));
         float SigmaRW = Spar_control(jpar,14);
         if (IgBlock !=0)
           {
            for (int kpar=1;kpar<=blocks(IgBlock);kpar++)
             {
              iblock = kpar + 1;
              n_Spar += 1;
              OutInpFile1 << "         "; OutInpFile1 << setw(12) << setprecision(6) << setfixed() << exp(S_pars_est(n_Spar)) << " "; 
              for (int ii=2;ii<=3;ii++) OutInpFile1 << setw(12) << setprecision(6) << setfixed() << Spar_control(n_Spar,ii) << " ";
	      OutInpFile1 << setw(10) << setfixed() << int(Spar_control(n_Spar,4)) << " ";
	      for (int ii=5;ii<=6;ii++) OutInpFile1 << setw(12) << setprecision(6) << setfixed() << Spar_control(n_Spar,ii) << " ";
	      for (int ii=7;ii<=8;ii++) OutInpFile1 << setw(6) << setfixed() << int(Spar_control(n_Spar,ii)) << " ";
  	      OutInpFile1 << "# " << parname1(PPstoreS+n_Spar); OutInpFile1 << endl;
             } //-- kpar  
           } //-- blocks
         // Environmental link
         if (IgEnvLink !=0) 
          {
           n_Spar += 1;
           OutInpFile1 << setw(12) << setprecision(6) << setfixed() << S_pars_est(n_Spar) << " "; 
           for (int ii=2;ii<=7;ii++) OutInpFile1 << Spar_control(n_Spar,ii) << " "; OutInpFile1 << Spar_control(n_Spar,15) << " # " << parname1(PPstoreS+n_Spar) << endl;
          } //--Env link
        }
       OutInpFile1 << endl;
      } //it,h,k

  OutInpFile1<< "# pre-specified selectivity/retention (ordered by type, sex, fleet and year)" << endl;
  for (int it=1;it<=2;it++)
   for (int h=1;h<=nsex;h++)
    for (int k=1;k<=nfleet;k++)
     if (slx_type_in((it-1)*nsex+h,k) == SELEX_PRESPECIFIED)
      {
       OutInpFile1 << "# Pre-specified values for " << seltypes(it) << " for " << sexes(h) <<"s for " <<fleetname(k) << endl;
       for (int ii=1;ii<=nclass;ii++) OutInpFile1 << setw(9) << setfixed() << ii << " "; OutInpFile1 << endl;
       int offset = (it-1)*nfleet*nsex*(nyr+1-syr+1)+nfleet*(nyr+1-syr+1)*(h-1)+(nyr+1-syr+1)*(k-1);
       for (int iyr =syr;iyr<=nyr+1;iyr++)
        {
         for (int ii=1;ii<=nclass;ii++) OutInpFile1 << setw(9) << setprecision(7) << setfixed() << CustomSelex(offset+iyr-syr+1,ii) << " ";
        OutInpFile1 << "# " << iyr << endl;
        }
      }
  
  OutInpFile1 << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## CATCHABILITY PARAMETER CONTROLS                                                      ##" << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## " << endl;
  OutInpFile1 << "# Catchability (specifications)" << endl;
  OutInpFile1 <<"# Analytic: should q be estimated analytically (1) or not (0)" << endl;
  OutInpFile1 <<"# Lambda: the weight lambda" << endl;
  OutInpFile1 <<"# Emphasis: the weighting emphasis" << endl;
  OutInpFile1 <<"# Block: Block number for time-varying q" << endl;
  OutInpFile1 <<"# Block_fn: 0:absolute values; 1:exponential" << endl;
  OutInpFile1 <<"# Env_L: Environmental link - options are 0: none; 1:additive; 2:multiplicative; 3:exponential" << endl;;
  OutInpFile1 <<"# EnvL_var: Environmental variable" << endl;
  OutInpFile1 <<"# RW: 0 for no random walk changes; 1 otherwise" << endl;
  OutInpFile1 <<"# RW_blk: Block number for random walks" << endl;
  OutInpFile1 <<"# Sigma_RW: Sigma for the random walk parameters" << endl;

  OutInpFile1 << "## Analytic  Lambda Emphass  Mirror   Block   Env_L EnvL_Vr      RW  RW_blk Sigma_RW" << endl;
  for (int b=1; b<=nSurveys;b++)
   {
    OutInpFile1 << "    ";for (int ii=1;ii<=9;ii++) OutInpFile1 << setw(7) << setfixed() << int(q_controls(b,ii)) << " " ;
    OutInpFile1 << setw(8) << setprecision(4) << setfixed() << q_controls(b,10) << " " << endl;;
   }

  OutInpFile1 << "# Catchability (parameters)" << endl;
  OutInpFile1 << "#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase " << endl;
  for (int b=1; b<=n_qpar;b++)
   {
    OutInpFile1 << setw(14) << setprecision(8) << setfixed() << survey_q(b) << " ";
    for (int ii=2;ii<=3;ii++) OutInpFile1 << setw(14) << setprecision(8) << setfixed() << q_pars(b,ii) << " ";
    OutInpFile1 << setw(11) << setfixed() << int(q_pars(b,4)) << " ";
    for (int ii=5;ii<=6;ii++) OutInpFile1 << setw(14) << setprecision(8) << setfixed() << q_pars(b,ii) << " ";
    OutInpFile1 << setw(6) << setfixed() << int(q_pars(b,7)) << " # Survey_q_parameter_"+str(b) << endl;
   }

  OutInpFile1 << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## ADDITIONAL CV PARAMETER CONTROLS                                                     ##" << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## " << endl;
  OutInpFile1 << "# Additiional CV controls (specifications)" << endl;
  OutInpFile1 <<"# Mirror: should additional variance be mirrored (value > 1) or not (0)?" << endl;
  OutInpFile1 <<"# Block: Block number for time-varying additional variance" << endl;
  OutInpFile1 <<"# Block_fn: 0:absolute values; 1:exponential" << endl;
  OutInpFile1 <<"# Env_L: Environmental link - options are 0: none; 1:additive; 2:multiplicative; 3:exponential" << endl;;
  OutInpFile1 <<"# EnvL_var: Environmental variable" << endl;
  OutInpFile1 <<"# RW: 0 for no random walk changes; 1 otherwise" << endl;
  OutInpFile1 <<"# RW_blk: Block number for random walks" << endl;
  OutInpFile1 <<"# Sigma_RW: Sigma for the random walk parameters" << endl;
  OutInpFile1 << "##   Mirror   Block   Env_L EnvL_Vr     RW   RW_blk Sigma_RW" << endl;
  for (int b=1; b<=nSurveys;b++)
   {
    OutInpFile1 << "    ";for (int ii=1;ii<=6;ii++) OutInpFile1 << setw(7) << setfixed() << int(add_cv_controls(b,ii)) << " " ;
    OutInpFile1 << setw(8) << setprecision(4) << setfixed() << add_cv_controls(b,7) << " " << endl;;
   }
  OutInpFile1 << "## Mirror Block Env_L EnvL_Var  RW RW_blk Sigma_RW" << endl;
  OutInpFile1 << "# Additional variance (parameters)" << endl;
  OutInpFile1 << "#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase " << endl;
  for (int b=1; b<=n_addcv_par;b++)
   {
    OutInpFile1 << setw(14) << setprecision(8) << setfixed() << exp(log_add_cv(b)) << " ";
    for (int ii=2;ii<=3;ii++) OutInpFile1 << setw(14) << setprecision(8) << setfixed() << add_cv_pars(b,ii) << " ";
    OutInpFile1 << setw(11) << setfixed() << int(add_cv_pars(b,4)) << " ";
    for (int ii=5;ii<=6;ii++) OutInpFile1 << setw(14) << setprecision(8) << setfixed() << add_cv_pars(b,ii) << " ";
    OutInpFile1 << setw(6) << setfixed() << int(add_cv_pars(b,7)) << " # Add_cv_parameter_"+str(b) << endl;
   }

  OutInpFile1 << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## CONTROLS ON F                                                                        ##" << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## " << endl;
  OutInpFile1 << "# Controls on F" << endl;
  OutInpFile1 << "#   Initial_male_F Initial_fema_F   Pen_SD (mal)   Pen_SD (fem) Phz_mean_F_mal Phz_mean_F_fem   Lower_mean_F   Upper_mean_F Low_ann_male_F  Up_ann_male_F    Low_ann_f_F     Up_ann_f_F" << endl;
  for (int b=1; b<=nfleet;b++)
    {
     OutInpFile1 << "    ";for (int ii=1;ii<=12;ii++) OutInpFile1 << setw(14) << setprecision(6) << setfixed() << f_controls(b,ii) << " " ;
     OutInpFile1 << " # " << fleetname(b) << endl;
    }

  OutInpFile1 << "#\n # Estimates related to fishing mortality" << endl;
  OutInpFile1 << "# Male fishing mortality by fleet" << endl;
  OutInpFile1 << "#"; for (int Ipar=1;Ipar<=nfleet;Ipar++) OutInpFile1 << fleetname(Ipar) << " "; OutInpFile1 << endl;
  OutInpFile1 << "#"; for (int Ipar=1;Ipar<=nfleet;Ipar++) OutInpFile1 << setw(12) << setprecision(8) << setfixed() << log_fbar(Ipar) << " ";  OutInpFile1 << endl;
  if (nsex > 1)
   {
    OutInpFile1 << "# Female offset fishing mortality by fleet" << endl;
    OutInpFile1 << "#"; for (int Ipar=1;Ipar<=nfleet;Ipar++) OutInpFile1 << fleetname(Ipar) << " "; OutInpFile1 << endl;
    OutInpFile1 << "#"; for (int Ipar=1;Ipar<=nfleet;Ipar++) OutInpFile1 << setw(12) << setprecision(8) << setfixed() << log_foff(Ipar) << " ";  OutInpFile1 << endl;
   } 
  OutInpFile1 << "# Male annual offset fishing mortality deviations by fleet" << endl;
  for (int Ipar=1;Ipar<=nfleet;Ipar++)
   {
    int Jpar = 0;
    OutInpFile1 << "# " << fleetname(Ipar) << " "; 
    for (int iy=syr;iy<=nyrRetro;iy++)
     for (int j=1;j<=nseason;j++) if (fhit(iy,j,Ipar) >0) OutInpFile1 << setw(12) << setfixed() << iy << " ";
    OutInpFile1 << endl;
    OutInpFile1 << "# " << fleetname(Ipar) << " "; 
    for (int iy=syr;iy<=nyrRetro;iy++)
     for (int j=1;j<=nseason;j++) 
      if (fhit(iy,j,Ipar) >0) { Jpar += 1; OutInpFile1 << setw(12) << setprecision(8) << setfixed()<< log_fdev(Ipar,Jpar) << " "; }
    OutInpFile1 << endl;
   }
  if (nsex > 1)
   {
    OutInpFile1 << "# Female annual offset fishing mortality deviations by fleet" << endl;
    for (int Ipar=1;Ipar<=nfleet;Ipar++)
     {
      int Jpar = 0;
      OutInpFile1 << "# " << fleetname(Ipar) << " "; 
      for (int iy=syr;iy<=nyrRetro;iy++)
        for (int j=1;j<=nseason;j++) if (yhit(iy,j,Ipar) >0) OutInpFile1 << setw(12) << setfixed() << iy << " ";
      OutInpFile1 << endl;
      OutInpFile1 << "# " << fleetname(Ipar) << " "; 
      for (int iy=syr;iy<=nyrRetro;iy++)
       for (int j=1;j<=nseason;j++) 
        if (yhit(iy,j,Ipar) >0) { Jpar += 1; OutInpFile1 << setw(12) << setprecision(8) << setfixed()<< log_fdov(Ipar,Jpar) << " "; }
      OutInpFile1 << endl;
     }
   } //--if (nsex)  
 
  OutInpFile1 << "#\n # Estimates related to recruitment" << endl;
  OutInpFile1 << "# Annual_deviations "; for (int Ipar=rdv_syr;Ipar<=rdv_eyr;Ipar++) OutInpFile1 << setw(12) << setfixed() << Ipar << " "; OutInpFile1 << endl;
  OutInpFile1 << "# Annual_deviations "; for (int Ipar=rdv_syr;Ipar<=rdv_eyr;Ipar++) OutInpFile1 << setw(12) << setprecision(8) << setfixed() << rec_dev_est(Ipar) << " "; OutInpFile1 << endl;
  if (nsex > 1)
   {
    OutInpFile1 << "# Sex_ratio_devians "; for (int Ipar=rdv_syr;Ipar<=rdv_eyr;Ipar++) OutInpFile1 << setw(12) << setfixed() << Ipar << " "; OutInpFile1 << endl;
    OutInpFile1 << "# Sex_ratio_devians "; for (int Ipar=rdv_syr;Ipar<=rdv_eyr;Ipar++) OutInpFile1 << setw(12) << setprecision(8) << setfixed() << logit_rec_prop_est(Ipar) << " "; OutInpFile1 << endl;
   }


  OutInpFile1 << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## SIZE COMPOSITIONS OPTIONS                                                            ##" << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## " << endl;

  OutInpFile1 <<"# Options when fitting size-composition data" << endl;
  OutInpFile1 << "## Likelihood types: " << endl;
  OutInpFile1 << "##  1:Multinomial with estimated/fixed sample size" << endl;
  OutInpFile1 << "##  2:Robust approximation to multinomial" << endl;
  OutInpFile1 << "##  3:logistic normal" << endl;
  OutInpFile1 << "##  4:multivariate-t" << endl;
  OutInpFile1 << "##  5:Dirichlet" << endl;
  OutInpFile1 << endl;
  anystring = "# ";
  for ( int kk = 1; kk <= nSizeComps_in; kk++ ) anystring = anystring + " " + fleetname(d3_SizeComps_in(kk,1,-5));
  OutInpFile1 << anystring << endl;
  anystring = "# ";
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    if (d3_SizeComps_in(kk,1,-4)==UNDET_SEX)        anystring = anystring +" male+female";
    if (d3_SizeComps_in(kk,1,-4)==MALES)            anystring = anystring +" male";
    if (d3_SizeComps_in(kk,1,-4)==FEMALES)          anystring = anystring +" female";
   }
  OutInpFile1 << anystring << endl;
  anystring = "# ";
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    if (d3_SizeComps_in(kk,1,-3)==TOTALCATCH)       anystring = anystring +" total";
    if (d3_SizeComps_in(kk,1,-3)==RETAINED)         anystring = anystring +" retained";
    if (d3_SizeComps_in(kk,1,-3)==DISCARDED)        anystring = anystring +" discard";
   }
  OutInpFile1 << anystring << endl;
  anystring = "# ";
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    if (d3_SizeComps_in(kk,1,-2)==UNDET_SHELL)      anystring = anystring +" all_shell";
    if (d3_SizeComps_in(kk,1,-2)==NEW_SHELL)        anystring = anystring +" newshell";
    if (d3_SizeComps_in(kk,1,-2)==OLD_SHELL)        anystring = anystring +" oldshell";
   }
  OutInpFile1 << anystring << endl;
  anystring = "# ";
  for ( int kk = 1; kk <= nSizeComps_in; kk++ )
   {
    if (d3_SizeComps_in(kk,1,-1)==UNDET_MATURE)       anystring = anystring +" immature+mature";
    if (d3_SizeComps_in(kk,1,-1)==IMMATURE)         anystring = anystring +" immature";
    if (d3_SizeComps_in(kk,1,-1)==MATURE)           anystring = anystring +" mature";
   }
  OutInpFile1 << anystring << endl;
 
  OutInpFile1 << setw(6) << setfixed() << iSizeCompType_in     << " # Type of likelihood" <<  endl;
  OutInpFile1 << setw(6) << setfixed() << bTailCompression_in << " # Auto tail compression" <<  endl;
  OutInpFile1 << setw(6) << setprecision(4) << setfixed()    << bTailCompression_in        << " # Auto tail compression (pmin)" << endl;
  OutInpFile1 << setw(6) << setfixed() << iCompAggregator    << " # Composition aggregator index" << endl;
  OutInpFile1 << setw(6) << setfixed() << lf_catch_in        << " # Set to 1 for catch-based predictions; 2 for survey or total catch predictions" << endl;
  OutInpFile1 << setw(6) << setprecision(4) << setfixed()    << lf_lambda_in        << " # Lambda for effective sample size" << endl;
  OutInpFile1 << setw(6) << setprecision(4) << setfixed()    << lf_emphasis_in      << " # Lambda for overall likelihood" << endl;
  OutInpFile1 << setw(6) << setfixed() << survey_for_q_in        << " # Survey to set Q for this comp" << endl;

  OutInpFile1 << endl;
  OutInpFile1 << "# The number of following parameters must match max(Composition Aggregator Index) " << endl;
  OutInpFile1 << "#      Initial    Lower_bound    Upper_bound  Prior_type        Prior_1        Prior_2  Phase " << endl;
  for (int b=1; b<=nSizeComps;b++)
   {
    OutInpFile1 << setw(14) << setprecision(8) << setfixed() << exp(log_vn(b)) << " ";
    for (int ii=2;ii<=3;ii++) OutInpFile1 << setw(14) << setprecision(8) << setfixed() << log_vn_pars(b,ii) << " ";
    OutInpFile1 << setw(11) << setfixed() << int(log_vn_pars(b,4)) << " ";
    for (int ii=5;ii<=6;ii++) OutInpFile1 << setw(14) << setprecision(8) << setfixed() << log_vn_pars(b,ii) << " ";
    OutInpFile1 << setw(6) << setfixed() << int(log_vn_pars(b,7)) << " # Overdispersion_parameter_for_size_comp_" << b << " (possibly extended)" << endl;;
   }

  OutInpFile1 << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 <<"## EMPHASIS FACTORS                                                                     ##" << endl;
  OutInpFile1 <<"## ==================================================================================== ##" << endl;
  OutInpFile1 << "\n" << setw(6) << setprecision(4) << setfixed() << tag_emphasis << " # Emphasis on tagging data" << endl;
  OutInpFile1 << "\n" << setw(6) << setprecision(4) << setfixed() << catch_emphasis << " # Emphasis on Catch: (by catch dataframes)" << endl;

  OutInpFile1 << "\n# Weights for penalties 1, 11, and 12" << endl;
  OutInpFile1 << "#   Mean_M_fdevs | Mean_F_fdevs |  Ann_M_fdevs |  Ann_F_fdevs" << endl;
  for (int b=1;b<=nfleet;b++)
   {
    OutInpFile1 << " ";
    OutInpFile1 <<setw(14) << setprecision(4) << setfixed() << Penalty_fdevs(b);
    OutInpFile1 << " # " << fleetname(b) << endl;
   }
  OutInpFile1 << "\n## Emphasis Factors (Priors/Penalties: 13 values) ##" << endl;
  
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(1)<<"\t#--Penalty on log_fdev (male+combined; female) to ensure they sum to zero"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(2)<<"\t#--Penalty on mean F by fleet to regularize the solution"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(3)<<"\t#--Not used"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(4)<<"\t#--Not used"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(5)<<"\t#--Not used"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(6)<<"\t#--Smoothness penalty on the recruitment devs"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(7)<<"\t#--Penalty on the difference of the mean_sex_ratio from 0.5"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(8)<<"\t#--Smoothness penalty on molting probability"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(9)<<"\t#--Smoothness penalty on selectivity patterns with class-specific coefficients"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(10)<<"\t#--Smoothness penalty on initial numbers at length"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(11)<<"\t#--Penalty on annual F-devs for males by fleet"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(12)<<"\t#--Penalty on annual F-devs for females by fleet"<<endl;
  OutInpFile1 << setw(11) << setprecision(4) << setfixed() <<Penalty_emphasis(13)<<"\t#--Penalty on deviation parameters"<<endl;

  OutInpFile1 << endl;
  OutInpFile1 << "# eof_ctl" << endl;
  OutInpFile1 << eof_ctl << endl;
  //exit(1); 
 
// =====================================================================================================================================
RUNTIME_SECTION
  maximum_function_evaluations 2000,   800,   1500,  25000, 25000
  convergence_criteria         1.e-2, 1.e-2, 1.e-3, 1.e-7, 1.e-7

// =====================================================================================================================================

GLOBALS_SECTION
  /**
   * @file gmacs.cpp
   * @authors Steve Martell, Jim Ianelli, D'Arcy Webber
  **/
  #include <admodel.h>
  #include <time.h>
  adstring like_names;
  adstring prior_names;
  #if defined __APPLE__ || defined __linux
  #include "include/libgmacs.h"
  #endif

  #if defined _WIN32 || defined _WIN64
  #include "include\libgmacs.h"
  #endif

  time_t start,finish;
  long hour,minute,second;
  double elapsed_time;

  ofstream OutFile1;
  ofstream OutFile2;
  ofstream OutFile3;
  ofstream OutFile4;
  ofstream OutFile5;
  ofstream RepFile1;
  ofstream OutInpFile1; 

  // Define objects for report file, echoinput, etc.
  /**
  \def REPVEC(object)
  Prints name and value of \a vector object on ADMB report %ofstream file.
  */
  #undef REPVEC
  #define REPVEC(object) \
  OutFile1 << #object << ": vector \n" << setw(8) \
  << setprecision(4) << setfixed() << object << endl; \
  OutFile2 << #object "\n" << setw(8) \
  << setprecision(4) << setfixed() << object << endl; \
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl; \
  RepFile1 << #object << ": vector \n" << setw(8) \
  << setprecision(4) << setfixed() << object << endl; 

  #undef REPVEC2
  #define REPVEC2(object) \
  OutFile1 << #object << ": vector\n" << setw(12) \
  << setprecision(8) << setfixed() << object << endl; \
  OutFile2 << #object "\n" << setw(12) \
  << setprecision(8) << setfixed() << object << endl; \
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl; \
  RepFile1 << #object << ": vector\n" << setw(12) \
  << setprecision(8) << setfixed() << object << endl;

  /**
  \def REPMAT(object)
  Prints name and value of \a matrix object on ADMB report %ofstream file.
  */
  #undef REPMAT
  #define REPMAT(object) \
  OutFile1 << #object << ": matrix\n" << setw(8) \
  << setprecision(4) << setfixed() << object << endl << ">EOM<" << endl; \
  OutFile2 << #object "\n" << setw(8) \
  << setprecision(4) << setfixed() << object << endl; \
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl; \
  RepFile1 << #object << ": matrix\n" << setw(8) \
  << setprecision(4) << setfixed() << object << endl << ">EOM<" << endl; 

  #undef REPMAT2
  #define REPMAT2(object) \
  OutFile1 << #object << ": matrix\n" << setw(12) \
  << setprecision(8) << setfixed() << object << endl << ">EOM<" << endl; \
  OutFile2 << #object "\n" << setw(12) \
  << setprecision(8) << setfixed() << object << endl; \
  RepFile1 << endl << "#--------------------------------------------------------------------------------------------" << endl; \
  RepFile1 << #object << ": matrix\n" << setw(12) \
  << setprecision(8) << setfixed() << object << endl << ">EOM<" << endl;

  /**
   * \def COUT(object)
   * Prints object to screen during runtime.
   * cout <<setw(6) << setprecision(3) << setfixed() << x << endl;
  **/
  #undef COUT
  #define COUT(object) cout << #object "\n" << setw(6) \
   << setprecision(6) << setfixed() << object << endl;

  #undef MAXIT
  #undef TOL
  #define MAXIT 100
  #define TOL 1.0e-4

  /**
  \def MCout(object)
  Prints name and value of \a object on echoinput %ofstream file.
  */
  #undef MCout
  #define MCout(object) mcout << #object << " " << object << endl;

  /**
  \def ECHO(object)
  Prints name and value of \a object on echoinput %ofstream file.
  */
  #undef ECHO
  #define ECHO(object) echoinput << #object << "\n" << object << endl;

  /**
  \def ECHOSTR(str)
  Prints character string to echoinput %ofstream file.
  */
  #undef ECHOSTR
  #define ECHOSTR(str) echoinput << (str) << endl;

  /**
  \def WriteFileName(object)
  Prints name and value of \a object to gmacs_files.in %ofstream.
  */
  #undef WriteFileName
  #define WriteFileName(object) ECHO(object); gmacs_files << "# " << #object << "\n" << object << endl;

  /**
  \def WriteCtl(object)
  Prints name and value of \a object on control %ofstream file.
  */
  #undef WriteCtl
  #define WriteCtl(object) ECHO(object); gmacs_ctl << "# " << #object << "\n" << object << endl;

  /**
  \def WriteCtlStr(str)
  Prints character string to echoinput and  control %ofstream files.
  */
  #undef WriteCtlStr
  #define WriteCtlStr(str) ECHOSTR((str)); gmacs_ctl << "# " <<  (str) << endl;

  /**
  \def WRITEDAT(object)
  Prints name and value of \a object on data %ofstream file.
  */
  #undef WRITEDAT
  #define WRITEDAT(object) ECHO(object); gmacs_data << "# " << #object << "\n" << object << endl;

  /**
  \def WRITEDATSTR(str)
  Prints character string to echoinput and  data %ofstream files.
  */
  #undef WRITEDATSTR
  #define WRITEDATSTR(str) ECHOSTR((str)); gmacs_data << "# " <<  (str) << endl;

  /**
  \def WRITEPRJ(object)
  Prints name and value of \a object on projection %ofstream file.
  */
  #undef WRITEPRJ
  #define WRITEPRJ(object) ECHO(object); gmacs_prj << "# " << #object << "\n" << object << endl;

  /**
  \def WRITEPRJSTR(str)
  Prints character string to echoinput and  prj %ofstream files.
  */
  #undef WRITEPRJSTR
  #define WRITEPRJSTR(str) ECHOSTR((str)); gmacs_prj << "# " <<  (str) << endl;

  /**
  Define a bunch of constants
  */
  //#undef TINY
  //#define TINY 1.0e-10
  #undef YES
  #define YES 1
  #undef NO
  #define NO 0

  #undef INSTANT_F
  #define INSTANT_F 0
  #undef CONTINUOUS_F
  #define CONTINUOUS_F 1
  #undef EXPLOIT_F
  #define EXPLOIT_F 2
  
  #undef NOGROWTH_DATA
  #define NOGROWTH_DATA 0
  #undef GROWTHINC_DATA
  #define GROWTHINC_DATA 1
  #undef GROWTHCLASS_DATA
  #define GROWTHCLASS_DATA 2
  #undef GROWTHCLASS_VALS
  #define GROWTHCLASS_VALS 3
  #undef NO_CUSTOM_M
  #define NO_CUSTOM_M 0
  #undef WITH_CUSTOM_M
  #define WITH_CUSTOM_M 1

  #undef LW_RELATIONSHIP
  #define LW_RELATIONSHIP 1
  #undef LW_VECTOR
  #define LW_VECTOR 2
  #undef LW_MATRIX
  #define LW_MATRIX 3

  #undef BIOMASS
  #define BIOMASS 1
  #undef ABUNDANCE
  #define ABUNDANCE 2

  #undef UNDET_SEX
  #define UNDET_SEX 0
  #undef MALES
  #define MALES 1
  #undef FEMALES
  #define FEMALES 2

  #undef UNDET_SHELL
  #define UNDET_SHELL 0
  #undef NEW_SHELL
  #define NEW_SHELL 1
  #undef OLD_SHELL
  #define OLD_SHELL 2
  
  #undef UNDET_MATURE
  #define UNDET_MATURE 0
  #undef MATURE
  #define MATURE 1
  #undef IMMATURE
  #define IMMATURE 2

  #undef TOTALCATCH
  #define TOTALCATCH 0
  #undef RETAINED
  #define RETAINED 1
  #undef DISCARDED
  #define DISCARDED 2

  #undef UNFISHEDEQN
  #define UNFISHEDEQN 0
  #undef FISHEDEQN
  #define FISHEDEQN 1
  #undef FREEPARS
  #define FREEPARS 2
  #undef FREEPARSSCALED
  #define FREEPARSSCALED 3
  #undef REFPOINTS
  #define REFPOINTS 4

  #undef SELEX_PARAMETRIC
  #define SELEX_PARAMETRIC 0
  #undef SELEX_COEFFICIENTS
  #define SELEX_COEFFICIENTS 1
  #undef SELEX_STANLOGISTIC
  #define SELEX_STANLOGISTIC 2
  #undef SELEX_5095LOGISTIC
  #define SELEX_5095LOGISTIC 3
  #undef SELEX_DOUBLENORM
  #define SELEX_DOUBLENORM 4
  #undef SELEX_UNIFORM1
  #define SELEX_UNIFORM1 5
  #undef SELEX_UNIFORM0
  #define SELEX_UNIFORM0 6
  #undef SELEX_DOUBLENORM4
  #define SELEX_DOUBLENORM4 7
  #undef SELEX_DECLLOGISTIC
  #define SELEX_DECLLOGISTIC 8
  #undef SELEX_CUBIC_SPLINE
  #define SELEX_CUBIC_SPLINE 9
  #undef SELEX_ONE_PAR_LOGISTIC
  #define SELEX_ONE_PAR_LOGISTIC 10
  #undef SELEX_PRESPECIFIED
  #define SELEX_PRESPECIFIED 11

  #undef GROWTH_FIXEDGROWTHTRANS
  #define GROWTH_FIXEDGROWTHTRANS 1
  #undef GROWTH_FIXEDSIZETRANS
  #define GROWTH_FIXEDSIZETRANS 2
  #undef GROWTH_INCGAMMA
  #define GROWTH_INCGAMMA 3
  #undef GROWTH_SIZEGAMMA
  #define GROWTH_SIZEGAMMA 4
  #undef GROWTH_VARYK
  #define GROWTH_VARYK 5
  #undef GROWTH_VARYLINF
  #define GROWTH_VARYLINF 6
  #undef GROWTH_VARYKLINF
  #define GROWTH_VARYKLINF 7
  #undef GROWTH_NORMAL
  #define GROWTH_NORMAL 8

  #undef FIXED_PROB_MOLT
  #define FIXED_PROB_MOLT 0
  #undef CONSTANT_PROB_MOLT
  #define CONSTANT_PROB_MOLT 1
  #undef LOGISTIC_PROB_MOLT
  #define LOGISTIC_PROB_MOLT 2
  #undef FREE_PROB_MOLT
  #define FREE_PROB_MOLT 3

  #undef FIXED_PROB_MATURE
  #define FIXED_PROB_MATURE 0
  #undef CONSTANT_PROB_MATURE
  #define CONSTANT_PROB_MATURE 1
  #undef LOGISTIC_PROB_MATURE
  #define LOGISTIC_PROB_MATURE 2
  #undef FREE_PROB_MATURE
  #define FREE_PROB_MATURE 3

  #undef UNIFORM_PRIOR
  #define UNIFORM_PRIOR 0
  #undef NORMAL_PRIOR
  #define NORMAL_PRIOR 1
  #undef LOGNORMAL_PRIOR
  #define LOGNORMAL_PRIOR 2
  #undef BETA_PRIOR
  #define BETA_PRIOR 3
  #undef GAMMA_PRIOR
  #define GAMMA_PRIOR 4

  #undef LINEAR_GROWTHMODEL
  #define LINEAR_GROWTHMODEL 1
  #undef INDIVIDUAL_GROWTHMODEL1
  #define INDIVIDUAL_GROWTHMODEL1 2
  #undef INDIVIDUAL_GROWTHMODEL2
  #define INDIVIDUAL_GROWTHMODEL2 3
  #undef PWRLAW_GROWTHMODEL
  #define PWRLAW_GROWTHMODEL 4

  #undef M_CONSTANT
  #define M_CONSTANT 0
  #undef M_RANDOM
  #define M_RANDOM 1
  #undef M_CUBIC_SPLINE
  #define M_CUBIC_SPLINE 2
  #undef M_BLOCKED_CHANGES
  #define M_BLOCKED_CHANGES 3
  #undef M_TIME_BLOCKS1
  #define M_TIME_BLOCKS1 4
  #undef M_TIME_BLOCKS3
  #define M_TIME_BLOCKS3 5
  #undef M_TIME_BLOCKS2
  #define M_TIME_BLOCKS2 6

  #undef NOPROJECT
  #define NOPROJECT 0
  #undef PROJECT
  #define PROJECT 1
  #undef UNIFORMSR
  #define UNIFORMSR 1
  #undef RICKER
  #define RICKER 2
  #undef BEVHOLT
  #define BEVHOLT 3
  #undef MEAN_RECRUIT
  #define MEAN_RECRUIT 4
  
  #undef CONSTANTREC
  #define CONSTANTREC 0
  #undef STOCKRECREC
  #define STOCKRECREC 1
  
  #undef CATCH_COMP
  #define CATCH_COMP 1
  #undef SURVEY_COMP
  #define SURVEY_COMP 2
  
  adstring_array parname1(1,500);
  adstring_array selname1(1,500);
  adstring_array mdevname1(1,100);
  adstring_array devnames1(1,500);
  adstring_array seldevnames1(1,100);
  adstring_array selenvnames1(1,100);
  adstring anystring;
  adstring_array fleetname;
  adstring_array sexes(0,2);
  adstring_array maturestate(0,2);
  adstring_array shellstate(0,2);
  adstring_array catchtypes(0,2);
  adstring_array unitstypes;
  adstring_array seltypes;
  adstring TheHeader;
  
  // Open output files using ofstream
  // This one for easy reading all input to R
  ofstream mcout("mcout.rep");
  ofstream mcoutSSB("mcoutSSB.rep");
  ofstream mcoutREC("mcoutREC.rep");
  ofstream mcoutREF("mcoutREF.rep");
  ofstream mcoutPROJSSB("mcoutPROJSSB.rep");
  ofstream mcoutPROJCAT("mcoutPROJCAT.rep");
  ofstream mcoutDIAG("mcoutDIAG.rep");
  ofstream echoinput("checkfile.rep");

  // These ones for compatibility with ADMB (# comment included)
  ofstream gmacs_files("gmacs_files_in.dat");
  ofstream gmacs_data("gmacs_in.dat");
  ofstream gmacs_ctl("gmacs_in.ctl");
  ofstream gmacs_prj("gmacs_in.prj");

  // Specify random number generation
  random_number_generator rng(666);
  
  // pointer to array of pointers for selectivity functions
  class gsm::Selex<dvar_vector>** ppSLX = 0;//initialized to NULL
// --------------------------------------------------------------------------------------------------

 double GenJitter(int JitterType, double Initial, double lower, double upper, int Phase, double sdJitter, dvector& rands, dvector& randu)
  {
   RETURN_ARRAYS_INCREMENT();
   double ParValue,eps;

   ParValue = Initial;

   if (Phase > 0)
    {
	// Andre's version
     if (JitterType==1)
      {
       int ifound = 0;
       ParValue = Initial;
       int ii = 1;
       if (Phase > 0)
        while (ifound ==0)
         {
          eps = rands(ii);
          ii += 1;
          if (eps > 0)
           ParValue = Initial + eps*(upper-Initial)*sdJitter/4.0;
          else
           ParValue = Initial + eps*(Initial-lower)*sdJitter/4.0;
          if (ParValue > lower && ParValue < upper) ifound = 1;
         }
      }

     // Buck's version
     if (JitterType==2)
      {
       double d = upper - lower;
       lower = lower+0.001*d;                        //shrink lower bound
       upper = upper-0.001*d;                        //shrink upper bound
       d = upper - lower;                            //shrink interval
       double lp = Initial - 0.5*d*sdJitter;
       double up = Initial + 0.5*d*sdJitter;
       double rp = Initial + (randu(1)-0.5)*d*sdJitter;
       if (rp > upper)
        {rp = lp - (rp-upper);}
       else
         if (rp < lower) {rp = up + (lower-rp);}
       ParValue = rp;
      }

     // Jie's version
     if (JitterType==3)
      {
       double tem1 = 0.5*rands(1)*sdJitter*log( (upper-lower+0.0000003)/(Initial-lower+0.0000001)-1.0);
       ParValue = lower+(upper-lower)/(1.0+exp(-2.0*tem1));
      }
    }
	
	RETURN_ARRAYS_DECREMENT();
   return (ParValue);

  }
// --------------------------------------------------------------------------------------------------

 double CheckBounds(const prevariable& xx, double lower, double upper)
  {
   RETURN_ARRAYS_INCREMENT();
   int Status;
   double Range;

   Status = 0;
   Range = upper - lower;
   if (xx < lower+Range*0.01) Status =-1;
   if (xx > upper-Range*0.01) Status = 1;
   OutFile1 << lower << " " << upper << " ";
   if (Status == 0) OutFile1 << "ok" << " ";
   if (Status ==-1) OutFile1 << "*-" << " ";
   if (Status == 1) OutFile1 << "*+" << " ";

   RepFile1 << lower << " " 
            << upper << " "
            << Status << " ";

   RETURN_ARRAYS_DECREMENT();
   return (Status);
  }

// --------------------------------------------------------------------------------------------------

 dvariable dnorm( const prevariable& x, const prevariable& mu, const prevariable& std )
  {
   RETURN_ARRAYS_INCREMENT();
   if( std<=0 ) 
    {
      cerr<<"Standard deviation is less than or equal to zero in "
       "dnorm(const dvariable& x, const prevariable& mu, prevariable& std)\n";
        return 0;
    }
   RETURN_ARRAYS_DECREMENT();
   return 0.5*log(2.0*M_PI)+log(std)+0.5*square(x-mu)/(std*std);
   }
// --------------------------------------------------------------------------------------------------

 dvariable dnorm( const prevariable& x, const double& std )
  {
   RETURN_ARRAYS_INCREMENT();
   if( std<=0 ) 
    {
      cerr<<"Standard deviation is less than or equal to zero in "
       "dnorm(const dvariable& x, const double& std)\n";
        return 0;
    }
   RETURN_ARRAYS_DECREMENT();
   return 0.5*log(2.0*M_PI)+log(std)+0.5*square(x)/(std*std);
   }

// ===============================================================================================

TOP_OF_MAIN_SECTION
  time(&start);
  arrmblsize = 50000000;
  gradient_structure::set_GRADSTACK_BUFFER_SIZE(1.e7);
  gradient_structure::set_CMPDIF_BUFFER_SIZE(5.e7);
  gradient_structure::set_MAX_NVAR_OFFSET(5000);
  gradient_structure::set_NUM_DEPENDENT_VARIABLES(5000);
  gradient_structure::set_MAX_DLINKS(150000);

// ===============================================================================================

FINAL_SECTION
  cout<<"Starting FINAL_SECTION"<<endl;
  CreateOutput();
  cout<<"Finished CreateOutput"<<endl;

    if (ppSLX) {
        //clean up pointer array--probably unnecessary
        cout<<"nsel_patterns = "<<nsel_patterns<<endl;
        cout<<"nsel_use      = "<<nsel_use<<endl;
        cout<<"deleting ppSLX array w/ "<<nsel_use<<" sel patterns"<<endl;
        for (int k=0;k<nsel_use;k++) {
          cout<<"deleting ppSLX["<<k<<"]"<<endl;
          if (ppSLX[k]) {
            delete ppSLX[k];
            cout<<"deleted ppSLX["<<k<<"]"<<endl;
          } else {
            cout<<endl<<"#------------------------------"<<endl;
            cout<<"WARNING: ppSLX["<<k<<"] was not defined!"<<endl;
            cout<<"Check your selectivity function declarations!"<<endl;
            cout<<"#------------------------------"<<endl<<endl;
          }
        }
        delete ppSLX;
        cout<<"Finished deleting ppSLX"<<endl;
    }

  //  Print run time statistics to the screen.
  cout<<endl<<"Starting time statistics"<<endl;
  time(&finish);
  elapsed_time = difftime(finish,start);
  hour = long(elapsed_time)/3600;
  minute = long(elapsed_time)%3600/60;
  second = (long(elapsed_time)%3600)%60;
  cout << endl << endl << "*******************************************" << endl;
  cout << endl << endl << "-------------------------------------------" << endl;
  cout << "--Start time: " << ctime(&start) << endl;
  cout << "--Finish time: " << ctime(&finish) << endl;
  cout << "--Runtime: ";
  cout << hour << " hours, " << minute << " minutes, " << second << " seconds" << endl;
  cout << "--Number of function evaluations: " << NfunCall << endl;
  cout << "*******************************************" << endl;
  
// ==============================================================================================
// 2020-01-16; Added index to survey data
// 2020-01-17; Added checks for missing length data
// 2020-01-17; Added ability to specify maturity state for indices
// 2020-01-17; Moved specification of length-class numbers by sex to the DAT file
// 2020-01-17; Deleted the custom M option
// 2020-01-17; Added (partially) double normal - completed ???
// 2020-01-17; Added mirroring of selectivity
// 2020-01-17; CTL labeling initiated.
// 2020-01-17; Recruitment sex-ratio can be specified
// 2020-01-18; Bug file for Selex type 1 (generalized to nclass lengths)
// 2020-01-18; Check that transition matrix in growth data is correct
// 2020-01-20; Added declining logistc (NSRKC)
// 2020-01-20; Added jittering
// 2020-01-21; Added ppSLX to reduce overhead with Selex class objects
// 2020-01-22; Added output to terminal when model quits after StopAfterFnCall function calls
// 2020-01-25; Added a jitter option
// 2020-01-2x; Added cubic spline selex + retention
// 2020-01-28; Added SelectivitySpline class to selex.hpp and new file gsm_splines.hpp
// 2020-01-27; Added mean and CV to recruitment

// Merging Nov-Dec 2021																			   
// 2021-01-14; Bug-fix mirrored parameters
// 2021-01-14; Fixed parameter count for uniform selex
// 2021-01-16; Updated penalty for rec_devs when you select the unfished option
// 2021-01-24; Bug-fix - included first rec_dev in the penalty
// 2021-03-09; Added SurveyType (1=total selectivity; 2=retention*selectivity)
// 2021-03-09; Indices can be any time during a time-step

// 2021-11-22; Add ability to mirror additional variance parameters (new inputs)
// 2021-11-22; fixed analytical Q estimation
// 2021-11-26; Included catch-based comp predictions (new inputs)
// 2021-11-29; New penalty on Fdevs and Fdovs
// 2021-11-29; Tidied up the output
// 2021-11-29; Corrected tagging likelihood
// 2021-12-01; Ability to switch of reference point calculation added
// 2021-12-01; Ability to number of years when computing equilibria added
// 2021-12-02; Ability to weight penalties by fleet added

// 2021-12-02; Ability to select only some derived variables to compute added

// 2021-12-03; Added the derived outputs (and SDs) to gmacsall,out
// 2021-12-03; Added projection-related inputs 
// 2021-12-16; Checked the _in files (and corrected a minor error)
// 2021-12-18; Worked on retrospective analysis     
// 2022-01-10; Corrected bug that impacted surveys
// 2022-01-12; Improved output of data
// 2022-01-13; Started Hamachan version of dynamics
// 2022-01-14; (Version 2.01.B); Fixed bug with OFL and ABC calculation; added headers ti output files
// 2022-01-14; (Version 2.01.B); Dump file for projections
// 2022-01-15; (Version 2.01.C); Hamachan's one-parameter logistic selectivity curve
// 2022-01-24; (Version 2.01.D); Added new dnorm function
// 2022-02-18; (Version 2.01.E); Fixed selectivity to allow for fixing (or not) the maximum selex to 1
// 2022-04-15; (Version 2.01.F); Corrected the Gmacs_in.Ctl AND protected MLAState

// 2022-04-21; (Version 2.01.F); update of the calc_predicted_composition function to properly include catch-based comp prediction
// 2022-05-06; (Version 2.01.G); Incorporate tiime varying natural mortality and work on the calc_predicted_composition function
// 2022-05-19; (Version 2.01.H); Corrected calculation of FOFL and output for dynamic B0
// 2022-05-24; (Version 2.01.I); Bug-fix - Correct the phase for selectivity parameter when slx_type(k) <0
// 2022-06-05; (Version 2.01.I); Bug-fix - Correct the condition on fhit in calc_brute_equilibrium() and the tempZ1 used in calc_predicted_project()

// 2022-06-06; (Version 2.01.J); Option to consider terminal molting added (new input in .CTL file => cf OTHER CONTROLS)
// 2022-06-06; (Version 2.01.K); Option to calculate the average recruitment used for reference points added (new input in .CTL file => cf OTHER CONTROLS)

// 2022-06-27; (Version 2.01.L); Update catch likelihood function to use dnorm(). Clean a bit the code and fix a small
// bug in the calc_predicted_project function (inverse season_type in the computation of tempZ1)

// 2022-10-31 ** WTS ** (Version to 2.01.WTS) - 1. Added commandline input flag "testingflag" to turn on sandbox - 2. Added alternative data file reader (TCSAM02 format)
// 2022-11-16 ** WTS ** (Version to 2.01.WTS) - 1. Added lots of diagnostic output when reading input files - 2. Added ECHOSTR, WriteCtlStr, WriteProjStr macros for 1 
// - 3. Reformatted calc_relative_abundance in preparation for adding ability to handle immature data
// 2022-12-22 ** MV ** (Version to 2.01.L02) - 1. Fix a small bug in calc_natural_mortality() - 2. Rename WTS's version - 3. Modify the DatFileReader.cpp to make it 
// compatible with different OS - Fix a small bug in the control file section (MrelFem)
// 2022-12-31 ** MV ** (Version to 2.01.L03) - 1. Add the simulation approach developped by AE- AE modified the code so initial values for selex is not re-set in the PARAMETER_SECTION
// 2023-01-17 ** AEP ** (Version to 2.01.L04) - 1. Corrected the override of the initialization of selectivity
// 2023-02-4 ** MV ** (Version to 2.01.L04) - 1. Small changes in the Format of the gmacsAll.out
// ================================================ //
// 2023-03-20 ** MV ** (Upgrade GMACS to version 2.01.M) - 1. Add the developed code by ** AEP ** to read in environmental data and modify his
// version of the code to make it working with all stocks (bug in the loop while counting the
// number of selectivity parameters).
// - 2. Add the developped code by ** AEP ** to incorporate potential random walk in the selectivity parameters. Modify the initial code to
// make it more flexible. Need to be updated to allow environmental impacts not being dependent upon time period of random walk.
// ================================================ //
// 2023-03-23 ** MV ** (Upgrade GMACS to version 2.01.M.01) - 1. Fixed a bug in the checking section of the inputs for the growth maxtrix and growth increment model
// 2023-05-30 ** AEP. (Upgrade GMACS to version 2.01.M.02) Added labels for model output and GMACSALL.STD, mature abundance (SSBA) and fixed some bugs in the calculaton of Francis weights.
// 2024-01-08 ** AEP. (Updated GMACS to version 2.01.M.03) (a) Corrected a bug with labels for selectivity; (b) Tag emphasis can be real; (c) merged Cody changes wrt time-varying molt probability and functional maturity;
// 2024-01-09 ** AEP. (Updated GMACS to version 2.01.M.04) (a) added output for the weight units, (b) moved where last functional call, last phase and calculate reference points occurs
// 2024-01-09 ** AEP. (Updated GMACS to version 2.01.M.05) (a) fixed indexing for matrix-based weight-at-length; (b) maturity-specific length-weight, (c) formatted output for gmacsall.out, (d) added OFLs by fleet to gmacsall.out
// 2024-01-10 ** AEP. (Updated GMACS to version 2.01.M.06) (a) modified to output projected catches, (b) calculated historical mortality for projections
// 2024-01-11 ** AEP. (Updated GMACS to version 2.01.M.07) (a) updated the _in files to match the latest version of GMACS. (b) producted inputs files with estimated parameters and expected data
// 2024-01-29 ** AEP. (Updated GMACS to version 2.01.M.08) Fixed time-varying growth increment and added a trap for negative growth increments in fn calls 0 and 1
// 2024-02-01 ** WTS. (Updated GMACS to version 2.01.M.09) Added alternative format for inputting size comps data.
// 2024-02-02 ** WTS. Renamed BOTHSEX, BOTHMATURE to UNDET_SEX, UNDET_MATURE. Added MALES(=1) macro. Need to refactor MALESANDCOMBINED functionality.
//                    Removed MALESANDCOMBINED (duplicated MALES). Refactored selectivity assignments and recruitment (no need to loop over h, so cleaner not to). 
//                    Reformatted some code to add parentheses, replace tabs with spaces, and correctly indent blocks.
//                    Replaced o == 1/2 with o == NEW_SHELL/OLD_SHELL, similar for m.
// 2024-02-05 ** WTS. Reverted selectivity assignaments--needed to loop over h if slx_isex(k) was 0. Added alternative input format for fishery catch data.
// 2024-02-29 ** AEP. (Updated GMACS to version 2.01.M.10) (a) corrected error wrt retrospective patterns and catch re-in, (d) adding units to read-in, and (c) output selex andgradient output.
// 2024-03-03 ** AEP. (Updated GMACS to versions 2.10) (Corrected the terminal molt)
// 2024-03-04 ** AEP. (Updated GMACS to versions 2.10.01) (Added immature N matrices)
// 2024-03-06 ** AEP. (Updated GMACS to versions 2.10.02) (Change projections and OFL sections to use the genetic season update code and fixed a projection error for the propotional F case)
// 2024-03-07 ** AEP. (Updated GMACS to versions 2.10.03) (a) Moved the read-in of the general controls to the start of the CTL file, and (b) replaced the read-in of ntheta by its calculation
// 2024-03-08 ** AEP. (Updated GMACS to versions 2.10.04) (a) Improved speed for the Hessian inversion stage by making loops more efficient, and (b) corrected the projection component of the code
// 2024-03-12 ** AEP. (Updated GMACS to versions 2.10.05) Changed read-in for q and add_cv to allow for generic parameter structure
// 2024-03-26 ** AEP. Fixed stock-recruitment bug for two sex models and models with terminal molt
// 2024-03-28 ** WTS. Added PWRLAW_GROWTHMODEL as alternative to LINEAR_GROWTHMODEL
// 2024-03-29 ** AEP. (Updated GMACS to version 2.20.00) Updated read-in for selectivity, M, growth, additional variance, Q and overdispersion
// 2024-03-29 ** AEP. (Updated GMACS to version 2.20.01) Standardized how priors are handled
// 2024-03-31 ** WTS. (Updated GMACS to version 2.20.02) Added extra info to error messages when using alternative dat file format.
// 2024-04-01 ** WTS. For the PWRLAW_GROWTHMODEL, the input definition for the parameter corresponding to gscale is on the ln-scale, 
//                    so it is exponentiated when assigning G_pars(3) to gscale. 
//                    Changed format of output of block_limits to gmacs_ctl to column form.
// 2024-04-01 ** AEP. (Updated GMACS to version 2.20.03) Tidied up output labels (GMACS_IN and GMACS_OUT).
// 2024-04-02 ** AEP. (Updated GMACS to version 2.20.04) Tidied up penalties (added back one that was commented out)
// 2024-04-02 ** AEP. (Updated GMACS to version 2.20.05) Added new pre-specified selectivity option (11)
// 2024-04-03 ** AEP. (Updated GMACS to version 2.20.06) Added a smoothness penalty to spline selectivity and now output Fs and recruitent to gmacs_out.ctl
// 2024-04-03 ** WTS. Growth transition matrix scale parameter is on l-scale when molt bUseGrowthIncrementModel2==PWRLAW_GROWTHMODEL
// 2024-04-04 ** AEP. Added exit(1) condition when M_relative(ig==1)!=0 after flagging error condition (M specification for first group can't be relative).
// 2024-04-04 ** WTS. Fixed issues with parameter specification when mirroring survey catchability and/or additional survey cv.
//                    Cleaned up compiler warnings by changing " & " and " | " to "&& " and " || ", respectively. 
//                    Added missing immature crab use case for survey abundance/biomass calculations.
//                    Fixed issues with prior density calculations when mirroring q's or additional cv's.
//                    Added additional diagnostics for verbose>10.
//                    (Updated GMACS to version 2.20.07). 
// 2024-04-05 ** WTS. Revised Gmacsall.out formats to play nice with R. Also developed R code to read and create a list object from the .out file.
// 2024-05-08 ** WTS. Changed leading dimension of log_vn_pars, log_vn_lb, log_vn_ub, log_vn_phz, prior_log_vn_type, prior_log_vn_p1, and 
//                    prior_log_vn_p2 from nSizeComps_in (the number of input size comps) to nSizeComps (the number of size comps 
//                    after "aggregation") to better match the number of effective sample size parameters. nAgeCompType_in and 
//                    nAgeCompType were renamed iSizeCompType_in and iSizeCompType, respectively. 
//                    (Updated GMACS to version 2.20.08).
//                    Added N for females by maturity state and shell condition to Gmacsall.out as dataframe with males.
// 2024-05-08 ** WTS. Defined RepFile1 as outstream to "gmacs.rep1". Changed REPORT and REPORT2 macros to REPVEC and REPVEC2 macros for 
//                    vector (or scalar) quantities and added output to RepFile1. Added REPMAT and REPMAT2 mamcros to output matrices 
//                    to OutFile1 (Gmacsall.out), OutFile2 (gmacs.rep), and RepFile1. Added FUNCTIONs to_str and strg to create an adstring 
//                    representation of a space-separated vector (simplifies code to write a vector to a file).
// 2024-05-10 ** WTS. Added more output to RepFile1. Added explicit "Status" column to Summary section of Gmacsall.out to indicate whether
//                    parameter estimate was close to lower bound ("*-"), upper bound ("*+"), or neither ("ok").
//                    Changed "pen_fbar", "log_pen_fbar", and "log_pen_fbar_off" to "init_fbar", "log_init_fbar", and "log_init_fbar_foff"
//                    to better clarify their purpose. 
//                    TODO: "log_init_fbar_foff" (column 2 of F controls) is never used anywhere. It should be removed from the ctl file.
// 2024-05-11 ** WTS. Revised size fit summary to RepFile1 (gmacs.rep1), added mapInpToAggSizeComps matrix which provides mapping from input size comps to 
//                    aggregated size comps (and is used in then revised size fit summary). 
//                    (Updated GMACS version to 2.20.09.)
// 2024-05-12 ** WTS. Added commandline option ("-jitter rseed") to override gmacs.dat setting. If rseed is 0, rseed is set based on the model start time. 
//                    The value of rseed used to initialize the random number generator is written to "jitter.txt" to allow repeating a jittered model run. 
//                    (Updated GMACS version to 2.20.10.)
// 2024-04-13 ** WTS. Added initialization of log_foff to log_init_fbar_foff in INIATIALIZATION section (otherwise it initialized to 0).
//                    Added likelihood penalty for ln-scale mean female offset to nlogPenalty(2) similar to ln-scale mean for males (search on '20240413').
//                    Added fishing mortality parameters output to Rep1File.  
//                    Updated GMACS version to 2.20.11.
// 2024-04-22 ** AEP. Added bias-ramp for recruitment deviations. 
// 2024-05-10 ** WTS. Added alternative format for environmental time series data in the dat file.  
// 2024-05-14 ** AEP. (Updated GMACS to version 2.20.12) Extended initial conditions to allow reference length to pre-specified.
// 2024-05-16 ** AEP. (Updated GMACS to version 2.20.13) F-penalty applies to all seasons (not just season 2)
// 2024-05-20 ** WTS. Added commandline option to make a retrospective run using "-retro XX", where XX is the number of years to peel off.
// 2024-06-26 ** AEP. Added the ability to set Q for size-composition data
// 2024-06-27 ** AEP. (Updated GMACS to version 2.20.15) Corrected the way tail compression is implemented and added a pmin input
// 2024-07-02 ** WTS. Corrected scaling of input size comps so relative proportions of appended size comps always agree with 
//                    relative proportions of input sample sizes. Added ECHOs when verbose >=3 for d3_pre_size_comps_in and d3_pre_size_comps.
// 2024-07-23 ** WTS. (Updated GMACS to version 2.20.16) Added Dirichlet-Multinomial alternative calculation using iSizeCompType_in=6. Added 
//                    comparison of input/output sample sizes to Gmacsall.out file.
// 2024-07-24 ** WTS. Resolved issue in FINAL_SECTION with deleting ppSLX. `nsel_use` is the size of ppSLX (the number of selectivity defined),
//                    not `nsel_patterns`.

// To-do list
// 2 - Review how female offsets are handled for fishing mortality (bounds for devs are hard-wired)?



