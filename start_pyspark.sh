#!/bin/bash

export PYSPARK_PYTHON=/Users/vahid/.virtualenvs/tensorflow/bin/python
export PYSPARK_DRIVER_PYTHON=/Users/vahid/.virtualenvs/tensorflow/bin/jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="notebook --NotebookApp.open_browser=False --NotebookApp.ip='*' --NotebookApp.port=8880"

pyspark "$@"

