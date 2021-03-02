rm -rf *.wasm

clang++ \
  -target cheerp-wasm \
  -cheerp-linear-heap-size=128 \
  -cheerp-linear-output=wasm \
  -cheerp-pretty-code \
  -cheerp-no-icf \
  -o bin.js \
  -cheerp-global-prefix=g \
  -cheerp-avoid-wasm-traps \
  main.cpp