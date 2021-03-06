#rm -rf *.wasm
#rm -rf *.bc



/Applications/cheerp/bin/clang++ \
  -target cheerp-wasm \
  -cheerp-linear-heap-size=2 \
  -cheerp-linear-output=wasm \
  -cheerp-no-icf \
  -cheerp-pretty-code \
  -o bin.js -O3\
  -cheerp-wasm-disable=sharedmem,growmem,returncalls \
  -cheerp-avoid-wasm-traps \
  main.cpp 

[ -f /tmp/bin.wasm ] && rm -f /tmp/bin.wasm || echo "skip"
[ -f bin.wasm ] && cp -f bin.wasm /tmp || echo "skip"