# Hotel Price and Distance Analysis - README

## Project Overview
This project is a data analysis study focusing on the relationship between hotel prices and their distance from the city center in Paris. The study aims to determine pricing trends and provide insights into the best hotel deals based on distance. The project includes data preprocessing, exploratory data analysis, regression modeling, and model selection.

## Dataset
- **Source:** `hotelbookingdata.csv`
- **Main Variables:**
  - `hotel_id`: Unique identifier for each hotel
  - `city`: City location
  - `distance`: Distance from the city center
  - `price`: Hotel price per night
  - `neighbourhood`: Hotel location area
  - `starrating`: Star rating of the hotel

## Requirements
The analysis was performed using **R** with the following libraries:
- `tidyverse` (for data manipulation)
- `modelsummary` (for regression summaries)
- `lspline` (for linear spline regression modeling)

## Data Processing
1. **Data Cleaning:**
   - Removed unnecessary variables.
   - Renamed columns for clarity.
   - Converted `distance` to numeric format.
   - Removed duplicate rows.
   
2. **Filtering Criteria:**
   - Selected only hotels in Paris from November 2017 (weekdays).
   - Removed extreme values:
     - **Price outliers**: Hotels with prices above $400 were excluded.
     - **Distance outliers**: Hotels located more than 10 km from the city center were excluded.
     - Hotels with star ratings below 3 or above 4 were excluded to maintain consistency.

## Exploratory Data Analysis
- **Distribution Insights:**
  - Both `price` and `distance` were right-skewed.
  - High-priced hotels were mainly located near the center.
  - Low-priced hotels were more dispersed across different distances.
  
- **Scatterplot Analysis:**
  - Showed an inverse relationship between price and distance.
  - Price declines steeply within the first few kilometers from the center, then stabilizes.
  
## Model Selection
Three regression models were considered:
1. **Linear Regression Model**
   - Simple and easy to interpret.
   - Assumes a constant rate of price decline with distance (not realistic for the dataset).
   
2. **Log-Level Model**
   - Captures proportional changes in distance affecting absolute price.
   - Works well for datasets where distance has a diminishing effect on price.
   
3. **Piecewise Linear Spline Model (Chosen Model)**
   - Allows for different rates of price decline at different distance ranges.
   - Provides the most flexible and accurate representation of the relationship.
   - Captures the rapid price decline near the center and the slower decline at greater distances.
   
## Best and Worst Hotel Deals
- **Best Deal:** Hotel ID `12451` with a significantly lower price than expected.
- **Worst Deal:** Hotel ID `13399` with a price much higher than predicted.

## Key Findings
- Hotels near the city center command a significant price premium.
- The effect of distance on price diminishes beyond a certain point (~7-10 km).
- The spline model best captures this non-linear pricing behavior.
- Outlier hotels (either overpriced or underpriced) were identified.

## Limitations & Future Work
- **Limitations:**
  - The model only considers `price` and `distance`, excluding factors like hotel amenities and seasonal effects.
  - The R-squared value is relatively low, suggesting additional factors influence pricing.
  - Data is specific to Paris and may not generalize to other cities.
  
- **Future Improvements:**
  - Include additional variables such as star ratings, amenities, and tourist attractions.
  - Use machine learning models to improve prediction accuracy.
  - Experiment with different statistical transformations or non-linear models.

## Conclusion
This analysis provides valuable insights into the pricing trends of Parisian hotels and can be beneficial for both travelers seeking affordable stays and hotel managers optimizing pricing strategies. The piecewise spline model successfully captures the non-linear relationship between hotel prices and distance from the city center, making it the best fit for the dataset.

---
**Author:** Trong Tan Huynh  
**Course:** ECON253 - Data Analysis I  

