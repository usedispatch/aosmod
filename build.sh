#!/bin/bash
set -e

# Get this script's directory (so paths work reliably)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LIBS_DIR="${SCRIPT_DIR}/libs"

# Clean up and recreate the libs directory
rm -rf "${LIBS_DIR}"
mkdir -p "${LIBS_DIR}"

# Docker image that has emscripten + ao-build-module
AO_IMAGE="p3rmaw3b/ao:0.1.3"

# Example Emscripten flags to enable 64-bit memory and link with Lua
EMXX_CFLAGS="-s MEMORY64=1 -s SUPPORT_LONGJMP=1 -I/lua-5.3.4/src"

# 1) Build hello.c into a static library
docker run --rm \
  -v "${SCRIPT_DIR}:/hello" \
  "${AO_IMAGE}" \
  sh -c "cd /hello && emcc -c hello.c -o hello.o ${EMXX_CFLAGS} && emar rcs libhello.a hello.o && rm hello.o"

# 2) Build lhello.c into a static library
docker run --rm \
  -v "${SCRIPT_DIR}:/hello" \
  "${AO_IMAGE}" \
  sh -c "cd /hello && emcc -c lhello.c -o lhello.o ${EMXX_CFLAGS} && emar rcs liblhello.a lhello.o && rm lhello.o"

# 3) Copy out the compiled libraries (so we could link them into the final module)
cp "${SCRIPT_DIR}/libhello.a"  "${LIBS_DIR}/libhello.a"
cp "${SCRIPT_DIR}/liblhello.a" "${LIBS_DIR}/liblhello.a"

# 4) Copy config.yml (or place it into your final directory for building)
# cp "${SCRIPT_DIR}/config.yml" "${SCRIPT_DIR}/config.yml"

# 5) Actually build the final WASM module
#    The "ao-build-module" tool looks for static libraries + your Lua code
#    in the current directory. It will produce something like 'process.wasm'.
docker run --rm \
  -e DEBUG=1 \
  -v "${SCRIPT_DIR}:/src" \
  "${AO_IMAGE}" \
  ao-build-module

# At the end of this, you'll have process.wasm (or similar) in your folder.
echo "Build complete. Check for process.wasm in ${SCRIPT_DIR}"

cp process.wasm test-module/process.wasm