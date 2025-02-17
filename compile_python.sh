#!/bin/bash

# List of packages to check
packages="build-essential wget pkg-config zlib1g-dev 
libncurses5-dev libgdbm-dev libnss3-dev libssl-dev 
libreadline-dev libffi-dev libsqlite3-dev libbz2-dev liblzma-dev tk-dev"

update_package_index=0
# Loop through each package and check if it is installed
for pkg in $packages; do
    if dpkg -s "$pkg" 1> /dev/null; then
        echo "$pkg is already installed"
    else
        if [ $update_package_index -eq 0 ]; then
            sudo apt update
            update_package_index=1 #the script will update the package index once
        fi
        echo "$pkg is not installed"
        sudo apt install $pkg -y
    fi
done

PYTHON_INSTALL_DIR="$HOME/MY_PYTHON"

PYTHON_VERSION="3.13.1"

if [ ! -f "Python-$PYTHON_VERSION.tgz" ]; then
    wget "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz"
fi

if [ ! -d "Python-$PYTHON_VERSION" ]; then
    tar -xf "Python-$PYTHON_VERSION.tgz"
fi

cd "Python-$PYTHON_VERSION"

export LDFLAGS="-Wl,-rpath $PYTHON_INSTALL_DIR/lib"

./configure \
    --enable-optimizations \
    --prefix="$PYTHON_INSTALL_DIR" \
    --enable-shared \
    --with-lto

NUM_THREAD=$(($(nproc) - 4))

make -j"$NUM_THREAD"

# sudo make altinstall

make install

# end of files
