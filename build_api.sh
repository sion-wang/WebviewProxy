#!/usr/bin/env bash

repo_path=$1
repo_name=$2
pkg_folder=$3
pkg_path=$4

rm -v proto/*

git clone ${repo_path}

cp -R ${repo_name}/ proto

rm -rf ${repo_name}

make build_api PKG_FOLDER=${pkg_folder} PKG_PATH=${pkg_path}