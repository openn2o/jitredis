rm -rf *.wasm
rm -rf *.bc

/Applications/cheerp/bin/clang++ \
  -target cheerp-wasm \
  -cheerp-linear-heap-size=128 \
  -cheerp-linear-output=wasm \
  -cheerp-no-icf \
  -o bin.js -O3 \
  -cheerp-avoid-wasm-traps \
  main.cpp 

[ -f /tmp/bin.wasm ] && rm -f /tmp/bin.wasm || echo "skip"
[ -f bin.wasm ] && mv -f bin.wasm /tmp || echo "skip"