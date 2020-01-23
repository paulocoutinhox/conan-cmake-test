# Conan CMake Test

[![Build Status](https://travis-ci.com/prsolucoes/conan-cmake-test.svg?branch=master)](https://travis-ci.com/prsolucoes/conan-cmake-test)

## About

Sample project using CMake and Conan to build a sample.

## Supported platforms:

1. macos

## How to use:

1. Clone reposity:  
    > git clone https://github.com/prsolucoes/conan-cmake-test.git

2. Enter on cloned folder:  
    > cd conan-cmake-test

3. Add repositories:  
    > conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan  
    > conan remote add darwin-toolchain https://api.bintray.com/conan/ezored/conan-darwin-toolchain  

4. Run:  
    > make install-profiles  
    > make deps  
    > make build  
    > make check    

## License

[MIT](http://opensource.org/licenses/MIT)

Copyright (c) 2019-present, Paulo Coutinho
