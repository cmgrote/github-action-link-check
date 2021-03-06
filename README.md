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
      - name: Check links
        id: check_links
        uses: cmgrote/github-action-link-check@master
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
      - name: Check links
        id: check_links
        uses: cmgrote/github-action-link-check@master
```

## Capturing problems

There are various options for capturing any problems that are identified.  Note that you will most likely
only want to make use of one of these options, as each one will likely result in its own notifications
(so using multiple will result in multiple notifications regarding the same problem).

### Creating an issue from the results

Add the following step _after_ the "Check links" step to create an issue if any broken links were found,
replacing the name of the labels with any that you want to be assigned, or other
[configuration options](https://github.com/peter-evans/create-issue-from-file):

```yaml
      - name: Create issue from file
        uses: peter-evans/create-issue-from-file@v2
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          title: Broken links
          content-filepath: ./errors.txt
          labels: report, automated issue
```

### Failing the action itself

Add the following step _after_ the "Check links" step to fail the action itself if any broken links
were found:

```yaml
      - name: Set exit status
        run: exit ${{ steps.check_links.outputs.exit_code }}
```

## Example links

[This link is to localhost, and is ignored by the configuration file.](http://localhost:8080/somewhere)

[This link does not exist, and will result in an issue being created.](non-existent/relative/path/that-should/give/issue.html)
