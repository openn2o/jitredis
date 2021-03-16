clean:
	rm -f *.so
	rm -f *.xo


all: 
	gcc -I. -DALLOW_TRACE=1 -W -Wall -fno-common -std=c99 -O2 \
	-c ./suma_apollo_core.c -o suma.xo -fPIC 
	gcc -o sumavlib.so suma.xo -shared -L./ -lluajit
	cp -f sumavlib.so /lib64/sumavlib.so
	[ ! -f /lib64/libluajit-5.1.so.2 ] && ln -s libluajit.so /lib64/libluajit-5.1.so.2 || echo "skip"
	echo "build done"


osx:
	gcc -I. -DALLOW_TRACE=1 -W -Wall -fno-common -std=c99 -O2 \
	-c ./suma_apollo_core.c -o suma.xo 
	gcc -o sumavlib.so suma.xo -shared
	cp -f sumavlib.so /tmp/sumavlib.so
	echo "build done"
