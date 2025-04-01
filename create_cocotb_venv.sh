#!/bin/bash

# === CONFIGURATION ===
PYTHON_VERSION=3.11.8
OPENSSL_VERSION=1.1.1w
LIBFFI_VERSION=3.4.4
INSTALL_PREFIX="$HOME/local"
VENV_PATH="$HOME/cocotb-env"

# === DIRECTORIES ===
mkdir -p ~/build && cd ~/build

# === Build OpenSSL ===
wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz
rm -rf openssl-$OPENSSL_VERSION && tar xzf openssl-$OPENSSL_VERSION.tar.gz && cd openssl-$OPENSSL_VERSION
./config --prefix=$HOME/openssl --openssldir=$HOME/openssl no-shared
make -j$(nproc)
make install

# === Build libffi ===
cd ~/build
wget https://github.com/libffi/libffi/releases/download/v$LIBFFI_VERSION/libffi-$LIBFFI_VERSION.tar.gz
rm -rf libffi-$LIBFFI_VERSION && tar xzf libffi-$LIBFFI_VERSION.tar.gz && cd libffi-$LIBFFI_VERSION
./configure --prefix=$HOME/libffi --disable-shared --enable-static CFLAGS="-fPIC"
make -j$(nproc)
make install

# === Build Python ===
cd ~/build
wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
rm -rf Python-$PYTHON_VERSION && tar xzf Python-$PYTHON_VERSION.tgz && cd Python-$PYTHON_VERSION

PKG_CONFIG_PATH=$HOME/libffi/lib64/pkgconfig \
./configure --prefix=$INSTALL_PREFIX \
            --with-openssl=$HOME/openssl \
            --with-system-ffi \
            --enable-shared \
            CPPFLAGS="-I$HOME/libffi/include -fPIC" \
            LDFLAGS="-L$HOME/libffi/lib64 -Wl,-rpath=$HOME/local/lib"
make -j$(nproc)
make install

# === Create and activate virtual environment ===
$INSTALL_PREFIX/bin/python3.11 -m venv $VENV_PATH
source $VENV_PATH/bin/activate

# === Install cocotb ===
pip install --upgrade pip setuptools wheel
pip install cocotb

# === Done ===
echo "✅ Python $PYTHON_VERSION, OpenSSL $OPENSSL_VERSION, libffi $LIBFFI_VERSION, and cocotb installed in virtualenv at $VENV_PATH"

