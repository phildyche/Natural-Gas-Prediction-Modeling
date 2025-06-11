Overview

This walkthrough explains how to set up and run the ANN prediction script.

1. Prepare Your Environment

Install required R packages:

install.packages(c("caret","readxl","openxlsx"))

Place ann_prediction.R in your project directory.

2. Configure the Script

pool_names: List of pool identifiers matching filenames.

saved_model_dir: Path to where .rds models are stored.

input_variables_dir: Path to Excel files named <PoolName> Input.xlsx containing predictors.

output_dir: Desired destination for results files.

3. Prepare Input Files

Ensure each input Excel file has:

A worksheet or file named <PoolName> Input.xlsx

Columns for: AWND, PRCP, HDD, HDD_sq, DB_HDD, weekdays (Mon–Sun), Sine, TMAX, TMIN.

4. Execute the Script

In R or RStudio:

source("ann_prediction.R")

Monitor console for:

Processing pool: YourPoolName
Predictions saved for pool YourPoolName to /path/to/YourPoolName_Predicted_Results.xlsx

5. Review the Results

Navigate to output_dir.

Open each <PoolName>_Predicted_Results.xlsx to verify forecasted demand alongside input variables.

6. Integrate into Workflow

Schedule this script via cron or Windows Task Scheduler for daily/weekly forecasts.

Import results into dashboards or reporting tools automatically.
