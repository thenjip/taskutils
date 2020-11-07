# Examples

Here is the list of the example projects that show how to use `taskutils` with
the Nimble script.
The list is sorted by increasing complexity.

## `custom_task`

A library project where the Nimble script has one custom task called `docs` to
generate the API documentation.

## `custom_task_&_output_dir`

Same as previously, but the output directory of the generated API doc can be
customized by setting the environment variable `OUTDIR`:

```sh
OUTDIR="$PWD/apidocs" nimble docs
```

An error will be raised, if `OUTDIR` is set to an empty or blank (ASCII) string.
If it is not set, it will default to `$PWD/htmldocs`.
