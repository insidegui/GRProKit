//
//  GRProProgressIndicator.m
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProProgressIndicator.h"
#import <QuartzCore/QuartzCore.h>

@implementation GRProProgressIndicator
{
    CALayer *_effectLayer;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(!self) return nil;

    [self setupLayerEffects];
    
    return self;
}

- (void)awakeFromNib
{
    [self setupLayerEffects];
}

- (void)setupLayerEffects
{
    if (_effectLayer) return;
    
    // make view layer backed
    self.wantsLayer = YES;
    
    // create a layer that will be above the progress indicator
    // this layer is transparent, we just use It to apply effects to the underlying view
    _effectLayer = [CALayer layer];
    _effectLayer.frame = self.frame;
    _effectLayer.cornerRadius = 4.0;
    _effectLayer.backgroundColor = [[NSColor whiteColor] CGColor];
    _effectLayer.opacity = 0;
    [self.layer addSublayer:_effectLayer];
    
    // adjust the exposure to make the progress bar dimmer
    CIFilter *adjustExposure = [CIFilter filterWithName:@"CIExposureAdjust"];
    [adjustExposure setValue:@-2 forKey:@"inputEV"];
    // adjust the saturation to make the progress bar 'black and white'
    CIFilter *adjustVibrance = [CIFilter filterWithName:@"CIVibrance"];
    [adjustVibrance setValue:@-1 forKey:@"inputAmount"];
    
    // add effects to the effect layer
    _effectLayer.backgroundFilters = @[adjustExposure, adjustVibrance];
}

@end
