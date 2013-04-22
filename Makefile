all: IDAlias.dylib # CalculatorOverrides.dylib # IDAlias64.dylib 

# VERSION=0.0.0		# hash: 01770378595d447b64764d88fb8add27483ca815
VERSION=0.0.1

clean:
	rm -f IDAlias.dylib IDAlias64.dylib CalculatorOverride.dylib

IDAlias.dylib: IDAlias.m
	gcc -g \
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
