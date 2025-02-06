#!/bin/bash
set -e

# Absolute path to the current (hello1) directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Ao "process" directory
PROCESS_DIR="${SCRIPT_DIR}/aos/process"
# Where we'll stash .a files inside the process folder
LIBS_DIR="${PROCESS_DIR}/libs"

# Docker image that has Emscripten + ao-build-module
AO_IMAGE="p3rmaw3b/ao:0.1.3"

# Emscripten flags
EMXX_CFLAGS="-s MEMORY64=1 -s SUPPORT_LONGJMP=1 -I/lua-5.3.4/src"

echo "==> Cleaning old libs in ${LIBS_DIR}"
rm -rf "${LIBS_DIR}"
mkdir -p "${LIBS_DIR}"

echo "==> Building hello.c into libhello.a"
docker run --rm \
  -v "${SCRIPT_DIR}:/src" \
  "${AO_IMAGE}" \
  sh -c "cd /src && emcc -c hello.c -o hello.o ${EMXX_CFLAGS} && emar rcs libhello.a hello.o && rm hello.o"

echo "==> Building lhello.c into liblhello.a"
docker run --rm \
  -v "${SCRIPT_DIR}:/src" \
  "${AO_IMAGE}" \
  sh -c "cd /src && emcc -c lhello.c -o lhello.o ${EMXX_CFLAGS} && emar rcs liblhello.a lhello.o && rm lhello.o"

# Copy the resulting static libraries into aos/process/libs
echo "==> Copying .a libraries into ${LIBS_DIR}"
cp "${SCRIPT_DIR}/libhello.a"  "${LIBS_DIR}/libhello.a"
cp "${SCRIPT_DIR}/liblhello.a" "${LIBS_DIR}/liblhello.a"

# Copy config.yml into the process directory
echo "==> Copying config.yml into ${PROCESS_DIR}"
cp "${SCRIPT_DIR}/config.yml" "${PROCESS_DIR}/config.yml"

# Now build the final process.wasm by calling ao-build-module *from* aos/process
echo "==> Building final WASM in ${PROCESS_DIR}"
cd "${PROCESS_DIR}"

docker run --rm \
  -e DEBUG=1 \
  -v "$(pwd)":/src \
  "${AO_IMAGE}" \
  ao-build-module

# Copy the final WASM back to test-module
echo "==> Copying process.wasm to test-module"
cp process.wasm "${SCRIPT_DIR}/test-module/process.wasm"

echo "==> Done. The final WASM is at test-module/process.wasm"