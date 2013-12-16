//
//  GRProProgressIndicator.m
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProProgressIndicator.h"
#import <QuartzCore/QuartzCore.h>

// progress bar corner radius
#define kProgressBarCornerRadius 3.0

// defines the width and spacing of the "water" particles
#define kParticleWidth 34.0
#define kParticleSpacing 15.0

// defines the duration of each animation step,
// tweak this to change animation behavior
#define kProgressIndicatorAnimationSleepInterval 0.02

// defines the duration of the animation used
// when doubleValue is changed
#define kDoubleValueAnimationDuration 0.3

@interface GRProProgressIndicator ()

@property (nonatomic, assign) double internalDoubleValue;

@end

@implementation GRProProgressIndicator
{
    // cached data
    NSColor *_particleGrad1;
    NSColor *_particleGrad2;
    NSGradient *_particleGradient;
    NSImage *_bezelTopLeftCorner;
    NSImage *_bezelTopEdgeFill;
    NSImage *_bezelTopRightCorner;
    NSImage *_bezelLeftEdgeFill;
    NSImage *_bezelCenterFill;
    NSImage *_bezelRightEdgeFill;
    NSImage *_bezelBottomLeftCorner;
    NSImage *_bezelBottomEdgeFill;
    NSImage *_bezelBottomRightCorner;
    NSGradient *_progressBarGradient;
    NSGradient *_progressBarLineGradient;
    NSColor *_indeterminateGradientColor0;
    NSColor *_indeterminateGradientColor1;
    NSColor *_indeterminateGradientColor2;
    NSColor *_indeterminateGradientColor3;
    NSGradient *_indeterminateGradient;
    
    // theme colors
    NSColor *_gradientColor0;
    NSColor *_gradientColor1;
    NSColor *_gradientColor2;
    NSColor *_gradientColor3;
    NSColor *_gradientColor4;
    NSColor *_inactiveGradientColor0;
    NSColor *_inactiveGradientColor1;
    NSColor *_inactiveGradientColor2;
    NSColor *_inactiveGradientColor3;
    NSColor *_inactiveGradientColor4;
    
    // defines if we are currently animating or not
    BOOL _animating;
    
    // animation counter
    int _currentAnimationStep;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // initialize images used to draw our bezel
        _bezelTopLeftCorner = [[GRThemeStore proThemeStore] imageNamed:@"pi_topLeft"];
        _bezelTopEdgeFill = [[GRThemeStore proThemeStore] imageNamed:@"pi_topFill"];
        _bezelTopRightCorner = [[GRThemeStore proThemeStore] imageNamed:@"pi_topRight"];
        _bezelLeftEdgeFill = [[GRThemeStore proThemeStore] imageNamed:@"pi_leftFill"];
        _bezelCenterFill = [[GRThemeStore proThemeStore] imageNamed:@"pi_centerFill"];
        _bezelRightEdgeFill = [[GRThemeStore proThemeStore] imageNamed:@"pi_rightFill"];
        _bezelBottomLeftCorner = [[GRThemeStore proThemeStore] imageNamed:@"pi_bottomLeft"];
        _bezelBottomEdgeFill = [[GRThemeStore proThemeStore] imageNamed:@"pi_bottomFill"];
        _bezelBottomRightCorner = [[GRThemeStore proThemeStore] imageNamed:@"pi_bottomRight"];
        
        // setup defaults
        self.minValue = 0;
        self.maxValue = 100;
        self.doubleValue = 0;
        [self setupTheme];
    }
    return self;
}

- (void)setupTheme
{
    _gradientColor0 = kProgressBarProGradientColor0;
    _gradientColor1 = kProgressBarProGradientColor1;
    _gradientColor2 = kProgressBarProGradientColor2;
    _gradientColor3 = kProgressBarProGradientColor3;
    _gradientColor4 = kProgressBarProGradientColor4;
    _inactiveGradientColor0 = kProgressBarInactiveGradientColor0;
    _inactiveGradientColor1 = kProgressBarInactiveGradientColor1;
    _inactiveGradientColor2 = kProgressBarInactiveGradientColor2;
    _inactiveGradientColor3 = kProgressBarInactiveGradientColor3;
    _inactiveGradientColor4 = kProgressBarInactiveGradientColor4;
    
    if(!_animating) [self setNeedsDisplay:YES];
}

// setup our observation of the window's properties
- (void)viewDidMoveToWindow
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowKeyChanged:) name:NSWindowDidBecomeKeyNotification object:self.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowKeyChanged:) name:NSWindowDidResignKeyNotification object:self.window];
}

- (void)windowKeyChanged:(NSNotification *)notification
{
    _progressBarGradient = nil;
    
    // we avoid calling setNeedsDisplay: while animation is on to prevent glitches
    if(!_animating) [self setNeedsDisplay:YES];
}

- (void)setDoubleValue:(double)doubleValue
{
    // the setting of the doubleValue is not animated if the new value is less than
    // the current value and if the PI is indeterminate
    if (doubleValue > _doubleValue && !self.isIndeterminate) {
        self.animator.internalDoubleValue = doubleValue;
    } else {
        self.internalDoubleValue = doubleValue;
    }
    
    _doubleValue = doubleValue;
}

- (void)setInternalDoubleValue:(double)internalDoubleValue
{
    _internalDoubleValue = internalDoubleValue;
    
    // we only call setNeedsDisplay: if the animation is not in progress,
    // if we where to call It during animation, this could cause glitches
    if(!_animating) [self setNeedsDisplay:YES];
}

- (void)setIndeterminate:(BOOL)indeterminate
{
    _indeterminate = indeterminate;
}

// calculate the rect of the progress bar inside based on the current doubleValue
- (NSRect)progressBarRect
{
    double scaledDoubleValue;
    
    if (_indeterminate) {
        scaledDoubleValue = _maxValue;
    } else {
        scaledDoubleValue = _internalDoubleValue*(_maxValue-_minValue)/_maxValue-_minValue;
    }
    
    return NSMakeRect(1, 2, round(scaledDoubleValue/_maxValue*NSWidth(self.frame)), NSHeight(self.frame)-3);
}

- (void)startAnimation:(id)sender
{
    if(_animating) return;
    
    // detach a new thread to handle animation updates
    [NSThread detachNewThreadSelector:@selector(render:) toTarget:self withObject:nil];
}

- (void)stopAnimation:(id)sender
{
    if(!_animating) return;
    
    _animating = NO;
    [self setNeedsDisplay:YES];
}

- (id)animationForKey:(NSString *)key
{
    // our internalDoubleValue is used to make the value increments smoother
    if ([key isEqualToString:@"internalDoubleValue"]) {
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.duration = kDoubleValueAnimationDuration;
        
        return animation;
    }
    
    return [super animationForKey:key];
}

// animation thread loop
- (void)render:(id)sender
{
    @autoreleasepool {
        
        // we are now animating
        _animating = YES;
        
        // animation loop
        while (_animating) {
            // the animation happens until it's walked back the width of a particle,
            // when this is the case, the frame will look the same as in the start, so we go back and loop
            if(_currentAnimationStep >= kParticleWidth) _currentAnimationStep = 0;
            
            _currentAnimationStep++;
            
            // render the view
            [self setNeedsDisplay:YES];
            
            // delay to control framerate
            [NSThread sleepForTimeInterval:kProgressIndicatorAnimationSleepInterval];
        }
        
    }
    
    [NSThread exit];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // draw bezel using nine images
    NSDrawNinePartImage(dirtyRect, _bezelTopLeftCorner, _bezelTopEdgeFill, _bezelTopRightCorner, _bezelLeftEdgeFill, _bezelCenterFill, _bezelRightEdgeFill, _bezelBottomLeftCorner, _bezelBottomEdgeFill, _bezelBottomRightCorner, NSCompositeSourceOver, 1.0, NO);
    
    // this will limit our drawing to the inside of the bezel
    NSRect clipRect = NSMakeRect(1, 2, NSWidth(self.frame)-2, NSHeight([self progressBarRect]));
    [[NSBezierPath bezierPathWithRoundedRect:clipRect xRadius:kProgressBarCornerRadius yRadius:kProgressBarCornerRadius] addClip];
    
    // draw progress bar
    [self drawProgressBar];
    
    // draw particle animation step if needed
    if(_animating) {
        if (!self.isIndeterminate) {
            [self drawAnimationStep];
        } else {
            [self drawIndeterminateAnimationStep];
        }
    }
}

// this method is responsible of drawing the progress bar itself
- (void)drawProgressBar
{
    if (self.doubleValue <= 0) return;
    
    NSRect progressBarRect = [self progressBarRect];
    
    // determine the correct gradient and shadow colors based on
    // the window's key state, the system's appearance preferences and current theme
    if(!_progressBarGradient) {
        if ([self.window isKeyWindow]) {
                _progressBarGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                        _gradientColor0, 0.0,
                                        _gradientColor1, 0.48,
                                        _gradientColor2, 0.49,
                                        _gradientColor3, 0.82,
                                        _gradientColor4, 1.0, nil];
        } else {
            _progressBarGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                    _inactiveGradientColor0, 0.0,
                                    _inactiveGradientColor1, 0.48,
                                    _inactiveGradientColor2, 0.49,
                                    _inactiveGradientColor3, 1.0, nil];
        }
    }
    
    // the progress bar rectangle
    NSBezierPath *rectanglePath = [NSBezierPath bezierPathWithRect:progressBarRect];
    [_progressBarGradient drawInBezierPath: rectanglePath angle: -90];
    
    // draw line after progress bar
    
    if(!_progressBarLineGradient) _progressBarLineGradient = [[NSGradient alloc] initWithStartingColor: kProgressBarProgressLineGradient0 endingColor: kProgressBarProgressLineGradient1];
    
    NSBezierPath *progressLinePath = [NSBezierPath bezierPathWithRect: NSMakeRect(NSWidth(progressBarRect)+1, progressBarRect.origin.y, 1, NSHeight(progressBarRect))];
    [_progressBarLineGradient drawInBezierPath: progressLinePath angle: 90];
}


// this method is responsible of drawing the aqua "water" particles animation
- (void)drawAnimationStep
{
    // initialize colors and gradient only once
    if(!_particleGrad1) {
        _particleGrad1 = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 0.07];
        _particleGrad2 = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 0];
        _particleGradient = [[NSGradient alloc] initWithStartingColor: _particleGrad1 endingColor: _particleGrad2];
    }
    
    // get progress rect and check if it's empty
    NSRect progressBarRect = [self progressBarRect];
    NSBezierPath *progressPath = [NSBezierPath bezierPathWithRoundedRect:progressBarRect xRadius:kProgressBarCornerRadius yRadius:kProgressBarCornerRadius];
    // if the rect is empty we don't do anything
    if ([progressPath isEmpty]) return;
    
    // limits the drawing of the particles to be only inside the progress area
    [progressPath addClip];
    
    // calculate how many particles we can fit inside the progress rect and add some extra for good luck :P
    int particlePitch = round(NSWidth(progressBarRect)/kParticleWidth)+2;
    
    // value used to calculate the X position of a particle
    CGFloat particleDelta = kParticleWidth+kParticleSpacing-kParticleWidth/2;
    
    for (int i = 0; i < particlePitch; i++) {
        // calculate X position of particle
        CGFloat particleX = (i*particleDelta)-_currentAnimationStep;
        
        // make circle used do draw the particle's gradient
        NSBezierPath *particlePath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(particleX, 3, kParticleWidth, 15)];
        [NSGraphicsContext saveGraphicsState];
        [[NSGraphicsContext currentContext] setCompositingOperation:NSCompositePlusLighter];
        [particlePath addClip];
        
        // draw particle gradient
        NSPoint gradientPoint = NSMakePoint(particleX+17, NSHeight(self.frame)/2.0);
        NSGradientDrawingOptions options = NSGradientDrawsBeforeStartingLocation | NSGradientDrawsAfterEndingLocation;
        [_particleGradient drawFromCenter: gradientPoint radius: 0
                                 toCenter: gradientPoint radius: 12.72
                                  options: options];
        
        [NSGraphicsContext restoreGraphicsState];
    }
}

// this method is responsible of drawing the stripes animation when the PI is indeterminate
- (void)drawIndeterminateAnimationStep
{
#define kIndeterminateParticleWidth 34.0
#define kIndeterminateParticleSpacing 16.0
    
    if(!_indeterminateGradient) {
        _indeterminateGradientColor0 = [NSColor colorWithCalibratedRed: 0.917 green: 0.917 blue: 0.916 alpha: 1];
        _indeterminateGradientColor1 = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 1];
        _indeterminateGradientColor2 = [NSColor colorWithCalibratedRed: 0.951 green: 0.951 blue: 0.951 alpha: 1];
        _indeterminateGradientColor3 = [NSColor colorWithCalibratedRed: 0.907 green: 0.907 blue: 0.907 alpha: 1];
        
        _indeterminateGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                  _indeterminateGradientColor0, 0.0,
                                  _indeterminateGradientColor1, 0.48,
                                  _indeterminateGradientColor2, 0.49,
                                  _indeterminateGradientColor3, 1.0, nil];
    }
    
    NSRect progressBarRect = [self progressBarRect];
    int particlePitch = round(NSWidth(progressBarRect)/kIndeterminateParticleWidth)+2;
    
    CGFloat particleDelta = kIndeterminateParticleWidth+kIndeterminateParticleSpacing-kIndeterminateParticleWidth/2;
    
    for (int i = 0; i < particlePitch; i++) {
        CGFloat particleX = (i*particleDelta)+_currentAnimationStep;
        
        NSBezierPath *particlePath = [NSBezierPath bezierPath];
        [particlePath moveToPoint: NSMakePoint(particleX-10, NSHeight(self.frame))];
        [particlePath lineToPoint: NSMakePoint(particleX+kIndeterminateParticleWidth/2-30, NSHeight(self.frame))];
        [particlePath lineToPoint: NSMakePoint(particleX+kIndeterminateParticleWidth-30, 0)];
        [particlePath lineToPoint: NSMakePoint(particleX+kIndeterminateParticleWidth/2-30, 0)];
        [particlePath lineToPoint: NSMakePoint(particleX-30, NSHeight(self.frame))];
        [particlePath closePath];
        [_indeterminateGradient drawInBezierPath:particlePath angle:-90];
    }
}

@end