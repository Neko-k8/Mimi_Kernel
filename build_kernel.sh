#!/bin/bash

echo
echo "--- Clean Build Directory ---"
rm -rf ./out_cfi

echo
echo "--- Setting up Clang-Primary Toolchain ---"

TOOLCHAIN_DIR="/run/media/haruka/DATA/Kernel_Android/toolchain"
CLANG_ROOT="$TOOLCHAIN_DIR/linux-x86-531a564ba5426707dee226eccb19f104a7af5a5f-clang-r563880c"
GCC_ROOT="$TOOLCHAIN_DIR/aarch64--glibc--stable-2025.08-1"

export CLANG_PATH="$CLANG_ROOT/bin"
export PATH="$CLANG_PATH:${PATH}"
export ARCH=arm64
export SUBARCH=arm64
export CLANG_TRIPLE=aarch64-linux-gnu-

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

export PATH="$CLANG_PATH:$GCC_ROOT/bin:${PATH}"

echo "Clang version:"
$CLANG_PATH/clang --version

echo
echo "--- Set DEFCONFIG (NX669J) ---"
mkdir -p out_cfi

make "${MAKE_FLAGS[@]}" NX669J_defconfig

echo
echo "--- Build The Good Stuff ---"

make "${MAKE_FLAGS[@]}" -j$(nproc)
