all: IDAlias.dylib # CalculatorOverrides.dylib # IDAlias64.dylib 

debug:
	make CFLAGS=-DDEBUG

# VERSION=0.0.0		# hash: 01770378595d447b64764d88fb8add27483ca815
# VERSION=0.0.1		# hash: 63112aaec9429d6785d071543e975223d4a43aca
VERSION=0.0.2

clean:
	rm -f IDAlias.dylib IDAlias64.dylib CalculatorOverride.dylib
	rm -rf IDAlias.dylib.dSYM

IDAlias.dylib: IDAlias.m
	gcc -g -Wall \
	  $(CFLAGS) \
	  -current_version ${VERSION} \
	  -arch i386 -arch x86_64 \
	  -framework AppKit -framework Foundation \
	  -o $@ \
	  -lobjc -dynamiclib \
	  $<

# IDAlias64.dylib: IDAlias.m
# 	gcc -g -arch x86_64 -framework AppKit -framework Foundation -o IDAlias64.dylib -lobjc -dynamiclib IDAlias.m

CalculatorOverrides.dylib: CalculatorOverrides.m
	gcc -arch x86_64 -framework AppKit -framework Foundation -o $@ -lobjc -dynamiclib $<
