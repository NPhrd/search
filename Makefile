DOMAINS_FILE = domains
OUTPUT_FILE = init.goggle
GOGGLE_NAME = talk
GOGGLE_DESC = look for talk

.PHONY: all clean $(OUTPUT_FILE)

all: $(OUTPUT_FILE)

$(OUTPUT_FILE): $(DOMAINS_FILE)
	@echo "! name: $(GOGGLE_NAME)" > $(OUTPUT_FILE)
	@echo "! description: $(GOGGLE_DESC)" >> $(OUTPUT_FILE)
	@echo "! public: false" >> $(OUTPUT_FILE)
	@echo "" >> $(OUTPUT_FILE)
	@awk '/^[ \t]*[^#]/ {print "$$boost,site="$$1}' $(DOMAINS_FILE) >> $(OUTPUT_FILE)
	@echo "" >> $(OUTPUT_FILE)
	@echo '$$discard' >> $(OUTPUT_FILE)
	@echo "Build complete."
