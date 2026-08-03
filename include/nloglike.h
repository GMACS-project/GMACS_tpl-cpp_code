/**
 * @file nloglike.h
 * @brief Composition-data negative log-likelihood interfaces and implementations.
 * @defgroup Likelihoods Likelihood models for composition data
 * @author Steven Martell, D'Arcy Webber
 * @date   Feb 10, 2014
 * @details
 * This header defines a polymorphic interface and concrete classes used to
 * evaluate negative log-likelihoods for composition data.
 *
 * Conventions used throughout this file:
 * - Observed compositions are passed as `dmatrix O` with one row per sample.
 * - Predicted compositions are passed as `dvar_matrix P` with matching shape.
 * - Effective sample-size-like quantities are supplied on log scale
 *   (`log_vn`, `log_effn`) unless noted otherwise.
 * - `nll_vector(...)` methods return per-row objective contributions.
 * - `nloglike(...)` methods return the sum of `nll_vector(...)`.
 * - Optional tail compression creates ragged rows by collapsing tails into
 *   boundary bins.
**/
#ifndef NLOGLIKE_H
#define NLOGLIKE_H

#define TINY     1.e-08

#include <admodel.h>


namespace acl
{
  /**
   * @brief Abstract base class for composition likelihoods.
   * @details
   * Stores observed composition data and shared metadata needed to optionally
   * compress tails in each row (ragged representation). Derived classes provide
   * model-specific objective and residual calculations.
   *
   * Interface contract:
   * - `_P` must have row and column extents compatible with `get_O()`.
   * - `_n` must have one element per row of `get_O()`.
   * - Rows used in compression should have strictly positive sums.
  **/
  class negativeLogLikelihood
  {

  private:
    /** @brief First row index in the observed matrix. */
    int r1,r2;
    /** @brief First and last column indices in the observed matrix. */
    int c1,c2;
    /** @brief Per-row first bin retained after tail compression. */
    ivector m_jmin;
    /** @brief Per-row last bin retained after tail compression. */
    ivector m_jmax;
    /** @brief Observed composition matrix (uncompressed). */
    dmatrix m_O;
    /** @brief Optional observed matrix in ragged/compressed form. */
    dmatrix m_Or;

  public:
    //virtual const dvariable nloglike(const dmatrix& _O) const = 0;
    //virtual const   dmatrix residual(const dmatrix& _O) const = 0;
    
    /**
      * @brief Compute per-row negative log-likelihood contributions.
     * @param _n Row-wise scale parameter(s), typically on log scale.
     * @param _P Predicted composition matrix aligned with observed data.
      * @return Per-row negative log-likelihood contributions.
      */
        virtual const dvar_vector nll_vector(const dvar_vector& _n, const dvar_matrix& _P) const = 0;

        /**
      * @brief Compute total negative log-likelihood contribution.
      * @details Implementations should return `sum(nll_vector(_n, _P))`.
      * @param _n Row-wise scale parameter(s), typically on log scale.
      * @param _P Predicted composition matrix aligned with observed data.
      * @return Summed negative log-likelihood contribution.
     */
    virtual const dvariable nloglike(const dvar_vector& _n, const dvar_matrix& _P) const = 0;

    /**
     * @brief Compute residual matrix associated with the likelihood.
     * @param _n Row-wise scale parameter(s), typically on log scale.
     * @param _P Predicted composition matrix aligned with observed data.
     * @return Residual matrix with dimensions compatible with observed data.
     */
    virtual const dmatrix residual(const dvar_vector& _n, const dvar_matrix& _P) const = 0;

    /**
     * @brief Compute baseline per-row likelihood contributions.
     * @details
     * Implementations should optionally compress observed data when the class
     * is configured for compression, row-normalize the resulting matrix, and
     * call the class-specific vector-valued kernel that is summed by
     * `nloglike(...)`.
     * @param _n Row-wise scale parameter(s), typically on log scale.
     * @return Per-row baseline contributions as a `dvar_vector`.
     */
    virtual const dvar_vector nll_base(const dvar_vector& _n) const = 0;

    negativeLogLikelihood(){}
    negativeLogLikelihood(const dmatrix& _O)
    :m_O(_O) 
    {
      r1 = m_O.rowmin();
      r2 = m_O.rowmax();
      c1 = m_O.colmin();
      c2 = m_O.colmax();
    }
         // ~negativeLogLikelihood(){}
    virtual ~negativeLogLikelihood() { }
    
    /** @brief Get uncompressed observed compositions. */
    dmatrix get_O()     const{ return m_O;    }
    /** @brief Set uncompressed observed compositions. */
    void    set_O(dmatrix _O){ this->m_O = _O;}

    /** @brief Get compressed/ragged observed compositions, if set. */
    dmatrix get_Or()     const{ return m_Or;    }
    /** @brief Set compressed/ragged observed compositions. */
    void    set_Or(dmatrix _O){ this->m_Or = _O;}

    /** @brief Get row-wise left compression indices. */
    const ivector get_jmin() const { return m_jmin; }
    /** @brief Get row-wise right compression indices. */
    const ivector get_jmax() const { return m_jmax; }

    /**
     * @brief Build row-wise index bounds used for ragged tail compression.
     * @details Populates `m_jmin` and `m_jmax` from observed data.
     */
    void tail_compression();

    template <typename T>
    inline
    /**
     * @brief Compress a matrix-like object to ragged form using tail bounds.
     * @details
     * Each row is normalized to sum to one, interior bins are copied from
     * `[m_jmin(i), m_jmax(i)]`, and both tails are collapsed into the boundary
     * bins.
     * @param _M Matrix-like object with row indexing compatible with observed data.
     * @return Compressed object with ragged row extents.
     */
    const T compress(const T& _M) const;

  };

  
  template <typename T>
  inline
  const T acl::negativeLogLikelihood::compress(const T& _M) const
  {
    // NOTE: Assumes each row sum is positive before normalization.

    T R;
    T M = _M;
    R.allocate(r1,r2,m_jmin,m_jmax);
    R.initialize();

    // fill ragged array R
    for ( int i = r1; i <= r2; i++ )
    {
      M(i) /= sum(M(i));
      R(i)(m_jmin(i),m_jmax(i)) = M(i)(m_jmin(i),m_jmax(i));

      // add cumulative sum to tails.
      R(i)(m_jmin(i)) = sum(M(i)(c1,m_jmin(i)));
      R(i)(m_jmax(i)) = sum(M(i)(m_jmax(i),c2));
    }
    return R;
  }
  
  
  /**
   * @brief Class for multinomial negative log-likelihood.
   * @details
   * Evaluates multinomial composition likelihood with optional tail compression.
   * `log_vn` is interpreted as log effective sample size by row.
  **/
  class multinomial: public negativeLogLikelihood
  {

  private:
    /** @brief If true, compress observed/predicted rows before evaluation. */
    bool        m_bCompress;
    /** @brief Cached log effective sample size parameter(s). */
    dvariable   m_log_vn;
    /** @brief Cached predicted composition matrix (optional storage). */
    dvar_matrix m_P;

  public:
    multinomial(const dmatrix &_O, const bool bCompress=false)
    : negativeLogLikelihood(_O), m_bCompress(bCompress) 
    {
      if ( m_bCompress ) tail_compression();
    }
    virtual ~multinomial() { }

    // ~multinomial();

    /** @brief Get cached log effective sample size parameter. */
    dvariable get_n()      const { return m_log_vn;    }
    /** @brief Set cached log effective sample size parameter. */
    void      set_n(dvariable _n){ this->m_log_vn = _n;}

    /** @brief Get cached predicted composition matrix. */
    dvar_matrix get_P()         const { return m_P;    }
    /** @brief Set cached predicted composition matrix. */
    void        set_P(dvar_matrix _P) { this->m_P = _P;}

    /**
     * @brief Compute multinomial per-row negative log-likelihood contributions.
     * @param log_vn Log effective sample size by row.
     * @param _P Predicted composition proportions by row/bin.
     * @return Per-row multinomial contributions.
     */
    const dvar_vector nll_vector(const dvar_vector& log_vn, const dvar_matrix& _P) const
    {
      if ( m_bCompress )
      {
        dmatrix     Or = compress(this->get_O());
        dvar_matrix Pr = compress(_P);
        return dmultinom(log_vn,Or,Pr);
      } else {
        return dmultinom(log_vn,this->get_O(),_P);
      }
    }

    /**
     * @brief Compute total multinomial negative log-likelihood.
     * @param log_vn Log effective sample size by row.
     * @param _P Predicted composition proportions by row/bin.
     * @return Summed multinomial contribution.
     */
    const dvariable nloglike(const dvar_vector& log_vn, const dvar_matrix& _P) const
    {
      return sum(nll_vector(log_vn, _P));
    }

    /**
     * @brief Baseline multinomial per-row contributions from observations.
     * @param _n Log effective sample size by row.
     * @return Per-row multinomial contributions used by `nloglike`.
     */
    const dvar_vector nll_base(const dvar_vector& _n) const
    {
      dmatrix O = this->get_O();
      if (m_bCompress) O = compress(O);
      dvar_matrix P = O;
      for (int i = P.rowmin(); i <= P.rowmax(); i++)
      {
        dvariable s = sum(P(i));
        if (value(s) > 0.0) P(i) /= s;
      }
      return dmultinom(_n, O, P);
    }

    /**
     * @brief Compute Pearson residuals for multinomial fit diagnostics.
     */
    const   dmatrix residual(const dvar_vector& _n, const dvar_matrix& _P) const
    {
      return pearson_residuals(_n,this->get_O(),_P);
    }
    
    /**
     * @brief Internal multinomial objective kernel.
     * @return Per-row negative log-likelihood contributions.
     */
    const dvar_vector dmultinom(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix& p) const;

    /** @brief Internal Pearson residual kernel for multinomial model. */
    const dmatrix pearson_residuals(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix p) const;
  };


  /**
   * @brief Class for multinomial negative log-likelihood with alternative minimum.
   * @details
   * Variant of multinomial likelihood that applies a small positive floor in
   * the kernel implementation to improve numerical behavior when probabilities
   * are very small.
  **/
  class multinomial_alt: public negativeLogLikelihood
  {

  private:
    /** @brief If true, compress observed/predicted rows before evaluation. */
    bool        m_bCompress;
    /** @brief Small positive floor used in alternative multinomial kernel. */
    double      m_smlVal = 0.00001;
    /** @brief Cached log effective sample size parameter(s). */
    dvariable   m_log_vn;
    /** @brief Cached predicted composition matrix (optional storage). */
    dvar_matrix m_P;

  public:
    multinomial_alt(const dmatrix &_O, const bool bCompress=false)
    : negativeLogLikelihood(_O), m_bCompress(bCompress) 
    {
      if ( m_bCompress ) tail_compression();
    }
    virtual ~multinomial_alt() { }

    /** @brief Get cached log effective sample size parameter. */
    dvariable get_n()      const { return m_log_vn;    }
    /** @brief Set cached log effective sample size parameter. */
    void      set_n(dvariable _n){ this->m_log_vn = _n;}

    /** @brief Get cached predicted composition matrix. */
    dvar_matrix get_P()         const { return m_P;    }
    /** @brief Set cached predicted composition matrix. */
    void        set_P(dvar_matrix _P) { this->m_P = _P;}

    /**
     * @brief Compute alternative multinomial per-row negative log-likelihood contributions.
     * @param log_vn Log effective sample size by row.
     * @param _P Predicted composition proportions by row/bin.
     * @return Per-row alternative multinomial contributions.
     */
    const dvar_vector nll_vector(const dvar_vector& log_vn, const dvar_matrix& _P) const
    {
      if ( m_bCompress )
      {
        dmatrix     Or = compress(this->get_O());
        dvar_matrix Pr = compress(_P);
        return dmultinom_alt(log_vn,Or,Pr);
      } else {
        return dmultinom_alt(log_vn,this->get_O(),_P);
      }
    }

    /**
     * @brief Compute total alternative multinomial negative log-likelihood.
     * @param log_vn Log effective sample size by row.
     * @param _P Predicted composition proportions by row/bin.
     * @return Summed alternative multinomial contribution.
     */
    const dvariable nloglike(const dvar_vector& log_vn, const dvar_matrix& _P) const
    {
      return sum(nll_vector(log_vn, _P));
    }

    /**
     * @brief Baseline alternative multinomial per-row contributions from observations.
     * @param _n Log effective sample size by row.
     * @return Per-row alternative multinomial contributions used by `nloglike`.
     */
    const dvar_vector nll_base(const dvar_vector& _n) const
    {
      dmatrix O = this->get_O();
      if (m_bCompress) O = compress(O);
      dvar_matrix P = O;
      for (int i = P.rowmin(); i <= P.rowmax(); i++)
      {
        dvariable s = sum(P(i));
        if (value(s) > 0.0) P(i) /= s;
      }
      return dmultinom_alt(_n, O, P);
    }

    /** @brief Compute Pearson residuals for alternative multinomial model. */
    const   dmatrix residual(const dvar_vector& _n, const dvar_matrix& _P) const
    {
      return pearson_residuals(_n,this->get_O(),_P);
    }
    
    /**
     * @brief Internal alternative multinomial objective kernel.
     * @return Per-row negative log-likelihood contributions.
     */
    const dvar_vector dmultinom_alt(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix& p) const;

    /** @brief Internal Pearson residual kernel for alternative multinomial model. */
    const dmatrix pearson_residuals(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix p) const;
  };


  /**
   * @brief Class for robust multinomial negative log-likelihood.
   * @details This is a derived class which inherits the virtual methods
   * in negativeLogLikelihood. The objective is less sensitive to extreme
   * composition residuals than a standard multinomial formulation.
  **/
  class robust_multi: public negativeLogLikelihood
  {

  private:
    /** @brief If true, compress observed/predicted rows before evaluation. */
    bool        m_bCompress;
    /** @brief Cached log effective sample size parameter(s). */
    dvariable   m_log_vn;
    /** @brief Cached predicted composition matrix (optional storage). */
    dvar_matrix m_P;

  public:
    robust_multi(const dmatrix &_O, const bool bCompress=false)
    : negativeLogLikelihood(_O),m_bCompress(bCompress) 
    {
      if ( m_bCompress ) tail_compression();
    }

    // ~robust_multi();
    virtual ~robust_multi() { }

    /** @brief Get cached log effective sample size parameter. */
    dvariable get_n()      const { return m_log_vn;    }
    /** @brief Set cached log effective sample size parameter. */
    void      set_n(dvariable _n){ this->m_log_vn = _n;}

    /** @brief Get cached predicted composition matrix. */
    dvar_matrix get_P()         const { return m_P;    }
    /** @brief Set cached predicted composition matrix. */
    void        set_P(dvar_matrix _P) { this->m_P = _P;}

    /**
     * @brief Compute robust multinomial-style per-row contributions.
     * @param log_vn Log effective sample size by row.
     * @param _P Predicted composition proportions by row/bin.
     * @return Per-row robust objective contributions.
     */
    const dvar_vector nll_vector(const dvar_vector& log_vn, const dvar_matrix& _P) const
    {
      if ( m_bCompress )
      {
        dmatrix     Or = compress(this->get_O());
        dvar_matrix Pr = compress(_P);
        return pdf(Or,Pr,log_vn);
      } else {
        return pdf(this->get_O(),_P,log_vn);
      }
    }

    /**
     * @brief Compute total robust multinomial-style negative log-likelihood.
     * @param log_vn Log effective sample size by row.
     * @param _P Predicted composition proportions by row/bin.
     * @return Summed robust objective contribution.
     */
    const dvariable nloglike(const dvar_vector& log_vn, const dvar_matrix& _P) const
    {
      return sum(nll_vector(log_vn, _P));
    }

    /**
     * @brief Baseline robust per-row contributions from observations.
     * @param _n Log effective sample size by row.
     * @return Per-row robust contributions used by `nloglike`.
     */
    const dvar_vector nll_base(const dvar_vector& _n) const
    {
      dmatrix O = this->get_O();
      if (m_bCompress) O = compress(O);
      dvar_matrix P = O;
      for (int i = P.rowmin(); i <= P.rowmax(); i++)
      {
        dvariable s = sum(P(i));
        if (value(s) > 0.0) P(i) /= s;
      }
      return pdf(O, P, _n);
    }

    /** @brief Compute Pearson residuals for robust model fit diagnostics. */
    const   dmatrix residual(const dvar_vector& _n, const dvar_matrix& _P) const
    {
      return pearson_residuals(this->get_O(),_P,_n);
    }
    
    /**
     * @brief Internal robust objective kernel.
     * @return Per-row negative log-likelihood contributions.
     */
    const dvar_vector pdf(const dmatrix& O, const dvar_matrix& P, const dvar_vector& lnN) const;
    
    /** @brief Internal Pearson residual kernel for robust model. */
    const dmatrix pearson_residuals(const dmatrix& o, const dvar_matrix p, const dvar_vector& log_vn) const;
  };


  /**
   * @brief Class for Dirichlet negative log-likelihood.
   * @details
   * Dirichlet likelihood for composition data with optional tail compression.
   * The `log_vn` argument controls concentration/dispersion according to the
   * kernel implementation.
  **/
  class dirichlet: public negativeLogLikelihood
  {

  private:
    /** @brief If true, compress observed/predicted rows before evaluation. */
    bool        m_bCompress;
    /** @brief Cached log concentration-like parameter(s). */
    dvariable   m_log_vn;
    /** @brief Cached predicted composition matrix (optional storage). */
    dvar_matrix m_P;

  public:
    dirichlet(const dmatrix &_O, const bool bCompress=false)
    : negativeLogLikelihood(_O), m_bCompress(bCompress) 
    {
      if ( m_bCompress ) tail_compression();
    }

    // ~dirichlet();
    virtual ~dirichlet() { }

    /** @brief Get cached log concentration-like parameter. */
    dvariable get_n()      const { return m_log_vn;    }
    /** @brief Set cached log concentration-like parameter. */
    void      set_n(dvariable _n){ this->m_log_vn = _n;}

    /** @brief Get cached predicted composition matrix. */
    dvar_matrix get_P()         const { return m_P;    }
    /** @brief Set cached predicted composition matrix. */
    void        set_P(dvar_matrix _P) { this->m_P = _P;}

    /**
     * @brief Compute Dirichlet per-row negative log-likelihood contributions.
     * @param log_vn Log concentration-like parameter by row.
     * @param _P Predicted composition proportions by row/bin.
     * @return Per-row Dirichlet contributions.
     */
    const dvar_vector nll_vector(const dvar_vector& log_vn, const dvar_matrix& _P) const
    {
      if ( m_bCompress )
      {
        dmatrix     Or = compress(this->get_O());
        dvar_matrix Pr = compress(_P);
        return ddirichlet(log_vn,Or,Pr);
      } else {
        return ddirichlet(log_vn,this->get_O(),_P);
      }
    }

    /**
     * @brief Compute total Dirichlet negative log-likelihood.
     * @param log_vn Log concentration-like parameter by row.
     * @param _P Predicted composition proportions by row/bin.
     * @return Summed Dirichlet contribution.
     */
    const dvariable nloglike(const dvar_vector& log_vn, const dvar_matrix& _P) const
    {
      return sum(nll_vector(log_vn, _P));
    }

    /**
     * @brief Baseline Dirichlet per-row contributions from observations.
     * @param _n Log concentration-like parameter by row.
     * @return Per-row Dirichlet contributions used by `nloglike`.
     */
    const dvar_vector nll_base(const dvar_vector& _n) const
    {
      dmatrix O = this->get_O();
      if (m_bCompress) O = compress(O);
      dvar_matrix P = O;
      for (int i = P.rowmin(); i <= P.rowmax(); i++)
      {
        dvariable s = sum(P(i));
        if (value(s) > 0.0) P(i) /= s;
      }
      return ddirichlet(_n, O, P);
    }

    /** @brief Compute Pearson residuals for Dirichlet model fit diagnostics. */
    const   dmatrix residual(const dvar_vector& _n, const dvar_matrix& _P) const
    {
      return pearson_residuals(_n,this->get_O(),_P);
    }
    
    /**
     * @brief Internal Dirichlet objective kernel.
     * @return Per-row negative log-likelihood contributions.
     */
    const dvar_vector ddirichlet(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix& p) const;

    /** @brief Internal Pearson residual kernel for Dirichlet model. */
    const dmatrix pearson_residuals(const dvar_vector& log_vn, const dmatrix& o, const dvar_matrix p) const;
  };

  /**
   * @brief Class for alternative Dirichlet-multinomial negative log-likelihood using Thorson et al. (2016) "theta" parameterization.
   * @details
   * Uses a theta-based parameterization with externally supplied input sample
   * sizes (`m_iss`). The base-class `nloglike` signature is preserved for
   * polymorphism; the `log_effn` argument is accepted for interface
   * compatibility and ignored by this implementation.
  **/
  class dirichlet_alt: public negativeLogLikelihood
  {

  private:
    /** @brief Log theta parameter in Thorson et al. (2016) parameterization. */
    dvariable   m_log_th;
    /** @brief Input sample sizes associated with each composition row. */
    dvector     m_iss;
    /** @brief If true, compress observed/predicted rows before evaluation. */
    bool        m_bCompress;
//    dvar_matrix m_P;         //matrix of predicted proportions

  public:
    dirichlet_alt(const dmatrix &_O, const dvariable& _log_th, const dvector& _iss, const bool bCompress=false)
    : negativeLogLikelihood(_O), m_log_th(_log_th), m_iss(_iss), m_bCompress(bCompress) 
    {
      if ( m_bCompress ) tail_compression();
    }

    // ~dirichlet_alt();
    virtual ~dirichlet_alt() { }

    /**
     * @brief Compute alternative Dirichlet-multinomial per-row contributions.
     * @param log_effn Required by interface, ignored in this implementation.
     * @param _P Predicted composition proportions by row/bin.
     * @return Per-row alternative Dirichlet-multinomial contributions.
     */
    const dvar_vector nll_vector(const dvar_vector& log_effn, const dvar_matrix& _P) const
    {
      (void)log_effn;
      if ( m_bCompress )
      {
        dmatrix     Or = compress(this->get_O());
        dvar_matrix Pr = compress(_P);
        return ddirichlet_alt(Or,Pr);
      } else {
        return ddirichlet_alt(this->get_O(),_P);
      }
    }

    /**
     * @brief Compute total alternative Dirichlet-multinomial negative log-likelihood.
     * @param log_effn Required by interface, ignored in this implementation.
     * @param _P Predicted composition proportions by row/bin.
     * @return Summed alternative Dirichlet-multinomial contribution.
     */
    const dvariable nloglike(const dvar_vector& log_effn, const dvar_matrix& _P) const
    {
      return sum(nll_vector(log_effn, _P));
    }

    /**
     * @brief Baseline alternative Dirichlet-multinomial per-row contributions.
     * @param _n Kept for interface compatibility (not used by this class kernel).
     * @return Per-row alternative Dirichlet-multinomial contributions used by `nloglike`.
     */
    const dvar_vector nll_base(const dvar_vector& _n) const
    {
      (void)_n;
      dmatrix O = this->get_O();
      if (m_bCompress) O = compress(O);
      dvar_matrix P = O;
      for (int i = P.rowmin(); i <= P.rowmax(); i++)
      {
        dvariable s = sum(P(i));
        if (value(s) > 0.0) P(i) /= s;
      }
      return ddirichlet_alt(O, P);
    }

    /** @brief Compute Pearson residuals for alternative Dirichlet-multinomial fit. */
    const   dmatrix residual(const dvar_vector& _n, const dvar_matrix& _P) const
    {
      return pearson_residuals(this->get_O(),_P);
    }
    
    /**
     * @brief Internal alternative Dirichlet-multinomial objective kernel.
     * @return Per-row negative log-likelihood contributions.
     */
    const dvar_vector ddirichlet_alt(const dmatrix& o, const dvar_matrix& p) const;

    /** @brief Internal Pearson residual kernel for alternative Dirichlet-multinomial model. */
    const dmatrix pearson_residuals(const dmatrix& o, const dvar_matrix p) const;
  };

} // end of acl namespace

#endif
