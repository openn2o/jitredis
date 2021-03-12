#
# mac os is not allow 
# build wat.
#

/Applications/cheerp/bin/clang++ \
  -target cheerp-wasm \
  -cheerp-linear-output=wasm \
  -cheerp-no-icf \
  -o bin.js -O3\
  -cheerp-avoid-wasm-traps \
  -cheerp-pretty-code \
  -cheerp-bounds-check \
  -cheerp-cfg-legacy \
  -cheerp-no-credits \
  -cheerp-no-icf \
  -cheerp-no-lto \
  main.cpp 

[ -f /tmp/bin.wasm ] && rm -f /tmp/bin.wasm || echo "skip"
[ -f bin.wasm ] && cp -f bin.wasm /tmp || echo "skip"