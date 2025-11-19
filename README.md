# VT_Head_Coach_Change_Analysis_in_R
Using random forest values and summary statistics to predict how well VT does in the future based on the head coaching change (Brent Pry to James Franklin)

This R code showcases the shift in the Virginia Tech Locker room with head coach James Franklin taking over the program. Franklin (previously at Penn State) has a 68% win rate over 188 games.

To predict and compare how Franklin MAY do compared to previous locker rooms, we must level the playing field before running our Machine Learning Model.

My R code examines the last four seasons (2022-2025) of Brent Pry vs. James Franklin to equalize the sample size. We will record wins and losses as they occur for the 2025 season and calculate the average win rate, along with other factors such as average points per game, offensive passing yards, and rushing yards, to be applied to a random forest model. We also normalize the values (as they are on different scales) for better interpretability. There is also a SHAP values plot to showcase differences regarding which variable/features mostly affect our prediction.



# Analysis

Average predicted win rate under Coach Franklin (based on R code): 57.92%

This means that in a 12-game season (excluding bowl games), Coach Franklin should win around 6 or more games when he takes over (theoretically speaking)

Looking closer, we can see that 4 seasons from now, Coach Franklin's win percentages may be:
- 53.51897% in Season 1
- 60.95917% in Season 2
- 59.72311% in Season 3
- 57.47641% in Season 4

POTENTIALLY (given an extrapolated value of +/- 3 percentage points, given confounding variables and adjustment)

<img width="861" height="587" alt="image" src="https://github.com/user-attachments/assets/e046380c-b999-4d1e-ba69-f3522cdcd658" />

Here we see the Shapley values plot. We see here that the amount of games won and Offensive passing yards seem to play a large role in our model (given the importance on the x-axis and the features on the y-axis). We see the given values + variance below: 


feature                                phi  phi.var
1                        Games_Won -3.7514968 2.517410
2                       Games_Lost -3.3919744 2.053284
3                  Points_Per_Game -3.5463372 2.281451
4          Offensive_Yards_passing -4.1793462 3.125304
5          Offensive_Yards_Rushing -2.6610295 1.270499
6                               TD -3.7495593 2.514717
7 Defensive_Yards_Allowed_Per_Game -0.7455365 0.522387


feature.value                                     
1                        Games_Won=0.230769230769231
2                                       Games_Lost=1
3                                  Points_Per_Game=0
4           Offensive_Yards_passing=0.26905132192846
5                          Offensive_Yards_Rushing=0
6                                               TD=0
7 Defensive_Yards_Allowed_Per_Game=0.972288202692003


With Franklin coming in, a new offensive scheme may be in play for the boys in maroon. 


Given that Coach Franklin needs some time to settle in, adopt his recruitment style, bolster the playbook, etc., these predictions should be accurate given the normalized data showcased here. 

The model is not perfect and can always be improved upon! If you have any issues/suggestions with/for the model, you can reach out to me.


# References 

https://help.football.cbssports.com/s/article/How-are-ties-calculated-for-winning-percentage

https://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm#overview

https://www.sports-reference.com/?utm_source=cfb&utm_medium=sr_xsite&utm_campaign=2023_01_srnav (VT data, PSU data, coaching data cross-checking)

https://www.r-bloggers.com/2019/03/a-gentle-introduction-to-shap-values-in-r/#google_vignette

https://bgreenwell.github.io/intro-fastshap/slides.html#1

Use of Claude 4.5 Sonnet for organized data cleaning/collection, Use of GitHub Copilot for Code Assistance on Model fit (random forest ML), and Normalizing Predictors 

PDF files of VT stats and PSU stats can be found in this GitHub Repo






