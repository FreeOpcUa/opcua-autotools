ACCOUNT := freeopcua
top_srcdir := $(PWD)
jobs := -j 8

with_gtest = --with-gtest=$(top_srcdir)/gtest-1.7.0
with_gmock = --with-gmock=$(top_srcdir)/gmock-1.7.0
with_uamappings= --with-uamappings=$(top_srcdir)/opcua-mappings
with_opccore = --with-opccore=$(top_srcdir)/opcua-core
with_client = --with-libopcuaclient=$(top_srcdir)/opcua-client
with_server = --with-opcuaserver=$(top_srcdir)/opcua-server

with_all = $(with_gtest) $(with_gmock) $(with_uamappings) $(with_opccore) $(with_client) $(with_server)

build_prefix=--prefix=$(PWD)/build

all:
	$(MAKE) $(jobs) -C opcua-mappings all
	$(MAKE) $(jobs) -C opcua-core all
	$(MAKE) $(jobs) -C opcua-client all
	$(MAKE) $(jobs) -C opcua-server all
	$(MAKE) $(jobs) -C opcua-mappings install
	$(MAKE) $(jobs) -C opcua-core install
	$(MAKE) $(jobs) -C opcua-client install
	$(MAKE) $(jobs) -C opcua-server install
	$(MAKE) $(jobs) -C opcua-wsdl all
	$(MAKE) $(jobs) -C opcua-wsdl install
	$(MAKE) $(jobs) -C opcua-python python-dist && cp opcua-python/dist/* $(PWD)/build

check:
	$(MAKE) $(jobs) -C opcua-mappings check
	$(MAKE) $(jobs) -C opcua-core check
	$(MAKE) $(jobs) -C opcua-client check
	$(MAKE) $(jobs) -C opcua-server check
	$(MAKE) $(jobs) -C opcua-wsdl check
	$(MAKE) $(jobs) -C opcua-python check

clean:
	$(MAKE) -C opcua-mappings clean
	$(MAKE) -C opcua-core clean
	$(MAKE) -C opcua-client clean
	$(MAKE) -C opcua-server clean
	$(MAKE) -C opcua-wsdl clean
	$(MAKE) -C opcua-python clean
	rm -rvf build .configured

configure: .configured

.configured: gtest-1.7.0 gmock-1.7.0 opcua-mappings opcua-core opcua-client opcua-server opcua-python opcua-wsdl
	cd $(top_srcdir)/opcua-mappings && ./configure $(with_all) $(build_prefix)
	cd $(top_srcdir)/opcua-core && ./configure $(with_all) $(build_prefix)
	cd $(top_srcdir)/opcua-client && ./configure $(with_all) $(build_prefix)
	cd $(top_srcdir)/opcua-server && ./configure $(with_all) $(build_prefix)
	cd $(top_srcdir)/opcua-wsdl && ./configure $(build_prefix) --with-opcuaserver=$(PWD)/build
	cd $(top_srcdir)/opcua-python && ./configure $(with_all) --with-opcuaserver=$(PWD)/build
	touch .configured

opcua-mappings:
	git clone https://github.com/$(ACCOUNT)/opcua-mappings.git

opcua-core:
	git clone https://github.com/$(ACCOUNT)/opcua-core.git

opcua-server:
	git clone https://github.com/$(ACCOUNT)/opcua-server.git

opcua-client:
	git clone https://github.com/$(ACCOUNT)/opcua-client.git

opcua-python:
	git clone https://github.com/$(ACCOUNT)/opcua-python.git

opcua-wsdl:
	git clone https://github.com/$(ACCOUNT)/opcua-wsdl.git

gmock-1.7.0:
	wget http://googlemock.googlecode.com/files/gmock-1.7.0.zip -O /tmp/gmock-1.7.0.zip
	unzip /tmp/gmock-1.7.0.zip
	cd gmock-1.7.0 && ./configure && make

gtest-1.7.0:
	wget https://googletest.googlecode.com/files/gtest-1.7.0.zip -O /tmp/gtest-1.7.0.zip
	unzip /tmp/gtest-1.7.0.zip
	cd gtest-1.7.0 && ./configure && make

install-deps: gtest-1.7.0 gmock-1.7.0
	apt-get install gcc g++ make autoconf automake libtool \
	libboost-dev libboost-thread-dev libboost-program-options-dev \
	libboost-system-dev libboost-filesystem-dev \
	libcppunit-dev pkg-config git python-dev libboost-python-dev \
	gsoap libxml2-dev build-essential autotools-dev dh-make \
	debhelper devscripts fakeroot xutils lintian pbuilder \
	reprepro

pull: 
	cd $(top_srcdir)/opcua-mappings && git pull
	cd $(top_srcdir)/opcua-core && git pull
	cd $(top_srcdir)/opcua-client && git pull
	cd $(top_srcdir)/opcua-server && git pull
	cd $(top_srcdir)/opcua-python && git pull
	cd $(top_srcdir)/opcua-wsdl && git pull

.PHONY: configure all check

