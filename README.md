## Instructions for Contributing to the StorageOS documentation

These instructions work on Mac, Windows and Linux.

All steps are run from a terminal console.

You will need the following software installed:
- docker (https://www.docker.com/products/overview)
- git (https://git-scm.com/downloads)
- text editor (https://atom.io recommended, with following packages: language-markdown, markdown-preview-plus)

## Staging the site locally (from scratch setup)

Make sure Docker is running (download and install from https://www.docker.com/products/overview).

The below commands to setup your environment for running GitHub pages locally. Then, any edits you make will be viewable
on a lightweight webserver that runs on your local machine.

This will typically be the fastest way (by far) to iterate on docs changes and see them staged.

Clone this repository:

  git clone ssh://git@code.storageos.net:7999/pub/docs.git

Run a local copy:

	make serve

Your copy of the site will then be viewable at: [http://localhost:4000](http://localhost:4000)
(or wherever Jekyll tells you).

You may edit the files while the server is running, and pages will update whenever they are saved.

## Publish to docs.storageos.com (password-protected)

The password-protected documentation site currently runs on the downloads server (Ubuntu running on DigitalOcean).  This site is used by closed-beta users.

To update the site, run:

  make publish

## Publish to GitHub Pages (not password-protected)

:warning: This is not currently in use, as we do not wish to publish documentation until we have patents in place.

Add git remote:

  git remote add public git@github.com:storageos/storageos.github.io.git

Push changes:

  git push public master
