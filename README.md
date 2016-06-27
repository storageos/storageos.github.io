## Instructions for Contributing to the StorageOS documentation

## Staging the site locally (from scratch setup)

The below commands to setup your environment for running GitHub pages locally. Then, any edits you make will be viewable
on a lightweight webserver that runs on your local machine.

This will typically be the fastest way (by far) to iterate on docs changes and see them staged, once you get this set up, but it does involve several install steps that take awhile to complete, and makes system-wide modifications.

Install Ruby 2.2 or higher. If you're on a Mac, follow [these instructions](https://gorails.com/setup/osx/). If you're on Linux, run these commands:

    apt-get install software-properties-common
    apt-add-repository ppa:brightbox/ruby-ng
    apt-get install ruby2.2
    apt-get install ruby2.2-dev

Install the GitHub Pages package, which includes Jekyll:

	gem install github-pages

Clone our site:

	git clone https://github.com/storageos/storageos.github.io.git

Make any changes you want. Then, to see your changes locally:

	cd storageos.github.io
	jekyll serve

Your copy of the site will then be viewable at: [http://localhost:4000](http://localhost:4000)
(or wherever Jekyll tells you).

The above instructions work on Mac and Linux.
[These instructions](https://martinbuberl.com/blog/setup-jekyll-on-windows-and-host-it-on-github-pages/) are for Windows users.
