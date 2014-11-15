//
//  GRProApplication.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRProApplication.h"

@interface GRProApplication ()
- (void)insertInMainMenu;
@end

@implementation GRProApplication

- (void)finishLaunching
{
    [super finishLaunching];
    
#ifdef DEBUG
    if ([[NSBundle bundleWithPath:@"/Library/Frameworks/FScript.framework"] load]) {
        [NSClassFromString(@"FScriptMenuItem") performSelector:@selector(insertInMainMenu)];
    }
#endif
}

#ifdef DEBUG
- (void)insertInMainMenu
{
    return;
}
#endif

@end
