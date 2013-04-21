all: idalias.dylib idalias64.dylib CalculatorOverrides.dylib

idalias.dylib: idalias.m
	gcc -g -arch i386 -arch x86_64 -framework AppKit -framework Foundation -o idalias.dylib -lobjc -dynamiclib idalias.m

idalias64.dylib: idalias.m
	gcc -g -arch x86_64 -framework AppKit -framework Foundation -o idalias64.dylib -lobjc -dynamiclib idalias.m

CalculatorOverrides.dylib: CalculatorOverrides.m
	gcc -arch x86_64 -framework AppKit -framework Foundation -o $@ -lobjc -dynamiclib $<
