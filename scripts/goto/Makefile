SUBDIRS = docs

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

clean: $(SUBDIRS)

install: $(SUBDIRS)

.PHONY: all clean install $(SUBDIRS)
