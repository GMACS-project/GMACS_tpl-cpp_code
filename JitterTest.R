GenJitter <- function(JitterType,Initial,lower,upper,sdJitter)
{
  
  if (JitterType==1)
   {
    ifound = 0;
    ParValue = Initial;
    while (ifound ==0)
     {
       eps = rnorm(1,0,1);
       if (eps > 0)
        ParValue = Initial + eps*(upper-Initial)*sdJitter/4.0
      else
        ParValue = Initial + eps*(Initial-lower)*sdJitter/4.0
      if (ParValue > lower && ParValue < upper) ifound = 1;
    }
   }
  
  # Buck's version
   if (JitterType==2)
    {
     d = upper - lower;
     lower = lower+0.001*d;                        #shrink lower bound
     upper = upper-0.001*d;                        #shrink upper bound
     d = upper - lower;                            #shrink interval
     lp = Initial - 0.5*d*sdJitter;
     up = Initial + 0.5*d*sdJitter;
     eps = rnorm(1,0,1);
      rp = Initial + (eps-0.5)*d*sdJitter;
     if (rp > upper)
      {rp = lp - (rp-upper);}
     else
       if (rp < lower) {rp = up + (lower-rp);}
     ParValue = rp;
    }

   # Jie's version
   if (JitterType==3)
    {
     eps = rnorm(1,0,1);
     tem1 = 0.5*eps*sdJitter*log( (upper-lower+0.0000003)/(Initial-lower+0.0000001)-1.0);
     ParValue = lower+(upper-lower)/(1.0+exp(-2.0*tem1));
   }
 return(ParValue)  
}

lower <- 1; upper <- 5; Initial <- 3; sdJitter <- 0.1
Nsim <- 10000

Jitt <- rep(0,Nsim)

Titles <- c("Andre","Buck","Jie")
par(mfrow=c(3,1),oma=c(2,5,2,5))
for (JitterType  in 1:3)
{
  set.seed(125)
  for (Isim in 1:Nsim)
  Jitt[Isim] <- GenJitter(JitterType,Initial,lower,upper,sdJitter)
 hist(Jitt,main=Titles[JitterType])
}

  
  

  
  