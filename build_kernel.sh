#!/bin/bash

echo
echo "--- Setting up Clang-Primary Toolchain ---"

TOOLCHAIN_DIR="/home/shiroyura/Kernel_Buld/toolchain"
CLANG_ROOT="$TOOLCHAIN_DIR/neutron-clang-06092026"
GCC_ROOT="$TOOLCHAIN_DIR/aarch64--glibc--stable-2026.08-1"

export CLANG_PATH="$CLANG_ROOT/bin"
export PATH="$CLANG_PATH:$GCC_ROOT/bin:${PATH}"

export ARCH=arm64
export SUBARCH=arm64
export CLANG_TRIPLE=aarch64-linux-gnu-

export KCFLAGS="-w -O3 -march=armv8.4-a+crypto+dotprod+crc -mcpu=cortex-a78 -mtune=cortex-a78 -fuse-ld=lld -mllvm -polly -fvectorize -fslp-vectorize -Wno-error=return-mismatch"
export HOSTCFLAGS="-O3"
export HOSTCXXFLAGS="-O3"

MAKE_FLAGS=(
    LLVM=1 
    LLVM_IAS=1 
    O=out_cfi
    ARCH=$ARCH
    CC=clang
    HOSTCC=clang
    HOSTCXX=clang++
    CROSS_COMPILE=aarch64-linux-gnu-
    CROSS_COMPILE_ARM32=arm-linux-gnueabi-
)

echo "Clang version:"
$CLANG_PATH/clang --version

echo
echo "--- Set DEFCONFIG (NX669J) ---"
mkdir -p out_cfi

make "${MAKE_FLAGS[@]}" NX669J_defconfig

echo
echo "--- Build The Good Stuff ---"

make "${MAKE_FLAGS[@]}" -j$(nproc)
