## Instructions for Contributing to the StorageOS documentation

These instructions should work on Mac, Windows and Linux.

All steps are run from a terminal console.

You will need the following software installed:
- docker (https://www.docker.com/products/overview)
- git (https://git-scm.com/downloads)
- text editor (https://atom.io recommended, with following packages: language-markdown, markdown-preview-plus)
- Dapper (http://github.com/rancher/dapper)


## Staging the site locally (from scratch setup)

Make sure Docker is running (download and install from https://www.docker.com/products/overview).

The below commands to setup your environment for running GitHub pages locally. Then, any edits you make will be viewable
on a lightweight webserver that runs on your local machine.

This will typically be the fastest way (by far) to iterate on docs changes and see them staged.

Fork the repository on github and clone it:

```
git clone https://github.com/fork/storageos.github.io.git
```

Run a local copy:

```
make serve
```

Your copy of the site will then be viewable at: [http://localhost:4000](http://localhost:4000)
(or wherever Jekyll tells you).

You may edit the files while the server is running, and pages will update whenever they are saved.

## Contributing

All contributions welcome, from major updates to typos.  If you're unsure, jump into our Slack channel to discuss.
When done, please submit PR from your fork's master branch to `storageos/storageos.github.io` master branch, make sure to pull the latest from the original repo before committing your contribution.

## Best Practices

"Say what you mean, simply and directly." - [Brian Kernighan](https://en.wikipedia.org/wiki/The_Elements_of_Programming_Style)

### Minimal Viable Documentation

From [Google Documentation Best Practices](https://github.com/google/styleguide/blob/gh-pages/docguide/best_practices.md):

A small set of fresh and accurate docs are better than a sprawling, loose assembly of "documentation" in various states of disrepair.

Write short and useful documents. Cut out everything unnecessary, while also making a habit of continually massaging and improving every doc to suit your changing needs. Docs work best when they are alive but frequently trimmed, like a bonsai tree.

### Avoid HTML in markdown

HTML should not be included in Markdown unless the team agrees there is appropriate need and no better alternative.  Ask
on the Slack channel for other suggestions or agreement to proceed before adding HTML.

### Use classes for images

Create a CSS class if you need non-default styling of an image.  Instead of:

```
<br> <img src="/images/docs/iso/appleicon.png" width="25">
```

Use:
```
[logo](/images/docs/iso/applicon.png)
```
