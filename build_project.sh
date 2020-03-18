#!/usr/bin/env bash

pkg_folder=$1
pkg_path=$2

rm -rf 'app/src/main/java'

git clone https://gitlab.silkrode.com.tw/team_mobile/genmvvmtemplate.git

rm -rf genmvvmtemplate/.git

cp -R genmvvmtemplate/ .

rm -rf genmvvmtemplate

make build_env PKG_FOLDER=${pkg_folder} PKG_PATH=${pkg_path}