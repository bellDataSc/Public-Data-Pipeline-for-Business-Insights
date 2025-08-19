from setuptools import setup, find_packages

setup(
    name="public-data-pipeline",
    version="1.0.0",
    author="Bel",
    description="A comprehensive ETL pipeline for Brazilian public data analysis",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    python_requires=">=3.9",
    install_requires=[
        "pandas>=1.5.0",
        "requests>=2.28.0",
        "python-dotenv>=0.19.0",
    ],
)
