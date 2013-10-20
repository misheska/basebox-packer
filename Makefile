BUILDER_TYPES = vmware virtualbox
TEMPLATE_DIRS := $(wildcard template/*)
TEMPLATE_FILES := $(patsubst %, %/template.json, ${TEMPLATE_DIRS})
BOX_FILENAMES := $(patsubst template/%, %.box, ${TEMPLATE_DIRS})
BOX_FILES := $(foreach builder, $(BUILDER_TYPES), $(foreach box_filename, $(BOX_FILENAMES), $(builder)/$(box_filename)))
RM = rm -f

.PHONY: all
all: $(BOX_FILES)

vmware/%.box: template/%/template.json
	cd $(dir $<); \
	rm -rf output-vmware; \
	mkdir -p ../../vmware; \
	packer build -only=vmware $(notdir $<)

virtualbox/%.box: template/%/template.json
	cd $(dir $<); \
	rm -rf output-virtualbox; \
	mkdir -p ../../virtualbox; \
	packer build -only=virtualbox $(notdir $<)

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
