//
//  GRProTheme.h
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

@interface GRProTheme : NSObject <NSCoding>

+ (instancetype)defaultTheme;

@property (nonatomic, copy) NSColor *windowBackgroundColor;
@property (nonatomic, copy) NSColor *titlebarGradientColor1;
@property (nonatomic, copy) NSColor *titlebarGradientColor2;
@property (nonatomic, copy) NSColor *titlebarSeparatorColor;
@property (nonatomic, copy) NSColor *titlebarTextColor;

@property (nonatomic, copy) NSColor *buttonBackgroundColorEnabledOff;
@property (nonatomic, copy) NSColor *buttonBackgroundColorEnabledOn;
@property (nonatomic, copy) NSColor *buttonBackgroundColorDisabled;
@property (nonatomic, copy) NSColor *buttonBackgroundColorDisabledOff;
@property (nonatomic, copy) NSColor *buttonBackgroundColorDisabledOn;
@property (nonatomic, copy) NSColor *buttonHighlightColor;
@property (nonatomic, copy) NSColor *buttonShadowColor;
@property (nonatomic, copy) NSColor *buttonShadowColor2;

@property (nonatomic, copy) NSColor *defaultButtonBackgroundColor1;
@property (nonatomic, copy) NSColor *defaultButtonBackgroundColor2;

@property (nonatomic, copy) NSColor *labelColor;
@property (nonatomic, copy) NSColor *textFieldBackgroundColor;

@property (nonatomic, copy) NSColor *headerColor;
@property (nonatomic, copy) NSColor *headerTextColor;
@property (nonatomic, copy) NSColor *gridColor;
@property (nonatomic, copy) NSColor *alternateSelectedControlColor;

- (NSImage *)imageNamed:(NSString *)name;

@end
