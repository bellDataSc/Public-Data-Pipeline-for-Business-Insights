# Contributing to Public Data Pipeline for Business Insights

First off, thank you for considering contributing to this project! 

It's people like you that make this project a great tool for the data engineering community.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Issue Reporting](#issue-reporting)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

### Our Pledge

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

### Prerequisites

Before you begin contributing, make sure you have:

- Python 3.8 or higher installed
- Git configured on your machine
- Docker and Docker Compose (for testing)
- Basic understanding of data engineering concepts

### Setting Up Your Development Environment

1. **Fork the repository**
   ```bash
   # Fork the repo on GitHub, then clone your fork
   git clone https://github.com/YOUR-USERNAME/Public-Data-Pipeline-for-Business-Insights.git
   cd Public-Data-Pipeline-for-Business-Insights
   ```

2. **Set up your development environment**
   ```bash
   # Create virtual environment
   python -m venv venv
   source venv/bin/activate  # Linux/macOS
   # venv\Scripts\activate   # Windows
   
   # Install development dependencies
   pip install -r requirements-dev.txt
   
   # Install pre-commit hooks
   pre-commit install
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your local configurations
   ```

4. **Verify your setup**
   ```bash
   make test
   make lint
   ```

## Development Process

### Branching Strategy

We use a simplified Git flow:

- `main`: Production-ready code
- `develop`: Integration branch for features
- `feature/*`: New features
- `bugfix/*`: Bug fixes
- `hotfix/*`: Critical fixes

### Workflow

1. **Create a new branch**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write your code
   - Add/update tests
   - Update documentation
   - Run tests locally

3. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new data source integration"
   ```

4. **Push and create a Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```

## Pull Request Process

1. **Before submitting:**
   - Ensure all tests pass: `make test`
   - Check code quality: `make lint`
   - Update documentation if needed
   - Add/update tests for new functionality

2. **Pull Request Requirements:**
   - Use a clear and descriptive title
   - Fill out the PR template completely
   - Link related issues
   - Include screenshots for UI changes
   - Ensure CI/CD pipeline passes

3. **Review Process:**
   - At least one maintainer must approve
   - All discussions must be resolved
   - CI/CD pipeline must pass
   - No conflicts with target branch

## Coding Standards

### Python Code Style

We follow PEP 8 with these specific guidelines:

- **Line length**: 88 characters (Black default)
- **Imports**: Use isort for import sorting
- **Type hints**: Required for all public functions
- **Docstrings**: Google style for all modules, classes, and functions

### Example Code Structure

```python
"""
Module docstring explaining the purpose and usage.

This module handles data extraction from IBGE API endpoints.
It provides functionality to fetch population, economic, and 
geographic data with built-in retry logic and error handling.
"""

import logging
from typing import Dict, List, Optional, Union
from datetime import datetime

import pandas as pd
import requests
from pydantic import BaseModel, validator

# Configure module logger
logger = logging.getLogger(__name__)

class IBGEConfig(BaseModel):
    """Configuration for IBGE API client.
    
    Attributes:
        base_url: Base URL for IBGE API
        timeout: Request timeout in seconds
        max_retries: Maximum number of retry attempts
    """
    
    base_url: str = "https://servicodados.ibge.gov.br/api/v1"
    timeout: int = 30
    max_retries: int = 3
    
    @validator('timeout')
    def validate_timeout(cls, v: int) -> int:
        """Validate timeout value."""
        if v <= 0:
            raise ValueError("Timeout must be positive")
        return v

class IBGEExtractor:
    """Extract data from IBGE (Brazilian Institute of Geography and Statistics) API.
    
    This class provides methods to fetch various types of data from IBGE API
    including population statistics, economic indicators, and geographic data.
    
    Example:
        >>> extractor = IBGEExtractor()
        >>> population_data = extractor.get_population_data(year=2020)
        >>> print(f"Extracted {len(population_data)} records")
    """
    
    def __init__(self, config: Optional[IBGEConfig] = None) -> None:
        """Initialize the IBGE extractor.
        
        Args:
            config: Configuration object for API settings
        """
        self.config = config or IBGEConfig()
        self.session = self._create_session()
        
    def _create_session(self) -> requests.Session:
        """Create configured requests session."""
        session = requests.Session()
        session.headers.update({
            'User-Agent': 'Public-Data-Pipeline/1.0',
            'Accept': 'application/json'
        })
        return session
    
    def get_population_data(
        self, 
        year: int, 
        regions: Optional[List[str]] = None
    ) -> pd.DataFrame:
        """Extract population data from IBGE API.
        
        Args:
            year: Year for data extraction (e.g., 2020)
            regions: List of region codes to filter. If None, all regions.
            
        Returns:
            DataFrame with population data
            
        Raises:
            ValueError: If year is invalid
            requests.RequestException: If API request fails
            
        Example:
            >>> data = extractor.get_population_data(2020, ['SP', 'RJ'])
            >>> print(data.columns.tolist())
            ['region', 'city', 'population', 'year']
        """
        if year < 1991 or year > datetime.now().year:
            raise ValueError(f"Invalid year: {year}")
            
        logger.info(f"Extracting population data for year {year}")
        
        # Implementation here...
        
    def _make_request(self, endpoint: str, params: Dict) -> Dict:
        """Make HTTP request with retry logic."""
        # Implementation here...
```

### Code Quality Tools

We use these tools to maintain code quality:

```bash
# Code formatting
black src/ tests/

# Import sorting  
isort src/ tests/

# Linting
flake8 src/ tests/

# Type checking
mypy src/

# Security scanning
bandit -r src/
```

## Testing Guidelines

### Testing Philosophy

- **Coverage**: Aim for >90% test coverage
- **Types**: Unit, integration, and end-to-end tests
- **Fast feedback**: Tests should run quickly
- **Isolation**: Tests should not depend on each other

### Test Structure

```
tests/
├── unit/                   # Fast, isolated tests
│   ├── extractors/
│   ├── transformers/
│   └── loaders/
├── integration/           # Component interaction tests
│   ├── test_pipeline.py
│   └── test_database.py
├── e2e/                   # Full pipeline tests
│   └── test_full_pipeline.py
├── fixtures/              # Test data
│   ├── sample_data.json
│   └── mock_responses.py
└── conftest.py           # Shared fixtures
```

### Writing Tests

```python
import pytest
import pandas as pd
from unittest.mock import Mock, patch

from src.extractors.ibge_extractor import IBGEExtractor, IBGEConfig

class TestIBGEExtractor:
    """Test suite for IBGE data extractor."""
    
    @pytest.fixture
    def extractor(self):
        """Create extractor instance for testing."""
        config = IBGEConfig(timeout=10, max_retries=1)
        return IBGEExtractor(config)
    
    @pytest.fixture
    def mock_api_response(self):
        """Mock API response data."""
        return {
            'resultados': [
                {'localidade': 'São Paulo', 'populacao': 12000000},
                {'localidade': 'Rio de Janeiro', 'populacao': 6500000}
            ]
        }
    
    def test_initialization_with_default_config(self):
        """Test extractor initialization with default configuration."""
        extractor = IBGEExtractor()
        
        assert extractor.config.base_url == "https://servicodados.ibge.gov.br/api/v1"
        assert extractor.config.timeout == 30
        assert extractor.config.max_retries == 3
    
    def test_initialization_with_custom_config(self):
        """Test extractor initialization with custom configuration."""
        config = IBGEConfig(timeout=60, max_retries=5)
        extractor = IBGEExtractor(config)
        
        assert extractor.config.timeout == 60
        assert extractor.config.max_retries == 5
    
    @patch('requests.Session.get')
    def test_get_population_data_success(self, mock_get, extractor, mock_api_response):
        """Test successful population data extraction."""
        # Arrange
        mock_get.return_value.json.return_value = mock_api_response
        mock_get.return_value.raise_for_status = Mock()
        
        # Act
        result = extractor.get_population_data(year=2020)
        
        # Assert
        assert isinstance(result, pd.DataFrame)
        assert len(result) == 2
        assert 'city' in result.columns
        assert 'population' in result.columns
        mock_get.assert_called_once()
    
    def test_get_population_data_invalid_year(self, extractor):
        """Test population data extraction with invalid year."""
        with pytest.raises(ValueError, match="Invalid year"):
            extractor.get_population_data(year=1800)
    
    @patch('requests.Session.get')
    def test_get_population_data_api_error(self, mock_get, extractor):
        """Test population data extraction with API error."""
        mock_get.side_effect = requests.RequestException("API Error")
        
        with pytest.raises(requests.RequestException):
            extractor.get_population_data(year=2020)
    
    @pytest.mark.integration
    def test_real_api_call(self, extractor):
        """Integration test with real API call."""
        # This test hits the real API - use sparingly
        result = extractor.get_population_data(year=2020)
        
        assert isinstance(result, pd.DataFrame)
        assert not result.empty
        assert all(col in result.columns for col in ['city', 'population'])
```

### Running Tests

```bash
# All tests
make test

# Specific test categories
pytest tests/unit/
pytest tests/integration/
pytest tests/e2e/

# With coverage
pytest --cov=src --cov-report=html

# Parallel execution
pytest -n auto

# Specific test file
pytest tests/unit/test_extractors.py

# Specific test method
pytest tests/unit/test_extractors.py::TestIBGEExtractor::test_initialization
```

## Documentation

### Documentation Requirements

- **Code documentation**: Docstrings for all public functions
- **API documentation**: Automatically generated from docstrings
- **User guides**: How-to guides and tutorials
- **Architecture docs**: System design and decisions

### Docstring Examples

```python
def extract_population_data(
    self, 
    year: int, 
    regions: Optional[List[str]] = None,
    include_metadata: bool = False
) -> pd.DataFrame:
    """Extract population data from IBGE API for specified year and regions.
    
    This method fetches population statistics from the Brazilian Institute 
    of Geography and Statistics (IBGE) API. It supports filtering by regions
    and includes built-in retry logic for reliability.
    
    Args:
        year: The year for which to extract data (1991-present)
        regions: Optional list of region codes (e.g., ['SP', 'RJ']).
                If None, data for all regions will be extracted.
        include_metadata: Whether to include additional metadata columns
                         such as data source and extraction timestamp.
    
    Returns:
        A pandas DataFrame containing population data with columns:
        - region: Region code (e.g., 'SP' for São Paulo)
        - city: City name
        - population: Population count
        - year: Data year
        - metadata: Additional metadata (if include_metadata=True)
    
    Raises:
        ValueError: If the year is outside the supported range (1991-present)
        requests.RequestException: If the API request fails after all retries
        pandas.errors.EmptyDataError: If the API returns no data
    
    Example:
        Extract population data for São Paulo and Rio de Janeiro in 2020:
        
        >>> extractor = IBGEExtractor()
        >>> data = extractor.extract_population_data(
        ...     year=2020, 
        ...     regions=['SP', 'RJ']
        ... )
        >>> print(f"Extracted {len(data)} city records")
        Extracted 645 city records
        
        >>> print(data.head())
           region           city  population  year
        0      SP      São Paulo    12252023  2020
        1      SP       Campinas     1213792  2020
        2      RJ  Rio de Janeiro     6747815  2020
    
    Note:
        This method implements exponential backoff retry logic to handle
        temporary API failures. The maximum number of retries and timeout
        can be configured through the IBGEConfig class.
    """
```

## Issue Reporting

### Before Creating an Issue

1. **Search existing issues** to avoid duplicates
2. **Check documentation** for common solutions
3. **Test with latest version** to ensure issue still exists

### Bug Reports

Include the following information:

- **Environment**: OS, Python version, package versions
- **Steps to reproduce**: Detailed steps that trigger the bug
- **Expected behavior**: What you expected to happen
- **Actual behavior**: What actually happened
- **Error messages**: Full error messages and stack traces
- **Code samples**: Minimal code that reproduces the issue

### Feature Requests

Include the following information:

- **Problem description**: What problem does this solve?
- **Proposed solution**: How should this feature work?
- **Alternatives considered**: What other approaches did you consider?
- **Use case**: Specific scenarios where this would be useful

### Issue Templates

We provide issue templates for:
- Bug reports
- Feature requests
- Documentation improvements
- Questions

## Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools

### Examples
```bash
feat: add SICONV API data extractor

fix(transformer): handle missing population data correctly

docs: update installation instructions for Windows

test: add integration tests for population transformer

chore: update dependencies to latest versions
```

## Release Process

### Version Numbering

We use [Semantic Versioning](https://semver.org/):
- **Major** (X.0.0): Breaking changes
- **Minor** (0.X.0): New features, backward compatible
- **Patch** (0.0.X): Bug fixes, backward compatible

### Release Steps

1. **Update version** in `src/__version__.py`
2. **Update CHANGELOG.md** with new features and fixes
3. **Create release branch**: `git checkout -b release/v1.2.0`
4. **Run final tests**: `make test-all`
5. **Create pull request** to `main`
6. **Tag release** after merge: `git tag v1.2.0`
7. **Create GitHub release** with release notes

## Community

### Getting Help

- **Documentation**: Check our comprehensive docs first
- **Issues**: Search existing issues or create a new one
- **Discussions**: Use GitHub Discussions for questions
- **Email**: Contact maintainers for private matters

### Recognition

Contributors are recognized through:
- **Contributors section** in README
- **Changelog mentions** for significant contributions  
- **GitHub contributor graph**
- **Special thanks** in release notes

---

Thank you for contributing to Public Data Pipeline for Business Insights! 

Your contributions help make data more accessible and useful for everyone.
