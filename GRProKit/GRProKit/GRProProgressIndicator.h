//
//  GRProProgressIndicator.h
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*
 GRProProgressIndicator - A NSProgressIndicator subclass
 This class adds a sublayer to the progress indicator and uses CIFilters to change the look of the standard indicator
 The pro indicator has reduced brightness and saturation
 */

@interface GRProProgressIndicator : NSProgressIndicator

@end
