all: IDAlias.dylib # CalculatorOverrides.dylib # IDAlias64.dylib 

clean:
	rm -f IDAlias.dylib IDAlias64.dylib CalculatorOverride.dylib

IDAlias.dylib: IDAlias.m
	gcc -g \
	  -arch i386 -arch x86_64 \
	  -framework AppKit -framework Foundation \
	  -o $@ \
	  -lobjc -dynamiclib \
	  $<

# IDAlias64.dylib: IDAlias.m
# 	gcc -g -arch x86_64 -framework AppKit -framework Foundation -o IDAlias64.dylib -lobjc -dynamiclib IDAlias.m

CalculatorOverrides.dylib: CalculatorOverrides.m
	gcc -arch x86_64 -framework AppKit -framework Foundation -o $@ -lobjc -dynamiclib $<
