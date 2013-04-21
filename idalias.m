/* #xxx #import "ACCalculatorOverrides.h" */
#import "IDAlias.h"
 
#include <stdio.h>
#include <objc/Object.h>
#include <objc/runtime.h>
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
 
static IMP NSSavePanel_URLs = NULL;
 
@interface IDAlias:Object
{
}
@end

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
  NSArray *urlArray;
  int count;

    // We first call the original method
    urlArray = NSSavePanel_URLs(self, @selector(URLs), self);
     
    // Run our custom code
    if ((count = [urlArray count])) {
      int i;

      for (i=0; i<count; i++) {
	fprintf(stderr, "URL:  %s\n",
		[[[urlArray objectAtIndex:i] path] UTF8String]);
	fprintf(stderr, " std: %s\n",
		[[[[urlArray objectAtIndex:i] URLByResolvingSymlinksInPath] path] UTF8String]);
      }

    }
    return urlArray;
}
 
@end
