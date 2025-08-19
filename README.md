# Public Data Pipeline for Business Insights

[![CI](https://github.com/bellDataSc/Public-Data-Pipeline-for-Business-Insights/workflows/CI/badge.svg)](https://github.com/bellDataSc/Public-Data-Pipeline-for-Business-Insights/actions)
[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

> A comprehensive ETL pipeline for Brazilian public data analysis and business insights


## Features

- **ETL Pipeline**: Complete Extract, Transform, Load workflow
- **🇧🇷 Brazilian Data**: Specialized for Brazilian public datasets
- **IBGE Integration**: Direct integration with Brazilian census data
- **SICONV Support**: Government funding and transfer data
- **Async Processing**: High-performance data processing
- **Well Tested**: Comprehensive test suite with pytest
- **Business Intelligence**: Ready-to-use insights and analytics

## Architecture

            src/public_data_pipeline/
        ├── extractors/ # Data extraction modules
        │ ├── ibge_extractor.py # IBGE API integration
        │ └── siconv_extractor.py # SICONV data extraction
        ├── transformers/ # Data transformation
        │ ├── cleaner.py # Data cleaning utilities
        │ └── normalizer.py # Data normalization
        └── loaders/ # Data loading and export
        ├── csv_loader.py # CSV export functionality
        └── database_loader.py # Database integration



## Data Sources

### IBGE (Brazilian Institute of Geography and Statistics)
- **Population Census**: Demographic data by municipality
- **Economic Surveys**: GDP, employment, income statistics  
- **Geographic Data**: Administrative boundaries and territories

### SICONV
- **Federal Transfers**: Government funding data
- **Municipal Projects**: Public investment tracking
- **Budget Analysis**: Government spending insights

## Configuration

Create a `.env` file for configuration:

API Configuration

IBGE_API_BASE_URL=https://servicodados.ibge.gov.br/api/v1
SICONV_API_BASE_URL=https://api.siconv.gov.br

---

## Usage Examples

### Basic Data Extraction

    from public_data_pipeline.extractors import IBGEExtractor

Initialize extractor

    extractor = IBGEExtractor()

Extract population data

    population_data = extractor.get_population_data(year=2020)
    print(f"Extracted {len(population_data)} records")

---

## Quick Start

Clone repository
    git clone https://github.com/bellDataSc/Public-Data-Pipeline-for-Business-Insights.git
    cd Public-Data-Pipeline-for-Business-Insights

Create virtual environment
    python -m venv venv
    venv\Scripts\activate # Windows

source venv/bin/activate # macOS/Linux
Install for development

    pip install -e .
    pip install -r requirements-dev.txt

Run tests
    pytest -v

---

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for your changes
5. Ensure tests pass (`pytest -v`)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Code Standards
- Follow PEP 8 style guidelines
- Add type hints to all functions
- Write comprehensive docstrings
- Maintain >90% test coverage
- Use conventional commit messages

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **IBGE** for providing comprehensive Brazilian statistical data
- **Brazilian Government** for open data initiatives
- **Python Community** for excellent data science tools

## Author

**Bel** - Data Engineer & Analyst  
- GitHub: [@bellDataSc](https://github.com/bellDataSc)
- LinkedIn: [Connect with Bel](https://www.linkedin.com/in/belcruz/)
- Email: isabel.gon.adm@gmail.com
