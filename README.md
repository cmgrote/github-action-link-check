# GitHub Action - link-check

A GitHub action for checking links in the project's (Markdown) documentation.

This takes its inspiration from [markdown-link-check](https://github.com/marketplace/actions/markdown-link-check),
but with the following variations:

- A single Markdown-formatted output file with any problematic links is produced, containing only the problems.
- A sub-heading for each problematic Markdown file is included, under which is a series of tick-boxes.
- Each tick-box is followed by the specific link that was problematic and the status code it returned.

This allows the output file to be a self-contained record of any problems, from which (for example) a GitHub issue
can be created with sufficient details to resolve the broken links.

## How to use

Create a new action workflow file in your repository under `.github/workflows`,
for example: `.github/workflows/link-check-action.yml`.

Depending on how you want the action to run, choose one of the following configurations
to copy/paste as a starting point.

You can further optionally use a [custom configuration](https://github.com/tcort/markdown-link-check#config-file-format)
file, when defined under `.github/workflows-config/link-check-action.json`, to configure how the checking should handle any edge
cases specific to your repository.

### Running on a schedule

The following example will setup the link checking to occur on a daily basis:

```yaml
name: Check documentation links
on:
  schedule:
    - cron: '0 1 * * *'
jobs:
  linkChecker:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Check Links
        uses: cmgrote/github-action-link-check@master
      - name: Create Issue from File
        uses: peter-evans/create-issue-from-file@v2
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          title: Broken links
          content-filepath: ./errors.txt
          labels: report, automated issue
```

### Running on each push

The following example will setup the link checking to occur on each repository push:

```yaml
name: Check documentation links
on: push
jobs:
  link-check:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: cmgrote/github-action-link-check@master
```
