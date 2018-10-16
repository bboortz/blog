site_install:
	( \
		virtualenv .venv; \
		source .venv/bin/activate; \
		pip install -U -r requirements.txt; \
	)

site_new:
	( \
		source .venv/bin/activate; \
		mkdocs new . \
	)

site_preview: 
	( \
		source .venv/bin/activate; \
		mkdocs serve \
	)

site_deploy: 
	( \
		source .venv/bin/activate; \
		mkdocs gh-deploy --clean \
	)

docker_build: 
	( \
		docker build -t benni-mkdocs .; \
	)
