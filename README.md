# R_Programming_Binary_Classification_Model_Evaluation
Binary Classification Model Performance Evaluation In R Programming

Disclaimer: 
This code snippet is developed with an intension for generic use only. I hereby declare that the code was not part of any of my professional development work. Also, no sensitive or confidential data sources are used for this development. 

Description: 
The repository consists of automated R codes for below list of model performance measures of a typical binary classification problem: 
1. Receiver Operator Characteristic (ROC) Curve & Area Under the Curve (AUC) 
2. Confusion Matrix & Accuracy Matrix 
3. Lift & Gain Table 
4. Rank Ordering Table 

Please find the below list for input and output parameters for each user defined function: 
1. AUC And ROC : The roc_function takes three inputs, Actual Class in vector form (should be of factor data type), Predicted Probability of True Class in vector form (should be of numeric data type), Plot Heading in character string. The function will generate the ROC curve with AUC value and save the plot in current working directory of R Session. 
2. Confusion Matrix And Accuracy Metrices: The cm_function takes three inputs, Actual Class in vector form (should be of factor data type), Predicted Probability of True Class in vector form (should be of numeric data type), True Class Name in character string. The function will produce a list, first element of which will be the Confusion Matrix and second element of which will be Accuracy Matrix. User need to manually extract these tables from the list. 
3. Lift And Gain: The lift_gain_function takes three inputs, Actual Class in vector form (should be of factor data type), Predicted Probability of True Class in vector form (should be of numeric data type), True Class Name in character string. The function will produce Lift and Gain table as data frame format. 
4. Rank Ordering: The rank_ordering_function takes three inputs, Actual Class in vector form (should be of factor data type), Predicted Probability of True Class in vector form (should be of numeric data type), True Class Name in character string. The function will produce Rank Ordering table as data frame format. 
These scripts can be used for testing overall performance of a binary classification model in Training and Testing Sample. 

Note: 
1. These scripts can be used only for binary class classification problem. 
2. The dependent variable should be of factor data type. Predicted Probabilities should be in numeric data type (in the range of 0-1) 

Steps For Execution: 
1. Build the predictive model. 
2. Score the training and testing sample using predict function. 
3. Copy these code files to the current working directory of R session. 
4. Load these files using following commands: 
source("AUC And ROC.R") 
source(“Confusion Matrix And Accuracy Metrices.R”) 
source(“Lift And Gain.R”) 
source(“Rank Ordering.R”) 
5. Execute each user defined functions following the input parameters stated above. 

Compatibility: 
The code is developed and tested on RStudio (Version 1.0.44) using R-3.3.2
