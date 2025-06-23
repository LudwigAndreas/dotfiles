# Root Makefile for managing vault

# Variables
PROJECTS_DIR := projects
TEMPLATES_DIR := templates/projects
DEBUG_TEMPLATE := $(TEMPLATES_DIR)/debug
GIT_DIR := .git

# Find all git projects in $(PROJECTS_DIR)
GIT_PROJECTS := $(shell find $(PROJECTS_DIR) -maxdepth 1 -mindepth 1 -type d -exec test -d "{}/$(GIT_DIR)" \; -print)

# Default goal
.DEFAULT_GOAL := help

# Targets
.PHONY: init help

init:  ## Initialize vault projects by copying debug template
	@echo "Initializing vault projects..."
	@for proj in $(GIT_PROJECTS); do \
		if [ ! -d "$$proj/debug" ]; then \
			echo "Copying debug template to $$proj..."; \
			cp -r $(DEBUG_TEMPLATE) "$$proj/"; \
		else \
			echo "Debug template already exists in $$proj, skipping..."; \
		fi \
	done
	@echo "Initialization complete."

help:  ## Show this help message
	@echo "Vault Makefile - available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

