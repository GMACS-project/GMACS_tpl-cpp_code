/**
 * @file selex.hpp
 * @defgroup Selectivities
 * @author Steven Martell, D'Arcy N. Webber, William Stockhausen
 * @namespace gsm
 * @date Feb 10, 2014
 * @title Selectivity functions
 * @details Alternative selectivity functions in the gsm namespace are derived from the gsm::Selex base class.
 *
 * The Selex class is an abstract class that contains 3 virtual methods.
 * - **Selectivity** 	Arithmetic 0-1 values of selectivity values.
 * - **logSelectivity**	Returns selectivity vector in log-space.
 * - **logSelexMeanOne** Returns selectivity in log-space and rescaled to have mean 1
 * in arithmetic space.
 *
 * Example of how to use this class to create a selectivity vector.
 *
 * 		// Declare a pointer to the abstract base class Selex.
 * 		// Cast the <type> of variable that the class will return.
 * 		gsm::Selex<dvector> *pSLX;
 *
 * 		// Instantiate a new Logistic curve selectivity with parameters p1 & p2
 * 		pSLX = new gsm::LogisticCurve<dvector,double>(p1,p2);
 *
 * 		// Call one of the available methods in the abstract class for size bins x
 * 		sex = pSLX -> Selectivity(x);
 *
 * Table 1. List of available selectivity functions, function names, and the class
 * object.
 * | Selectivity       | Functions        | Class name              |
 * |-------------------|------------------|-------------------------|
 * | Logistic          | plogis           | LogisticCurve           |
 * | Logistic95        | plogis95         | LogisticCurve95         |
 * | Coefficients      | selcoffs         | SelectivityCoefficients |
 * | Nonparameteric    | nonparametric    | ParameterPerClass       |
 * | Uniform           | uniform          | UniformCurve            |
 * | Declining logistic| declplogistic    | DeclineLogistic         |
 * | Uniform           | uniform          | LogisticCurveOne        |
 * | Double normal     | pdubnorm         | DoubleNormal            |
 * | Double normal     | pdubnorm4        | DoubleNormal4           |
 * | Double normal     | pDubnorm6        | DoubleNormal6           |
 * | Stacked logistic  | plogis           | StackedLogistic         |
 * | Spline            | spline_cubic_val | SelectivitySpline       |
**/

#ifndef SELEX_HPP
#define SELEX_HPP

// Global headers
#include <admodel.h>

#include "gsm_splines.hpp"
// #include "gsm.h"


namespace gsm {

    // =========================================================================================================
    // Selex: Defined Base Class for Selectivity Functions
    // =========================================================================================================

    /**
     * @ingroup Selectivities
     * @brief An abstract class for Selectivity functions.
     * @details Classes that derive from this class overload the pure virtual functions:<br><br>
     * const T Selectivity(const T &x) const <br>
     *
     * @tparam x Independent variable (ie. age or size) for calculating selectivity.
    **/

    template<class T>
    class Selex
    {

    private:
            T m_x;

    public:
            virtual const T Selectivity(const T &x) const = 0;
            virtual const T logSelectivity(const T &x) const = 0;
            virtual const T logSelexMeanOne(const T &x) const = 0;
            virtual ~Selex(){}
            void Set_x(T & x) { this->m_x = x; }
            T    Get_x() const{ return m_x;     }
    };

    // =========================================================================================================
    // plogis: Base functions for logistic-based selectivity functions
    // =========================================================================================================
    /**
     * @brief Logistic function
     * @details Basic two parameter logistic function with mean and standard deviation.
     *          Return type will be the same as x, so x:
     *            should be a dvar_vector if mean, sd are dvariables
     *            should be a dvector if mean, sd are doubles
     *
     * @param T x - Independent variable (e.g. age or size) as data vector or dvar vector
     * @param T2 mean - size at 50% selected
     * @param T2 sd - 'width' of the logistic curve
     *
     * @return selectivity at values of x. Return type will be same as x.
    **/
    template<class T,class T2>
    inline
    const T plogis(const T &x, const T2 &mean, const T2 &sd)
    {
        T selex = T2(1.0)/(T2(1.0)+mfexp(-(x-mean)/sd));
        return selex;
    }


    /**
     * @brief Logistic function with size at 50%, 95% selection parameterization
     * @details Alternative two parameter logistic function with mean and standard deviation
     *          Return type will be the same as x, so x:
     *            should be a dvar_vector if mean, sd are dvariables
     *            should be a dvector if mean, sd are doubles
     *
     * @param T x - Independent variable (e.g. age or size) as data vector or dvar vector
     * @param T2 s50 - size at 50% selected
     * @param T2 s95 - size at 95% selected
     *
     * @return selectivity at values of x. Return type will be same as x.
    **/
    template<class T, class T2>
    inline
    const T plogis95(const T &x, const T2 &s50, const T2 &s95)
    {
        T selex = T2(1.0)/(T2(1.0)+(exp(-log(19)*((x-s50)/(s95-s50)))));
        return selex;
    }


    /**
     * @brief Logistic function with size at slope selection parameterization and 0.999 for last class
     * @details Alternative two parameter logistic function with mean and standard deviation
     *          Return type will be the same as x, so x:
     *            should be a dvar_vector if mean, sd are dvariables
     *            should be a dvector if mean, sd are doubles
     *
     * @param T x - Independent variable (e.g. age or size) as data vector or dvar vector
     * @param T2 slope - slope
     *
     * @return selectivity at values of x. Return type will be same as x.
    **/
    template<class T, class T2>
    inline
    const T plogisOne(const T &x, const T2 &slope)
    {
        int x1 = x.indexmax();
         T selex = T2(1.0)/(T2(1.0)+exp(slope*(-x+x(x1))+log(1.0/0.999-1.0)));
        return selex;
    }


    /**
     * @brief 3-parameter double normal function (no plateau)
     * @details Return type will be the same as x, so x:
     *            should be a dvar_vector if sL, s50, sR are dvariables
     *            should be a dvector     if sL, s50, sR are doubles
     *
     * @param T x - Independent variable (e.g. age or size) as data vector or dvar vector
     * @param T2 sL - ascending limb width
     * @param T2 s50 - size/age at full selection (50% cdf)
     * @param T2 sR - descending limb width
     *
     * @return selectivity at values of x. Return type will be same as x.
    **/
    template<class T, class T2>
    inline
    const T pdubnorm(const T &x, const T2 &sL, const T2 &s50, const T2 &sR)
    {
        T2 slp  = T2(5.0);//use pretty steep slope for join
        T selLH = mfexp(-0.5*square((x-s50)/sL));// ascending limb
        T selRH = mfexp(-0.5*square((x-s50)/sR));//descending limb
        T join  = 1.0/(1.0+exp(-slp*(x-s50)));//0 for x<s50, 1 for x>s50
        T selex = elem_prod(elem_prod(1.0-join,selLH) + join,
                            elem_prod(    join,selRH) + (1.0-join));
        return selex;
    }

    /**
     * @brief 4-parameter double normal function (with plateau)
     * @details Return type will be the same as x, so x:
     *            should be a dvar_vector if ascWdZ, ascPkZ, dscWdZ, dscPkZ are dvariables
     *            should be a dvector     if ascWdZ, ascPkZ, dscWdZ, dscPkZ are doubles
     *
     * @param T x - Independent variable (e.g. age or size) as data vector or dvar vector
     * @param T2 ascWdZ - ascending limb width
     * @param T2 ascPkZ - ascending limb size/age at full selection
     * @param T2 dscWdZ - descending limb width
     * @param T2 dscPkZ - descending limb size/age at full selection
     *
     * @return selectivity at values of x. Return type will be same as x.
    **/
    template<class T, class T2>
    inline
    const T pdubnorm4(const T &x, const T2 &ascWdZ, const T2 &ascPkZ,
                                  const T2 &dscWdZ, const T2 &dscPkZ)
    {
        T2 slp = T2(5.0);
        T ascS = mfexp(-0.5*square((x-ascPkZ)/ascWdZ));
        T dscS = mfexp(-0.5*square((x-dscPkZ)/dscWdZ));
        T ascJ = 1.0/(1.0+mfexp( slp*(x-(ascPkZ))));
        T dscJ = 1.0/(1.0+mfexp(-slp*(x-(dscPkZ))));
        T s = elem_prod(elem_prod(ascJ,ascS)+(1.0-ascJ),
                        elem_prod(dscJ,dscS)+(1.0-dscJ));
        return s;
    }

    // DecliningLogisticCurve: Base function for declining logistic selectivity coefficients
    /**
     * @brief declining function
     * @details Basic two parameter logistic function with mean and slope plus coefficients for the first few size-classes
     *          Return type will be the same as x, so x:
     *            should be a dvar_vector if any other inputs are dvar_ types
     *            should be a dvector     if all other inputs are not dvar_ types
     *
     * @param T x - Independent variable (e.g. age or size) as data vector or dvar vector
     * @param T1 mean - size at 50% selected
     * @param T2 slope - slope of the logistic curve
     * @param T3 sel_coeffs - dvector or dvar_vector for over-ride values
    **/
    template<class T, class T1, class T2, class T3>
    const T declplogis(const T &x, const T1 &mean, const T2 &slope, const T3 &sel_coeffs)
    {
        T logisticselex = T2(1.0)/(T2(1.0)+mfexp(slope*(x-mean)));
        int x1 = x.indexmin();
        int y2 = sel_coeffs.indexmax();
        T selex = 1.0*logisticselex;
        for ( int i = x1; i <= y2; i++ ) selex(i) = mfexp(sel_coeffs(i));
        return selex;
    }

    // nonparametric: Base function for non-parametric selectivity option
    /**
     * @brief Nonparametric selectivity function
     *
     * @details Estimate one parameter per age/size class.
     *        NOTES: x and selparms types must be identical.
     *               selparms are on ln-scale
     *               indices of x must be compatible with those of selparms, but don't need to be identical
     *
     * @param x Independent variable (number of classes)
     * @param selparms Vector of ln-scale selectivity parameters (initial values).
     *
     * @return Selectivity values, with same type as x.
    **/
    template<class T>
    const T nonparametric(const T &x, const T &selparms)
    {
        T selex = 0.0*x;
        for ( int i = x.indexmin(); i <= x.indexmax(); i++ )
        {
            selex(i) = mfexp(selparms(i));
        }
        return selex;
    }

    // --------------------------------------------------------------------------------------------------
    // Selectivity classes
    // --------------------------------------------------------------------------------------------------

    // LogisticCurve: Logistic-based selectivity function with options
    /**
     * @brief Logistic curve
     * @details Uses the logistic curve (plogis) for a two parameter function
     *
     * @tparam T data vector or dvar vector
     * @tparam T2 double or dvariable for mean and standard deviation of the logistic curve
    **/
    template<class T,class T2>
    class LogisticCurve: public Selex<T>
    {
    private:
            T2 m_mean;
            T2 m_std;

    public:
            LogisticCurve(T2 mean = T2(0), T2 std = T2(1))
            : m_mean(mean), m_std(std) {}

            T2 GetMean() const { return m_mean; }
            T2 GetStd()  const { return m_std;  }

            void SetMean(T2 &mean) { this->m_mean = mean;}
            void SetStd(T2 &std)   { this->m_std  = std; }
            void SetParams(T2 &mean, T2 &std){this->m_mean = mean;this->m_std  = std;}

            /**
             * @brief selex
             * @param T x - independent variable--must be compatible with T2
             * @return selex with type T
             */
            const T Selectivity(const T &x) const
            {
                    return gsm::plogis(x, m_mean, m_std);
            }

            /**
             * @brief calculate log(selex)
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex) with type T
             */
            const T logSelectivity(const T &x) const
            {
                    return log(gsm::plogis(x, m_mean, m_std));
            }

            /**
             * @brief calculate log(selex/mean(selex))
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex/mean(selex)) with type T
             */
            const T logSelexMeanOne(const T &x) const
            {
                    T y = log(gsm::plogis(x, m_mean, m_std));
                    y  -= log(mean(mfexp(y)));
                    return y;
            }
    };

    // LogisticCurve95: Logistic-based selectivity function with options
    /**
     * @brief Logistic curve parameterised with 5% and 95% selectivity
     * @details Uses the logistic curve (plogis95) for a two parameter function
     *
     * @tparam T data vector or dvar vector
     * @tparam T2 double or dvariable for size at 5% and 95% selectivity
    **/
    template<class T,class T2>
    class LogisticCurve95: public Selex<T>
    {
    private:
            T2 m_s50;
            T2 m_s95;

    public:
            LogisticCurve95(T2 s50 = T2(1), T2 s95 = T2(1))
            : m_s50(s50), m_s95(s95) {}

            T2 GetS50() const { return m_s50; }
            T2 GetS95() const { return m_s95; }

            void SetS50(T2 &s50) { this->m_s50 = s50; }
            void SetS95(T2 &s95) { this->m_s95 = s95; }
            void SetParams(T2 &s50, T2 &s95){this->m_s50 = s50;this->m_s95  = s95;}

            /**
             * @brief selex
             * @param T x - independent variable--must be compatible with T2
             * @return selex with type T
             */
            const T Selectivity(const T &x) const
            {
                    return gsm::plogis95(x, m_s50, m_s95);
            }

            /**
             * @brief calculate log(selex)
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex) with type T
             */
            const T logSelectivity(const T &x) const
            {
                    return log(gsm::plogis95(x, m_s50, m_s95));
            }

            /**
             * @brief calculate log(selex/mean(selex))
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex/mean(selex)) with type T
             */
            const T logSelexMeanOne(const T &x) const
            {
                    T y = log(gsm::plogis95(x, m_s50, m_s95));
                    //y  -= log(mean(mfexp(y)));//WTS: added this
                    return y;
            }
    };



    // OneParLogistic: Logistic-based selectivity function with 0.999 for last class
    /**
     * @brief Logistic curve parameterised with 50% selectivity
     * @details Uses the logistic curve (plogisone) for a one parameter function
     *
     * @tparam T data vector or dvar vector
     * @tparam T2 double or dvariable for size at 50% selectivity
    **/
    template<class T,class T2>
    class LogisticCurveOne: public Selex<T>
    {
    private:
            T2 m_slope;

    public:
            LogisticCurveOne(T2 slope = T2(1))
            : m_slope(slope) {}

            T2 GetSlope() const { return m_slope; }

            void SetSlope(T2 &slope) { this->m_slope = slope; }
            void SetParams(T2 &slope){this->m_slope = slope;}

            /**
             * @brief selex
             * @param T x - independent variable--must be compatible with T2
             * @return selex with type T
             */
            const T Selectivity(const T &x) const
            {
                    return gsm::plogisOne(x, m_slope);
            }

            /**
             * @brief calculate log(selex)
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex) with type T
             */
            const T logSelectivity(const T &x) const
            {
                    return log(gsm::plogisOne(x, m_slope));
            }

            /**
             * @brief calculate log(selex/mean(selex))
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex/mean(selex)) with type T
             */
            const T logSelexMeanOne(const T &x) const
            {
                    T y = log(gsm::plogisOne(x, m_slope));
                    y  -= log(mean(mfexp(y)));
                    return y;
            }
    };



    // DecliningLogistic: Declining Logistic-based selectivity function with options
    /**
     * @brief Declining Logistic curve
     * @details Uses the logistic curve (plogisd) for a two parameter function
     *          but overrides the first few size classes
     *
     * @tparam T data vector or dvar vector
     * @tparam T2 double or dvariable for mean and standard deviation of the logistic curve
    **/
    template<class T, class T1,class T2, class T3>
    class DeclineLogistic: public Selex<T>
    {
    private:
            T1 m_mean;
            T2 m_slope;
            T3 m_sel_coeffs;

    public:
            DeclineLogistic(T1 mean = T2(0), T2 slope = T2(1), T3 params = T3(1) )
            : m_mean(mean), m_slope(slope), m_sel_coeffs(params) {}

            T1 GetMean() const { return m_mean; }
            T2 GetSlope()  const { return m_slope;  }
            T3 GetSelCoeffs() const { return m_sel_coeffs; }

            void SetMean(T1 &mean) { this->m_mean = mean;}
            void SetSlope(T2 &slope)   { this->m_slope  = slope; }
            void SetSelCoeffs(T3 &x) { this->m_sel_coeffs = x; }
            void SetParams(T1 &mean, T2 &slope, T3 &x){
                this->m_mean = mean;
                this->m_slope  = slope;
                this->m_sel_coeffs = x;
            }

            /**
             * @brief selex
             * @param T x - independent variable--must be compatible with T2
             * @return selex with type T
             */
            const T Selectivity(const T &x) const
            {
                    return gsm::declplogis(x, m_mean, m_slope, m_sel_coeffs );
            }

            /**
             * @brief calculate log(selex)
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex) with type T
             */
            const T logSelectivity(const T &x) const
            {
                    return log(gsm::declplogis(x, m_mean, m_slope, m_sel_coeffs ));
            }

            /**
             * @brief calculate log(selex/mean(selex))
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex/mean(selex)) with type T
             */
            const T logSelexMeanOne(const T &x) const
            {
                    T y = log(gsm::declplogis(x, m_mean, m_slope, m_sel_coeffs ));
                    y  -= log(mean(mfexp(y)));
                    return y;
            }
    };

    // DoubleNormal: 3-parameter double normal (dome shaped) selectivity
    /**
     * @brief 3-parameter double normal curve
     * @details Uses gsm::pdubnorm<T> function.
     *
     * @param T data vector or dvar vector
     * @param T2 double or dvariable for left-hand width, size at dome, right-hand width
    **/
    template<class T,class T2>
    class DoubleNormal: public Selex<T>
    {
    private:
            T2 m_sL;
            T2 m_s50;
            T2 m_sR;

    public:
        /**
         * Class constructor.
         *
         * @param sL - width of lefthand limb  (default=1)
         * @param s50 - size at dome           (default=1)
         * @param sR - width of righthand limb (default=1)
         */
            DoubleNormal(T2 sL = T2(1), T2 s50 = T2(1), T2 sR = T2(1))
            : m_sL(sL), m_s50(s50), m_sR(sR) {}

            T2 GetSL()  const { return m_sL; }
            T2 GetS50() const { return m_s50; }
            T2 GetSR()  const { return m_sR; }

            void SetSL(T2 &sL)   { this->m_sL = sL; }
            void SetS50(T2 &s50) { this->m_s50 = s50; }
            void SetSR(T2 &sR)   { this->m_sR = sR; }
            void SetParams(T2 &sL, T2 &s50, T2 &sR){
                this->m_sL = sL;
                this->m_s50 = s50;
                this->m_sR = sR;
            }

            /**
             * @brief selex
             * @param T x - independent variable--must be compatible with T2
             * @return selex with type T
             */
            const T Selectivity(const T &x) const
            {
                return gsm::pdubnorm(x, m_sL, m_s50, m_sR);
            }

            /**
             * @brief calculate log(selex)
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex) with type T
             */
            const T logSelectivity(const T &x) const
            {
                return log(gsm::pdubnorm(x, m_sL, m_s50, m_sR));
            }

            /**
             * @brief calculate log(selex/mean(selex))
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex/mean(selex)) with type T
             */
            const T logSelexMeanOne(const T &x) const
            {
                T y = log(gsm::pdubnorm(x, m_sL, m_s50, m_sR));
                y  -= log(mean(mfexp(y)));
                return y;
            }
    };

    // DoubleNormal4: 4-parameter double normal (dome shaped) selectivity
    /**
     * @brief 4-parameter double normal curve
     * @details Uses the logistic curve (plogis95) for a two parameter function
     *
     * @param T data vector or dvar vector
     * @param T2 double or dvariable
    **/
    template<class T,class T2>
    class DoubleNormal4: public Selex<T>
    {
    private:
        T2 m_ascWdZ;//ascending limb width
        T2 m_ascPkZ;//size at which ascending limb reaches 1
        T2 m_dscWdZ;//descending limb width
        T2 m_dscPkZ;//size at which descending limb departs from 1

    public:
        /**
         *
         * @param ascWdZ - ascending limb width
         * @param ascPkZ - size at which ascending limb reaches 1
         * @param dscWdZ - descending limb width
         * @param dscPkZ - size at which descending limb departs from 1
         */
        DoubleNormal4(T2 ascWdZ = T2(1), T2 ascPkZ = T2(1),
                      T2 dscWdZ = T2(1), T2 dscPkZ = T2(1))
        : m_ascWdZ(ascWdZ), m_ascPkZ(ascPkZ), m_dscWdZ(dscWdZ), m_dscPkZ(dscPkZ) {}

        T2 GetAscWdZ()  const { return m_ascWdZ; }
        T2 GetAscPkZ()  const { return m_ascPkZ; }
        T2 GetDscWdZ()  const { return m_dscWdZ; }
        T2 GetDscPkZ()  const { return m_dscPkZ; }

        void SetAscWdZ(T2 &ascWdZ){ this->m_ascWdZ = ascWdZ; }
        void SetAscPkZ(T2 &ascPkZ){ this->m_ascPkZ = ascPkZ; }
        void SetDscWdZ(T2 &dscWdZ){ this->m_dscWdZ = dscWdZ; }
        void SetDscPkZ(T2 &dscPkZ){ this->m_dscPkZ = dscPkZ; }
        void SetParams(T2 &ascWdZ, T2 &ascPkZ, T2 &dscWdZ, T2 &dscPkZ){
            this->m_ascWdZ = ascWdZ;
            this->m_ascWdZ = ascPkZ;
            this->m_dscWdZ = dscWdZ;
            this->m_dscPkZ = dscPkZ;
        }

        /**
         * @brief selex
         * @param T x - independent variable--must be compatible with T2
         * @return selex with type T
         */
        const T Selectivity(const T &x) const
        {
            return gsm::pdubnorm4(x, m_ascWdZ, m_ascPkZ, m_dscWdZ, m_dscPkZ);
        }

        /**
         * @brief calculate log(selex)
         * @param T x - independent variable--must be compatible with T2
         * @return log(selex) with type T
         */
        const T logSelectivity(const T &x) const
        {
            return log(gsm::pdubnorm4(x, m_ascWdZ, m_ascPkZ, m_dscWdZ, m_dscPkZ));
        }

        /**
         * @brief calculate log(selex/mean(selex))
         * @param T x - independent variable--must be compatible with T2
         * @return log(selex/mean(selex)) with type T
         */
        const T logSelexMeanOne(const T &x) const
        {
            T y = log(gsm::pdubnorm4(x, m_ascWdZ, m_ascPkZ, m_dscWdZ, m_dscPkZ));
            y  -= log(mean(mfexp(y)));
            return y;
        }
    };

    // StackedLogistic: 5-parameter stacked logistic selectivity
    /**
     * @brief 5-parameter stacked logistic selectivity
     * @details Uses the logistic curve (plogis95) for a two parameter function
     *
     * @param T data vector or dvar vector
     * @param T2 double or dvariable
    **/
    template<class T,class T2>
    class StackedLogistic: public Selex<T>
    {
    private:
        T2 m_omega;     // weighting factor
        T2 m_mean1;     // mean for the first logistic curve
        T2 m_sd1;       // sd for the first logistic curve
        T2 m_mean2;     // mean for the second logistic curve
        T2 m_sd2;       // sd for the first logistic curve

    public:
        /**
         *
         * @param omega - weighting factor
         * @param mean1 - mean for the first logistic curve
         * @param sd1   - sd for the first logistic curve
         * @param mean2 - mean for the second logistic curve
         * @param sd2   - sd for the first logistic curve
         */
        StackedLogistic(T2 omega = T2(1), T2 mean1 = T2(1),
                      T2 sd1 = T2(1), T2 mean2 = T2(1), T2 sd2 = T2(1))
        : m_omega(omega), m_mean1(mean1), m_sd1(sd1), m_mean2(mean2), m_sd2(sd2) {}

        T2 GetOmega()  const { return m_omega; }
        T2 GetMean1()  const { return m_mean1; }
        T2 GetSd1()    const { return m_sd1; }
        T2 GetMean2()  const { return m_mean2; }
        T2 GetSd2()    const { return m_sd2; }

        void SetOmega(T2 &omega){ this->m_omega = omega; }
        void SetMean1(T2 &mean1){ this->m_mean1 = mean1; }
        void SetSd1(T2 &sd1)    { this->m_sd1 = sd1; }
        void SetMean2(T2 &mean2){ this->m_mean2 = mean2; }
        void SetSd2(T2 &sd2)    { this->m_sd2 = sd2; }
        void SetParams(T2 &omega, T2 &mean1, T2 &sd1, T2 &mean2, T2 &sd2){
            this->m_omega = omega;
            this->m_mean1 = mean1;
            this->m_sd1   = sd1;
            this->m_mean2 = mean2;
            this->m_sd2   = sd2;
        }

        /**
         * @brief selex
         * @param T x - independent variable--must be compatible with T2
         * @return selex with type T
         */
        const T Selectivity(const T &x) const
        {
             T y1 = gsm::plogis(x, m_mean1, m_sd1);
             T y2 = gsm::plogis(x, m_mean2, m_sd2);
             T y = m_omega*y1 + (1-m_omega)*y2;
            return y;
        }

        /**
         * @brief calculate log(selex)
         * @param T x - independent variable--must be compatible with T2
         * @return log(selex) with type T
         */
        const T logSelectivity(const T &x) const
        {
             T y1 = gsm::plogis(x, m_mean1, m_sd1);
             T y2 = gsm::plogis(x, m_mean2, m_sd2);
             T y = m_omega*y1 + (1-m_omega)*y2;
             y = log(y);
            return y;
        }

        /**
         * @brief calculate log(selex/mean(selex))
         * @param T x - independent variable--must be compatible with T2
         * @return log(selex/mean(selex)) with type T
         */
        const T logSelexMeanOne(const T &x) const
        {
             T y1 = gsm::plogis(x, m_mean1, m_sd1);
             T y2 = gsm::plogis(x, m_mean2, m_sd2);
             T y = m_omega*y1 + (1-m_omega)*y2;
             y = log(y);
             y  -= log(mean(mfexp(y)));
            return y;
        }
    };

    // Coefficients: Base function for non-parametric selectivity cooefficients
    /**
     * @brief Nonparametric selectivity coefficients
     * @details The length of the vector sel_coeffs must be less than or equal to
     * length of the independent variabls x.  If it it shorter, then it is assumed that
     * the parameters in the last element of sel_coeffs is the same for all elements in
     * the terminus of the independent vector.  Also use a logit transformation to ensure
     * that selectivities are bounded between 0-1.
     *
     * @param x Independent variable
     * @param sel_coeffs Vector of estimated selectivity coefficients logit (??: exponential?) transformed.
     * @return Selectivity coefficients.
    **/
    template<class T>
    const T coefficients(const T &x, const T &sel_coeffs)
    {
            int x1 = x.indexmin();
            int x2 = x.indexmax();
            int y2 = sel_coeffs.indexmax();
            T y = 0.0*x;
            for ( int i = x1; i < y2; i++ )
            {
                    y(i) = mfexp(sel_coeffs(i));
            }
            y(y2,x2) = mfexp(sel_coeffs(y2));
            return y;
    }

    // SelectivityCoefficients: Age/size-specific selectivity coefficients for n-1 age/size classes
    /**
     * @brief Selectivity coefficients
     * @details Age or size-specific selectivity coefficients for n-1 age/size classes
     *
     * @tparam T vector of coefficients
    **/
    template<class T>
    class SelectivityCoefficients: public Selex<T>
    {
    private:
            T m_sel_coeffs;

    public:
            SelectivityCoefficients(T params = T(1))
            :m_sel_coeffs(params) {}

            T GetSelCoeffs() const { return m_sel_coeffs; }
            void SetSelCoeffs(T &x) { this->m_sel_coeffs = x; }

            /**
             * @brief selex
             * @param T x - independent variable--must be compatible with T2
             * @return selex with type T
             */
            const T Selectivity(const T &x) const
            {
                    // Call the age/size specific function
                    return gsm::coefficients(x, m_sel_coeffs);
            }

            /**
             * @brief calculate log(selex)
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex) with type T
             */
            const T logSelectivity(const T &x) const
            {
                    // Call the age/size specific function
                    return log(gsm::coefficients(x, m_sel_coeffs));
            }

            /**
             * @brief calculate log(selex/mean(selex))
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex/mean(selex)) with type T
             */
            const T logSelexMeanOne(const T &x) const
            {
                    T y = log(gsm::coefficients(x, m_sel_coeffs));
                    y -= log(mean(mfexp(y)));
                    return y;
            }
    };


    // ParameterPerClass: One age/size-specific selectivity parameter for each age/size class
    /**
     * @brief Parametric selectivity function
     * @details One age or size-specific selectivity parameter for each age/size class.
     *
     * Note that the same can be accomplished using the SelectivityCoefficients class but Athol wanted to have this function in CSTAR
     *
     * @param T vector of parameters (initial values)
    **/
    template<class T>
    class ParameterPerClass: public Selex<T>
    {
    private:
            T m_selparms;

    public:
            ParameterPerClass(T selparms = T(1))
            :m_selparms(selparms) {}

            T GetSelparms() const { return m_selparms; }
            void SetSelparms(T &selparms) { this->m_selparms = selparms; }

            /**
             * @brief selex
             * @param T x - independent variable--must be compatible with T
             * @return selex with type T
             */
            const T Selectivity(const T &x) const
            {
                    // Call the age/size specific function
                    return gsm::nonparametric(x, m_selparms);
            }

            /**
             * @brief calculate log(selex)
             * @param T x - independent variable--must be compatible with T
             * @return log(selex) with type T
             */
            const T logSelectivity(const T &x) const
            {
                    // Call the age/size specific function
                    return log(gsm::nonparametric(x, m_selparms));
            }

            /**
             * @brief calculate log(selex) [NOT log(selex/mean(selex))??]
             * @param T x - independent variable--must be compatible with T2
             * @return log(selex/mean(selex)) with type T
             */
            const T logSelexMeanOne(const T &x) const
            {
                    T y = log(gsm::nonparametric(x, m_selparms));
                    //y  -= log(mean(mfexp(y)));
                    return y;
            }
    };

    // UniformCurve: Uniform over a length
    /**
     * @brief Flat selectivity
     * @details All values equal 1 (with type T)
    **/
    template<class T>
    class UniformCurve: public Selex<T>
    {

    public:
            UniformCurve() {}

            /**
             * @brief selex
             * @param T x - independent variable
             * @return 1 with type T
             */
            const T Selectivity(const T &x) const
            {
                    T selex = 1.0 + 0.0*x;
                    return selex;
            }

            /**
             * @brief calculate log(selex) = 0
             * @param T x - independent variable--must be compatible with T2
             * @return 0 with type T
             */
            const T logSelectivity(const T &x) const
            {
                    T selex = 0.0*x;
                    return selex;
            }
            /**
             * @brief calculate log(selex/mean(selex))
             * @param T x - independent variable--must be compatible with T2
             * @return 0 with type T
             */
            const T logSelexMeanOne(const T &x) const
            {
                    T selex = 0.0*x;//WTS: was 1.0+0.0*x, but this was not correct
                    return selex;
            }

    };

    /**
     * @brief Uniform curve with selex = 0.
     */
    template<class T>
    class Uniform0Curve: public Selex<T>
    {

    public:
            Uniform0Curve() {}

            /**
             * @brief selex
             * @param T x - independent variable
             * @return selex with type T
             */
            const T Selectivity(const T &x) const
            {
                T selex = 0.0*x;
                    return selex;
            }

            /**
             * @brief calculate log(selex) [= -100]
             * @param T x - independent variable--must be compatible with T2
             * @return -100 with type T
             */
            const T logSelectivity(const T &x) const
            {
                T selex = -100.0 + 0.0*x;
                    return selex;
            }
            /**
             * @brief calculate log(selex/mean(selex)) [= 0 here]
             * @param T x - independent variable--must be compatible with T2
             * @return 0 with type T
             */
            const T logSelexMeanOne(const T &x) const
            {
                    T selex = 0.0*x;//WTS: was 1.0+0.0*x, but this was not correct
                    return selex;
            }

    };


    // Cubic Spline: Age/size-specific for a cubic split
    /**
     * @brief Cubic Spline
     * @details Cubic spline
     *
     * @param y_vals T vector of values at knots (selex type will be T)
     * @param x_vals T1 vector of knots (must be non-dvar_ if T is non-dvar_)
    **/
    template<typename T, typename T1>
    class SelectivitySpline: public Selex<T> {
        public:
            static int debug;//debugging flag

        private:
            T  m_yvals; //dependent values in spline (estimated parameters, can be dvar_ or non-dvar_)
            T1 m_xvals; //independent values in spline (knots, must be non-dvar_ if yvals is non-dvar_
            T  m_y2vals;//2nd derivatives of m_yvals at m_xvals


        public:
            /**
             * Constructor for cubic spline. Beginning and ending boundary conditions
             * on first derivatives are set to 0.
             *
             * @param T  yvals - values at knots (can be dvar_ or non-dvar_)
             * @param T1 xvals - knots           (must be non-dvar_ if yvals is non-dvar_)
             */
            SelectivitySpline(const T &yvals, const T1 &xvals){
                initSpline(yvals,xvals);
            }

            /**
             * Calculate second derivatives for spline interpolation.
             *
             * @param T yvals
             * @param T1 xvals
             */
            void initSpline(const T &yvals, const T1 &xvals) {
                if ((m_yvals.indexmin()!=yvals.indexmin())||
                    (m_yvals.indexmax()!=yvals.indexmax())){
                    if (debug) cout<<"initSpline:: deallocating arrays"<<endl;
                    m_yvals.deallocate();
                    m_xvals.deallocate();
                    m_y2vals.deallocate();
                }
                m_yvals = (T&)  yvals;//create shallow, un-const copy
                m_xvals = (T1&) xvals;//create shallow, un-const copy

                //shift arrays to start at 0
                int lb = m_xvals.indexmin();//lower bound on x and y indices
                m_xvals.shift(0);
                m_yvals.shift(0);

                //calculate second derivatives
                //cout<<"--computing 2nd derivatives"<<endl;
                int ibcbeg = 1;
                int ibcend = 1;
                double ybcbeg = 0.0;
                double ybcend = 0.0;
                m_y2vals.allocate(m_xvals);
                m_y2vals = spline_cubic_set(m_yvals, m_xvals, ibcbeg, ybcbeg, ibcend, ybcend);

                //shift arrays back to start at original lower index
                m_xvals.shift(lb);
                m_yvals.shift(lb);
                m_y2vals.shift(lb);
                //cout<<"m_xvals = "<<m_xvals<<endl;
                //cout<<"m_yvals= "<<m_yvals<<endl;
                //cout<<"y2vals  = "<<m_y2vals<<endl;
            }

            /**
             * @brief selex
             * @param T1 x - independent variable--must be compatible with T
             * @return selex with type T
             */
            const T Selectivity(const T1 &x) const {
                // do interpolation at x values
                int mmin = x.indexmin();
                int mmax = x.indexmax();
                T selex(x.indexmin(),x.indexmax());
                T tempX(x.indexmin(),x.indexmax());
                for (int i=mmin;i<=mmax;i++){
				   {
                    tempX(i) = spline_cubic_val(x(i),m_xvals,m_yvals,m_y2vals);
                    selex(i) = mfexp(tempX(i))/(1.0+exp(tempX(i)));
				   }
                }
                return selex;
            }

            /**
             * @brief calculate log(selex)
             * @param T1 x - independent variable--must be compatible with T
             * @return log(selex) with type T
             */
            const T logSelectivity(const T1 &x) const {
                return log(Selectivity(x));
            }

            /**
             * @brief calculate log(selex/mean(selex))
             * @param T1 x - independent variable--must be compatible with T
             * @return log(selex/mean(selex)) with type T
             */
            const T logSelexMeanOne(const T1 &x) const {
                T y = log(Selectivity(x));
                y -= log(mean(mfexp(y)));
                return y;
            }
    };//SelectivitySpline<T,T1>
    template<typename T, typename T1>
    int SelectivitySpline<T,T1>::debug = 0;//flag to print debugging info

} //gsm namespace

#endif /* SELEX_HPP */

