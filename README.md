# DS 4420: Machine Learning and Data Mining — Final Project
**Northeastern University | Spring 2026 | Professor: Eric Gerber**

**GitHub Repository:** https://github.com/tessjoseph/ds4420finalproject.git

## Group Members

Emma Penn, Janina Kurowski, Tessa Joseph

## Project Overview

This project investigates **healthcare access, treatment, and outcomes for women with reproductive system disorders** with a focus on endometriosis and related autoimmune conditions through the lens of Medicare claims and inpatient discharge data.

Our central questions:
- Are there significant trends over time in Medicare inpatient discharges related to female reproductive system disorders?
- Do certain insurance plans or coverage structures produce better health outcomes for women with conditions like endometriosis?
- Which treatments are most frequently denied, and how does coverage variation relate to diagnosis and discharge patterns?

We apply **three machine learning methods** with at least one Bayesian model. At least one method is implemented manually without pre-built modeling packages.

---

## Phase I: Proof-of-Concept — Time Series Analysis of Medicare Discharges

Our project will explore whether there are significant trends over time in the number of inpatient hospital discharges related to female reproductive system disorders among Medicare beneficiaries. Understanding these trends in time series data will be a step towards the Phase II question of whether coverage structures and plan types are associated with different health outcomes for women with conditions like endometriosis.

### Dataset

**Medicare Inpatient Hospitals — by Geography and Service**
- **Source:** Centers for Medicare & Medicaid Services (CMS)
- **URL:** https://data.cms.gov/provider-summary-by-type-of-service/medicare-inpatient-hospitals/medicare-inpatient-hospitals-by-geography-and-service
- **Coverage:** National Medicare Part A inpatient discharge summaries, aggregated by geography and DRG (Diagnosis-Related Group) service code
- **Relevant subset:** DRG codes corresponding to female reproductive system disorders, aggregated nationally by year

The dataset used for this analysis is the Medicare Inpatient Hospitals by Geography and Service dataset, published by the Centers for Medicare & Medicaid Services (CMS). It contains national Medicare Part A inpatient discharge summaries aggregated by geography and DRG (Diagnosis-Related Group) service code, capturing hospital utilization patterns across the United States. For this proof-of-concept, we filtered the data to DRG codes corresponding to female reproductive system disorders and aggregated discharge counts at the national level by year. While the dataset is comprehensive in scope, it is not updated on a quarterly basis, which limits the number of usable time points for longitudinal modeling. The available data runs through 2013 in its historical aggregate form, constraining our ability to build a robust time series model on this subset alone. Future iterations of this analysis will explore whether more recent CMS data exists to extend the series, or whether an alternative framing using service-level coverage data better supports the modeling approach.

### Methods (Phase I)

Exploratory **time series analysis** in Python to assess whether discharge counts over available years show a statistically meaningful trend.

Key steps:
1. Filtered CMS dataset to DRG codes for female reproductive system disorders (menstrual and other female reproductive system disorders, with and without CC/MCC)
2. Aggregated national discharge counts by year
3. Plotted the raw time series
4. Examined the **ACF (Autocorrelation Function)** plot to assess stationarity and autocorrelation structure

### Phase I Findings & Limitations

The initial time series plot shows a clear downward trend in total discharges from roughly 2,400 at the start of the series down to approximately 1,600, with a slight uptick in the final observed years. The ACF plot shows high autocorrelation at lag 1 that decays gradually without a sharp cutoff, which is characteristic of a non-stationary series rather than a clean AR or MA process. Both DRG subsets (with and without CC/MCC) exhibit nearly identical autocorrelation structure. The slow decay in the ACF suggests the series may be better described by a random walk or trend-stationary process, but with only ~11 time points the series is too short to fit and validate a meaningful ARIMA model.

Key limitations:
- The data is **not updated quarterly**, limiting the number of usable time points
- Available aggregate data runs only through 2013, which is insufficient for a robust long-horizon time series
- The signal for reproductive disorder discharges may be too sparse at the national aggregate level to model with confidence

### Planned Pivot for Phase II

We are evaluating two directions based on Phase I findings:

1. **Data extension:** Identify whether more recent CMS inpatient data (post-2013) exists to extend the time series to a usable length
2. **Question reframing:** Shift toward modeling how Medicare-covered services related to female reproductive health (e.g., specific treatment types, coverage of endometriosis-related procedures) predict or explain discharge volume and outcomes — connecting more directly to the access and equity framing of our literature review

Additional datasets under consideration for Phase II:
- [Health Care Cost Institute (HCCI)](https://healthcostinstitute.org/) — commercial claims data for cross-payer comparison
- UTHealth Endometriosis MRI Dataset (UT-EndoMRI) — for potential imaging-based modeling

### Running the Phase I Code

**Requirements:** Python 3.x, `pandas`, `matplotlib`, `statsmodels`, `os`

```bash
cd phase1/
jupyter notebook POC_timeseries.ipynb
```

---

## Planned Phase II Models

| Model | Method | Language | Notes |
|-------|--------|----------|-------|
| TBD (time series extension or reframed access model) | Time Series / Regression | Python | To be finalized at March 23 check-in |
| Bayesian Model | Bayesian Classification or Regression | R | Manual implementation; no pyMC/rstan |
| TBD | TBD | Python or R | Third model for group of three |

*All models will be finalized and fully documented in the Phase II submission (due April 16).*

---

## Literature Review Summary

Our literature review examines prior work on disparities in endometriosis diagnosis and treatment, healthcare access inequities for women with reproductive disorders, and the use of ML methods in analyzing Medicare claims and diagnostic patterns. Full review available in `phase1/literature_review.pdf`.

**Selected Works:**

Westwood, Shannon, Mackenzie Fannin, Fadumo Ali, Justice Thigpen, Rachel Tatro, Amanda Hernandez, Cadynce Peltzer, et al. "Disparities in women with endometriosis regarding access to care, diagnosis, treatment, and management in the United States: a scoping review." *Cureus* 15, no. 5 (2023).

*Additional references available in the full literature review PDF, including work on diagnostic error in endometriosis (BMJ Open Quality) and Medicare diagnosis severity group time series modeling.*

---

## Full Citations

**Primary Dataset:**
Centers for Medicare & Medicaid Services. *Medicare Inpatient Hospitals - by Geography and Service*. Centers for Medicare & Medicaid Services. Published May 14, 2025; last modified May 22, 2025. Dataset. https://data.cms.gov/provider-summary-by-type-of-service/medicare-inpatient-hospitals/medicare-inpatient-hospitals-by-geography-and-service

**Documentation:**
Python Software Foundation. *os — Miscellaneous operating system interfaces*. Python Software Foundation. Last modified March 13, 2026. https://docs.python.org/3/library/os.html
