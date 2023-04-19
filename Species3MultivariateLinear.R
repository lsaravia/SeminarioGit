library(rethinking)

# Dos especies que compiten, y responden a un factor no observado U 
# y a otro factor observado Q que es discreto
#
#
set.seed(73)
N <- 50
id <- 1:N
U_sim <- rnorm( N ) + 0.2 * id
U_sim <- U_sim - min(U_sim)
plot(id,U_sim)
#Q_sim <- sample( 1:4 , size=N , replace=TRUE )
E_sim <- rpois( N , U_sim )
W_sim <- rpois( N , U_sim - .5 * E_sim) 
W_sim <- ifelse(is.na(W_sim),0,W_sim)
Z_sim <- rpois( N , max(U_sim) - U_sim + .2 * W_sim) 

plot(Z_sim,W_sim)
plot(Z_sim,E_sim)
plot(W_sim,E_sim)

dat_sim <- list(
  W=standardize(W_sim) ,
  E=standardize(E_sim) ,
  Z=standardize(Z_sim) ,
  U=standardize(U_sim))

#
# Modelo gausiano multivariado multinivel
#
m14.8 <- ulam(
  alist(
    c(W,E,Z) ~ multi_normal( c(muW,muE,muZ) , Rho , Sigma ),
    muW <- aW ,
    muE <- aE ,
    muZ <- aZ ,
    c(aW,aE,aZ) ~ normal( 0 , 0.2 ),
    Rho ~ lkj_corr( 2 ),
    Sigma ~ exponential( 1 )
  ), data=dat_sim , chains=4 , cores=4 )
plot(precis( m14.8 , depth=3, pars=c("Rho") ))

lbls <- c("W","E","Z")
pairs( m14.8 , pars="Rho" , labels=lbls )

#
# Modelo gausiano multivariado multinivel con variable ambiental U
#
m14.8a <- ulam(
  alist(
    c(W,E,Z) ~ multi_normal( c(muW,muE,muZ) , Rho , Sigma ),
    muW <- aW + bW*U,
    muE <- aE + bE*U,
    muZ <- aZ + bZ*U,
    c(aW,aE,aZ) ~ normal( 0 , 0.2 ),
    c(bW,bE,bZ) ~ normal( 0 , 0.2 ),
    Rho ~ lkj_corr( 2 ),
    Sigma ~ exponential( 1 )
  ), data=dat_sim , chains=4 , cores=4 )
precis( m14.8a , depth=3, pars=c("Rho") )

precis( m14.8a , depth=3 )


#
# Modelo gausiano multivariado multinivel con variable ambiental U
#
dat_sim <- list(
  W=standardize(W_sim) ,
  E=standardize(E_sim) ,
  Z=standardize(Z_sim) ,
  U=standardize(U_sim))

with(dat_sim, c(W,E,Z))

m14.8a <- ulam(
  alist(
    c(W,E,Z) ~ multi_normal( mu , Rho , Sigma ),
    muW <- aW + bW*U,
    muE <- aE + bE*U,
    muZ <- aZ + bZ*U,
    c(aW,aE,aZ) ~ normal( 0 , 0.2 ),
    c(bW,bE,bZ) ~ normal( 0 , 0.2 ),
    Rho ~ lkj_corr( 2 ),
    Sigma ~ exponential( 1 )
  ), data=dat_sim , chains=4 , cores=4 )
precis( m14.8a , depth=3, pars=c("Rho") )

precis( m14.8a , depth=3 )



# Analisis con el paquete Boral 
#
library(boral)
y <- data.frame(E=E_sim,W=W_sim,Z=Z_sim)

fit.lvmp <- boral(y = y, family = "poisson", lv.control = list(num.lv = 2), row.eff = "fixed")
plot(fit.lvmp)
lvsplot(fit.lvmp)


#
# Analisis usando una distribución Poisson 
#
y <- data.frame(I=rep(1:50, times=3),S=rep(1:3,each=50), C = c(E_sim,W_sim,Z_sim))
maxs <-  max(y$S)
maxI <-  max(y$I)
sim_data <- list(
  S = y$S,
  C = y$C,
  I = y$I
)

m14.9 <- ulam(
  alist(
    C ~ dpois(lambda),
    log(lambda) <- abar[S] + T[S], 
    abar[S] ~ normal(0,tau_A),
    vector[3]:T ~ multi_normal(0, Rho_gr,sigma_gr),
    Rho_gr ~ lkj_corr(2),
    c(tau_A,sigma_gr) ~ exponential(1)
  ), data=sim_data , chains=4 , cores=4 )

precis( m14.9 , depth=3, pars=c("Rho_gr"))
precis( m14.9 , depth=3)
  

#
# La densidad de cada especie depende del sitio porque el sitio tiene otras
# variables nutrientes luz etc que determinan el crecimiento y ademas tiene
# otras especies que pueden influir o no en la especie local
#
# En este caso las especies tienen interacciones y ademas responden a una variable
# ambiental que esta correlacionada con el sitio y es un gradiente
#
# A = Species
# B = Species
# S = Sitios

sim_data <-list(
  S = as.integer(y$S),
  C = y$C,
  I = as.integer(y$I))


m14.9 <- ulam(
  alist(
    C ~ dpois(lambda),
    log(lambda) <- abar[S] + s[I,S], 
    abar[A] ~ normal(0,tau_S),
    vector[50]:s[S] ~ multi_normal(0, Rho_S,sigma_S),
    Rho_S ~ dlkjcorr(2),
    sigma_S ~ exponential(1),
    tau_S ~ exponential(1)
  ), data=sim_data , chains=4 , cores=4 )

precis( m14.9 , depth=3)
stancode(m14.9)
#
# No funciona porque hay demasiados parametros para estimar la covarianza
#