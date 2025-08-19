"""Basic tests for the package."""

import sys
from pathlib import Path

# Adicionar src ao path
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

from public_data_pipeline import __version__


def test_version():
    """Test version is defined."""
    assert __version__ == "1.0.0"


def test_package_import():
    """Test package can be imported."""
    import public_data_pipeline
    assert public_data_pipeline is not None
