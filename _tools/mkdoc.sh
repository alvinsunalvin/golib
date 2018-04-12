#!/bin/bash

progdir=$(dirname "$0")
pkglist=$(go list ./... | sed 's@.*/vendor/@@')

(
    sed -n '1,/(AUTOGENERATED)/p' README.md
    for p in $pkglist; do
        echo "- [$(basename $p)](#$p)"
    done
    for p in $pkglist; do
        $GOPATH/bin/godoc2md -template "$progdir/godoc2md.templ" $p |
        sed \
            -e "s@/src/github.com/billziss-gh/golib/@@g"\
            -e "s@/src/target@$(basename $p)@g"\
            -e "s@?s=[0-9][0-9]*:[0-9][0-9]*#@#@g"
    done
) > $progdir/../README.md.new
mv $progdir/../README.md.new $progdir/../README.md
