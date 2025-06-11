Overview

This walkthrough explains how the ANN training script works and how to set up your environment.

1. Prepare Your Environment

Install required R packages:

install.packages(c("nnet","caret","doParallel","openxlsx","readxl"))

Update ann_training.R:

pool_names: vector of file base names (without .xlsx)

training_data_dir: directory with your Excel files

saved_model_dir: where .rds models will be stored

2. Verify Training Files

Ensure each Excel training file is named exactly <PoolName>.xlsx and contains:

Total_Load column (response)

Weather and calendar predictors (e.g., AWND, PRCP, HDD, weekdays, Sine, TMAX, TMIN)

3. Run the Training Script

In R:

source("ann_training.R")

You’ll see logs for each pool and confirmation messages when models are saved.

4. Deploying the Model

Use the "Loading and Using the Saved Model" code snippet above in your forecasting application. Ensure that new input data is preprocessed with the same centering/scaling objects saved in the .RDS file.

