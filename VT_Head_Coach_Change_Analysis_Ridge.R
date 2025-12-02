#Comparing Average Win Percentage across all 4 seasons 

VT_avg_wins_2022_2025 <- sum(virginia_tech_stats_2022_2025$Games_Won_VT) 

Penn_state_avg_wins_2022_2025 <- sum(penn_state_football_stats$Games_Won_PS)


#Not a great metric, lets try win percentage rate

VT_win_percent <- sum(virginia_tech_stats_2022_2025$Games_Won_VT + 0) / sum(virginia_tech_stats_2022_2025$Games_Won_VT + virginia_tech_stats_2022_2025$Games_Lost_VT) * 100

#40% winning percentage over the last 4 seasons

PS_win_percentage <- sum(penn_state_football_stats$Games_Won_PS + 0) / sum(penn_state_football_stats$Games_Won_PS + penn_state_football_stats$Games_Lost_PS) * 100
#73.1% winning percentage by James Franklin over the last 4 seasons

#average PPG
Penn_avg_ppg <- mean(penn_state_football_stats$PSU_Points_Per_Game) #33.9 pts per game on average
VT_avg_ppg <- mean(virginia_tech_stats_2022_2025$VT_Points_Per_Game) #25.1 pts per game on average

# Load required libraries
library(readxl)
library(caret)
library(glmnet)    
library(iml)


vt_data <- read_excel("virginia_tech_stats_2022_2025.xlsx")
ps_data <- read_excel("penn_state_football_stats.xlsx")


vt_data$Team  <- "VT"
vt_data$Coach <- "Brent Pry"
ps_data$Team  <- "PSU"
ps_data$Coach <- "James Franklin"


combined_data <- rbind(
  data.frame(
    Team = vt_data$Team,
    Games_Won = vt_data$Games_Won_VT,
    Games_Lost = vt_data$Games_Lost_VT,
    Points_Per_Game = vt_data$VT_Points_Per_Game,
    Offensive_Yards_passing = vt_data$VT_Pass_Total_Yards,
    Offensive_Yards_Rushing = vt_data$VT_Rush_Total_Yards,
    TD = vt_data$VT_Total_TDs,
    Defensive_Yards_Allowed_Per_Game = vt_data$OPP_Avg_Yards_Per_Game,
    Coach = vt_data$Coach
  ),
  data.frame(
    Team = ps_data$Team,
    Games_Won = ps_data$Games_Won_PS,
    Games_Lost = ps_data$Games_Lost_PS,
    Points_Per_Game = ps_data$PSU_Points_Per_Game,
    Offensive_Yards_passing = ps_data$PSU_Passing_Total,
    Offensive_Yards_Rushing = ps_data$PSU_Rushing_Total,
    TD = ps_data$PSU_Total_TDs_Scored,
    Defensive_Yards_Allowed_Per_Game = ps_data$OPP_Avg_Per_Game,
    Coach = ps_data$Coach
  )
)

# ----- Feature engineering: win percentage -----
combined_data$Win_Percentage <- combined_data$Games_Won /
  (combined_data$Games_Won + combined_data$Games_Lost) * 100

# Encode Coach as factor
combined_data$Coach <- as.factor(combined_data$Coach)

# ----- Normalize predictors (Min–Max) -----
minmax_scale <- function(x) {
  lo <- min(x, na.rm = TRUE)
  hi <- max(x, na.rm = TRUE)
  rng <- hi - lo
  if (!is.finite(rng) || rng == 0) return(rep(0, length(x)))
  (x - lo) / rng
}

predictor_cols <- c(
  "Games_Won", "Games_Lost", "Points_Per_Game",
  "Offensive_Yards_passing", "Offensive_Yards_Rushing",
  "TD", "Defensive_Yards_Allowed_Per_Game"
)

for (col in predictor_cols) {
  combined_data[[col]] <- minmax_scale(combined_data[[col]])
}

# ----- Train/test split -----
train_data <- subset(combined_data, Coach == "James Franklin")
test_data  <- subset(combined_data, Team  == "VT")

# ----- LOOCV with deterministic seeds -----
set.seed(42)

# Ridge: alpha = 0, tune over lambda
tune_grid <- expand.grid(
  alpha = 0,                                # ridge
  lambda = 10^seq(-4, 3, length.out = 50)   # wide lambda range
)

k <- nrow(tune_grid)
seeds <- vector("list", nrow(train_data) + 1)
for (i in seq_len(nrow(train_data))) seeds[[i]] <- sample.int(1e6, k)
seeds[[nrow(train_data) + 1]] <- sample.int(1e6, 1)

ctrl <- trainControl(
  method = "LOOCV",
  savePredictions = "final",
  returnResamp   = "all",
  seeds = seeds
)

# ----- Train Ridge model via caret::train (glmnet backend) -----
ridge_model <- caret::train(
  Win_Percentage ~ Games_Won + Games_Lost + Points_Per_Game +
    Offensive_Yards_passing + Offensive_Yards_Rushing +
    TD + Defensive_Yards_Allowed_Per_Game,
  data      = train_data,
  method    = "glmnet",
  trControl = ctrl,
  tuneGrid  = tune_grid,
  metric    = "RMSE",
  standardize = TRUE   # glmnet's own standardization; fine even after min-max
)

print(ridge_model$results[which.min(ridge_model$results$RMSE), ])

# ----- Predict VT win percentage under Franklin -----
ridge_pred <- predict(ridge_model, newdata = test_data)
cat("Predicted VT win percentage under James Franklin (Ridge):\n")
print(ridge_pred)

avg_predicted_win_percent <- mean(ridge_pred)
cat("Average predicted VT win percentage under James Franklin (Ridge):\n")
print(avg_predicted_win_percent)

# ----- LOOCV metrics from predictions -----
loocv_metrics <- caret::postResample(
  pred = ridge_model$pred$pred,
  obs  = ridge_model$pred$obs
)
print(loocv_metrics)  # RMSE, R^2, MAE

# ----- RAE on LOOCV (relative abs. error should be low) -----
rae <- with(ridge_model$pred,
            sum(abs(obs - pred)) / sum(abs(obs - mean(obs)))
)
cat("LOOCV RAE:", rae, "\n")

# ----- SHAP analysis with iml -----
train_predictors <- train_data[, predictor_cols]
predictor <- Predictor$new(ridge_model, data = train_predictors, y = train_data$Win_Percentage)

test_predictors <- test_data[, predictor_cols]
shap <- Shapley$new(predictor, x.interest = test_predictors[1, ])
print(shap$results)
plot(shap)
