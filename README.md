# Website for kube-router.io
Source for website kube-router.io

# Components
This site uses Jekyll as a static site render and it uses mkdocs to convert
Markdown from the kube-router site to a read-the-docs format.

# Updating the Website

All that is needed to update the website and bring it current with the
documentation on the main kube-router project is to run:
```sh
make
```

All steps are run in containers so you don't need to download
Ruby/Python/Jekyll/mkdocs/etc.

This will perform the following:
* Jekyll build
* Fetches current version of kube-router project to a place mkdocs can work on
  it
* Resolves some relative links that are otherwise broken
* Creates /docs based on mkdocs rendering

# Testing the Site Locally

In order to test site changes locally, run: `make serve`

Then you can navigate the site at: http://localhost:4000
