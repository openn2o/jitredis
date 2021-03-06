# rm -rf *.wasm
# rm -rf *.bc


clang++ \
  -target cheerp-wasm \
  -cheerp-linear-heap-size=128 \
  -cheerp-linear-output=wast \
  -o output.js -O3 \
  -cheerp-avoid-wasm-traps \
  main.cpp
  

clang++ \
  -target cheerp-wasm \
  -cheerp-linear-heap-size=128 \
  -cheerp-linear-output=wasm \
  -cheerp-no-icf \
  -o bin.js -O3 \
  -cheerp-avoid-wasm-traps \
  main.cpp 

[ -f /tmp/bin.wasm ] && rm -f /tmp/bin.wasm || echo "skip"
[ -f bin.wasm ] && cp -f bin.wasm /tmp || echo "skip"