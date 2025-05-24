# Public Data Pipeline for Business Insights

This project simulates a complete data pipeline that extracts, transforms, and analyzes **public data sources** (e.g., IBGE, Brazilian Federal Revenue) to generate insights that support **data-driven decision making**.

      -- Check out the same project in Kotlin ' gh repo clone bellDataSc/Kotlin-Data-Pipeline ' - This project is a complete rewrite of my previous data pipeline, now using only Kotlin. The choice of language is intended to show how it is possible to apply modern data engineering practices outside of the Python ecosystem, using the power of the JVM, while maintaining conciseness, and preparing the code to evolve into backend applications or microservices in the future.

**Objective**

To showcase how public data can be organized and processed into reusable pipelines to extract value in fields such as public administration, education, media, and regional economic development.

**Tech Stack**

- Python (pandas, requests)
- Streamlit or Power BI (for dashboards)
- Google BigQuery / SQLite / CSV
- Public APIs (IBGE, company registries, etc.)

**Use Cases**

- Ranking cities by educational potential
- Clustering regional economic profiles
- Exploratory analysis of population and consumption behavior

---

**Project Structure**

public-data-pipeline/ │
├── data/ │
├── raw/ # raw data extracted from public APIs │ 
└── processed/ # cleaned and transformed data │ 
├── scripts/ # ETL scripts │ 
├── extract_ibge.py │ 
└── load_bigquery.py │ 
├── notebooks/ # exploratory data analysis (EDA) │ 
└── population_analysis.py │ 
├── dashboards/ # BI or Streamlit visual dashboards (to come) │ 
├── requirements.txt # dependencies 
└── README.md



---

## 👩‍💻 Created by

**Bel** – Data Analyst with expertise in public data, BI and ETL, currently working in the government of São Paulo, Brazil.



