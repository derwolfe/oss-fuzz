#!/bin/bash -eu
# Copyright 2018 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

./autogen.sh --disable-shared
make -j$(nproc) all

# there are some gifs in $SRC/giflib/pic
if [ ! -d "$OUT/decoder_fuzzer_corpus" ]; then
    mkdir "$OUT/decoder_fuzzer_corpus"
    cp -v $SRC/giflib/pic/*.gif $OUT/decoder_fuzzer_corpus
fi;

$CXX $CXXFLAGS -std=c++11 -I"$SRC/giflib/lib" \
     $SRC/decoder_fuzzer.cc -o $OUT/decoder_fuzzer \
     -lFuzzingEngine -L$SRC/giflib/lib/.libs -lgif
