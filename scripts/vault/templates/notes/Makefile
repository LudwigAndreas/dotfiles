# Makefile for managing notes


# Variables
NOTES_DIR := .
TEMPLATES_DIR := ../templates/notes
TYPE ?= daily

# Define date format based on TYPE
ifeq ($(TYPE),daily)
	DATE_FORMAT := +%Y-%m-%d
endif
ifeq ($(TYPE),weekly)
	# ISO week number with year, e.g., 2025-W25
	DATE_FORMAT := +%G-W%V
endif

DATE := $(shell date $(DATE_FORMAT))
TEMPLATE := $(TEMPLATES_DIR)/$(TYPE).md
NOTE_FILE := $(NOTES_DIR)/$(TYPE)/$(DATE).md

.PHONY: note help

note: $(NOTE_FILE)  ## Create a note of type $(TYPE) from template

$(NOTE_FILE): $(TEMPLATE)
	@echo "Creating $(TYPE) note: $(NOTE_FILE)"
	@mkdir -p $(dir $(NOTE_FILE))
	@cp $(TEMPLATE) $(NOTE_FILE)

help:  ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %]()]()*

