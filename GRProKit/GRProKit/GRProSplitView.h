//
//  GRProSplitView.h
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

/*
 This is a subclass of NSSplitView that basically hides the divider, so we keep only the functionality but not the look.
 Designed specifically to use with GRProBox, which already has kind of a bottom divider (a black line)
 */

#import <Cocoa/Cocoa.h>

@interface GRProSplitView : NSSplitView

@end
