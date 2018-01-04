#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo "Usage: $(basename $0) [PACKAGE_NAME]"
  exit
fi

if [[ ! -d "./gpd-pocket-arch-packages/$1" ]]; then
    echo "Package $1 does not exist."
  exit
fi

PACKAGE=$1
REPO_DB=gpd-pocket-arch.db.tar

root_dir=$(pwd)
package_dir="./gpd-pocket-arch-packages/$PACKAGE"

cd $package_dir
makepkg --force --syncdeps --rmdeps
pkg_file=$(ls *.xz)

if [[ ! -f "$pkg_file" ]]; then
  echo "Package file was not build properly. Check logs."
  exit
fi

mv $pkg_file $root_dir
cd $root_dir

repo-add $REPO_DB $pkg_file
