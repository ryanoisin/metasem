\name{reml}
\alias{reml}
\title{Estimate Variance Components with Restricted (Residual) Maximum
  Likelihood Estimation
}
\description{
It estimates the variance components of random-effects in univariate and
multivariate meta-analysis with restricted (residual) maximum likelihood
(REML) estimation method.
}
\usage{
reml(y, v, x, data, RE.constraints = NULL, RE.startvalues = 0.1,
     RE.lbound = 1e-10, intervals.type = c("z", "LB"),
     model.name="Variance component with REML",
     suppressWarnings = TRUE, silent = TRUE, run = TRUE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{y}{A vector of effect size for univariate meta-analysis or a \eqn{k}{k} x
	\eqn{p}{p} matrix of effect sizes for multivariate meta-analysis
	where \eqn{k}{k} is the number of studies and \eqn{p}{p} is the
	number of effect sizes. 
}
  \item{v}{A vector of the sampling variance of the effect size for univariate
	meta-analysis or a \eqn{k}{k} x \eqn{p*}{p*} matrix of the sampling
	covariance matrix of the effect sizes for multivariate meta-analysis
	where \eqn{p* = p(p+1)/2 }{p* = p(p+1)/2}. It is arranged by column
	major as used by \code{\link[OpenMx]{vech}}.
}
  \item{x}{A predictor or a \eqn{k}{k} x \eqn{m}{m} matrix of predictors
	where \eqn{m}{m} is the number of predictors.
}
  \item{data}{An optional data frame containing the variables in the model.
}   
  \item{RE.constraints}{A \eqn{p}{p} x \eqn{p}{p} matrix
	specifying the variance components of the random effects. If the input
	is not a matrix, it is converted into a matrix by
	\code{as.matrix()}. The default is that all
	covariance/variance components are free. The format of this matrix
	follows \code{\link[metaSEM]{as.mxMatrix}}. Elements of the variance
	components can be constrained equally by using the same labels. If a zero matrix is
	specified, it becomes a fixed-effects meta-analysis.
}
  \item{RE.startvalues}{A vector of \eqn{p}{p} starting values on the
	diagonals of the variance component of the random effects. If only one
	scalar is given, it will be repeated across the diagonals. Starting values for the
	off-diagonals of the variance component are all 0. A \eqn{p}{p} x
	\eqn{p}{p} symmetric matrix of starting values is also accepted. 
}
  \item{RE.lbound}{A vector of \eqn{p}{p} lower bounds on the
	diagonals of the variance component of the random effects. If only one
	scalar is given, it will be repeated across the diagonals. Lower
	bounds for the off-diagonals of the variance component are set at \code{NA}. A \eqn{p}{p} x
	\eqn{p}{p} symmetric matrix of the lower bounds is also accepted.
}
  \item{intervals.type}{Either \code{z} (default if missing) or
	\code{LB}. If it is \code{z}, it calculates the 95\% Wald confidence
	intervals (CIs) based on the z statistic. If it is \code{LB}, it
	calculates the 95\% likelihood-based CIs on the
	parameter estimates. Note that the z values and their
	associated p values are based on the z statistic. They are not
	related to the likelihood-based CIs.
  }
  \item{model.name}{A string for the model name in \code{\link[OpenMx]{mxModel}}. 
	}  
  \item{suppressWarnings}{Logical. If \code{TRUE}, warnings are
	suppressed. It is passed to \code{\link[OpenMx]{mxRun}}.
  }
  \item{silent}{Logical. Argument to be passed to \code{\link[OpenMx]{mxRun}}}
  \item{run}{Logical. If \code{FALSE}, only return the mx model without running the analysis.}  
  \item{\dots}{Further arguments to be passed to \code{\link[OpenMx]{mxRun}}
}
}
\details{
  Restricted (residual) maximum likelihood obtains the parameter estimates on the transformed data that do not include the fixed-effects parameters. A transformation matrix \eqn{M=I-X(X'X)^{-1}X}{M=I-X(X'X)^{-1}X'} is created based on the design matrix \eqn{X}{X} which is just a column vector when there is no predictor in \code{x}. The last \eqn{N}{N} redundant rows of \eqn{M}{M} is removed where \eqn{N}{N} is the rank of \eqn{X}{X}. After pre-multiplying by \eqn{M} on \code{y}, the parameters of fixed-effects are removed from the model. Thus, only the parameters of random-effects are estimated.

  An alternative but equivalent approach is to minimize the
  -2*log-likelihood function: \deqn{
	\log(\det|V+T^2|)+\log(\det|X'(V+T^2)^{-1}X|)+(y-X\hat{\alpha})'(V+T^2)^{-1}(y-X\hat{\alpha})}{
	log(det|V+T^2|)+log(det|X'(V+T^2)^{-1}X|)+(y-X\alpha)'(V+T^2)^{-1}(y-X*\alpha)}
  where \eqn{V}{V} is the known conditional sampling covariance matrix
  of \eqn{y}{y}, \eqn{T^2}{T^2} is the variance component of the random
  effects, and \eqn{\hat{\alpha}=(X'(V+T^2)^{-1}X)^{-1}
  X'(V+T^2)^{-1}y}{\hat{\alpha}=(t(X)(V+T^2)^{-1}X)^{-1}t(X)(V+T^2)^{-1}y}. \code{reml()}
  minimizes the above likelihood function to obtain the parameter estimates.

}
\value{An object of class \code{reml} with a list of
  \item{call}{Object returned by \code{\link[base]{match.call}}}
  \item{data}{A data matrix of y, v and x  }
  \item{no.y}{No. of effect sizes}
  \item{no.x}{No. of predictors}
  \item{miss.vec}{A vector indicating missing data. Studies will be removed before the analysis if they are \code{TRUE}}
  \item{mx.fit}{A fitted object returned from	\code{\link[OpenMx]{mxRun}}}
}
\references{
  Cheung, M. W.-L. (2013). Implementing restricted maximum likelihood
  estimation in structural equation models. \emph{Structural Equation
	Modeling}, \bold{20(1)}, 157-167.

  Mehta, P. D., & Neale, M. C. (2005). People Are Variables Too: Multilevel Structural Equations Modeling. \emph{Psychological
  	Methods}, \bold{10(3)}, 259-284.

  Searle, S. R., Casella, G., & McCulloch, C. E. (1992). \emph{Variance components}. New York: Wiley.
  
  Viechtbauer, W. (2005). Bias and efficiency of meta-analytic variance estimators in the random-effects model. \emph{Journal of Educational and Behavioral Statistics}, \bold{30(3)}, 261-293.  
}
\author{Mike W.-L. Cheung <mikewlcheung@nus.edu.sg>
%%  ~~who you are~~
}
\note{ \code{reml} is more computationally intensive than \code{meta}. Moreover, \code{reml} is more
  likely to encounter errors during optimization. Since
  a likelihood function is directly employed to obtain the parameter
  estimates, there is no number of studies and number of observed statistics
  returned by \code{\link[OpenMx]{mxRun}}. Ad-hoc steps are used
  to modify \code{mx.fit@runstate$objectives[[1]]@numObs} and \code{mx.fit@runstate$objectives[[1]]@numStats}.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{ \code{\link[metaSEM]{meta}}, \code{\link[metaSEM]{reml3}}, \code{\link[metaSEM]{Hox02}}, \code{\link[metaSEM]{Berkey98}}
%% ~~objects to See Also as \code{\link{help}}, ~~~
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ meta-analysis }
