"""Basic tests to ensure the package works."""

import pytest
from src.public_data_pipeline import __version__

def test_version():
    """Test that version is defined."""
    assert __version__.__version__ is not None

def test_imports():
    """Test that basic imports work."""
    from src.public_data_pipeline.extractors import ibge_extractor
    assert ibge_extractor is not None