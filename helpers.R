### Collection by Wilson Funkhouser


### Mutliple Assignments in R
### From:  http://stackoverflow.com/questions/7519790/assign-multiple-new-variables-on-lhs-in-a-single-line-in-r
### USE ####
# g(a,b,c) %=% 101:103
# will assign 101 to a, 102 to b, 103 to c. 
# also works with lists
# g(a,b) %=% list("foo","bar")
# assigns
# foo to a and bar to b

# Generic form
'%=%' = function(l, r, ...) UseMethod('%=%')

# Binary Operator
'%=%.lbunch' = function(l, r, ...) {
  Envir = as.environment(-1)

  if (length(r) > length(l))
    warning("RHS has more args than LHS. Only first", length(l), "used.")

  if (length(l) > length(r))  {
    warning("LHS has more args than RHS. RHS will be repeated.")
    r <- extendToMatch(r, l)
  }

  for (II in 1:length(l)) {
    do.call('<-', list(l[[II]], r[[II]]), envir=Envir)
  }
}

# Used if LHS is larger than RHS
extendToMatch <- function(source, destin) {
  s <- length(source)
  d <- length(destin)

  # Assume that destin is a length when it is a single number and source is not
  if(d==1 && s>1 && !is.null(as.numeric(destin)))
    d <- destin

  dif <- d - s
  if (dif > 0) {
    source <- rep(source, ceiling(d/s))[1:d]
  }
  return (source)
}

# Grouping the left hand side
g = function(...) {
  List = as.list(substitute(list(...)))[-1L]
  class(List) = 'lbunch'
  return(List)
}


resetGraph <- function() {
  par(mfrow=c(1,1))
}

loadOrInstall <- function(thePack) {
  print(thePack)
  if (!require(thePack,character.only=TRUE)){
   install.packages(thePack,repos="http://cran.us.r-project.org")
   require(thePack,character.only=TRUE)
  } else {
    print("ok")
  }
}

### For constructing a lot of models based on indices instead of typing it all out
### useful week2 of ds740 at bare minimum

lm_constructor <- function(indices,response_var_index,datas) {
  rhs <- paste(colnames(datas)[indices],collapse=" + ")
  lhs <- paste(colnames(datas)[response_var_index]," ~ ")
  return(paste(lhs,rhs,sep=" "))
}

lm_constructor_list <- function(models_list,response_var_index,datas) {
  n <- length(models_list)
  all_lms <- rep(NA,n)
  for(i in 1:n) {
    all_lms[i] <- lm_constructor(unlist(models_list[i]),response_var_index,datas) 
  }
  return(all_lms)
}



# regsubset predictor from week 3 ds740 
predict.regsubsets <- function(object,newdata,id,...){
  form = as.formula(object$call[[2]])
  mat = model.matrix(form,newdata)
  coefi = coef(object,id=id)
  xvars = names(coefi)
  mat[,xvars]%*% coefi
  
} 
