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
	done | sort

.PHONY: clean
clean:
	$(foreach builder_type,$(BUILDER_TYPES),$(RM) -r $(builder_type);)
	@for template_dir in $(TEMPLATE_DIRS) ; do \
		$(RM) -r $$template_dir/output-vmware ;\
	done
