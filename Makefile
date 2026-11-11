TYPST ?= typst
DOT ?= dot

DIAGRAM_DIR := assets/diagrams
DOT_SOURCES := $(wildcard $(DIAGRAM_DIR)/*.dot)
DIAGRAMS := $(DOT_SOURCES:.dot=.svg)

SESSION_PDF := session.pdf
SESSION_SRC := session.typ
LIB_SOURCES := $(wildcard lib.typ)
SECTION_SOURCES := $(wildcard sections/*.typ sections/*/*.typ)

.PHONY: all clean material assets

all: material

material: $(SESSION_PDF)

$(SESSION_PDF): $(SESSION_SRC) $(LIB_SOURCES) $(SECTION_SOURCES) $(DIAGRAMS)
	$(TYPST) compile --root . $< $@

$(DIAGRAM_DIR)/%.svg: $(DIAGRAM_DIR)/%.dot
	$(DOT) -Tsvg $< -o $@

clean:
	rm -f $(SESSION_PDF) $(DIAGRAMS)
