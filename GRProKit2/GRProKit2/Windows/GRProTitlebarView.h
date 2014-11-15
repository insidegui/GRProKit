//
//  GRProTitlebarView.h
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

@class NSThemeFrame;

@interface GRProTitlebarView : NSView

@property BOOL transparent;
@property BOOL drawsSeparator;

@property (nonatomic, assign) NSVisualEffectBlendingMode blendingMode;
@property (nonatomic, assign) NSVisualEffectMaterial material;
@property (nonatomic, assign) NSVisualEffectState state;

@end
