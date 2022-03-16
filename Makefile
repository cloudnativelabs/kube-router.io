IN_DOCKER_GROUP=$(filter docker,$(shell groups))
DOCKER=$(if $(or $(IN_DOCKER_GROUP),$(IS_ROOT),$(OSX)),docker,sudo docker)
CURRENT_UID=$(shell id -u)
CURRENT_GID=$(shell id -g)

all: build_jekyll build_mkdocs cleanup_docs

build_jekyll:
	$(DOCKER) run -v $(PWD):/srv/jekyll jekyll/builder \
		sh -c \
		"jekyll build"

checkout_kube_router_docs:
	$(eval kube_checkout := $(shell mktemp -d))
	git clone https://github.com/cloudnativelabs/kube-router.git $(kube_checkout)
	cp -r $(kube_checkout)/docs kube-router
	@mkdir -p kube-router/docs/manifests
	cp $(kube_checkout)/daemonset/* kube-router/docs/manifests
	sed -i 's;\.\./daemonset;manifests;' kube-router/docs/dsr.md
	sed -i 's;\.\./daemonset;manifests;' kube-router/docs/user-guide.md
	rm -rf $(kube_checkout)

build_mkdocs: checkout_kube_router_docs
	$(DOCKER) run -v $(PWD):/docs squidfunk/mkdocs-material \
		build --site-dir /docs/kube-router -d /docs/docs
	sudo chown -R $(CURRENT_UID):$(CURRENT_GID) .

cleanup_docs:
	rm -rf kube-router/docs

serve: build_mkdocs cleanup_docs
	$(DOCKER) run -ti -v $(PWD):/srv/jekyll --rm --publish [::1]:4000:4000 jekyll/builder jekyll serve

#all:
#	jekyll build
#	mkdocs build --site-dir kube-router/docs -d _site/docs

.PHONY: build_jekyll build_mkdocs checkout_kube_router_docs cleanup_docs serve

.DEFAULT: all
