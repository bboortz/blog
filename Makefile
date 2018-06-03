site_install:
	( \
		source .venv/bin/activate; \
		pip install -r requirements.txt; \
	)

site_new:
	( \
		source .venv/bin/activate; \
		mkdocs new . \
	)

site_link:
	ln -sf $(CURDIR)/README.md $(CURDIR)/docs/index.md

site_preview: site_link
	( \
		source .venv/bin/activate; \
		mkdocs serve \
	)

site_deploy: site_link
	( \
		source .venv/bin/activate; \
		mkdocs gh-deploy --clean \
	)
