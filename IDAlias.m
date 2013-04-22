// IDAlias.m
// Force alias resolution in NSSavePanels under 10.8 for
// recalcitrant applications. Such as InDesign. Only load
// ourselves in apps on our list (InDesign and InCopy).
// 
// John Hawkinson <jhawk@mit.edu>
// 21 April 2013
// 
// Derived from an example by Alexandre Colucci (timac.org)

#include <stdio.h>
#include <objc/Object.h>
#include <objc/runtime.h>
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
 
static IMP NSSavePanel_URLs = NULL;
 
@interface IDAlias:NSObject
{
}
@end

@implementation IDAlias
 
+(void)load
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];

    NSArray *appsToUse = [NSArray arrayWithObjects:
				  @"Adobe InDesign",
				  @"Adobe InCopy",
				  nil];
    
    /* Of the methods discussed in 
     * Technical Q&A QA1544
     * Obtaining the localized application name in Cocoa
     * http://developer.apple.com/library/mac/#qa/qa1544/_index.html
     *
     * only methods (3) and (5) return useful strings for InDesign at this
     * stage; the others return null:
     *
     * [[NSProcessInfo processInfo] processName]
     * returns <Adobe InDesign CS5>
     *
     * -[NSBundlebundlePath]
     * returns <Adobe InDesign CS5.app>
     */

    NSString *procName = [[NSProcessInfo processInfo] processName];

    NSEnumerator *i = [appsToUse objectEnumerator];
    id id;
    BOOL found = NO;
    while ((id = [i nextObject])) {
	if ([procName rangeOfString:id].location == 0)
	    found = YES;
    }

    if (!found) {
#if DEBUG
	NSLog(@"IDAlias in proc <%@> not ID/IC. Punting.", procName);
#endif
	return;
    }

    NSLog(@"IDAlias interposing -[NSSavePanel URLs] in process <%@>.",
	  procName);

    Class originalClass = NSClassFromString(@"NSSavePanel");
    Method originalMeth = class_getInstanceMethod(originalClass,
						  @selector(URLs));
    NSSavePanel_URLs = method_getImplementation(originalMeth);
     
    Method replacementMeth = class_getInstanceMethod(
			         NSClassFromString(@"IDAlias"),
				 @selector(URLs));
    method_exchangeImplementations(originalMeth, replacementMeth);

    [pool drain];
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
#ifdef DEBUG
	fprintf(stderr, "URL:  %s\n",
		[[url path] UTF8String]);
#endif

	
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
#ifdef DEBUG
	  NSLog(@"IDAlias replaced path with realPath:%@", [realURL path]);
#endif
      }

    }
    return urlArray;
}
 
@end
