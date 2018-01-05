#!/usr/bin/env bash

BASENAME=gpd-pocket-arch
ROOT_DIR=$(pwd)


remove_old_packages() {
  rm $ROOT_DIR/*.xz 2> /dev/null
  rm $ROOT_DIR/$BASENAME.db 2> /dev/null
  rm $ROOT_DIR/$BASENAME.files 2> /dev/null
}

sync_packages_submodule() {
  git submodule init
  git submodule update --remote
}

update_repo_db() {
  repo-add --new $BASENAME.db.tar *.xz
}

build_package() {
  local package_name=$1
  local package_dir="./gpd-pocket-arch-packages/$package_name"

  if [[ ! -d "$package_dir" ]]; then
    echo "Package '$package_name' not found"
    exit
  fi

  cd $package_dir
  makepkg --force --syncdeps --rmdeps --clean
  mv *.xz $ROOT_DIR

  cd $ROOT_DIR
}

clean_repo() {
  mv $BASENAME.files.tar $BASENAME.files 2> /dev/null
  mv $BASENAME.db.tar $BASENAME.db  2> /dev/null
  rm *.old 2> /dev/null
}



if [[ "$1" == "all" ]]; then
  sync_packages_submodule
  remove_old_packages

  build_package gpd-pocket-alsa-lib
  build_package gpd-pocket-scrolling
  build_package gpd-pocket-linux-jwrdegoede
  build_package gpd-pocket-support

  update_repo_db
  clean_repo
elif [[ -n "$1" ]]; then
  sync_packages_submodule

  build_package $1

  update_repo_db
  clean_repo
else
  echo "Usage: $(basename $0) [all / package-name]"
  exit
fi