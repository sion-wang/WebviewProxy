mapper = '{"google.protobuf.Timestamp":"String","bytes":"json.RawMessage","string":"String","int32":"Int","int64":"Long","bool":"Boolean"}'
pkg_folder_path = $(PKG_FOLDER)
pkg_path = $(PKG_PATH)

build_env:
	mkdir -p template/init/app/src/main/java/${pkg_folder_path}

	@if [ -d "template/init/app/src/main/java/com/test/mvvm" ]; then \
		cp -R template/init/app/src/main/java/com/test/mvvm/ template/init/app/src/main/java/${pkg_folder_path}; \
	fi

	mkdir -p proto
	mkdir -p keystore
	mkdir -p app/keystore

	rm -rf template/init/app/src/main/java/com/test

	truss \
		-project ${pkg_path} \
		-template_folder template/init \
		-dist_folder . \
		-force_replace

build_api:
	mkdir -p template/api/app/src/main/java/${pkg_folder_path}

	@if [ -d "template/api/app/src/main/java/com/test/mvvm" ]; then \
		cp -R template/api/app/src/main/java/com/test/mvvm/ template/api/app/src/main/java/${pkg_folder_path}; \
	fi

	rm -rf template/api/app/src/main/java/com/test

	truss \
		-project ${pkg_path} \
		-mapper $(mapper) \
		-template_folder template/api \
		-dist_folder . \
		-force_replace