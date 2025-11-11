.PHONY: build run check clean

SRC := src/main.roc

GEN := src/main

OUT := out/main

ROCN := .rocn

build:
	@echo "Building $(SRC)..."
	mkdir -p out
	roc build $(SRC)
	mv $(GEN) $(OUT)

run: build
	@echo "Running $(OUT)..."
	./$(OUT)

check:
	@echo "Checking $(SRC)..."
	roc check $(SRC)

clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(OUT) $(ROCN)

