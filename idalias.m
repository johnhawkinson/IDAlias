#include <stdio.h>
#include <objc/Object.h>
#include <objc/runtime.h>
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
 
static IMP NSSavePanel_URLs = NULL;
 
#if 0
@interface IDAlias:Object
{
}
@end
#endif

@implementation IDAlias
 
+(void)load
{
    Class originalClass = NSClassFromString(@"NSSavePanel");
    Method originalMeth = class_getInstanceMethod(originalClass, @selector(URLs));
    NSSavePanel_URLs = method_getImplementation(originalMeth);
     
    Method replacementMeth = class_getInstanceMethod(NSClassFromString(@"IDAlias"), @selector(URLs));
    method_exchangeImplementations(originalMeth, replacementMeth);
}
 
-(NSArray*)URLs
{
  int count;
  NSError *error = nil;
  NSMutableArray *urlArray;

    // We first call the original method
    urlArray = NSSavePanel_URLs(self, @selector(URLs), self);
     
    // Run our custom code
    if ((count = [urlArray count])) {
      int i;

      for (i=0; i<count; i++) {
	NSURL *url = [urlArray objectAtIndex:i];
	fprintf(stderr, "URL:  %s\n",
		[[url path] UTF8String]);

	
	NSData *alias = [NSURL bookmarkDataWithContentsOfURL:url error:&error];
	if (alias == NULL) {
	  // Not an alias! A-OK!
	  continue;
	}

	BOOL isStale;
	NSURL *realURL = [NSURL URLByResolvingBookmarkData:alias options:0
					     relativeToURL:nil
				       bookmarkDataIsStale:&isStale
						     error:&error];
	if (isStale || realURL == NULL) {
	  NSLog(@"IDAlias failed alias resolution: %@", error);
	}

	[urlArray replaceObjectAtIndex:i withObject:realURL];
	if (0) { // debugging
	  NSLog(@"IDAlias replaced path with realPath:%@", [realURL path]);
	}
      }

    }
    return urlArray;
}
 
@end
