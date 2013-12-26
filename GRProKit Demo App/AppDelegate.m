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
    NSArray *_people;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _people = @[
                @{@"name": @"John Appleseed", @"email" : @"johnappleseed@apple.com"},
                @{@"name": @"Steve Jobs", @"email" : @"sjobs@apple.com"},
                @{@"name": @"Phil Schiller", @"email" : @"pschiller@apple.com"},
                @{@"name": @"Jonathan Ive", @"email" : @"ive@apple.com"},
                @{@"name": @"Joe Bloggs", @"email" : @"joe@apple.com"}
                ];
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
    
    self.box.title = @"Hello, Pro World!";
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _people.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([tableView.identifier isEqualToString:@"name"]) {
        return _people[row][@"name"];
    } else {
        return _people[row][@"email"];
    }
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
- (IBAction)submenuItemAction:(id)sender {
}
- (IBAction)anotherSubitemAction:(id)sender {
}

@end
