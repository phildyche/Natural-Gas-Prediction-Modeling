# -------------------------------------------------------------------------

# ANN Forecasting Model Training & Saving Script

# -------------------------------------------------------------------------

 

# Load necessary libraries

library(nnet)

library(caret)

library(doParallel)

library(openxlsx)

library(readxl)

 

# Define pool names

pool_names <- c("Name of training files") 

 

# Directories (update these paths as needed)

training_data_dir   <- "Training data excel file path" 



saved_model_dir     <- "Path to where you want your model saved" 

 

# Register parallel backend for faster training

num_cores <- parallel::detectCores() - 1  # Reserve one core

cl <- makeCluster(num_cores)

registerDoParallel(cl)

 

# Loop through each pool for training

for (pool in pool_names) {

 

  cat("\nProcessing pool:", pool, "\n")

 

  # Construct the file path for the training data (Excel file)

  training_data_file <- file.path(training_data_dir, paste0(pool, ".xlsx"))

  if (!file.exists(training_data_file)) {

    cat("Training data file not found for pool", pool, "\n")

    next

  }

 

  # Load and clean the training data

  data <- read_excel(training_data_file)

  data <- na.omit(data)  # Remove rows with missing values

  data[] <- lapply(data, function(x) as.numeric(as.character(x)))  # Ensure numeric

 

  # Select & rename relevant columns

  # (Assuming these are the columns in your file; adjust as needed)

  data <- data[, c("Total_Load",  "AWND", "PRCP", "HDD", "HDD sq", "DB HDD", 

                  

                   "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Sine", "TMAX","TMIN")]

  colnames(data) <- c("Total_Load", "AWND", "PRCP", "HDD", "HDD_sq", "DB_HDD",

                    

                      "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Sine","TMAX","TMIN")

 

  # Separate predictors and response

  predictor_names <- setdiff(names(data), "Total_Load")

  predictors <- data[, predictor_names]

  response   <- data$Total_Load

 

  # Preprocess predictors (centering and scaling)

  preProc_predictors <- preProcess(predictors, method = c("center", "scale"))

  predictors_norm <- predict(preProc_predictors, predictors)

 

  # Preprocess response (centering and scaling)

  preProc_response <- preProcess(data.frame(Total_Load = response), method = c("center", "scale"))

  response_norm <- predict(preProc_response, data.frame(Total_Load = response))

 

  # Combine normalized response and predictors

  data_norm <- cbind(Total_Load = response_norm$Total_Load, predictors_norm)

 

  if (nrow(data_norm) < 10) {

    cat("Not enough data to train the neural network for pool", pool, "\n")

    next

  }

 

  # Set up repeated k-fold cross-validation

  set.seed(123)

  train_control <- trainControl(method = "repeatedcv", number = 10, repeats = 5, verboseIter = FALSE)

 

  # Define tuning grid for hidden layer size and decay

  tune_grid <- expand.grid(size = 1:25, decay = c(0, 0.001, 0.01, 0.1))

 

  # Create formula for the model

  formula <- as.formula(paste("Total_Load ~", paste(predictor_names, collapse = " + ")))

 

  cat("Training model for pool", pool, "\n")

  nnet_model <- train(formula, data = data_norm, method = "nnet",

                      trControl = train_control, tuneGrid = tune_grid,

                      linout = TRUE, maxit = 350, trace = FALSE)

 

  # Save the model and pre-processing objects as a list

  model_object <- list(model = nnet_model,

                       preProc_predictors = preProc_predictors,

                       preProc_response = preProc_response)

 

  model_save_file <- file.path(saved_model_dir, paste0(pool, "_nnet_model.rds"))

  saveRDS(model_object, file = model_save_file)

  cat("Model saved for pool", pool, "to", model_save_file, "\n")

}

 

stopCluster(cl)
