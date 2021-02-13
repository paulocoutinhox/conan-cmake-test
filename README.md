# Conan CMake Test

![Build - iOS](https://github.com/paulo-coutinho/conan-cmake-test/workflows/Build%20-%20iOS/badge.svg?branch=master)

![Build - Catalyst](https://github.com/paulo-coutinho/conan-cmake-test/workflows/Build%20-%20Catalyst/badge.svg?branch=master)

## About

Sample project using CMake and Conan to build a sample.

## Supported platforms:

1. macos (ios and catalyst)

## Requirements

1. Python 3
2. CMake
3. Ninja
4. Xcode

## How to use:

1. Clone reposity:  
    > git clone https://github.com/prsolucoes/conan-cmake-test.git

2. Enter on cloned folder:  
    > cd conan-cmake-test

3. Install conan:  
    > pip install conan --upgrade      
    > conan profile new default --detect  
    > conan remote add darwin-toolchain https://api.bintray.com/conan/ezored/conan-darwin-toolchain  
    > make install-profiles  

4. Run:  
    > make deps-ios  
    > make build-ios  
    > make check-ios  
    > make deps-catalyst  
    > make build-catalyst  
    > make check-catalyst    

## License

[MIT](http://opensource.org/licenses/MIT)

Copyright (c) 2019-present, Paulo Coutinho
