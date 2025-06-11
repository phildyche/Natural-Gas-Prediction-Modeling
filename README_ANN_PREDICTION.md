Description

This R script loads pre-trained ANN models and generates natural gas demand forecasts based on new weather and calendar inputs. It outputs predictions to Excel files for each defined pool, ready for downstream reporting or automated pipelines.

Background and Explanation

After building and saving ANN models, this script handles the prediction phase:

Loading Models: Reads the .rds file containing the trained nnet model and its preprocessing objects (preProc_predictors, preProc_response).

Input Data: Imports new daily inputs (weather variables and calendar features) from Excel sheets matching each pool name.

Data Cleaning: Removes missing values and converts all columns to numeric to ensure compatibility.

Preprocessing: Applies the same centering and scaling used during training to the new data via preProc_predictors.

Prediction: Uses the neural network to predict normalized demand values.

Inverse Transformation: Converts normalized predictions back to the original scale using the mean and standard deviation stored in preProc_response.

Output: Combines original inputs with Predicted_Total_Load and writes results to an Excel file for each pool.

Key Features

Automates batch predictions for multiple pools

Ensures consistency by reusing training-time preprocessing

Handles data cleaning and type conversion

Saves results in user-friendly Excel format

Usage

Configure:

pool_names: Vector of sheet/base names matching your model and input files.

saved_model_dir: Directory containing <PoolName>_nnet_model.rds files.

input_variables_dir: Directory with <PoolName> Input.xlsx files.

output_dir: Directory where <PoolName>_Predicted_Results.xlsx files will be saved.

Install Dependencies:

install.packages(c("caret","readxl","openxlsx"))

Run Prediction:

source("ann_prediction.R")

The console will log each pool and confirm output file locations.
