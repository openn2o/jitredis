
#  wangwenbo@alibaba-inc.com @2017

define __main__
	cat $1 >> $2
endef

define __define__
    @cat $1$2>>$3
endef

define __case__
    @cd $1$2 && $3 $4 $2.js 
endef

define __version__
    @echo "//\version[$2]\;" > $1 
	@cat $(HEADER) >> $1 
endef

define __definedir__
    @cat $1/*.js >> $2
endef

define __defineluadir__
	@cat $1/*.lua >> $2
endef

