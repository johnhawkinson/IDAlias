/* #xxx #import "ACCalculatorOverrides.h" */
#import "IDAlias.h"
 
#include <stdio.h>
#include <objc/runtime.h>
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
 
static IMP sOriginalImp = NULL;
 
@implementation IDAlias
 
+(void)load
{
    // We replace the method -[CalculatorController showAbout:] with
    // the method -[ACCalculatorOverrides patchedShowAbout:]
    Class originalClass = NSClassFromString(@"NSSavePanel");
    Method originalMeth = class_getInstanceMethod(originalClass, @selector(URLs));
    sOriginalImp = method_getImplementation(originalMeth);
     
    Method replacementMeth = class_getInstanceMethod(NSClassFromString(@"IDAlias"), @selector(URLs));
    method_exchangeImplementations(originalMeth, replacementMeth);
}
 
-(NSArray*)URLs
{
  NSArray *urlArray;

    // We first call the original method to display the original About Box
    urlArray = sOriginalImp(self, @selector(URLs), self);
     
    // Run our custom code which simply display an alert
#if 0
    NSAlert *alert = [NSAlert alertWithMessageText:@"Code has been injected!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"The code has been injected using DYLD_INSERT_LIBRARIES into Calculator.app"];
    [alert runModal];
#endif

    fprintf(stderr, "[NSSavePanel URLs] returned %d\n", (int)[urlArray count]);
    return urlArray;
}
 
@end
