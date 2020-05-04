################################################################################################
#################################   Lift & Gain Function     ###################################
#########################    Developer:   Debasish Dutta       #################################
#########################    Date:   	    December 2017      #################################
######                       Input:       1. Actual Class Vector                          ######
######                                    2. Predicted Probability Vector                 ######
######                                    3. Name of The True Class As Character          ######
######                       Output:      1. Lift & Gain Chart Data Frame                 ######
################################################################################################

lift_gain_function <-
  function(actual_class, predicted_prob, true_class) {
    ###################### Installing & Loading dplyr Package ########################
    if (!require("dplyr", character.only = TRUE))
    {
      install.packages("dplyr", dep = TRUE)
      if (!require("dplyr", character.only = TRUE))
        stop("dplyr Package not found")
    }
    
    ######################## Creating Rank Ordering Data Set ##########################
    actual_class <- as.character(actual_class)
    df <- data.frame(actual_class, predicted_prob)
    df_sorted <-
      data.frame(df[order(predicted_prob, decreasing = TRUE), ])
    df_sorted$decile_no <-
      rep(1:10, each = ceiling(nrow(df) / 10))[1:nrow(df)]
    x <-
      as.data.frame(table(df_sorted$decile_no, df_sorted$actual_class))
    event_count <- x[which(x$Var2 == true_class), c(1, 3)]
    names(event_count) <- c("Decile", "N_Events")
    
    obs_count <- as.data.frame(table(df_sorted$decile_no))
    names(obs_count) <- c("Decile", "N_Obs")
    
    consolidated_data <-
      merge(obs_count, event_count, by = "Decile", all.x = T)
    consolidated_data$Decile <- as.integer(consolidated_data$Decile)
    
    final_data <-
      data.frame(consolidated_data[order(consolidated_data$Decile), ])
    final_data$Cumm_Events <- cumsum(final_data$N_Events)
    final_data$Gain_Model <-
      round(final_data$Cumm_Events / max(final_data$Cumm_Events) * 100,
            digits = 2)
    final_data$Gain_Random <- seq(10, 100, 10)
    final_data$Lift_Model <-
      round(final_data$Gain_Model / (final_data$Decile * 10), digits = 2)
    final_data$Lift_Random <- 1
    new_row <- c(0, 0, 0, 0, 0, 0, NA, NA)
    final_result <- rbind(final_data, new_row)
    
    final <- data.frame(final_result[order(final_result$Decile), ])
    row.names(final) <- NULL
    return(final)
  }
