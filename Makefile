SHELL=/bin/bash

test_deps:
	python -m pip install .[test]

lint:
	for dir in $$(dirname */__init__.py); do ruff $$dir; done
	for script in scripts/*[^cmd]; do if grep -q python $$script; then ruff $$script; fi; done
	mypy --install-types --non-interactive --check-untyped-defs argcomplete

test:
	coverage run --source=argcomplete --omit=argcomplete/packages/_shlex.py ./test/test.py -v

init_docs:
	cd docs; sphinx-quickstart

docs:
	sphinx-build docs docs/html

install: clean
	python -m pip install build
	python -m build
	python -m pip install --upgrade $$(echo dist/*.whl)[test]

clean:
	-rm -rf build dist
	-rm -rf *.egg-info

.PHONY: test_deps lint test docs install clean

include common.mk
