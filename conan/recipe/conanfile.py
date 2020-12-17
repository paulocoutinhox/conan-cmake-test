from conans import ConanFile, CMake


class TargetConan(ConanFile):
    name = "ios_framework"
    version = "1.0.0"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False], "group": "ANY"}
    default_options = {
        "shared": False,
        "fPIC": True,
        "group": "",
        "sqlite3:threadsafe": 1,
        "sqlite3:build_executable": False,
    }
    exports_sources = "*"
    generators = "cmake"

    def build(self):
        cmake = CMake(self, generator="Xcode")
        cmake.definitions["CMAKE_BUILD_TYPE"] = self.settings.build_type
        cmake.definitions["PROJECT_CONFIG_ARCH"] = self.settings.arch
        cmake.definitions["PROJECT_CONFIG_GROUP"] = self.options.group
        cmake.configure()
        cmake.build()

    def requirements(self):
        self.requires("sqlite3/3.34.0")
