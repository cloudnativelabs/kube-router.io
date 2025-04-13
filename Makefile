IN_DOCKER_GROUP=$(filter docker,$(shell groups))
DOCKER=$(if $(or $(IN_DOCKER_GROUP),$(IS_ROOT),$(OSX)),docker,sudo docker)
CURRENT_UID=$(shell id -u)
CURRENT_GID=$(shell id -g)
RUBY_VERSION=3.3
JEKYLL_CLI=jekyll-docker:latest

all: build_container build_jekyll build_mkdocs cleanup_docs

build_container:
	$(DOCKER) build --build-arg RUBY_VERSION=$(RUBY_VERSION) -t jekyll-docker:latest -f Dockerfile .

build_jekyll:
	$(DOCKER) run -v $(PWD):/srv/jekyll $(JEKYLL_CLI) \
		sh -c \
		"bundle exec jekyll build"

checkout_kube_router_docs:
	$(eval kube_checkout := $(shell mktemp -d))
	git clone https://github.com/cloudnativelabs/kube-router.git $(kube_checkout)
	cp -r $(kube_checkout)/docs kube-router
	@mkdir -p kube-router/docs/manifests
	cp $(kube_checkout)/daemonset/* kube-router/docs/manifests
	cp $(kube_checkout)/CONTRIBUTING.md kube-router/docs
	cp $(kube_checkout)/RELEASE.md kube-router/docs
	# Manual fixups of broken links
	# Fix links to daemonset files
	sed -i 's;\.\./daemonset;manifests;' kube-router/docs/dsr.md
	sed -i 's;\.\./daemonset;manifests;' kube-router/docs/user-guide.md
	sed -i 's;\.\./daemonset;manifests;' kube-router/docs/RELEASE.md
	# Fix links to CONTRIBUTING.md
	sed -i 's;/CONTRIBUTING.md;/docs/CONTRIBUTING/;' kube-router/docs/index.md
	sed -i 's;/CONTRIBUTING.md;/docs/CONTRIBUTING/;' kube-router/docs/developing.md
	# Fix links to RELEASE.md
	sed -i 's;/RELEASE.md;/docs/RELEASE/;' kube-router/docs/developing.md
	# Fix links to Makefile
	sed -i 's;\[Makefile\](/Makefile);Makefile;' kube-router/docs/developing.md
	sed -i 's;\[Makefile\](Makefile);Makefile;' kube-router/docs/RELEASE.md
	# Fix links inside CONTRIBUTING.md
	sed -i 's;/developing.md;/developing/;' kube-router/docs/CONTRIBUTING.md
	sed -i 's;/user-guide.md;/user-guide/;' kube-router/docs/CONTRIBUTING.md
	# Remove links to workflows, go mods, and Daemonset folder from RELEASE.md
	sed -i 's;\[Github Workflow\](\.github/workflow/ci.yml);Github Workflow;' kube-router/docs/RELEASE.md
	sed -i 's;\[go.mod\](go.mod);go.mod;' kube-router/docs/RELEASE.md
	sed -i 's;\[Daemonset\](daemonset);daemonset;' kube-router/docs/RELEASE.md
	rm -rf $(kube_checkout)

build_mkdocs: checkout_kube_router_docs
	$(DOCKER) run -v $(PWD):/docs squidfunk/mkdocs-material \
		build --site-dir /docs/kube-router -d /docs/docs --strict
	sudo chown -R $(CURRENT_UID):$(CURRENT_GID) .

cleanup_docs:
	rm -rf kube-router/docs

serve: build_container build_mkdocs cleanup_docs
	$(DOCKER) run -ti -v $(PWD):/srv/jekyll --rm --publish 4000:4000 $(JEKYLL_CLI) \
		sh -c \
		"bundle exec jekyll serve -H 0.0.0.0"

update-gems:
	$(DOCKER) run -ti -v $(PWD):/build --rm -w /build ruby:$(RUBY_VERSION) bundle update

#all:
#	jekyll build
#	mkdocs build --site-dir kube-router/docs -d _site/docs

.PHONY: build_container build_jekyll build_mkdocs checkout_kube_router_docs cleanup_docs serve update-gems

.DEFAULT: all
