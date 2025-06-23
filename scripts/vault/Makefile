# Root Makefile for managing vault

PROJECTS_DIR := projects
TEMPLATES_DIR := templates/projects
NOTES_DIR := notes
NOTES_TEMPLATE_DIR := templates/notes
DEBUG_TEMPLATE := $(TEMPLATES_DIR)/debug
GIT_DIR := .git

# Find all git projects in $(PROJECTS_DIR)
GIT_PROJECTS := $(shell find $(PROJECTS_DIR) -maxdepth 1 -mindepth 1 -type d -exec test -d "{}/$(GIT_DIR)" \; -print)

.PHONY: init init-projects init-notes help

init: init-projects init-notes  ## Initialize vault: projects and notes

init-projects:  ## Initialize projects by copying debug template
	@echo "Initializing projects..."
	@for proj in $(GIT_PROJECTS); do \
		if [ ! -d "$$proj/debug" ]; then \
			echo "  Copying debug folder to $$proj"; \
			cp -r $(DEBUG_TEMPLATE) "$$proj/debug"; \
		else \
			echo "  Debug folder already exists in $$proj, skipping"; \
		fi \
	done

init-notes:  ## Initialize notes by linking Makefile from templates/notes
	@echo "Initializing notes..."
	@if [ ! -L $(NOTES_DIR)/Makefile ]; then \
		ln -s $(PWD)/$(NOTES_TEMPLATE_DIR)/Makefile $(NOTES_DIR)/Makefile; \
		echo "  Created symlink for notes Makefile"; \
	else \
		echo "  Notes Makefile symlink already exists, skipping"; \
	fi

help:  ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

