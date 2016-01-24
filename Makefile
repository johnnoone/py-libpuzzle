container:
	docker build --tag puzzle .

run:
	docker run -it --rm -v ${PWD}:/app puzzle /bin/bash

do: container run

compile:
	ERRORIST_DEVELOPMENT_MODE=libpuzzle python setup.py build_ext --inplace

install:
	python -m pip install -e .

test: compile install
	py.test tests/ -vv
