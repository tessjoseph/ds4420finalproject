# Time Series Analysis
# Data Preprocessing

# Load necessary libraries
library(readr)

# Read and combine the yearly data files
year_and_quarter <- c()
measurement <- c()

data_folder <- "Time Series Analysis Data"
file_list <- list.files(path = data_folder,
                        pattern = "\\.csv$",
                        full.names = TRUE)
file_list <- sort(file_list)

for (file in file_list) {
  current_df <- read_csv(file, show_col_types = FALSE)
  
  current_df <- na.omit(current_df)
  current_df$`Medicaid Amount Reimbursed` <- as.numeric(current_df$`Medicaid Amount Reimbursed`)
  current_df <- current_df[current_df$`Product Name` %in% c("LUPRON DEPOT", "LUPRON DEP"), ]
  
  quarter_values <- sort(unique(current_df$Quarter))
  
  split_file <- strsplit(basename(file), "-")[[1]]
  year <- gsub("\\.csv$", "", split_file[2])
  
  for (q in quarter_values) {
    quarter_df <- current_df[current_df$Quarter == q, ]
    total_reimbursed <- sum(quarter_df$`Medicaid Amount Reimbursed`, na.rm = TRUE)
    
    year_and_quarter <- c(year_and_quarter, paste0(year, "Q", q))
    measurement <- c(measurement, total_reimbursed)
  }
}

spending_data <- data.frame(Date = year_and_quarter, Spending = measurement)
head(spending_data)

# Visualize the time series
try(dev.off(), silent = TRUE)
par(mar = c(4, 4, 2, 1))

plot(spending_data$Spending,
     type = "l",
     xlab = "Quarter",
     ylab = "Medicaid Amount Reimbursed",
     main = "Lupron Spending Over Time",
     xaxt = "n")

axis(1,
     at = seq(1, length(spending_data$Date), by = 4),
     labels = spending_data$Date[seq(1, length(spending_data$Date), by = 4)],
     las = 2,
     cex.axis = 0.8)

# Check autocorrelation structure
acf(spending_data$Spending, main = "Lupron Spending ACF Plot")
pacf(spending_data$Spending, main = "Lupron Spending PACF Plot")

# Split into training and test sets
train_size <- round(0.8 * nrow(spending_data))
train_data <- spending_data[1:train_size, ]
test_data <- spending_data[(train_size + 1):nrow(spending_data), ]

y_train <- train_data$Spending
y_test <- test_data$Spending

# Using AR(2) model from base R
ar_model <- ar(y_train,
               order.max = 2,
               aic = FALSE,
               method = "ols",
               demean = FALSE)

ar_model$order
ar_model$ar

ar_roots <- polyroot(c(1, -ar_model$ar))
Mod(ar_roots)

# Get predictions
phi1 <- ar_model$ar[1]
phi2 <- ar_model$ar[2]

full_series <- spending_data$Spending
test_start <- train_size + 1

one_step_pred <- c()

for (t in test_start:nrow(spending_data)) {
  pred_t <- phi1 * full_series[t - 1] + phi2 * full_series[t - 2]
  one_step_pred <- c(one_step_pred, pred_t)
}

# Convert AR predictions to a data frame
pred_data <- data.frame(Date = test_data$Date,
                        pred_spending = one_step_pred)

# Plot actual vs predicted from AR model
plot(one_step_pred, y_test,
     ylab = "Observed Spending",
     xlab = "Predicted Spending",
     main = "AR(2) Model Predictions")
abline(0, 1, col = "red")

# Time series plot of actual vs predicted spending
plot(1:length(y_test), y_test,
     type = "l",
     col = "blue",
     lwd = 2,
     ylim = range(c(one_step_pred, y_test)),
     xlab = "Test Quarter",
     ylab = "Medicaid Amount Reimbursed",
     main = "AR(2) Model Predictions",
     xaxt = "n")

axis(1,
    at = 1:length(test_data$Date),
    labels = test_data$Date,
    las = 2,
    cex.axis = 0.8)

lines(1:length(one_step_pred), one_step_pred,
      col = "red",
      lwd = 2,
      lty = 2)

legend("topleft",
       legend = c("Actual Spending", "AR(2) Predicted Spending"),
       col = c("blue", "red"),
       lty = c(1, 2),
       bty = "n")

# Mean Absolute Error (MAE)
mae <- mean(abs(y_test - one_step_pred))

cat(sprintf("Mean Absolute Error: %.2f\n", mae))

# Root Mean Squared Error (RMSE)
rmse <- sqrt(mean((y_test - one_step_pred)^2))

cat(sprintf("Root Mean Squared Error: %.2f\n", rmse))

# Checking the diagnostics plots
ar_residuals <- ar_model$resid

plot(ar_residuals,
     type = "l",
     main = "Residuals Over Time",
     ylab = "Residuals",
     xlab = "Time")
abline(h = 0, col = "red", lty = 2)

hist(ar_residuals,
     breaks = 20,
     main = "Histogram of Residuals",
     xlab = "Residuals",
     col = "gray",
     probability = TRUE)

lines(density(ar_residuals, na.rm = TRUE),
      col = "blue",
      lwd = 2)

qqnorm(ar_residuals, main = "Q-Q Plot of Residuals")
qqline(ar_residuals, col = "red", lwd = 2)

acf(ar_residuals, na.action = na.pass, main = "Autocorrelation of Residuals")

# Time series plot
png("lupron_spending_over_time.png", width = 1600, height = 900, res = 150)

par(mar = c(9, 4, 3, 1), mgp = c(5, 1.5, 0))
plot(spending_data$Spending,
     type = "l",
     lwd = 2,
     xlab = "Quarter",
     ylab = "Medicaid Amount Reimbursed",
     main = "Lupron Spending Over Time",
     xaxt = "n")

axis(1,
     at = seq(1, length(spending_data$Date), by = 4),
     labels = spending_data$Date[seq(1, length(spending_data$Date), by = 4)],
     las = 2,
     cex.axis = 0.8)

dev.off()

# PACF plot
png("lupron_pacf.png", width = 1200, height = 800, res = 150)

par(mar = c(5, 4, 3, 1))
pacf(spending_data$Spending,
     main = "PACF of Lupron Spending")

dev.off()

# Actual versus predicted plot
png("lupron_actual_vs_predicted.png", width = 1400, height = 800, res = 150)

par(mar = c(9, 4, 3, 1), mgp = c(5, 1.5, 0))
plot(1:length(y_test), y_test,
     type = "l",
     lwd = 2,
     col = "blue",
     ylim = range(c(one_step_pred, y_test)),
     xlab = "Test Quarter",
     ylab = "Medicaid Amount Reimbursed",
     main = "AR(2) Model Predictions on Test Data",
     xaxt = "n")

axis(1,
     at = 1:length(test_data$Date),
     labels = test_data$Date,
     las = 2,
     cex.axis = 0.8)

lines(1:length(one_step_pred), one_step_pred,
      col = "red",
      lwd = 2,
      lty = 2)

legend("topleft",
       legend = c("Actual Spending", "Predicted Spending"),
       col = c("blue", "red"),
       lty = c(1, 2),
       lwd = 2,
       bty = "n")

dev.off()
