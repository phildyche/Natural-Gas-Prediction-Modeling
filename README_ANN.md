# Natural-Gas-Prediction-Modeling
This R script loads pre-trained ANN models and generates natural gas demand forecasts based on new weather and calendar inputs. It outputs predictions to Excel files for each defined pool, ready for downstream reporting or automated pipelines.


Background and Explanation

Artificial Neural Networks are computational models that mimic the structure of the human brain. They consist of layers of interconnected nodes ("neurons") that transform input data through weighted connections. During training, the network iteratively adjusts these weights to minimize prediction error. Key aspects:

Input Features: Historical load (Total_Load) and weather-derived variables (e.g., average wind speed, precipitation, heating degree days).

Hidden Layer: A single layer whose size (number of neurons) controls model capacity. Too few neurons may underfit; too many can overfit.

Weight Decay (Regularization): Penalizes large weights to prevent overfitting by smoothing the learned function.

Normalization: Centering and scaling inputs/outputs ensures all variables contribute proportionally and accelerates training convergence.

Cross-Validation: Repeated k-fold splits evaluate model performance on unseen data and guide hyperparameter tuning.

Key Features

Reads Excel files for each defined pool of data

Cleans and converts all columns to numeric values

Normalizes both predictors and response variables

Performs hyperparameter tuning over hidden layer sizes (1–25) and decay values

Employs parallel processing to speed up training on multi-core machines

Saves the final model along with preprocessing objects to an .RDS file for deployment

Usage

Configure:

Set pool_names to match the base names of your training Excel files.

Update training_data_dir and saved_model_dir paths at the top of the script.

Install Dependencies:

install.packages(c("nnet","caret","doParallel","openxlsx","readxl"))

Run Training:

source("ann_training.R")

The console will display progress for each pool and confirm where the .rds file was saved.

Loading and Using the Saved Model

After training, load and apply the model in a separate forecasting script:
# Load the saved model object
model_obj <- readRDS("path/to/YourPool_nnet_model.rds")

# Extract preprocessing and model components
preProc_preds <- model_obj$preProc_predictors
preProc_resp  <- model_obj$preProc_response
nnet_model    <- model_obj$model

# Prepare new data frame 'new_data' with same predictor columns
new_data_norm <- predict(preProc_preds, new_data)
# Get normalized predictions
pred_norm     <- predict(nnet_model, new_data_norm)
# Back-transform to original scale
final_preds   <- predict(preProc_resp, data.frame(Total_Load = pred_norm))

# 'final_preds$Total_Load' holds the forecasted gas demand values
