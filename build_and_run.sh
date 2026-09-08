#!/bin/bash
set -e

if [ "$(id -u)" -eq 0 ]; then
  echo "Switching execution from root to developer user for bitbake compliance"
  chown -R developer:developer /home/developer
  exec sudo -u developer HOME=/home/developer PATH="$PATH" /bin/bash "$0" "$@"
fi


WORKSPACE="/home/developer/workspace"
BUILD_DIR="/home/developer/native-build"

HELLOWORLD_LAYER_REPO="https://github.com/abishekbalu/meta-helloworld.git"

echo "============================================"
echo "    Setting up workspace & cloning Poky"
echo "============================================"

mkdir -p ${WORKSPACE}
cd ${WORKSPACE}

if [ ! -d "poky" ]; then
  git clone -b scarthgap https://git.yoctoproject.org/poky
fi

cd poky

echo "==========================================="
echo "     Cloning our meta-helloworld layer "
echo "==========================================="

if [ ! -d "meta-helloworld" ]; then
  git clone ${HELLOWORLD_LAYER_REPO} meta-helloworld
fi

echo "=========================================="
echo " Initializing the Yocto Build Environment "
echo "=========================================="

source oe-init-build-env ${BUILD_DIR}

echo "=========================================="
echo "    Adding Custom Layer    "
echo "=========================================="

bitbake-layers add-layer ${WORKSPACE}/poky/meta-helloworld

echo "=========================================="
echo "        Building the Core Image "
echo "=========================================="

bitbake core-image-minimal

echo "=========================================="
echo "    Booting Target in QEMU ARM64 "
echo "=========================================="

expect -c '
set timeout 300
spawn runqemu qemuarm64 nographic slirp

expect "qemuarm64 login:"
send "root\r"

expect "# "
send "helloworld\r"

expect "# "
send "poweroff\r"
'
