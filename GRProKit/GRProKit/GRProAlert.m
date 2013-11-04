//
//  GRProAlert.m
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProAlert.h"



@implementation GRProAlert
{
    NSModalSession _modalSession;
}
- (id)init
{
    self = [super init];
    if(!self) return nil;
    
    self.okButtonTitle = @"Ok";
    self.cancelButtonTitle = @"Cancel";
    
    return self;
}

- (void)setupPanel
{
    [[NSBundle bundleForClass:[GRProAlert class]] loadNibNamed:@"GRProAlert" owner:self topLevelObjects:nil];
    
    [self.okButton setDefault:YES];
    
    NSColor *labelColor = [NSColor colorWithCalibratedWhite:0.642 alpha:1.000];
    NSShadow *labelShadow = [[NSShadow alloc] init];
    labelShadow.shadowBlurRadius = 0.5;
    labelShadow.shadowOffset = NSMakeSize(0, 1);
    labelShadow.shadowColor = [NSColor colorWithCalibratedWhite:0 alpha:0.7];
    
    [self.titleLabel setTextColor:labelColor];
    [self.titleLabel setShadow:labelShadow];
    [self.informativeTextLabel setTextColor:labelColor];
    [self.informativeTextLabel setShadow:labelShadow];
    
    self.window.hideTrafficLights = YES;
}

- (void)runModal
{
    [self setupPanel];
    
    _modalSession = [[NSApplication sharedApplication] beginModalSessionForWindow:self.window];
    
    [self.window makeKeyAndOrderFront:self];
}

- (void)beginSheetModalForWindow:(NSWindow *)hostWindow completionHandler:(void (^)(NSUInteger))handler
{
    [self setupPanel];
    self.completionHandler = handler;
    [[NSApplication sharedApplication] beginSheet:self.window modalForWindow:hostWindow modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    // when the sheet finishes, we call the completion handler, if available
    if(self.completionHandler) self.completionHandler(self.result);
}

- (IBAction)okAction:(id)sender {
    self.result = 1;
    [self doCloseWindow];
}

- (IBAction)cancelAction:(id)sender {
    self.result = 0;
    [self doCloseWindow];
}

- (void)doCloseWindow
{
    if ([self.window isSheet]) {
        [[NSApplication sharedApplication] endSheet:self.window];
        [self.window close];
    } else {
        // if we have a completion handler, we call It
        if(self.completionHandler) self.completionHandler(self.result);
        
        [[NSApplication sharedApplication] endModalSession:_modalSession];
        [self.window close];
    }
}


@end
