// from http://blog.timac.org/?p=761
// Simple code injection using DYLD_INSERT_LIBRARIES
// Posted: December 18th, 2012
// Author: Timac aka Alexandre Colucci
// Filed under: code injection, Debugging, DYLD_INSERT_LIBRARIES, MacOSX, Programming
// | No Comments

/* #import "ACCalculatorOverrides.h" */
 
#include <stdio.h>
#include <objc/runtime.h>
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
 
static IMP sOriginalImp = NULL;
 
@implementation ACCalculatorOverrides
 
+(void)load
{
    // We replace the method -[CalculatorController showAbout:] with the method -[ACCalculatorOverrides patchedShowAbout:]
    Class originalClass = NSClassFromString(@"CalculatorController");
    Method originalMeth = class_getInstanceMethod(originalClass, @selector(showAbout:));
    sOriginalImp = method_getImplementation(originalMeth);
     
    Method replacementMeth = class_getInstanceMethod(NSClassFromString(@"ACCalculatorOverrides"), @selector(patchedShowAbout:));
    method_exchangeImplementations(originalMeth, replacementMeth);
}
 
-(void)patchedShowAbout:(id)sender
{
    // We first call the original method to display the original About Box
    sOriginalImp(self, @selector(showAbout:), self);
     
    // Run our custom code which simply display an alert
    NSAlert *alert = [NSAlert alertWithMessageText:@"Code has been injected!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"The code has been injected using DYLD_INSERT_LIBRARIES into Calculator.app"];
    [alert runModal];
}
 
@end
