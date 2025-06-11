# -------------------------------------------------------------------------

# ANN Forecasting Model Prediction Script Using Saved Models

# -------------------------------------------------------------------------

 

# Load necessary libraries

library(caret)

library(readxl)

library(openxlsx)

 

# Define pool names

pool_names <- c("tab names within the input file") 

 

# Directories (update these paths as needed)

saved_model_dir    <- "saved model directory" 

input_variables_dir <- "input variables" 

output_dir          <- "output directory" 

 

 

 

# Loop through each pool to load the model and predict on new data

for (pool in pool_names) {

  cat("\nProcessing pool:", pool, "\n")

  # Construct the file path for the saved model

  model_file <- file.path(saved_model_dir, paste0(pool, "_nnet_model.rds"))

  if (!file.exists(model_file)) {

    cat("Saved model file not found for pool", pool, "\n")

    next

  }

  # Load the saved model object (should be a list with model, preProc_predictors, preProc_response)

  saved_model <- readRDS(model_file)

  # Construct the file path for the new input data for this pool

  input_file <- file.path(input_variables_dir, paste0(pool, " Input.xlsx"))

  if (!file.exists(input_file)) {

    cat("Input data file not found for pool", pool, "\n")

    next

  }

  # Read and clean new data

  new_data <- read_excel(input_file)

  new_data <- na.omit(new_data)

  new_data[] <- lapply(new_data, function(x) as.numeric(as.character(x)))

  # Define predictor names (must match those used in training)

  predictor_names <- c("AWND", "PRCP", "HDD", "HDD_sq", "DB_HDD",

                     

                       "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Sine","TMAX","TMIN") 

  # Reset column names to match the training data predictors

  colnames(new_data) <- predictor_names

  # Preprocess new data using the saved preProc_predictors

  new_data_norm <- predict(saved_model$preProc_predictors, new_data[, predictor_names, drop = FALSE])

  # Generate predictions using the saved model

  predictions_norm <- predict(saved_model$model, new_data_norm)

  # Inverse-transform predictions back to the original scale using preProc_response

  predictions <- predictions_norm * saved_model$preProc_response$std + saved_model$preProc_response$mean

  # Combine new data with predictions

  results_df <- cbind(new_data, Predicted_Total_Load = predictions)

  # Save the prediction results to an Excel file

  output_file <- file.path(output_dir, paste0(pool, "_Predicted_Resultsall.xlsx"))

  write.xlsx(results_df, output_file, rowNames = FALSE)

  cat("Predictions saved for pool", pool, "to", output_file, "\n")

}
