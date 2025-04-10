# extract_ibge.py
import requests
import pandas as pd
import os

def fetch_population_data(year=2021):
    """Fetches population data from IBGE API for all Brazilian states."""
    url = f"https://servicodados.ibge.gov.br/api/v3/agregados/6579/periodos/{year}/variaveis/9324?localidades=N1[all]"
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()
        records = []
        for item in data[0]['resultados'][0]['series']:
            state = item['localidade']['nome']
            population = item['serie'][str(year)]
            records.append({'State': state, 'Population': population})
        df = pd.DataFrame(records)
        return df
    else:
        raise Exception(f"Failed to fetch data from IBGE: {response.status_code}")

if __name__ == "__main__":
    df_population = fetch_population_data()
    os.makedirs("data/raw", exist_ok=True)
    df_population.to_csv("data/raw/population_ibge.csv", index=False)
    print("✅ Population data saved to data/raw/population_ibge.csv")
