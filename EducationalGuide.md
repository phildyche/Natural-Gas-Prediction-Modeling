ANN Model Educational Guide

1. Introduction

This guide provides a deep dive into the scripts for natural gas demand forecasting using Artificial Neural Networks (ANNs). You'll learn:

Domain Dynamics: How weather and calendar factors drive natural gas consumption during cold snaps and winter seasons.

Mathematical Modeling: The theory behind ANNs and why they excel at capturing nonlinear relationships in time series data.

Script Walkthrough: What each R script performs under the hood.

2. Natural Gas Demand Dynamics

Natural gas demand in the winter is influenced by several interacting factors:

Temperature & Degree Days

Heating Degree Days (HDDs) measure how much (in °F) the daily average temperature falls below a base (often 65°F).

Each HDD represents extra energy needed for heating: more HDDs → higher gas consumption.

Weather Variables

Wind Speed (AWND): Wind chill can exacerbate perceived cold, driving up heating needs.

Precipitation (PRCP) and Snowfall: Snow cover and moisture retention affect heat loss in buildings.

Calendar Effects

Weekday/Weekend Patterns: Industrial demand may drop on weekends, while residential consumption patterns hinge on occupancy.

Seasonal Trends: Shorter days and holiday schedules also shift usage.

By combining these, we capture the nonlinear interplay between physical weather processes and human behavior.

3. Why Use ANNs for Forecasting?

Nonlinear Approximation: Unlike linear regression, ANNs model complex relationships where, for example, a small temperature drop may trigger disproportionate heating demand.

Feature Interactions: Hidden layers naturally learn interactions (e.g., the combined effect of wind and humidity) without manual feature engineering.

Adaptability: With sufficient data, ANNs can adjust to changing patterns, such as evolving building insulation standards or shifting usage behaviors.

Comparison to Other Methods:

Time Series Models (ARIMA) assume linearity and stationarity, often underperforming in volatile cold snaps.

Decision Trees/Random Forests handle nonlinearity but can overfit and struggle with smoothly varying relationships.

ANNs strike a balance: flexible yet regularizable via weight decay and early stopping.

4. Mathematical Foundations of ANNs

4.1 Neuron & Activation

A neuron computes:



: input signals (e.g., HDD, AWND)

: weights learned during training

: bias term

: activation function (here, linear output for regression).

4.2 Layers & Network Structure

Input Layer: One node per predictor.

Hidden Layer: The script tunes size from 1 to 25 neurons. More neurons increase capacity but risk overfitting.

Output Layer: Single neuron producing the normalized gas demand forecast.

4.3 Training via Backpropagation

Forward Pass: Compute outputs layer by layer.

Error Computation: Use Mean Squared Error (MSE) between predicted and true values.

Backward Pass: Compute gradients  and update weights:


: learning rate implicit in train()

: weight decay parameter (regularization) preventing large weights.

4.4 Normalization

Centering and scaling ensure all inputs share a common scale (mean 0, std 1). Benefits:

Faster convergence during gradient descent.

Prevents variables with large magnitudes from dominating weight updates.

5. Script Workflows

5.1 Training Script (ann_training.R)

Load Excel Data → numeric conversion → omit NAs.

Split into predictors  and response .

Normalize  and  via preProcess().

Hyperparameter Tuning: Repeated 10-fold CV across hidden sizes (1–25) and decay values (0, 0.001, 0.01, 0.1).

Train Final Model with best settings.

Save model and preprocess objects in .rds for inference.

5.2 Prediction Script (ann_prediction.R)

Load .rds model object.

Load & Clean new input Excel.

Normalize using saved preProc_predictors.

Predict normalized demand.

Inverse Transform to original scale.

Write results to Excel for each pool.

6. Practical Considerations

Data Quality: Ensure weather station data and load records are accurate and synchronized.

Retraining Frequency: Re-train monthly or after significant pattern shifts (e.g., new building codes).

Model Monitoring: Track forecast error metrics (MAE, RMSE) over time to detect drift.

7. Advanced Visualizations & Diagrams

7.1 Single Neuron Diagram

To solidify the concept of a single ANN neuron, consider the following schematic:

     x₁ ----→(w₁)               
                 \            
     x₂ ----→(w₂) --→ [Σ + b] --→ f(z) = y
                 /            
     xₙ ----→(wₙ)               

Inputs (xᵢ) feed into a summation node weighted by wᵢ, plus a bias b.

The activation function f then produces the output.

7.2 Full Network Architecture

Below is a conceptual diagram of our feedforward network:

Input Layer       Hidden Layer          Output Layer
  [x₁]  ●         ●---●---●         ●   [ŷ]
  [x₂]  ●         ●   ●   ●         
  [ ... ] ●         ●---●---●         
  [xₙ]  ●                                
                              

The Input Layer has one node for each predictor (e.g., HDD, AWND, PRCP, day-of-week indicators).

The Hidden Layer (tunable size) learns abstract features by combining inputs in nonlinear ways.

The Output Layer produces the final normalized forecast, later rescaled to actual demand.

7.3 Why Visualization Matters

Visual depictions help you understand:

Data Flow: How raw weather and calendar variables propagate through weighted connections.

Capacity Control: Why increasing hidden neurons adds modeling power (more abstract features) but risks overfitting.

Regularization Effects: How weight decay smooths the surface between input and output, flattening extreme connections.

8. Integrating Visuals in Your Workflow

Embed these diagrams in presentation decks for stakeholder buy-in.

Use generated plots alongside performance metrics (RMSE over epochs) to demonstrate training stability.
