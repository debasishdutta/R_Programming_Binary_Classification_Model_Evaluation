################################################################################################
############################### Confusion Matrix Function      #################################
#########################    Developer:   Debasish Dutta       #################################
#########################    Date:   	  December 2017        #################################
######                       Input:       1. Actual Class Vector                          ######
######                                    2. Predicted Probability Vector                 ######
######                                    3. Name of The True Class                       ######
######                       Output:      1. A List (First Element: Confusion Matrix)     ######
######                                              (Second Element: Accuracy Matrices)   ######
################################################################################################

cm_function <- function(actual_class, predicted_prob, true_class) {
  ###################### Installing & Loading caret & reshape2 Package ########################
  if (!require("caret", character.only = TRUE))
  {
    install.packages("caret", dep = TRUE)
    if (!require("caret", character.only = TRUE))
      stop("caret Package not found")
  }
  
  if (!require("reshape2", character.only = TRUE))
  {
    install.packages("reshape2", dep = TRUE)
    if (!require("reshape2", character.only = TRUE))
      stop("reshape2 Package not found")
  }
  
  
  ################### Creating Confusion Matrix At Different Prob ###################
  confusion_matrix_final <- NULL
  accuracy_final <- NULL
  probability_cutoffs <- c(0.75, 0.8, 0.85, 0.9, 0.95, 0.975, 0.99)
  accuracy_measures <-
    c(
      "Accuracy",
      "Balanced Accuracy",
      "Kappa",
      "Sensitivity",
      "Specificity",
      "Precision",
      "Recall"
    )
  accuracy_final <-
    data.frame(cbind(accuracy_final, accuracy_measures))
  names(accuracy_final) <- "Accuracy Metrices"
  
  for (i in 1:length(probability_cutoffs)) {
    confusion_matrix <-
      confusionMatrix(
        data = predicted_prob >= probability_cutoffs[i],
        reference = actual_class == true_class,
        positive = "TRUE",
        dnn = c("Predicted_Class", "Actual_Class"),
        mode = "everything"
      )
    confusion_matrix_temp <- data.frame(confusion_matrix$table)
    confusion_matrix_temp$Prob_Cutoffs <- probability_cutoffs[i]
    confusion_matrix_final <-
      rbind(confusion_matrix_final, confusion_matrix_temp)
    
    accuracy_matrix <-
      data.frame(t(cbind(
        t(confusion_matrix$overall),
        t(confusion_matrix$byClass)
      )))
    accuracy_matrix$Metrics <-
      as.character(row.names(accuracy_matrix))
    row.names(accuracy_matrix) <- NULL
    accuracy_matrix_temp <-
      accuracy_matrix[which(accuracy_matrix$Metrics %in% accuracy_measures), ]
    accuracy_matrix_temp <- accuracy_matrix_temp[, c(2, 1)]
    names(accuracy_matrix_temp) <- c(
      "Accuracy Metrices",
      paste("Prob Cut Off= ", probability_cutoffs[i] *
              100, "%", sep = "")
    )
    accuracy_matrix_temp[, 2] <-
      round(accuracy_matrix_temp[, 2], digits = 4) * 100
    accuracy_final <-
      merge(accuracy_final,
            accuracy_matrix_temp,
            by = "Accuracy Metrices",
            all.x = T)
  }
  
  con_mat <- dcast(
    confusion_matrix_final,
    Predicted_Class + Actual_Class ~ Prob_Cutoffs,
    value.var = "Freq",
    fill = 0
  )
  names(con_mat)[3:length(names(con_mat))] <-
    paste("Prob Cut Off= ",
          as.numeric(names(con_mat)[3:length(names(con_mat))]) *
            100,
          "%", sep = "")
  final_result <- list(con_mat, accuracy_final)
  
  return(final_result)
}