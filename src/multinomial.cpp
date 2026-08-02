#include <admodel.h>
#if defined __APPLE__ || defined __linux
	#include "../include/nloglike.h"
#endif
#if defined _WIN32 || defined _WIN64
	#include "include\nloglike.h"
#endif


/**
 * @brief multinomial desity function with estimated effective sample size.
 *
 * @details Negative log likelihood using the multinomial distribution.	
 *
 * @author Dave Fournier
 * @param log_vn log of effective sample size.
 * @param o observed proportions.
 * @param p predicted proportions
 * @return negative loglikelihood.
**/
const dvar_vector acl::multinomial::dmultinom(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix& p) const
{
	if ( o.colsize() != p.colsize() || o.rowsize() != p.rowsize() )
	{
		cerr << "Error in dmultinom, "
		" observed and predicted matrixes"
		" are not the same size" << endl;
		ad_exit(1);
	}

	dvar_vector vn = mfexp(log_vn);
	int r1 = o.rowmin();
	int r2 = o.rowmax();
	dvar_vector ff(r1,r2);
	ff.initialize();
	for ( int i = r1; i <= r2; i++ )
	{
  		int c1 = o(i).indexmin();
	  	int c2 = o(i).indexmax();
		//scale observed numbers by effective sample size.
		dvar_vector sobs = vn(i) * o(i)/sum(o(i));  
		ff(i) -= gammln(vn(i));
		for ( int j = c1; j <= c2; j++ )
		{
			if ( value(sobs(j)) > 0.0 )
			{
				ff(i) += gammln(sobs(j));
			}
		}
		ff(i) -= sobs * log(TINY + p(i));
	}
	return ff;
}


const dmatrix acl::multinomial::pearson_residuals(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix p) const
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
 * @brief multinomial desity function with estimated effective sample size.
 *
 * @details Negative log likelihood using the multinomial distribution as referenced to the "best" fit (i.e., p_i=x_i).	
 *
 * @author WTS
 * @param log_vn dvar_vector of the log of effective sample sizes.
 * @param o dmatrix of the observed proportions.
 * @param p dvar_matrix of the predicted proportions
 * @return negative loglikelihood.
**/
const dvar_vector acl::multinomial_alt::dmultinom_alt(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix& p) const
{
  if ( o.colsize() != p.colsize() || o.rowsize() != p.rowsize() ){
    cerr << "Error in dmultinom, "
    " observed and predicted matrixes"
    " are not the same size" << endl;
    ad_exit(1);
  }

  dvar_vector vn = mfexp(log_vn);
	dvar_vector ff(o.rowmin(),o.rowmax());
	ff.initialize();
  for ( int i = o.rowmin(); i <= o.rowmax(); i++ ){
		ff(i) -= vn(i) * o(i) * (log(p(i)+m_smlVal)-log(o(i)+m_smlVal));
  }
  return ff;
}


const dmatrix acl::multinomial_alt::pearson_residuals(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix p) const
{
  dvector vn = value(mfexp(log_vn));
  dmatrix res = o - value(p);
  for ( int i = o.rowmin(); i <= o.rowmax(); i++ ){
    dvector var = value(elem_prod(p(i),1.0-p(i)+m_smlVal)) / vn(i);
    res(i) = elem_div(res(i),sqrt(var+m_smlVal));
  }
  return res;
}
