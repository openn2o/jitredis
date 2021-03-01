include ./make.inc
WORKSPACE=./

JSTARGET=$(WORKSPACE)build/app.min.js
JSTMP=$(WORKSPACE)build/tmpa.js
VERSION=0.0.1
COPY_RIGHT=agent.zy@aliyun.cn
CC=clang

.PHONY: clear debug main

clear: 
	@rm -f $(WORKSPACE)build/*.js && echo "=====main is build===="
	@echo "// VERSION $(VERSION)" > $(JSTMP);
	
	
jsbriage:$(JSTMP)
	#$(call __define__,$(WORKSPACE)/src/,dssa_modu.js,$(JSTMP));
	$(call __definedir__,$(WORKSPACE)/src/,$(JSTMP));
	
all: clear jsbriage 
	@echo "=====main publish version build done===="
	mv  $(JSTMP) $(JSTARGET)

wasi:
	node run.js --wasm-opt