x1 = read.delim("butadiene.MCMC.inter.1.out")
x2 = read.delim("butadiene.MCMC.inter.2.out")
x3 = read.delim("butadiene.MCMC.inter.3.out")
dim(x1)

mytrajplot=function(i, titre) {
 # set up split display: on the left the trajectories,
 # on the right a density estimate
 oma = c(4, 5, 0.5, 0.5)
 mar = rep(0, 4)
 par(oma = oma, mar = mar)
 lom <- matrix(1:2, ncol = 1)
 lo <- layout(t(lom), widths = c(3,1), heights = c(4), respect = TRUE)
 # get y limits
 a = min(x1[,i], x2[,i], x3[,i])
 b = max(x1[,i], x2[,i], x3[,i])
 # thin out the plot
 N = dim(x1)[1]-1
 thin = seq(1, N, 1) 
 plot(x1[thin,1],x1[thin,i], xlim=c(0,N), ylim=c(a,b), type="l",
      lty=1, xlab="",ylab="", axes=0)
 par(new=TRUE)
 plot(x2[thin,1],x2[thin,i], xlim=c(0,N), ylim=c(a,b), type="l",
      lty=1, xlab="",ylab="", axes=0)
 par(new=TRUE)
 plot(x3[thin,1],x3[thin,i], xlim=c(0,N), ylim=c(a,b), type="l",
      lty=1, xlab="",ylab="", mgp = c(2.8, 0.7, 0), las = 1, cex.lab=1.5);
 par(new=TRUE)
 mtext("Iteration", side=1, line=2.5, cex=1.5)
 mtext(titre, side=2, line=3.5, las=0, cex=1.5)
 # builing a density estimate and plot it sideway
 d <- density(x1[x1[,1]>1,i], adjust=3)
 plot(d$y,d$x,type="l", axes=0, ann=0,xaxs="i", xlim=c(0, max(d$y)*1.1),
      ylim=c(a, b))
 box()
}

# check the number of the column you want
num=13
titre = print(paste("parameter: ", num, "; label: ", dimnames(x1)[[2]][num]));
# form a pretty title
# titre=expression(paste("Population average of ", italic(k[met]), " (1/min)"))
# call the function
mytrajplot (num, titre)

