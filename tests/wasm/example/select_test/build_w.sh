# rm -rf *.wasm
# rm -rf *.bc


clang++ \
  -target cheerp-wasm \
  -cheerp-linear-heap-size=8 \
  -cheerp-linear-output=wast \
  -o output.js -O3 \
  -cheerp-avoid-wasm-traps \
  main.cpp
mv *.wast debug.lua  

clang++ \
  -target cheerp-wasm \
  -cheerp-linear-heap-size=2 \
  -cheerp-linear-output=wasm \
  -cheerp-no-icf \
  -o bin.js -O3 \
  -cheerp-pretty-code \
  -cheerp-wasm-disable=sharedmem,growmem,returncalls \
  -cheerp-avoid-wasm-traps \
  main.cpp 

  

