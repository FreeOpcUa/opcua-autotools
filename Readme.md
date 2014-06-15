Makefile which will manage configuring and build of opcua libraries.

#Quick start:
```
#install soft required for building
make install-deps
#configure all repositories
make configure
#compile everything
make
#run unittests
make check
```

Everything will be installed into build directory.

#Targets

- make - compile everything. Download and cofigures nothing, only compiling.
- make configure - configure repository dependencies.
- make check - run unit tests.
- make clean - cleanup
- make pull - pull changes from all repos.
- make install-deps - install software required for building


