rm(list=ls())

library(tidyverse)
library(modelsummary)
library(lspline)
library(broom)

df <- read_csv('hotelbookingdata.csv')
df <- rename(df,city = s_city,distance = center1distance)

city_data <- filter(df, city == 'Paris', year == 2017 & month ==11 & weekend ==0) |>
  separate(accommodationtype, '@', into = c('garbage', 'acc_type')) |>
  separate(distance, ' ', into = c('distance', 'miles')) |>
  select (-garbage, -miles) |>
  filter(acc_type == 'Hotel') |>
  select(hotel_id, distance, price, neighbourhood, starrating)|>
  mutate(distance = as.numeric(distance))|>
  distinct()


#2.2
datasummary_skim(city_data)

ggplot(data=city_data) +
  geom_histogram(aes(x = distance), fill = '#eb9b34', color = 'black') +
  labs(x = 'Distance', y = 'Count') +
  theme_bw()
ggplot(data=city_data) +
  geom_histogram(aes(x = price), fill = 'lightblue', color = 'black') +
  labs(x = 'Price', y = 'Count') +
  theme_bw()

ggplot(data = city_data) +
geom_point(aes(x = distance, y = price), fill = 'bisque3', color = 'black', shape = 21, size = 2) +
scale_x_continuous(limits=c(0, 18), breaks=seq(0, 18, by=1)) +
scale_y_continuous (limits = c(0, 1200), breaks = seq(0, 1200, by = 50)) +
theme_bw()

ev_distance = filter(city_data, distance > 10)

ev_star1 = filter(city_data, starrating > 4 & distance >10)

ev_price = filter(city_data, price > 400)

ev_star2 = filter(city_data, starrating > 4 & price >400)

city_data = filter(city_data, distance < 10)
#city_data = filter(city_data, starrating ==3 | starrating == 3.5 | starrating == 4)
#city_data = filter(city_data, starrating <= 3)
city_data = filter(city_data, price < 400)
city_data = filter(city_data, starrating <=4 & starrating >=3)
#b <- filter(city_data, distance > 8)
ggplot(data = city_data) +
  geom_point(aes(x = distance, y = price), fill = 'bisque', color = 'black', shape = 21, size = 2) +
  scale_x_continuous(limits=c(0, 10), breaks=seq(0, 18, by=1)) +
  scale_y_continuous (limits = c(0, 400), breaks = seq(0, 400, by = 50)) +
  theme_bw()

#2.4.
#a.
ggplot(data = city_data) +
geom_point(aes(x = distance, y = price), fill = 'bisque', color = 'black', shape = 21, size = 2) +
  scale_x_continuous(limits=c(0, 10), breaks=seq(0, 18, by=1)) +
  scale_y_continuous (limits = c(0, 400), breaks = seq(0, 400, by = 50)) +
geom_smooth(aes(x = distance, y = price), method = "loess", color = "red", se = FALSE) + 
  labs(title = "Relationship between price and distance", x = "Distance",y = "Price") + 
  theme_bw()

#b
reg0 <- lm(price ~ distance, data = city_data)
summary(reg0)

reg0_summary <- tidy(reg0)

# Get the R-squared value
r_squared <- summary(reg0)$r.squared

# Display the coefficients, standard errors, t-values, etc.
#model_results

ggplot(data = city_data, aes(x = distance, y = price)) +
  geom_point(fill = 'bisque', color = 'black', shape = 21, size = 2) +
  geom_smooth(method = "loess", color = "red", se = FALSE) +
  geom_smooth(method = "lm", color = "blue", se = FALSE) +
  scale_x_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1)) +
  scale_y_continuous(limits = c(0, 400), breaks = seq(0, 400, by = 50)) +
  labs(title = "Price vs Distance: Linear Regression vs Lowess Curve",
       x = "Distance",
       y = "Price") +
  theme_bw()
modelsummary(reg0, latex = "table")

#2.5
# Create new log-transformed variables
city_data$log_price <- log(city_data$price)
city_data$log_distance <- log(city_data$distance)

# Plot histograms to inspect their distributions
# Log-Price Histogram
ggplot(city_data, aes(x = log_price)) +
  geom_histogram(binwidth = 0.2, fill = '#eb9b34', color = '#d16004') +
  labs(title = "Histogram of Log-Price", x = "Log-Price", y = "Frequency") +
  theme_minimal(base_size = 15)

# Log-Distance Histogram
ggplot(city_data, aes(x = log_distance)) +
  geom_histogram(binwidth = 0.2, fill = '#54aeb3', color = '#047ab5') +
  labs(title = "Histogram of Log-Distance", x = "Log-Distance", y = "Frequency") +
  theme_minimal(base_size = 15)

ggplot(city_data, aes(x = log_distance, y = log_price)) +
  geom_point(color = "#42bcf5") +
  #geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(title = "Log-Log Scatterplot", x = "Log-Distance", y = "Log-Price") +
  theme_bw()

ggplot(city_data, aes(x = distance, y = log_price)) +
  geom_point(color = "#42bcf5") +
  #geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(title = "Log-Level Scatterplot", x = "Distance", y = "Log-Price") +
  theme_bw()

ggplot(city_data, aes(x = log_distance, y = price)) +
  geom_point(color = "#42bcf5") +
  #geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(title = "Level-Log Scatterplot", x = "Log-Distance", y = "Price") +
  theme_bw()

#comparing models

# Step 2: Fit the three models

# Log-Log Model (log of price vs log of distance)
log_log_model <- lm(log_price ~ log_distance, data = city_data)

# Log-Level Model (log of price vs distance)
log_level_model <- lm(log_price ~ distance, data = city_data)

# Level-Log Model (price vs log of distance)
level_log_model <- lm(price ~ log_distance, data = city_data)

# Step 3: Compute Adjusted R-squared for each model

# Log-Log Model
r_squared_log_log <- summary(log_log_model)$r.squared

# Log-Level Model
r_squared_log_level <- summary(log_level_model)$r.squared

# Level-Log Model
r_squared_level_log <- summary(level_log_model)$r.squared

# Fit the log-level regression model (log of price, original distance)
reg1 <- lm(log_price ~ distance, data = city_data)

# Display a summary of the model (this will show the regression coefficients, p-values, and R-squared)
summary(reg1)

# Create a table format of the regression results using broom
reg1_summary <- tidy(reg1)
print(reg1)

# Generate a scatterplot with the regression line
ggplot(city_data, aes(x = distance, y = log_price)) +
  geom_point(color = '#42bcf5') +  # Scatterplot of the data
  geom_smooth(method = "lm", se = FALSE, color = "#f76d5e") +  # Regression line
  labs(title = "Log-Level Model: Price vs. Distance",
       x = "Distance",
       y = "Log of Price") +
  theme_minimal()
modelsummary(reg1)

#2.6


knot_value <- 1
# Fit the piecewise linear spline model
reg2 <- lm(price ~ lspline(distance, knots = knot_value), data = city_data)

# Display the summary of the model
summary(reg2)

# Tidy output in table format using broom
reg2_summary = tidy(reg2)

# Plot the piecewise linear spline with the fitted line
ggplot(city_data, aes(x = distance, y = price)) +
  geom_point(color = '#42bcf5') +  
  geom_smooth(method = "lm", formula = y ~ lspline(x, knots = knot_value), se = FALSE, color = "#f76d5e") +
  labs(title = "Piecewise Linear Spline Model: Price vs. Distance",
       x = "Distance",
       y = "Price") +
  theme_minimal()

modelsummary(reg2)
r_squared_spline <- summary(reg2)$r.squared

#2.7 

# Compute residuals and fitted values
city_data$residuals <- residuals(reg2)
city_data$fitted <- fitted(reg2)

# Find the best deals (lowest residuals) and worst deals (highest residuals)
best_deals <- city_data %>% arrange(residuals) %>% head(5)
worst_deals <- city_data %>% arrange(desc(residuals)) %>% head(5)

ggplot(city_data, aes(x = distance, y = price)) +
  geom_point(color = "grey", alpha = 0.6) +
  geom_point(data = best_deals, aes(x = distance, y = price), color = "#39b324", size = 3) +
  geom_point(data = worst_deals, aes(x = distance, y = price), color = "#b33724", size = 3) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, knots = knot_value), color = "#ed771c") +
  labs(title = "Best and Worst Deals: Piecewise Linear Spline Model", x = "Distance from City Center", y = "Price")+
  theme_bw()

ggplot(data = city_data, aes(x = distance, y = price)) +
  geom_point(fill = 'bisque3', color = 'black', shape = 21, size = 2, alpha = 0.6) +
  scale_x_continuous(limits=c(0, 10), breaks=seq(0, 10, by=1)) +
  scale_y_continuous (limits = c(0, 400), breaks = seq(0, 450, by = 50)) +
  geom_point(data = best_deals, aes(x = distance, y = price), color = "#39b324", size = 3) +
  geom_point(data = worst_deals, aes(x = distance, y = price), color = "#b33724", size = 3) +
  theme_bw()









