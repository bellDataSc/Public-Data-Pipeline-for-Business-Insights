# ==============================================================================
# MAKEFILE FOR PUBLIC DATA PIPELINE
# ==============================================================================
# Automation commands for development, testing, and deployment

.PHONY: help install install-dev clean lint test build docker-up docker-down docs

# Default target
.DEFAULT_GOAL := help

# ==============================================================================
# HELP AND DOCUMENTATION
# ==============================================================================
help: ## Show this help message
	@echo "Public Data Pipeline for Business Insights - Available Commands"
	@echo "=================================================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo "  make setup          # Complete development setup"
	@echo "  make test           # Run all tests"
	@echo "  make docker-up      # Start all services with Docker"
	@echo "  make clean          # Clean temporary files"

# ==============================================================================
# ENVIRONMENT AND INSTALLATION
# ==============================================================================
setup: ## Complete development environment setup
	@echo " Setting up development environment..."
	python -m venv venv
	@echo " Virtual environment created. Activate with:"
	@echo "   Linux/macOS: source venv/bin/activate"
	@echo "   Windows: venv\\Scripts\\activate"
	@echo "  Please activate the virtual environment and run 'make install-dev'"

install: ## Install production dependencies
	@echo "Installing production dependencies..."
	pip install --upgrade pip
	pip install -r requirements.txt
	@echo "Production dependencies installed"

install-dev: ## Install development dependencies
	@echo "Installing development dependencies..."
	pip install --upgrade pip
	pip install -r requirements-dev.txt
	@echo "Development dependencies installed"

install-hooks: ## Install pre-commit hooks
	@echo "🪝 Installing pre-commit hooks..."
	pre-commit install
	pre-commit install --hook-type commit-msg
	@echo "Pre-commit hooks installed"

# ==============================================================================
# CODE QUALITY AND FORMATTING
# ==============================================================================
format: ## Format code with black and isort
	@echo "Formatting code..."
	black src/ tests/ scripts/
	isort src/ tests/ scripts/
	@echo "Code formatted"

format-check: ## Check code formatting without making changes
	@echo "Checking code formatting..."
	black --check --diff src/ tests/ scripts/
	isort --check-only --diff src/ tests/ scripts/
	@echo "Code formatting check completed"

lint: ## Run all linting tools
	@echo "Running linting tools..."
	flake8 src/ tests/ scripts/
	mypy src/
	@echo "Linting completed"

lint-fix: ## Run linting with auto-fix where possible
	@echo "Running linting with auto-fix..."
	autopep8 --in-place --recursive src/ tests/ scripts/
	@echo "Auto-fix completed"

security: ## Run security checks
	@echo "Running security checks..."
	bandit -r src/
	safety check
	pip-audit
	@echo "Security checks completed"

# ==============================================================================
# TESTING
# ==============================================================================
test: ## Run all tests
	@echo "Running all tests..."
	pytest tests/ -v
	@echo "All tests completed"

test-unit: ## Run unit tests only
	@echo "Running unit tests..."
	pytest tests/unit/ -v
	@echo "Unit tests completed"

test-integration: ## Run integration tests only
	@echo "Running integration tests..."
	pytest tests/integration/ -v
	@echo "Integration tests completed"

test-e2e: ## Run end-to-end tests
	@echo "Running end-to-end tests..."
	pytest tests/e2e/ -v
	@echo "End-to-end tests completed"

test-coverage: ## Run tests with coverage report
	@echo "Running tests with coverage..."
	pytest tests/ --cov=src --cov-report=html --cov-report=term --cov-report=xml
	@echo "Coverage report generated in htmlcov/"
	@echo "Coverage tests completed"

test-watch: ## Run tests in watch mode
	@echo "Running tests in watch mode..."
	ptw tests/ src/ --runner "pytest -v"

benchmark: ## Run performance benchmarks
	@echo "Running benchmarks..."
	pytest tests/ --benchmark-only
	@echo "Benchmarks completed"

# ==============================================================================
# DATABASE OPERATIONS
# ==============================================================================
db-init: ## Initialize database schema
	@echo "Initializing database..."
	python -m src.database.init_db
	@echo "Database initialized"

db-migrate: ## Run database migrations
	@echo "Running database migrations..."
	alembic upgrade head
	@echo "Database migrations completed"

db-reset: ## Reset database (WARNING: destroys all data)
	@echo "Resetting database (this will destroy all data)..."
	@read -p "Are you sure? Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		python -m src.database.reset_db; \
		echo "Database reset completed"; \
	else \
		echo "Database reset cancelled"; \
	fi

db-seed: ## Seed database with sample data
	@echo "Seeding database..."
	python -m src.database.seed_db
	@echo "Database seeded"

# ==============================================================================
# DATA PIPELINE OPERATIONS
# ==============================================================================
pipeline-run: ## Run the complete data pipeline
	@echo "Running complete data pipeline..."
	python -m src.pipeline.main
	@echo "Pipeline completed"

pipeline-extract: ## Run data extraction only
	@echo "Running data extraction..."
	python -m src.extractors.main
	@echo "Data extraction completed"

pipeline-transform: ## Run data transformation only
	@echo "Running data transformation..."
	python -m src.transformers.main
	@echo "Data transformation completed"

pipeline-load: ## Run data loading only
	@echo "Running data loading..."
	python -m src.loaders.main
	@echo "Data loading completed"

# ==============================================================================
# DOCKER OPERATIONS
# ==============================================================================
docker-build: ## Build Docker images
	@echo "Building Docker images..."
	docker-compose build
	@echo "Docker images built"

docker-up: ## Start all services with Docker Compose
	@echo "Starting services..."
	docker-compose up -d
	@echo "Services started"
	@echo "Available services:"
	@echo "   - API: http://localhost:8000"
	@echo "   - Dashboard: http://localhost:8501"
	@echo "   - Database: localhost:5432"
	@echo "   - Redis: localhost:6379"

docker-up-dev: ## Start development services
	@echo "Starting development services..."
	docker-compose --profile development up -d
	@echo "Development services started"
	@echo "Additional services:"
	@echo "   - Jupyter: http://localhost:8888"
	@echo "   - PgAdmin: http://localhost:8080"

docker-up-monitoring: ## Start monitoring services
	@echo "Starting monitoring services..."
	docker-compose --profile monitoring up -d
	@echo "Monitoring services started"
	@echo "Monitoring services:"
	@echo "   - Prometheus: http://localhost:9090"
	@echo "   - Grafana: http://localhost:3000"

docker-down: ## Stop all services
	@echo "Stopping services..."
	docker-compose down
	@echo "Services stopped"

docker-down-volumes: ## Stop services and remove volumes
	@echo "Stopping services and removing volumes..."
	docker-compose down -v
	@echo "Services stopped and volumes removed"

docker-logs: ## Show logs from all services
	docker-compose logs -f

docker-shell: ## Open shell in main application container
	docker-compose exec app bash

docker-clean: ## Clean up Docker resources
	@echo "Cleaning up Docker resources..."
	docker-compose down --rmi all --volumes --remove-orphans
	docker system prune -f
	@echo "Docker cleanup completed"

# ==============================================================================
# APPLICATION SERVICES
# ==============================================================================
api: ## Start API server locally
	@echo "Starting API server..."
	python -m src.api.main

dashboard: ## Start Streamlit dashboard locally
	@echo "Starting dashboard..."
	streamlit run src/dashboard/main.py

jupyter: ## Start Jupyter Lab locally
	@echo "Starting Jupyter Lab..."
	jupyter lab --ip=0.0.0.0 --port=8888 --no-browser

worker: ## Start Celery worker
	@echo "Starting Celery worker..."
	celery -A src.tasks.celery worker --loglevel=info

flower: ## Start Celery Flower monitoring
	@echo "Starting Flower..."
	celery -A src.tasks.celery flower

# ==============================================================================
# DOCUMENTATION
# ==============================================================================
docs: ## Build documentation
	@echo "Building documentation..."
	mkdocs build
	@echo "Documentation built in site/"

docs-serve: ## Serve documentation locally
	@echo "Serving documentation..."
	mkdocs serve
	@echo "Documentation available at: http://localhost:8000"

docs-deploy: ## Deploy documentation to GitHub Pages
	@echo "Deploying documentation..."
	mkdocs gh-deploy --force
	@echo "Documentation deployed"

# ==============================================================================
# DATA OPERATIONS
# ==============================================================================
data-download: ## Download sample datasets
	@echo "Downloading sample data..."
	python scripts/download_sample_data.py
	@echo "Sample data downloaded"

data-validate: ## Validate data quality
	@echo "Running data validation..."
	python -m src.validators.main
	@echo "Data validation completed"

data-backup: ## Backup data directory
	@echo "Creating data backup..."
	tar -czf backups/data_backup_$(shell date +%Y%m%d_%H%M%S).tar.gz data/
	@echo "Data backup created"

data-clean: ## Clean temporary data files
	@echo "Cleaning temporary data files..."
	find data/temp -type f -name "*.tmp" -delete
	find data/temp -type f -name "*.cache" -delete
	@echo "Temporary data files cleaned"

# ==============================================================================
# DEVELOPMENT UTILITIES
# ==============================================================================
clean: ## Clean temporary files and caches
	@echo "Cleaning temporary files..."
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type f -name ".coverage" -delete
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
	find . -type d -name "htmlcov" -exec rm -rf {} +
	@echo "Cleanup completed"

env-create: ## Create .env file from template
	@echo "Creating .env file..."
	cp .env.example .env
	@echo ".env file created. Please edit with your configurations."

env-check: ## Check if required environment variables are set
	@echo "Checking environment variables..."
	python scripts/check_env.py
	@echo "Environment check completed"

deps-check: ## Check for outdated dependencies
	@echo "Checking for outdated dependencies..."
	pip list --outdated
	@echo "Dependency check completed"

deps-update: ## Update dependencies (interactive)
	@echo "Updating dependencies..."
	pip-review --local --interactive

# ==============================================================================
# CI/CD AND DEPLOYMENT
# ==============================================================================
ci-test: ## Run CI test suite
	@echo "Running CI test suite..."
	$(MAKE) format-check
	$(MAKE) lint
	$(MAKE) security
	$(MAKE) test-coverage
	@echo "CI tests completed"

pre-commit-all: ## Run pre-commit hooks on all files
	@echo "🪝 Running pre-commit on all files..."
	pre-commit run --all-files
	@echo "Pre-commit completed"

release-patch: ## Create patch release
	@echo "Creating patch release..."
	bump2version patch
	@echo "Patch release created"

release-minor: ## Create minor release
	@echo "Creating minor release..."
	bump2version minor
	@echo "Minor release created"

release-major: ## Create major release
	@echo "Creating major release..."
	bump2version major
	@echo "Major release created"

# ==============================================================================
# MONITORING AND LOGGING
# ==============================================================================
logs: ## Show application logs
	@echo "Showing logs..."
	tail -f logs/app.log

logs-error: ## Show error logs only
	@echo "Showing error logs..."
	tail -f logs/app.log | grep ERROR

monitor: ## Start monitoring dashboard
	@echo "Starting monitoring..."
	$(MAKE) docker-up-monitoring

# ==============================================================================
# PERFORMANCE AND PROFILING
# ==============================================================================
profile: ## Run performance profiling
	@echo "Running performance profiling..."
	python -m cProfile -o profile_output.prof -m src.pipeline.main
	@echo "Profile saved to profile_output.prof"
	@echo "View with: snakeviz profile_output.prof"

load-test: ## Run load tests
	@echo "Running load tests..."
	locust -f tests/load/locustfile.py --host=http://localhost:8000

# ==============================================================================
# ALL-IN-ONE COMMANDS
# ==============================================================================
dev-setup: ## Complete development setup
	@echo "Complete development setup..."
	$(MAKE) setup
	@echo "Please activate virtual environment and run:"
	@echo "make install-dev && make install-hooks && make env-create"

full-test: ## Run complete test suite
	@echo "Running complete test suite..."
	$(MAKE) format-check
	$(MAKE) lint
	$(MAKE) security
	$(MAKE) test-coverage
	@echo "Complete test suite finished"

dev-start: ## Start development environment
	@echo "Starting development environment..."
	$(MAKE) docker-up-dev
	$(MAKE) data-download
	@echo "Development environment ready!"

prod-deploy: ## Deploy to production
	@echo "Deploying to production..."
	$(MAKE) ci-test
	$(MAKE) docker-build
	$(MAKE) docker-up
	@echo "Production deployment completed"

# ==============================================================================
# PROJECT INFO
# ==============================================================================
info: ## Show project information
	@echo "Public Data Pipeline for Business Insights"
	@echo "=========================================="
	@echo "Author: Bel (bellDataSc)"
	@echo "Python: $(shell python --version)"
	@echo "Docker: $(shell docker --version 2>/dev/null || echo 'Not installed')"
	@echo "Docker Compose: $(shell docker-compose --version 2>/dev/null || echo 'Not installed')"
	@echo ""
	@echo "Project Structure:"
	@echo "├── src/          # Source code"
	@echo "├── tests/        # Test files"
	@echo "├── data/         # Data files"
	@echo "├── docs/         # Documentation"
	@echo "├── scripts/      # Utility scripts"
	@echo "└── config/       # Configuration files"