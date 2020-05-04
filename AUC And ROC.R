################################################################################################
############################### ROC Curve & AUC Function       #################################
#########################    Developer:   Debasish Dutta       #################################
#########################    Date:   	  December 2017        #################################
######                       Input:       1. Actual Class Vector                          ######
######                                    2. Predicted Probability Vector                 ######
######                                    3. Plot Heading i.e. "Test Sample ROC"          ######
######                       Output:      1. ROC Curve Will Be Saved In Working Directory ######
################################################################################################

roc_function <-
  function(actual_class,
           predicted_prob,
           plot_heading) {
    ###################### Installing & Loading ROCR Package ########################
    if (!require("ROCR", character.only = TRUE))
    {
      install.packages("ROCR", dep = TRUE)
      if (!require("ROCR", character.only = TRUE))
        stop("ROCR Package not found")
    }
    
    #################################### Computing AUC ##########################################
    perf <- prediction(predicted_prob, actual_class)
    auc <-
      round(slot(performance(perf, "auc"), "y.values")[[1]] * 100, digits = 2)
    
    
    ################################### Generating ROC ##########################################
    roc <- performance(perf, "tpr", "fpr")
    jpeg(
      "ROC.jpeg",
      width = 670,
      height = 480,
      units = "px",
      pointsize = 12,
      quality = 75,
      bg = "white",
      res = NA,
      family = "",
      restoreConsole = TRUE,
      type = c("windows", "cairo")
    )
    plot(
      roc,
      colorize = TRUE,
      main = plot_heading,
      xlab = "False Positive Rate",
      ylab = "True Positive Rate"
    )
    abline(
      a = 0,
      b = 1,
      lwd = 2,
      lty = 2,
      col = "red"
    )
    text(1,
         0.15,
         labels = paste("AUC = ", auc, "%", sep = ""),
         adj = 1)
    dev.off()
  }
