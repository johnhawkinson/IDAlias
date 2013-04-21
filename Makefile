all: idalias.dylib CalculatorOverrides.dylib

idalias.dylib: idalias.m
	gcc -arch i386 -framework AppKit -framework Foundation -o idalias.dylib -lobjc -dynamiclib idalias.m

CalculatorOverrides.dylib: CalculatorOverrides.m
	gcc -arch x86_64 -framework AppKit -framework Foundation -o $@ -lobjc -dynamiclib $<
