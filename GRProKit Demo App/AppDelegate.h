//
//  AppDelegate.h
//  GRProKit Demo App
//
//  Created by Guilherme Rambo on 31/10/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GRProKit/GRProKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet GRProWindow *window;
@property (weak) IBOutlet GRProBox *box;

@property (nonatomic, strong) GRProAlert *alert;
@property (weak) IBOutlet GRProButton *runModalCheck;
@property (weak) IBOutlet GRProProgressIndicator *progressBar;
@property (unsafe_unretained) IBOutlet GRProWindow *preferencesWindow;

@end
