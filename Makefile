container:
	docker build --tag puzzle .

run:
	docker run -it --rm -v ${PWD}:/app puzzle /bin/bash

do: container run

install:
	python setup.py build_ext --inplace
	python -m pip install -e .

test: install
	py.test tests/ -vv
