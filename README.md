# CFB_VT_Head_Coach_Change_Analysis_in_R (November 2025)

<img width="400" height="283" alt="image" src="https://github.com/user-attachments/assets/eea3f376-f30e-44cb-a3f9-e41fa2474f91" />  

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2b4bccc0-8583-4870-8f88-8e2d810727b7" />

Images taken from: 
- https://brand.vt.edu/licensing/university-trademarks.html#guidelines
- https://hokiesports.com/news/2025/11/17/james-franklin-announced-as-new-leader-of-virginia-tech-football

-----------------------------------------------------------------------------------------------------------------------------------------------


Using random forest regression values (MAE and RMSE, not OOB and Confusion Matrix) and summary statistics to predict how well VT does in the future based on the head coaching change (Brent Pry to James Franklin)

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

  These numbers are all produced by running the model a couple of times with a random seed of 42. 

POTENTIALLY (given an extrapolated value of +/- 3 percentage points, given confounding variables and adjustment)

<img width="861" height="587" alt="image" src="https://github.com/user-attachments/assets/e046380c-b999-4d1e-ba69-f3522cdcd658" />

Here we see the Shapley values plot. We see here that the amount of games won and Offensive passing yards seem to play a large role in our model (given the importance on the x-axis and the features on the y-axis). We see the given values + variance below: 

<img width="653" height="483" alt="image" src="https://github.com/user-attachments/assets/9b20a408-32de-4ef8-8759-13fc87cea375" />

With Franklin coming in, a new offensive scheme may be in play for the boys in maroon. 


Given that Coach Franklin needs some time to settle in, adopt his recruitment style, bolster the playbook, etc., these predictions should be accurate given the normalized data showcased here. 

The model is not perfect and can always be improved upon! If you have any issues/suggestions with/for the model, you can reach out to me.


# References 

https://help.football.cbssports.com/s/article/How-are-ties-calculated-for-winning-percentage

https://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm#overview

https://www.sports-reference.com/?utm_source=cfb&utm_medium=sr_xsite&utm_campaign=2023_01_srnav (VT data, PSU data, coaching data cross-checking)

https://www.r-bloggers.com/2019/03/a-gentle-introduction-to-shap-values-in-r/#google_vignette

https://bgreenwell.github.io/intro-fastshap/slides.html#1

https://datasciencelessons.wordpress.com/2019/08/13/random-forest-for-classification-in-r/

Use of Claude 4.5 Sonnet for organized data cleaning/collection, Use of GitHub Copilot for Code Assistance on Model fit (random forest ML), and Normalizing Predictors 

PDF files of VT stats and PSU stats can be found in this GitHub Repo






