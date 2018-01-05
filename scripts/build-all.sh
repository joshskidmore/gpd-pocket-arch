#!/usr/bin/env bash

BASENAME=gpd-pocket-arch
ROOT_DIR=$(pwd)


sync_packages_submodule() {
  git submodule update --remote
}

update_repo_db() {
  repo-add --new $BASENAME.db.tar *.xz
}

build_package() {
  local package_name=$1
  local package_dir="./gpd-pocket-arch-packages/$package_name"

  cd $package_dir
  makepkg --force --syncdeps --rmdeps
  mv *.xz $ROOT_DIR

  cd $ROOT_DIR
}

clean_repo() {
  mv $BASENAME.files.tar $BASENAME.files
  mv $BASENAME.db.tar $BASENAME.db
  rm *.old 2> /dev/null
}


sync_packages_submodule

build_package gpd-pocket-alsa-lib
build_package gpd-pocket-scrolling
#build_package gpd-pocket-linux-jwrdegoede
build_package gpd-pocket-support

update_repo_db
clean_repo