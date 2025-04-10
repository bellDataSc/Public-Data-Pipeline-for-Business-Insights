# load_bigquery.py
from google.cloud import bigquery
import pandas as pd

def load_csv_to_bigquery(csv_path, table_id):
    """Loads a CSV file to a BigQuery table."""
    client = bigquery.Client()
    df = pd.read_csv(csv_path)

    job = client.load_table_from_dataframe(df, table_id)
    job.result()  # Wait for the job to complete

    print(f"✅ Data successfully loaded into {table_id}")

if __name__ == "__main__":
    csv_path = "data/raw/population_ibge.csv"
    table_id = "your-project-id.your_dataset.population_data"
    load_csv_to_bigquery(csv_path, table_id)

## 🔐 Remember to authenticate with gcloud auth application-default login before running BigQuery operations.
