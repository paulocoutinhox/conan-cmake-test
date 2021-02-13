.DEFAULT_GOAL := help

help:
	@echo "Type: make [rule]. Available options are:"
	@echo ""
	@echo "- help"
	@echo ""
	@echo "- deps-ios"
	@echo "- build-ios"
	@echo "- check-ios"
	@echo ""
	@echo "- deps-catalyst"
	@echo "- build-catalyst"
	@echo "- check-catalyst"
	@echo ""
	@echo "- install-profiles"
	@echo ""

install-profiles:
	@echo "> Installing profiles..."
	mkdir -p ~/.conan/profiles/
	cp conan/profiles/*profile ~/.conan/profiles/

#################################################################
# IOS
#################################################################

deps-ios:
	rm -rf out/conan-ios
	mkdir -p out/conan-ios

	cd out/conan-ios && \
		conan install ../../conan/recipe/conanfile.py \
		--profile cmake_test_ios_framework_profile \
		-s arch=armv8 \
		-s os.version=9.0 \
		-s build_type=Debug \
		-o group=ios \
		-o darwin-toolchain:enable_bitcode=True \
		--build=missing \
		--update

build-ios:
	rm -rf out/build-ios
	mkdir -p out/build-ios

	cd out/build-ios && \
		conan build ../../conan/recipe/conanfile.py \
		--source-folder ../../cmake \
		--build-folder . \
		--install-folder ../conan-ios

	cp -R support/Modules out/build-ios/lib/Sample.framework/

check-ios:
	file out/build-ios/lib/Sample.framework/Sample

sign-ios:
	@echo "> Signing..."
	codesign --force --verbose --sign "Z65H7K3Q57" --deep out/build-ios/lib/Sample.framework

#################################################################
# MAC CATALYST
#################################################################

deps-catalyst:
	rm -rf out/conan-catalyst
	mkdir -p out/conan-catalyst

	cd out/conan-catalyst && \
		conan install ../../conan/recipe/conanfile.py \
		--profile cmake_test_catalyst_framework_profile \
		-s arch=x86_64 \
		-s os.version=13.0 \
		-s os.subsystem=catalyst \
		-s build_type=Debug \
		-o group=catalyst \
		--build=missing \
		--update

build-catalyst:
	rm -rf out/build-catalyst
	mkdir -p out/build-catalyst

	cd out/build-catalyst && \
		conan build ../../conan/recipe/conanfile.py \
		--source-folder ../../cmake \
		--build-folder . \
		--install-folder ../conan-catalyst

	cp -R support/Modules out/build-catalyst/lib/Sample.framework/

check-catalyst:
	file out/build-catalyst/lib/Sample.framework/Sample

sign-catalyst:
	@echo "> Signing..."
	codesign --force --verbose --sign "Z65H7K3Q57" --deep out/build-catalyst/lib/Sample.framework
