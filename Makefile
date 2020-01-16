.DEFAULT_GOAL := help

help:
	@echo "Type: make [rule]. Available options are:"
	@echo ""
	@echo "- help"
	@echo "- build"
	@echo "- check"
	@echo "- install-profiles"
	@echo ""

build:
	rm -rf out

	mkdir -p out/conan
	cd out/conan && \
		conan install ../../conan/recipe/conanfile.py \
		--profile cmake_test_ios_framework_profile \
		-s arch=armv7 \
		-s os.version=9.0 \
		-s build_type=Debug \
		--build=missing \
		--update

	mkdir -p out/build
	cd out/build && \
		conan build ../../conan/recipe/conanfile.py \
		--source-folder ../../cmake \
		--build-folder . \
		--install-folder ../conan

check:
	file out/build/lib/Sample.framework/Sample

install-profiles:
	@echo "> Installing profiles..."
	mkdir -p ~/.conan/profiles/
	cp conan/profiles/*profile ~/.conan/profiles/
