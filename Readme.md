Makefile which will manage configuring and build of opcua libraries.

Quick start:
make install-deps
make configure
make
make check

Everithing will be installed into build directory.

help:

make - compile everything. Download and cofigures nothing, only compiling.
make configure - configure repository dependencies.
make check - run unit tests.
make clean - cleanup
make pull - pull changes from all repos.
make install-deps - install software required for building

