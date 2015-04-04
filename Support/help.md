# Building and Running

There are three commands to build or run a project:

* Run ⌘R
* Build ⌘B
* Run Single File ⇧⌘R

## Run

The Run command will build and run the current project in the following way:

1. If a file name `run.sh` exists in the current working directory, that will
be executed

2. If a filed name `dub.json` exists in the current working directory
the `dub run` command will be executed

3. Otherwise it will fallback to the Run Single File command

## Build

The Build command works similar to the Run command but it will only build the
project and not run it.

1. If a file name `build.sh` exists in the current working directory, that will
be executed

2. If a filed name `dub.json` exists in the current working directory
the `dub build` command will be executed

3. Otherwise it will fallback to the <a href="javascript:goTo('sect_1.3')">Run Single File</a> command but with the extra
`--build-only` flag

## Run Single File

The Run Single File will compile and run the currently active file, regardless
if it's part of a project or a standalone file. The command that will be
executed is:

    rdmd -vcolumns --compiler=$TM_DMD <current_file>

Where `<current_file>` is the current active file.

# Environment Variables

The run and build commands recognizes the `TM_DMD` environment variable. This
should point to the compiler that is to be used when building. It needs to be
compatible with the DMD command line interface, for GDC and LDC that means it
needs to point to the `gdmd` or `ldmd` command. If the `TM_DMD` variable isn't
present it will fallback to use `dmd`.
