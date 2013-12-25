//
//  GRProKit.h
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GRProWindow.h"
#import "GRProToolbar.h"
#import "GRProLabel.h"
#import "GRProSplitView.h"
#import "GRProBox.h"
#import "GRProButton.h"
#import "GRProAlert.h"
#import "GRProProgressIndicator.h"
#import "GRProTableView.h"

int GRProApplicationMain(int argc, const char **argv);

@interface GRProKit : NSObject

+ (void)install;

@end

