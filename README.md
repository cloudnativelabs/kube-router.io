# Website for kube-router.io

Source for website kube-router.io

## Components

This site uses Jekyll as a static site render and it uses mkdocs to convert
Markdown from the kube-router site to a read-the-docs format.

### Jekyll

Jekyll is particularly useful in its ability to serve the landing page and other
static assets within the project.

All of the directories prefixed with an `_` (e.g. `_layouts`, `_includes`, etc.)
belong to Jekyll and are used for configuring the Jekyll site.

The primary Jekyll configuration sits in `_config.yml`.

`_layouts/page.html` is what forms the primary landing page and is a bunch of includes
from `_includes`

More information on Jekyll layout can be found here: [Jekyll Structure](https://jekyllrb.com/docs/structure/)

### mkdocs

mkdocs on the other hand owns everything under the `/docs` HTTP path and is
more of the standard mkdocs format that is familiar to Python projects everywhere.

Everything in the `/docs` directory belongs to mkdocs and is configured with
`mkdocs.yml`.

More information on configuring mkdocs can be found here:
[mkdocs Configuration](https://www.mkdocs.org/user-guide/configuration)

## Updating Ruby Gems

In order to keep ruby up to date (which is what Jekyll runs on) you need
to occasionally update the gems for the project. This can be done by running:

```sh
make update-gems
```

Note, it is also good to check and update the version of ruby used for this
from time to time. This can be done via the Makefile.

## Updating the Website

All that is needed to update the website and bring it current with the
documentation on the main kube-router project is to run:

```sh
make
```

All steps are run in containers so you don't need to download Ruby/Python/Jekyll/mkdocs/etc.

This will perform the following:

* Jekyll build
* Fetches current version of kube-router project to a place mkdocs can work on it
* Resolves some relative links that are otherwise broken
* Creates /docs based on mkdocs rendering

## Testing the Site Locally

In order to test site changes locally, run: `make serve`

Then you can navigate the site at: http://localhost:4000
