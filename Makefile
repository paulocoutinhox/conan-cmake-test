.DEFAULT_GOAL := help

help:
	@echo "Type: make [rule]. Available options are:"
	@echo ""
	@echo "- help"
	@echo "- deps"
	@echo "- build"
	@echo "- check"
	@echo "- install-profiles"
	@echo ""

deps:
	rm -rf out/conan
	mkdir -p out/conan

	cd out/conan && \
		conan install ../../conan/recipe/conanfile.py \
		--profile cmake_test_catalyst_framework_profile \
		-s arch=x86_64 \
		-s os.version=13.0 \
		-s os.subsystem=catalyst \
		-s build_type=Debug \
		-o darwin-toolchain:enable_bitcode=True \
		--build=missing \
		--update

build:
	rm -rf out/build
	mkdir -p out/build

	cd out/build && \
		conan build ../../conan/recipe/conanfile.py \
		--source-folder ../../cmake \
		--build-folder . \
		--install-folder ../conan

	cp -R support/Modules out/build/lib/Sample.framework/

check:
	file out/build/lib/Sample.framework/Sample

install-profiles:
	@echo "> Installing profiles..."
	mkdir -p ~/.conan/profiles/
	cp conan/profiles/*profile ~/.conan/profiles/

sign:
	@echo "> Signing..."
	codesign --force --verbose --sign "Z65H7K3Q57" --deep out/build/lib/Sample.framework