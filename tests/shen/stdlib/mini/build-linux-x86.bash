clang++ \
  -target cheerp-wasm \
  -cheerp-linear-heap-size=128 \
  -cheerp-linear-output=wast \
  -cheerp-pretty-code \
  -o output.js \
  main.cpp
  
  
clang++ \
  -target cheerp-wasm \
  -cheerp-linear-heap-size=128 \
  -cheerp-linear-output=wasm \
  -cheerp-pretty-code \
  -o bin.js \
  main.cpp