all:
	jekyll build
	mkdocs build --site-dir kube-router/docs -d _site/docs
