#!/bin/bash

function compile() 
{

source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
ccache -M 100G
git clone --depth=1 https://github.com/StatiXOS/android_prebuilts_gcc_linux-x86_arm_arm-eabi gcc
git clone --depth=1 https://github.com/StatiXOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-elf gcc64
export ARCH=arm64
export KBUILD_BUILD_HOST=Anupam_Roy
export KBUILD_BUILD_USER="Gorilla669"

[ -d "out" ] && rm -rf AnyKernel && rm -rf out || mkdir -p out

make O=out ARCH=arm64 RM6785_defconfig

PATH="${PWD}/gcc/bin:${PATH}:${PWD}/gcc64/bin:/usr/bin:$PATH" \
make -j$(nproc --all) O=out \
			CROSS_COMPILE_ARM32=arm-eabi- \
			CROSS_COMPILE=aarch64-elf- \
			LD=aarch64-elf-ld.lld \
			CC=aarch64-elf-gcc \
			STRIP=llvm-strip \
			CONFIG_DEBUG_SECTION_MISMATCH=y
}

function zupload()
{
git clone --depth=1 https://github.com/Johny8988/AnyKernel3.git AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 ThunderStorm-lto-KERNEL-RM6785.zip *
curl -sL https://git.io/file-transfer | sh
./transfer wet ThunderStorm-lto-KERNEL-RM6785.zip
}

compile
zupload
