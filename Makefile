BUILDER_TYPES = vmware virtualbox
TEMPLATE_PATHS := $(wildcard template/*/*.json)
TEMPLATE_FILENAMES := $(notdir ${TEMPLATE_PATHS})
TEMPLATE_DIRS := $(dir ${TEMPLATE_PATHS})
BOX_FILENAMES := $(TEMPLATE_FILENAMES:.json=.box)
BOX_FILES := $(foreach builder, $(BUILDER_TYPES), $(foreach box_filename, $(BOX_FILENAMES), $(builder)/$(box_filename)))
RM = rm -f

vpath %.json template/centos:template/debian:template/fedora:template/freebsd:template/opensuse:template/oraclelinux:template/osx:template/ubuntu:template/windows2008r2:template/windows2012:template/windows2012r2:template/windows7:template/windows8:template/windows81

.PHONY: all
all: $(BOX_FILES)

vmware/%.box: %.json
	cd $(dir $<); \
	rm -rf output-vmware; \
	mkdir -p ../../vmware; \
	packer build -only=vmware $(notdir $<)

virtualbox/%.box: %.json
	cd $(dir $<); \
	rm -rf output-virtualbox; \
	mkdir -p ../../virtualbox; \
	packer build -only=virtualbox-iso $(notdir $<)

.PHONY: list
list:
	@for builder in $(BUILDER_TYPES) ; do \
		for box_filename in $(BOX_FILENAMES) ; do \
			echo $$builder/$$box_filename ; \
		done ; \
	done

.PHONY: clean really-clean clean-builders clean-output clean-packer-cache
clean: clean-builders clean-output

really-clean: clean clean-packer-cache

clean-builders:
	@for builder in $(BUILDER_TYPES) ; do \
		if test -d $$builder ; then \
			echo Deleting $$builder ; \
			$(RM) -rf $$builder ; \
		fi ; \
	done

clean-output:
	@for template in $(TEMPLATE_DIRS) ; do \
		for builder in $(BUILDER_TYPES) ; do \
			if test -d $$template/output-$$builder ; then \
				echo Deleting $$template/output-$$builder ; \
				$(RM) -rf $$template/output-$$builder ; \
			fi ; \
		done ; \
	done

clean-packer-cache:
	@for template in $(TEMPLATE_DIRS) ; do \
		if test -d $$template/packer_cache ; then \
			echo Deleting $$template/packer_cache ; \
			$(RM) -rf $$template/packer_cache ; \
		fi ; \
	done
