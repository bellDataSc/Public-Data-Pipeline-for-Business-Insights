# population_analysis.py
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

# Load the population data
df = pd.read_csv("../data/raw/population_ibge.csv")

# Clean population column
df['Population'] = df['Population'].astype(int)

# Sort by population
df_sorted = df.sort_values(by='Population', ascending=False)

# Plot
plt.figure(figsize=(10, 6))
sns.barplot(x='Population', y='State', data=df_sorted, palette='viridis')
plt.title("Population by State (IBGE - 2021)", fontsize=14)
plt.xlabel("Population")
plt.ylabel("State")
plt.tight_layout()
plt.show()
