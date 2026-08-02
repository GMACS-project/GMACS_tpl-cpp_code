/**
 * @file dirichlet.cpp
 * @author D'Arcy N. Webber
**/

// Global headers
#include <admodel.h>

// Local headers
#if defined __APPLE__ || defined __linux
	#include "../include/nloglike.h"
#endif
#if defined _WIN32 || defined _WIN64
	#include "include\nloglike.h"
#endif


/**
 * @brief Dirichlet desity function.
 * @details Negative log likelihood using the Dirichlet distribution.
 * @author D'Arcy N. Webber
 * @param alpha_0 log of effective sample size.
 * @param alpha_t log of relative sample size.
 * @param o observed proportions.
 * @param p predicted proportions
 * @return negative loglikelihood.
**/
//const dvariable acl::dirichlet::ddirichlet(const dvar_vector& alpha_o, const dvar_vector& alpha_t, const dmatrix& o, const dvar_matrix& p) const
const dvar_vector acl::dirichlet::ddirichlet(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix& p) const
{
	if ( o.colsize() != p.colsize() || o.rowsize() != p.rowsize() )
	{
		cerr << "Error in dirichlet.cpp, observed and predicted matrixes are not the same size" << endl;
		ad_exit(1);
	}

	dvar_vector vn = mfexp(log_vn);
	dvariable lmnB;
	dvariable aj;
	dvariable sj;
	dvariable alpha0;
	int r1 = o.rowmin();
	int r2 = o.rowmax();
	dvar_vector ff(r1,r2);
	ff.initialize();
	for ( int i = r1; i <= r2; i++ )
	{
		lmnB = 0.0;
		sj = 0.0;
		alpha0 = 0.0;
		dvar_vector alpha = vn(i) * p(i)/sum(p(i));
		dvar_vector obs = o(i)/sum(o(i));
  		int c1 = o(i).indexmin();
	  	int c2 = o(i).indexmax();
		for ( int j = c1; j <= c2; j++ )
		{
			aj = alpha(j);
			alpha0 += aj;
			lmnB += gammln(aj);
			sj += (aj - 1.0) * log(1e-10 + obs(j));
		}
		lmnB -= gammln(alpha0);
		ff(i) = -(sj - lmnB);
	}
	return ff;
}

const dmatrix acl::dirichlet::pearson_residuals(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix p) const
{
	dvector vn = value(mfexp(log_vn));
	dmatrix res = o - value(p);
	// dmatrix var = value(elem_prod(p,1.0-p)) / vn;
	for ( int i = o.rowmin(); i <= o.rowmax(); i++ )
	{
		dvector var = value(elem_prod(p(i),1.0-p(i))) / vn(i);
		res(i) = elem_div(res(i),sqrt(var+TINY));
	}
	return res;
}

/**
 * @brief Dirichlet density function with Thorson et al (2016) recommended "theta" parameterization.
 * @details Negative log likelihood using the Dirichlet distribution.
 * @author William Stockhausen
 * @param o dmatrix of observed proportions.
 * @param p dvar_matrix of predicted proportions
 * @return negative loglikelihood.
**/
const dvar_vector acl::dirichlet_alt::ddirichlet_alt(const dmatrix& o, const dvar_matrix& p) const
{
  // cout<<"In dirichlet_alt::ddirichlet_alt"<<endl;
  if ( o.colsize() != p.colsize() || o.rowsize() != p.rowsize() )
  {
    cerr << "Error in dirichlet_alt::ddirichlet_alt calc: observed and predicted matrices are not the same size" << endl;
    ad_exit(1);
  }

  dvariable theta = mfexp(m_log_th);
	dvar_vector tot_nll(o.rowmin(), o.rowmax());
	tot_nll.initialize();
  // cout<<"theta = "<<theta<<endl;
  for (int r = o.rowmin(); r<=o.rowmax();r++){
    //the following is from Thorson et al. 2016
    double      n   = m_iss[r];      //to maintain semblance to Thorson et al.
    dvariable   thn = theta*n;
    // dvector     obsp = o(r)/sum(o(r));   replaced 20260318
    // dvar_vector modp = p(r)/sum(p(r));
    dvector     obsp = (o(r)+1.0e-10)/sum(o(r)+1.0e-10);
    dvar_vector modp = (p(r)+1.0e-10)/sum(p(r)+1.0e-10);
    // cout<<"row "<<r<<" n = "<<n<<" thn = "<<thn<<endl;
    // cout<<"obsp = "<<obsp<<endl;
    // cout<<"modp = "<<modp<<endl;
    dvariable nll;
    nll.initialize();
    if (n>0){//blows up if ss=0
      nll = -( gammln(n+1.0)-sum(gammln(n*obsp+1.0)) );//constant term
      // cout<<"nll 1 = "<<nll<<endl;
      nll -= gammln(thn)-gammln(n+thn);
      // cout<<"nll 2 = "<<nll<<endl;
      nll -= sum(gammln(n*obsp+thn*modp) - gammln(thn*modp));
      // cout << "gammln(n*obsp+thn*modp) = " << gammln(n*obsp+thn*modp) << endl;
      // cout << "gammln(thn*modp)        = " << gammln(thn*modp) << endl;
      if (std::isnan(value(nll))){
        cout<<"In dirichlet_alt::ddirichlet_alt"<<endl;
        cout<<"theta = "<<theta<<endl;
        cout<<"row "<<r<<" n = "<<n<<" thn = "<<thn<<endl;
        cout<<"obsp = "<<obsp<<endl;
        cout<<"modp = "<<modp<<endl;
        cout<<"nll 1 = "<<nll<<endl;
        cout<<"nll2  = "<<gammln(thn)-gammln(n+thn)<<endl;
        cout<<"gammln(n*obsp+thn*modp) = " << gammln(n*obsp+thn*modp) << endl;
        cout<<"gammln(thn*modp)        = " << gammln(thn*modp) << endl;
        ad_exit(1);
      }
    }
    // cout<<"nll = "<<nll<<endl;
		tot_nll(r) = nll;
  } //--r loop
  // cout<<"tot_nll = "<<tot_nll<<endl;
  return(tot_nll);
}

const dmatrix acl::dirichlet_alt::pearson_residuals(const dmatrix& o, const dvar_matrix p) const
{
  double th = value(mfexp(m_log_th));
	dvector vn = (1.0+m_iss*th)/(1.0+th);
	dmatrix res = o - value(p);
	// dmatrix var = value(elem_prod(p,1.0-p)) / vn;
	for ( int i = o.rowmin(); i <= o.rowmax(); i++ ) {
		dvector var = value(elem_prod(p(i),1.0-p(i))) / vn(i);
		res(i) = elem_div(res(i),sqrt(var+TINY));
	}
	return res;
}
