# a script to pilot calls to a simple model created by MCSim "mod" with the
# command line instruction "mod -R simple.model simple_model.c"

require (deSolve)

system ("mod -R simple.model simple_model.c")

system ("R CMD SHLIB simple_model.c")

dyn.load ("simple_model.so")

source ("simple_model_inits.R")

# example of use of functions provided by simple_model_inits.R:

parms = initParms () # read default values

Y = initStates (parms) # read default initial state values

Outputs # list output variable, not a nice name will will call it "Sum" below

# you can reassign:

parms <- c(k1 = 0.04, k2 = 1e4, k3=3e7)

Y     <- c(y1 = 1.0, y2 = 0.0, y3 = 0.0)

# set output times, time 0 must be given
times <- c(0, 0.4*10^(0:11))

# no jacobian defined, let it decide...
out <- ode(Y, times, func = "derivs", parms = parms, jacfunc = "jac", dllname = "simple_model", initfunc = "initmod", nout = 1, outnames = "Sum")

plot(out,log="x",type="b")

# use events: either by dataframe:
times <- c(0:5000)

eventdata <- data.frame(var=rep("y1",2),time=c(400,4000),value=c(1,1), method=rep("rep",2))

eventdata

out <- ode(Y, times, func = "derivs", parms = parms, jacfunc = "jac", dllname = "simple_model", initfunc = "initmod", nout = 1, outnames = "Sum", events = list(data = eventdata))

plot(out, type="l")

# use events: by a C function (not an R function!)

out <- ode(Y, times, func = "derivs", parms = parms, jacfunc = "jac", dllname = "simple_model", initfunc = "initmod", nout = 1, outnames = "Sum", events = list(func="event",time=c(400,4000)))

plot(out, type="l")

##### It is better to use dataframes for events, because there is no equivalent in MCSim

# to use events triggered by root functions, both the root function and the event function must be in C:

out <- ode(Y, times, func = "derivs", parms = parms, jacfunc = "jac", dllname = "simple_model", initfunc = "initmod", nout = 1, outnames = "Sum", events = list(func = "event", root = TRUE), rootfun = "root", nroot = 1)

plot(out, type="l")

##### Yes...

