Force alias resolution in NSSavePanels under 10.7 for
recalcitrant applications. Such as InDesign. And also
10.8 (Mountain Lion)

This addresses the problems seen in http://forums.adobe.com/thread/950652.

This is beta-quality[*] software.

Install IDAlias.dylib in ~/Library
Versions are OS-dependent  
10.7	[IDAlias.dylib](https://github.com/johnhawkinson/IDAlias/blob/master/dist/10.7/IDAlias.dylib?raw=true)  
10.8    [IDAlias.dylib](https://github.com/johnhawkinson/IDAlias/blob/master/dist/10.8/IDAlias.dylib?raw=true)  

and then run

    launchctl setenv DYLD_INSERT_LIBRARIES ~/Library/IDAlias.dylib

and restart InDesign.

This method of installation will affect other apps, which might not be
wise.


---
[*] It was "alpha-quality" for 3 years and no one complained, so I guess now
it can be "beta-quality."