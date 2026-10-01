DATA_SECTION

 init_int Yr1;
 init_int Yr2;
 init_int ndataGrp;
 init_int nsex;
 init_int nshell;
 init_int nmat;
 init_int nclass;
 init_int max_nclass;
 
 init_int Ncatlines;
 !! cout << Ncatlines << endl;
 init_matrix Catch_data(1,Ncatlines,1,11);
 
 init_int Nindexlines;
 init_matrix Index_data(1,Nindexlines,1,11);
 
 number Ref_catch;
 vector Index(1,5); 

 // Find the last five years of index data and the average catch for the last five years
 !!Index.initialize();
 !!for (int Iy=1; Iy<=5;Iy++)
 !! for (int II=1;II<=Nindexlines;II++)
 !!  if (Index_data(II,1)==1 & Index_data(II,2)==(Yr2-5+Iy) & Index_data(II,4)==4) 
 !!   {
 !!    Index(Iy) = Index_data(II,7);
 !!   }
 //cout << Index << endl;
 
PARAMETER_SECTION
 init_number a;
 init_number b;

 number TAC;
 
 objective_function_value ff;
 
 
PROCEDURE_SECTION 
 int Index_use;
 dvariable Pred;
 
 Index_use = 1;
 
 // Reference catch
 Ref_catch = 100;
 
 
 
 ff = 0;
 for (int Iy=1;Iy<=5;Iy++)
  if (Index(Iy) > 0)
   {
    Pred = exp(a + b*Iy);
    //cout << Iy << " " << Pred << " " << Index(Iy) << endl;
    ff += (log(Pred)-log(Index(Iy)))*(log(Pred)-log(Index(Iy)));
   }
 cout << ff << endl;


REPORT_SECTION
 cout << "REPORT" << endl;
 cout << Ref_catch << " " << b << endl;
 TAC = Ref_catch*(1+0.5*b);
 report << TAC << endl;
 report << Yr2 << endl;
 report << Index << endl;
 