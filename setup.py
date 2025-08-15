#!/usr/bin/env python3
"""
Setup configuration for Public Data Pipeline for Business Insights.

This file contains the packaging and installation configuration for the
Public Data Pipeline project. It defines dependencies, entry points,
and metadata required for distribution.
"""

import os
import sys
from pathlib import Path
from typing import List

from setuptools import find_packages, setup

# ==============================================================================
# PACKAGE METADATA
# ==============================================================================
NAME = "public-data-pipeline"
DESCRIPTION = "A comprehensive ETL pipeline for Brazilian public data analysis"
URL = "https://github.com/bellDataSc/Public-Data-Pipeline-for-Business-Insights"
AUTHOR = "Bel"
AUTHOR_EMAIL = "bel@datasciencegovbr.com"
REQUIRES_PYTHON = ">=3.8.0"

# ==============================================================================
# PACKAGE PATHS
# ==============================================================================
HERE = Path(__file__).parent
SRC_DIR = HERE / "src"

# ==============================================================================
# VERSION MANAGEMENT
# ==============================================================================
def get_version() -> str:
    """
    Retrieve version from version file.
    
    Returns:
        str: Version string in format 'X.Y.Z'
        
    Raises:
        RuntimeError: If version file cannot be found or parsed
    """
    version_file = SRC_DIR / "public_data_pipeline" / "__version__.py"
    
    if not version_file.exists():
        raise RuntimeError(f"Version file not found: {version_file}")
    
    version_info = {}
    with open(version_file, encoding="utf-8") as f:
        exec(f.read(), version_info)
    
    if "__version__" not in version_info:
        raise RuntimeError("Version information not found in version file")
    
    return version_info["__version__"]

# ==============================================================================
# LONG DESCRIPTION
# ==============================================================================
def get_long_description() -> str:
    """
    Read long description from README file.
    
    Returns:
        str: Content of README.md file
    """
    readme_file = HERE / "README.md"
    
    if readme_file.exists():
        with open(readme_file, encoding="utf-8") as f:
            return f.read()
    
    return DESCRIPTION

# ==============================================================================
# REQUIREMENTS MANAGEMENT
# ==============================================================================
def load_requirements(filename: str) -> List[str]:
    """
    Load requirements from requirements file.
    
    Args:
        filename: Name of requirements file
        
    Returns:
        List of requirement strings
    """
    requirements_file = HERE / filename
    
    if not requirements_file.exists():
        return []
    
    requirements = []
    with open(requirements_file, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            # Skip empty lines, comments, and -r references
            if line and not line.startswith("#") and not line.startswith("-r"):
                requirements.append(line)
    
    return requirements

def get_install_requires() -> List[str]:
    """Get production dependencies."""
    return load_requirements("requirements.txt")

def get_extras_require() -> dict:
    """Get optional dependencies organized by category."""
    return {
        # Development dependencies
        "dev": load_requirements("requirements-dev.txt"),
        
        # Testing dependencies
        "test": [
            "pytest>=7.3.0",
            "pytest-cov>=4.1.0",
            "pytest-xdist>=3.3.0",
            "pytest-mock>=3.10.0",
            "factory-boy>=3.2.0",
            "faker>=18.0.0",
        ],
        
        # Documentation dependencies
        "docs": [
            "mkdocs>=1.4.0",
            "mkdocs-material>=9.1.0",
            "sphinx>=6.2.0",
            "sphinx-rtd-theme>=1.2.0",
        ],
        
        # Visualization dependencies
        "viz": [
            "streamlit>=1.22.0",
            "plotly>=5.14.0",
            "matplotlib>=3.7.0",
            "seaborn>=0.12.0",
        ],
        
        # Jupyter dependencies
        "jupyter": [
            "jupyter>=1.0.0",
            "jupyterlab>=4.0.0",
            "ipykernel>=6.23.0",
            "ipywidgets>=8.0.0",
        ],
        
        # Cloud service dependencies
        "gcp": [
            "google-cloud-bigquery>=3.10.0",
            "google-cloud-storage>=2.8.0",
            "google-auth>=2.17.0",
        ],
        
        "aws": [
            "boto3>=1.26.0",
            "s3fs>=2023.5.0",
        ],
        
        # Performance dependencies
        "performance": [
            "cython>=0.29.0",
            "numba>=0.57.0",
        ],
        
        # All optional dependencies
        "all": [],  # Will be populated below
    }

# ==============================================================================
# CLASSIFIERS
# ==============================================================================
CLASSIFIERS = [
    # Development status
    "Development Status :: 4 - Beta",
    
    # Intended audience
    "Intended Audience :: Developers",
    "Intended Audience :: Science/Research",
    "Intended Audience :: Government",
    "Intended Audience :: Information Technology",
    
    # License
    "License :: OSI Approved :: MIT License",
    
    # Natural language
    "Natural Language :: English",
    "Natural Language :: Portuguese (Brazilian)",
    
    # Operating systems
    "Operating System :: OS Independent",
    "Operating System :: POSIX",
    "Operating System :: Microsoft :: Windows",
    "Operating System :: MacOS",
    
    # Programming language
    "Programming Language :: Python",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.8",
    "Programming Language :: Python :: 3.9",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: Implementation :: CPython",
    "Programming Language :: Python :: Implementation :: PyPy",
    
    # Topics
    "Topic :: Scientific/Engineering",
    "Topic :: Scientific/Engineering :: Information Analysis",
    "Topic :: Software Development :: Libraries :: Python Modules",
    "Topic :: Database",
    "Topic :: Office/Business",
    "Topic :: Internet :: WWW/HTTP :: Dynamic Content",
    
    # Environment
    "Environment :: Console",
    "Environment :: Web Environment",
    
    # Framework
    "Framework :: FastAPI",
    "Framework :: Jupyter",
    
    # Typing
    "Typing :: Typed",
]

# ==============================================================================
# KEYWORDS
# ==============================================================================
KEYWORDS = [
    "data-pipeline",
    "etl",
    "data-engineering",
    "public-data",
    "brazil",
    "ibge",
    "business-intelligence",
    "analytics",
    "government-data",
    "streamlit",
    "bigquery",
    "postgresql",
    "data-science",
    "automation",
]

# ==============================================================================
# ENTRY POINTS
# ==============================================================================
ENTRY_POINTS = {
    "console_scripts": [
        "data-pipeline=src.cli.main:main",
        "dp=src.cli.main:main",
        "public-data-pipeline=src.cli.main:main",
    ],
}

# ==============================================================================
# PACKAGE DATA
# ==============================================================================
PACKAGE_DATA = {
    "public_data_pipeline": [
        "config/*.yaml",
        "config/*.yml", 
        "config/*.json",
        "templates/*.html",
        "templates/*.jinja2",
        "static/*",
        "sql/*.sql",
        "data/schemas/*.json",
    ]
}

# ==============================================================================
# SETUP CONFIGURATION
# ==============================================================================
def main():
    """Main setup function."""
    
    # Get extras requirements and populate "all"
    extras_require = get_extras_require()
    all_extras = set()
    for deps in extras_require.values():
        if isinstance(deps, list):
            all_extras.update(deps)
    extras_require["all"] = list(all_extras)
    
    setup(
        # Basic package information
        name=NAME,
        version=get_version(),
        description=DESCRIPTION,
        long_description=get_long_description(),
        long_description_content_type="text/markdown",
        
        # Author information
        author=AUTHOR,
        author_email=AUTHOR_EMAIL,
        maintainer=AUTHOR,
        maintainer_email=AUTHOR_EMAIL,
        
        # URLs
        url=URL,
        project_urls={
            "Documentation": f"{URL}#readme",
            "Source": URL,
            "Tracker": f"{URL}/issues",
            "Changelog": f"{URL}/blob/main/CHANGELOG.md",
            "Discussions": f"{URL}/discussions",
            "CI/CD": f"{URL}/actions",
        },
        
        # Package discovery
        packages=find_packages(where="src"),
        package_dir={"": "src"},
        package_data=PACKAGE_DATA,
        include_package_data=True,
        
        # Requirements
        python_requires=REQUIRES_PYTHON,
        install_requires=get_install_requires(),
        extras_require=extras_require,
        
        # Metadata
        license="MIT",
        license_files=["LICENSE"],
        classifiers=CLASSIFIERS,
        keywords=" ".join(KEYWORDS),
        
        # Entry points
        entry_points=ENTRY_POINTS,
        
        # Additional options
        zip_safe=False,
        platforms=["any"],
        
        # Test suite
        test_suite="tests",
        tests_require=extras_require["test"],
    )

    # Post-installation message
    print("\n" + "="*60)
    print(f" {NAME} v{get_version()} installed successfully!")
    print("="*60)
    print("\n Quick Start:")
    print("  1. Configure your environment:")
    print("     cp .env.example .env")
    print("     # Edit .env with your settings")
    print()
    print("  2. Initialize the database:")
    print("     data-pipeline db init")
    print()
    print("  3. Run your first pipeline:")
    print("     data-pipeline run --help")
    print()
    print("Links:")
    print(f" Documentation: {URL}")
    print(f" Issues: {URL}/issues")
    print(f" Discussions: {URL}/discussions")
    print()
    print("If you find this project useful, please give it a star!")
    print("Contributions are welcome! See CONTRIBUTING.md")
    print("="*60 + "\n")

if __name__ == "__main__":
    main()