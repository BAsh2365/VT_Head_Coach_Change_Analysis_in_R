# CFB_VT_Head_Coach_Change_Analysis_in_R (November 2025)

<img width="400" height="283" alt="image" src="https://github.com/user-attachments/assets/eea3f376-f30e-44cb-a3f9-e41fa2474f91" />  

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2b4bccc0-8583-4870-8f88-8e2d810727b7" />

Images taken from: 
- https://brand.vt.edu/licensing/university-trademarks.html#guidelines
- https://hokiesports.com/news/2025/11/17/james-franklin-announced-as-new-leader-of-virginia-tech-football

-----------------------------------------------------------------------------------------------------------------------------------------------


Using random forest regression values (Corrected to Ridge Regression, see below to compare model results) (MAE and RMSE, not OOB and Confusion Matrix) and summary statistics to predict how well VT does in the future based on the head coaching change (Brent Pry to James Franklin)

This R code showcases the shift in the Virginia Tech Locker room with head coach James Franklin taking over the program. Franklin (previously at Penn State) has a 68% win rate over 188 games.

To predict and compare how Franklin MAY do compared to previous locker rooms, we must level the playing field before running our Machine Learning Model.

My R code examines the last four seasons (2022-2025) of Brent Pry vs. James Franklin to equalize the sample size. We will record wins and losses as they occur for the 2025 season and calculate the average win rate, along with other factors such as average points per game, offensive passing yards, and rushing yards, to be applied to a random forest and ridge regression models. We also normalize the values (as they are on different scales) for better interpretability. There is also a SHAP values plot to showcase differences regarding which variable/features mostly affect our prediction.



# Analysis (Random forest)

Average predicted win rate under Coach Franklin (based on R code): 57.85%

This means that in a 12-game season (excluding bowl games), Coach Franklin should win around 6 or more games when he takes over (theoretically speaking)

Looking closer, we can see that 4 seasons from now, Coach Franklin's win percentages may be:
- 52.86% in Season 1
- 61.42% in Season 2
- 59.47% in Season 3
- 57.63% in Season 4

  These numbers are all produced by running the model a couple of times with a random seed of 42. 

POTENTIALLY (given an extrapolated value of +/- 3 percentage points, given confounding variables and adjustment)

<img width="861" height="587" alt="image" src="https://github.com/user-attachments/assets/9b1e5b84-909f-419e-b624-156323d5996a" />


Here we see the Shapley values plot. We see here that the amount of games lost and Offensive passing yards seem to play a large role in our model (given the importance measured using (phi- stemming from game theory), the x-axis, and the features on the y-axis). We see the given values + variance below: 

<img width="728" height="346" alt="image" src="https://github.com/user-attachments/assets/039b6930-b9d1-4e50-8859-ae09e564fe46" />


As well as the RSME and RAE results:

<img width="671" height="110" alt="image" src="https://github.com/user-attachments/assets/82b34f25-feac-46a4-b3b5-4ef4ea6e2fdc" />


With Franklin coming in, a new offensive scheme may be in play for the boys in maroon. 


Given that Coach Franklin needs some time to settle in, adopt his recruitment style, bolster the playbook, etc., these predictions should be accurate given the normalized data showcased here. 

UPDATE: This Random Forest model, upon further inspection, is not the greatest model for accuracy, even with using an in-memory version (Ranger) (as the MAE and RMSE values don't line up with the R^2 value of 1, which indicates overfitting).

# Ridge model regression Analysis (More accurate)

We use the ridge model regression with a more accurate R^2 value of 0.512 instead of 1 with similar RSME and RAE stats.

The Win percentage rates are shown here:

<img width="781" height="181" alt="image" src="https://github.com/user-attachments/assets/eb9fa707-6aaa-499a-b41f-2b4c40193457" />

Similar estimates, with Coach Franklin projected to win about 6 to 7 games in a full 12 game season as he takes over.

The SHAP values plot for the more accurate Ridge regression is shown here:

<img width="861" height="587" alt="image" src="https://github.com/user-attachments/assets/56f6a8e2-1b29-4f7f-9ade-74c5f749708f" />

Points per game and games lost are the two big contributors here for our model.

with the values shown here:
<img width="650" height="337" alt="image" src="https://github.com/user-attachments/assets/9ed907f5-1d63-436c-ae89-c828ebbd38eb" />


The RSME/RAE LOOCV results shown here (leaving one value out for cross-validation for more accurate model results due to sample size):

<img width="673" height="199" alt="image" src="https://github.com/user-attachments/assets/bad611ed-a6e2-420a-a787-d6e4238eecef" />


These models are not perfect and can always be improved upon! If you have any issues/suggestions with/for the model, you can reach out to me. Ridge regression seems to be more accruate for sample size.


# References 

https://help.football.cbssports.com/s/article/How-are-ties-calculated-for-winning-percentage

https://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm#overview

https://www.sports-reference.com/?utm_source=cfb&utm_medium=sr_xsite&utm_campaign=2023_01_srnav (VT data, PSU data, coaching data cross-checking)

https://www.r-bloggers.com/2019/03/a-gentle-introduction-to-shap-values-in-r/#google_vignette

https://bgreenwell.github.io/intro-fastshap/slides.html#1

https://datasciencelessons.wordpress.com/2019/08/13/random-forest-for-classification-in-r/

https://machinelearningmastery.com/loocv-for-evaluating-machine-learning-algorithms/

https://www.rdocumentation.org/packages/ranger/versions/0.16.0/topics/ranger

https://datascienceharp.medium.com/cant-decide-between-a-linear-regression-or-a-random-forest-here-let-me-help-ab941b94da4c

Use of Claude 4.5 Sonnet for organized data cleaning/collection

Use of GitHub Copilot for Code Assistance on Model fit (random forest ML vs Ridge), debugging/accuracy, and Normalizing Predictors 

PDF files of VT stats and PSU stats can be found in this GitHub Repo


# Future improvements

- Testing out more ML models
- Gathering more data
- Adding in confounding variables to see the weights + biases (how it influences the models)
- Up to date data pipeline 



