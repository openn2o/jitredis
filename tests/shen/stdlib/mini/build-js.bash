clang++ \
  -target cheerp \
  -cheerp-pretty-code \
  -o dist.js -DOS_TYPE=1\
  main.cpp
node dist.js
  
