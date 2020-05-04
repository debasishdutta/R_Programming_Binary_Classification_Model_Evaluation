################################################################################################
################################  Rank Ordering Function     ###################################
#########################    Developer:   Debasish Dutta       #################################
#########################    Date:   	    December 2017      #################################
######                       Input:       1. Actual Class Vector                          ######
######                                    2. Predicted Probability Vector                 ######
######                                    3. Name of The True Class As Character          ######
######                       Output:      1. Rank Ordering Data Frame                     ######
################################################################################################

rank_ordering_function <-
  function(actual_class, predicted_prob, true_class) {
    ###################### Installing & Loading dplyr Package ########################
    if (!require("dplyr", character.only = TRUE))
    {
      install.packages("dplyr", dep = TRUE)
      if (!require("dplyr", character.only = TRUE))
        stop("dplyr Package not found")
    }
    
    ######################## Creating KS Statistics Data Set #########################
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
    consolidated_data$N_Non_Events <-
      consolidated_data$N_Obs - consolidated_data$N_Events
    consolidated_data$Pct_Events <-
      round((
        consolidated_data$N_Events / sum(consolidated_data$N_Events)
      ) * 100,
      digits = 2)
    consolidated_data$Pct_Non_Events <-
      round((
        consolidated_data$N_Non_Events / sum(consolidated_data$N_Non_Events)
      ) * 100,
      digits = 2)
    final_result <-
      data.frame(consolidated_data[order(consolidated_data$Decile), ])
    final_result$Cumm_Pct_Events <- cumsum(final_result$Pct_Events)
    final_result$Cumm_Pct_Non_Events <-
      cumsum(final_result$Pct_Non_Events)
    final_result$KS_Stat <-
      abs(final_result$Cumm_Pct_Events - final_result$Cumm_Pct_Non_Events)
    final_result$Decile_Val <-
      final_result$Decile[which(final_result$KS_Stat == max(final_result$KS_Stat))]
    
    if (which(final_result$KS_Stat == max(final_result$KS_Stat)) >= 4) {
      print("Criteria Not Satisfied")
    } else{
      print("Criteria Satisfied")
    }
    return(final_result)
  }
