# Current valid values: provisionerless | chef | salt
PROVISIONER := chef
#PROVISIONER := provisionerless
# Current valid values: latest | x.y.x | x.y
PROVISIONER_VERSION := 10.16.6
#PROVISIONER_VERSION :=
# Packer does not allow empty variables, so only pass variables that are defined
ifdef PROVISIONER_VERSION
	PACKER_VARS := -var 'provisioner=${PROVISIONER}' -var 'provisioner_version=$(PROVISIONER_VERSION)'
else
	PACKER_VARS := -var 'provisioner=$(PROVISIONER)'
endif
BUILDER_TYPES = vmware virtualbox
TEMPLATE_PATHS := $(wildcard template/*/*.json)
TEMPLATE_FILENAMES := $(notdir ${TEMPLATE_PATHS})
TEMPLATE_DIRS := $(dir ${TEMPLATE_PATHS})
BOX_FILENAMES := $(TEMPLATE_FILENAMES:.json=\-$(PROVISIONER)$(PROVISIONER_VERSION).box)
BOX_FILES := $(foreach builder, $(BUILDER_TYPES), $(foreach box_filename, $(BOX_FILENAMES), $(builder)/$(box_filename)))
RM = rm -f

vpath %.json template/centos:template/debian:template/fedora:template/freebsd:template/opensuse:template/oraclelinux:template/osx:template/ubuntu:template/windows2008r2:template/windows2012:template/windows2012r2:template/windows7:template/windows8:template/windows81

.PHONY: all
all: $(BOX_FILES)

vmware/%-$(PROVISIONER)$(PROVISIONER_VERSION).box: %.json
	cd $(dir $<); \
	rm -rf output-vmware-iso; \
	mkdir -p ../../vmware; \
	packer build -only=vmware-iso $(PACKER_VARS) $(notdir $<)

virtualbox/%-$(PROVISIONER)$(PROVISIONER_VERSION).box: %.json
	cd $(dir $<); \
	rm -rf output-virtualbox-iso; \
	mkdir -p ../../virtualbox; \
	packer build -only=virtualbox-iso $(PACKER_VARS) $(notdir $<)

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
			find $$builder -maxdepth 1 -type f -name "*.box" ! -name .gitignore -exec rm '{}' \; ; \
		fi ; \
	done

clean-output:
	@for template in $(TEMPLATE_DIRS) ; do \
		for builder in $(BUILDER_TYPES) ; do \
			if test -d $$template/output-$$builder ; then \
				echo Deleting $$template/output-$$builder-iso ; \
				$(RM) -rf $$template/output-$$builder-iso ; \
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
