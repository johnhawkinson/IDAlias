Force alias resolution in NSSavePanels under 10.7 for
recalcitrant applications. Such as InDesign. And also
10.8 (Mountain Lion)

This addresses the problems seen in http://forums.adobe.com/thread/950652.

This is alpha-quality software.

Install [IDAlias.dylib](https://github.com/johnhawkinson/IDAlias/blob/master/dist/IDAlias.dylib?raw=true) in ~/Library
and then run

    launchctl setenv DYLD_INSERT_LIBRARIES ~/Library/IDAlias.dylib

and restart InDesign.

This method of installation will affect other apps, which might not be
wise.
