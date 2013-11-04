//
//  GRProButton.h
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

/*
 GRProButton - This class should be used in the place of NSButtons.
 You need to set the button's cell to be a GRProButtonCell (for buttons), GRProCheckboxCell (for checkboxes) or GRProRadioCell (for radio buttons)
 The cell class can be set in interface builder
 */

#import <Cocoa/Cocoa.h>

@interface GRProButton : NSButton

@property (nonatomic, assign, setter = setDefault:) BOOL isDefault;

@end

// regular button cell
@interface GRProButtonCell : NSButtonCell

@end

// checkbox button cell
@interface GRProCheckboxCell : NSButtonCell

@end

// radio button cell
@interface GRProRadioButtonCell : GRProCheckboxCell

@end

// popup button cell
@interface GRProPopUpButtonCell : NSPopUpButtonCell

@end