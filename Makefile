VERSION := $(shell ./setup.py --version)

container:
	docker build --tag puzzle .

run:
	docker run -it --rm -v ${PWD}:/app puzzle /bin/bash

serve: container run

compile:
	ERRORIST_DEVELOPMENT_MODE=libpuzzle python setup.py build_ext --inplace

install:
	python -m pip install -e .

test: compile install
	py.test tests/ -vv

publish:
	# python setup.py build_ext --inplace
	python setup.py sdist
	twine upload dist/libpuzzle-${VERSION}.*

.PHONY: container run serve compile install test publish
