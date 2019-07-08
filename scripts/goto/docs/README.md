# goto/docs

This folder holds the manpage documentation for the goto function.

## Requirements

To make changes in this environment you will need the `asciidoctor` function
installed.  This can be installed by running

```$ sudo apt-get install asciidoctor```

## Make endpoints

There are 4 main make endpoints, `all`, `update`, `install`, and `clean`. 

`make all` will update all the location manpages. Note that by local this means
the manpages in this directory.

`make clean` will delete those manpages.

`make update` will copy those manpages into `/usr/local/share/man/` so they can
be accessed with the `man` command.

`make install` will call `make update` but will also update the index for `man`.
This is only really necessary when a new manpage is added or it is installed for
the first time.
