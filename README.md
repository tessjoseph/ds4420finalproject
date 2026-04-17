# DS 4420: Machine Learning and Data Mining — Final Project
**Northeastern University | Spring 2026 | Professor: Eric Gerber**

**GitHub Repository:** https://github.com/tessjoseph/ds4420finalproject.git

## Group Members

Emma Penn, Janina Kurowski, Tessa Joseph

## Machine Learning Analysis of Women’s Reproductive Health Outcomes in Government-funded Health Insurance Programs

## Project Overview

This project investigates **women’s reproductive health outcomes in government-funded health insurance programs** using Medicare and Medicaid administrative data. Our work focuses on endometriosis-related treatment patterns and female reproductive system utilization, with particular attention to Lupron Depot spending, prescribing, and downstream healthcare use.

Our central questions:
- How has quarterly Medicaid spending on Lupron Depot changed over time, and how well can a time series model capture that trajectory?
- Did Lupron prescription counts increase across states, and how much state to state variation exists in those trends?
- Can state level provider, hospital, and Medicare payment features help predict inpatient and outpatient utilization related to female reproductive system disorders?

We apply **three machine learning methods** with at least one Bayesian model. At least one method is implemented manually without pre-built modeling packages.

---

## Time Series Analysis of Medicaid Lupron Spending

The time series was built by aggregating Lupron-related Medicaid reimbursement amounts by quarter. This created a long historical series that let us evaluate how spending changed over time and whether recent values could be forecast from earlier quarters.

### Dataset

**CMS State Drug Utilization Data**
- **Source:** Centers for Medicare & Medicaid Services (CMS)
- **Relevant subset:** Lupron Depot reimbursement amounts aggregated by quarter
- **Time coverage:** Quarterly observations from 1998 to 2025

### Methods

Exploratory **time series analysis in R** followed by ARIMA modeling.

Key steps:
1. Combined quarterly Medicaid reimbursement data across years
2. Plotted the raw time series
3. Examined the **ACF** and **PACF** plots to assess lag structure and nonstationarity
4. Fit and compared autoregressive style models with differencing
5. Evaluated predictions with residual diagnostics and mean absolute error

### Findings and Limitations

The final model was **ARIMA(2, 2, 0)**. The series showed a strong long-term upward trend in Lupron spending, but also increasing variability in later years. The model captured the overall direction of spending growth, though it still struggled with volatility and nonstationarity.

Key takeaway:
- Medicaid reimbursement for Lupron increased substantially over time

Key limitation:
- Even after differencing, the series was still difficult to forecast precisely because spending behavior became more variable in later years

### Running the Time Series Code

**Requirements:** R, `readr`, `rmarkdown`

```r
install.packages(c("readr", "rmarkdown"))
rmarkdown::render("ARIMA_model_AR2_differencing1.Rmd")
```

---

## Bayesian Poisson Regression of State Level Lupron Prescriptions

Our second analysis studies whether **Lupron prescription counts changed over time across states**. This model shifts from spending to prescribing behavior, allowing us to assess both a national pattern and state-level variation.

### Dataset

**CMS State Drug Utilization Data**
- **Source:** Centers for Medicare & Medicaid Services (CMS)
- **Relevant subset:** Annual Lupron prescription totals by state
- **Time coverage:** 2009 to 2024

The Bayesian dataset was built by aggregating annual Lupron prescription counts across states. Suppressed rows and unknown state codes were removed before modeling.

### Methods

A **Bayesian Poisson regression model in Python** with state specific intercepts and slopes.

Key steps:
1. Filtered Lupron prescription records and aggregated them to the state year level
2. Centered the year variable to improve interpretation
3. Modeled annual prescription counts with a Poisson likelihood
4. Placed Normal priors on state intercepts and state slopes
5. Used a **manual Metropolis-Hastings sampler** to approximate the posterior
6. Summarized posterior means, posterior standard deviations, and interval estimates across states

### Findings & Limitations

The model found evidence of a **positive national prescribing trend** from 2009 to 2024. The posterior mean for the national average slope, mu_beta, was approximately 0.037, suggesting a modest increase in prescribing over time on the log scale. At the same time, the state-level estimates showed meaningful geographic variation, with some states increasing faster than others, and a smaller number declining.

Key takeaway:
- Lupron prescribing generally increased over time across states in the Medicaid data

Key limitations:
- The prescription counts showed substantial dispersion, which makes the Poisson assumption imperfect
- The Metropolis-Hastings sampler had a low acceptance rate, so the model should be interpreted as exploratory rather than fully optimized

### Running the Bayesian Code

**Requirements:** Python 3.x, `numpy`, `pandas`, `matplotlib`, `scipy`, `jupyter`

```bash
pip install numpy pandas matplotlib scipy notebook jupyter
jupyter notebook "PoissonBayesian.ipynb"
```

___

## Neural Network Analysis of State Level Utilization

Our third analysis asks whether **state level healthcare system characteristics can predict utilization related to female reproductive system disorders**. This model focuses on downstream use of care rather than spending or prescribing alone.

### Dataset

A merged **state level utilization dataset** built from multiple CMS sources:
- Medicare inpatient utilization data
- Medicare outpatient utilization data
- Hospital counts and provider counts
- Medicare payment features

Each row represented one state. The outcome variable was total utilization, defined as the sum of selected inpatient discharges and outpatient utilization for female reproductive system disorders in 2023.

### Methods

A **manually implemented neural network regression model in Python**.

Key steps:
1. Merged state level features with utilization targets
2. Cleaned numeric variables and filled missing predictor values with medians
3. Standardized predictors using training set statistics
4. Standardized the target during training and transformed predictions back to the original scale for interpretation
5. Fit a multilayer perceptron with one hidden layer, one hidden node, ReLU activation, and a linear output layer
6. Used gradient descent with L2 regularization
7. Used **leave-one-out cross-validation** to compare random seeds and select the final initialization

### Findings and Limitations

Earlier versions of the neural network underfit the data and predicted within a too-narrow range. After tuning the learning rate, including bias terms, and using leave-one-out cross-validation, the final model performed much better than a simple baseline that predicted the training set mean.

Key takeaway:
- State level provider, hospital, and Medicare payment features contained useful predictive signal for reproductive health utilization

Key limitation:
- The dataset was very small because each observation represented a state, so the model remains exploratory and sensitive to initialization choices

### Running the Neural Network Code

**Requirements:** Python 3.x, `numpy`, `pandas`, `matplotlib`, `jupyter`

```bash
pip install numpy pandas matplotlib notebook jupyter
jupyter notebook "Neural Network.ipynb"
```

---

## Final Project Models

| Model | Method | Language |
|-------|--------|----------|
| ARIMA(2, 2, 0) | Time Series | R |
| Bayesian Poisson regression with state specific intercepts and slopes | Bayesian Modeling | Python |
| One hidden layer multilayer perceptron | Neural Network | Python |

---

## Literature Review Summary

Our literature review examines prior work on disparities in endometriosis diagnosis and treatment, healthcare access inequities in women’s reproductive health, and machine learning approaches for analyzing related clinical and administrative data. The final project builds on that literature by shifting attention toward government-funded insurance measures of spending, prescribing, and utilization rather than imaging-based diagnosis alone.

**Selected Works:**

Westwood, Shannon, Mackenzie Fannin, Fadumo Ali, Justice Thigpen, Rachel Tatro, Amanda Hernandez, Cadynce Peltzer, et al. “Disparities in women with endometriosis regarding access to care, diagnosis, treatment, and management in the United States: a scoping review.” *Cureus* 15, no. 5 (2023).

Bontempo, Allyson C., and Gordon D. Schiff. “Diagnosing Diagnostic Error of Endometriosis: A Secondary Analysis of Patient Experiences from a Mixed Methods Survey.” *BMJ Open Quality* 14, no. 1 (2025).

Xing, et al. Research on the UT EndoMRI dataset and deep learning based endometriosis imaging tasks.

*Additional references available in the full report PDF, including work on diagnostic error in endometriosis (BMJ Open Quality) and Medicare diagnosis severity group time series modeling.*
