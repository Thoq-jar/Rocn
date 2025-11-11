.PHONY: build run check clean

SRC := src/main.roc
GEN := src/main
OUT := out/main
ROCN := .rocn

build:
	mkdir -p out
	roc build $(SRC)
	mv $(GEN) $(OUT)

run: build
	./$(OUT)

check:
	roc check $(SRC)

clean:
	rm -rf $(OUT) $(ROCN)

