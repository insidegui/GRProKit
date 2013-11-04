//
//  AppDelegate.m
//  GRProKit Demo App
//
//  Created by Guilherme Rambo on 31/10/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
{
    double currentProgress;
    NSTimer *_progressTimer;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.box.title = @"Hello, Pro World!";
}
- (IBAction)proButtonClicked:(id)sender {
    self.alert = [[GRProAlert alloc] init];
    
    self.alert.title = @"This is a Pro Alert!";
    self.alert.informativeText = @"The Pro Alert has the beautiful Pro Window look, and works just like a NSAlert :)";

    if (self.runModalCheck.intValue) {
        self.alert.completionHandler = ^(NSUInteger result){
            NSLog(@"alert modal finished with result %ld", result);
        };
        [self.alert runModal];
    } else {
        [self.alert beginSheetModalForWindow:self.window completionHandler:^(NSUInteger result) {
            NSLog(@"alert sheet finished with result %ld", result);
        }];
    }
}
- (IBAction)preferences:(id)sender {
    [self.preferencesWindow makeKeyAndOrderFront:sender];
}

- (void)updateProgress:(NSTimer *)timer
{
    currentProgress++;
    self.progressBar.doubleValue = currentProgress;
    if (currentProgress >= 100) {
        currentProgress = 0;
        [timer invalidate];
        [self.progressBar stopAnimation:nil];
    }
}

- (IBAction)startProgress:(id)sender {
    [self.progressBar startAnimation:sender];
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
}
- (IBAction)proItem:(id)sender {
}
- (IBAction)otherItem:(id)sender {
}

@end
