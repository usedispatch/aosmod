all: clean build run	

run:
	node --experimental-wasm-memory64 --import tsx index.ts

build:
	ao build

clean:
	rm -f process.wasm