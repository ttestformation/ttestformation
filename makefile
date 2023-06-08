.ONESHELL: 

# Signifies our desired python version
PY = python3

# .PHONY defines parts of the makefile that are not dependant on any specific file
# This is most often used to store functions
.PHONY = help clean setup


# define the name of the virtual environment directory
# used only to create virtual environment
VENV     = .venv
VENV_BIN = $(VENV)/bin

# define Makefile's current directory
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

PY3 := $(shell echo `which python3.9`)
PY   = $(ROOT_DIR)/$(VENV)/bin/python3


# Defines the default target that `make` will to try to make, or in the case of a phony target, execute the specified commands
# This target is executed whenever we just type `make`
.DEFAULT_GOAL = help

.SILENT: setup clean $(VENV) $(VENV_BIN)/activate

# The @ makes sure that the command itself isn't echoed in the terminal
help: 
	@echo "install   - prepare the environment"
	@echo "clean     - remove the virtual environment"

$(VENV_BIN)/activate: 
	test -d $(VENV) || $(PY3) -m venv $(VENV)

$(VENV): $(VENV_BIN)/activate
	touch $(VENV)

setup: $(VENV) backend/requirements.txt
	$(VENV_BIN)/pip install --upgrade "pip>=23.1.2" --quiet
	$(VENV_BIN)/pip install -r backend/requirements.txt --quiet

@setup: setup

install: @setup
	. $(VENV_BIN)/activate
	cd backend
	export LD_LIBRARY_PATH=/usr/local/lib
	$(PY) manage.py migrate
	$(PY) manage.py createsuperuser
	$(PY) manage.py runserver

clean: 
	rm -rf $(VENV)