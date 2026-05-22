SHELL = /bin/bash

GENERATED_FILE = generated
ALLOW_FILE     = allow
DENY_FILE      = deny
OUTPUT_FILE    = init.goggle
GOGGLE_NAME    = talk
GOGGLE_DESC    = look for talk

.PHONY: all clean $(OUTPUT_FILE)

all: $(OUTPUT_FILE)

$(OUTPUT_FILE): $(GENERATED_FILE) $(ALLOW_FILE) $(DENY_FILE)
	@# Warn about any URLs present in both allow and deny
	@overlap=$$(comm -12 \
	    <(grep -hE '^[^#[:space:]]' $(ALLOW_FILE) | sort -u) \
	    <(grep -hE '^[^#[:space:]]' $(DENY_FILE)  | sort -u)); \
	if [ -n "$$overlap" ]; then \
	    echo "WARNING: the following URLs appear in both allow and deny:"; \
	    echo "$$overlap" | sed 's/^/  /'; \
	fi
	@# Build the goggle header
	@echo "! name: $(GOGGLE_NAME)" > $(OUTPUT_FILE)
	@echo "! description: $(GOGGLE_DESC)" >> $(OUTPUT_FILE)
	@echo "! public: false" >> $(OUTPUT_FILE)
	@echo "" >> $(OUTPUT_FILE)
	@# Union of generated + allow, minus deny, written as boost rules
	@comm -23 \
	    <(grep -hE '^[^#[:space:]]' $(GENERATED_FILE) $(ALLOW_FILE) | sort -u) \
	    <(grep -hE '^[^#[:space:]]' $(DENY_FILE) | sort -u) \
	  | awk '{print "$$boost,site="$$1}' >> $(OUTPUT_FILE)
	@echo "" >> $(OUTPUT_FILE)
	@echo '$$discard' >> $(OUTPUT_FILE)
	@echo "Build complete."

clean:
	rm -f $(OUTPUT_FILE)
