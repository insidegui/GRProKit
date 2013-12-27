//
//  GRProTableView.m
//  TableViewTest
//
//  Created by Guilherme Rambo on 17/12/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProTableView.h"
#import "GRThemeStore.h"
#import "GRProLabel.h"
#import "GRProFont.h"
#import "GRProColor.h"

#define kProTableViewTextLeftMargin 12.0
#define kProTableViewStandardRowHeight 22.0

@interface GRProTextFieldCell : NSTextFieldCell
+ (NSShadow *)proTextFieldShadow;
+ (NSParagraphStyle *)proParagraphStyle;
@end

@implementation NSTableHeaderCell (GRProKit)

- (void)drawWithFrame:(CGRect)cellFrame highlighted:(BOOL)isHighlighted inView:(NSView *)view
{
    CGRect fillRect, borderRect;
    CGRectDivide(cellFrame, &borderRect, &fillRect, 1.0, CGRectMaxYEdge);
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.265 green:0.265 blue:0.272 alpha:1.000] endingColor:[NSColor colorWithCalibratedRed:0.185 green:0.185 blue:0.195 alpha:1.000]];
    [gradient drawInRect:fillRect angle:90.0];
    
    [GRProColor drawNoiseTextureInRect:fillRect];
    
    [[NSColor colorWithCalibratedRed:0.115 green:0.114 blue:0.123 alpha:1.000] set];
    NSRectFill(borderRect);
    
    NSRectFill(NSMakeRect(cellFrame.origin.x+NSWidth(cellFrame), 0, 1.0, NSHeight(cellFrame)));
    
    [[NSColor colorWithCalibratedRed:0.112 green:0.112 blue:0.115 alpha:1.000] set];
    NSRectFill(NSMakeRect(0, 0, NSWidth(view.frame), 1.0));
    
    [self drawInteriorWithFrame:CGRectInset(fillRect, kProTableViewTextLeftMargin, 6.0) inView:view];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSDictionary *attributes = @{NSFontAttributeName: [GRProFont proLabelFont], NSForegroundColorAttributeName : [NSColor colorWithCalibratedRed:0.81f green:0.81f blue:0.81f alpha:1.0f], NSShadowAttributeName : [GRProTextFieldCell proTextFieldShadow], NSParagraphStyleAttributeName : [GRProTextFieldCell proParagraphStyle]};
    [self.stringValue drawInRect:cellFrame withAttributes:attributes];
}

- (void)drawWithFrame:(CGRect)cellFrame inView:(NSView *)view
{
    [self drawWithFrame:cellFrame highlighted:NO inView:view];
}

- (void)highlight:(BOOL)isHighlighted withFrame:(NSRect)cellFrame inView:(NSView *)view
{
    [self drawWithFrame:cellFrame highlighted:isHighlighted inView:view];
}

@end

@implementation GRProTextFieldCell

+ (NSShadow *)proTextFieldShadow
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.3];
    shadow.shadowOffset = NSMakeSize(0,0);
    shadow.shadowBlurRadius = 2.0;
    return shadow;
}

+ (NSParagraphStyle *)proParagraphStyle
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    
    return [style copy];
}

- (id)initTextCell:(NSString *)aString
{
    self = [super initTextCell:aString];
    if(!self) return nil;
    
    [self initializeCustomLook];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self) return nil;
    
    [self initializeCustomLook];
    
    return self;
}

- (void)initializeCustomLook
{
    self.textColor = [NSColor colorWithCalibratedRed:0.84f green:0.84f blue:0.84f alpha:1.0f];
    [self setTruncatesLastVisibleLine:YES];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSShadow *shadow = [GRProTextFieldCell proTextFieldShadow];
    shadow.shadowColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.4];
    
    NSColor *textColor;
    
    NSFont *font = [GRProFont proLabelFont];
    
    NSRect finalTextRect = cellFrame;
    finalTextRect.size.width -= kProTableViewTextLeftMargin;
    finalTextRect.origin.x += kProTableViewTextLeftMargin;
    
    if (self.isHighlighted) {
        textColor = [NSColor colorWithCalibratedWhite:1.0 alpha:1.0];
    } else {
        textColor = [NSColor colorWithCalibratedRed:0.81f green:0.81f blue:0.81f alpha:1.0f];
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName : textColor, NSShadowAttributeName : shadow, NSParagraphStyleAttributeName : [GRProTextFieldCell proParagraphStyle]};
    [self.stringValue drawInRect:finalTextRect withAttributes:attributes];
}

@end

@implementation GRProTableView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(!self) return nil;
    
    [self initializeCustomLook];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self) return nil;
    
    [self initializeCustomLook];
    [self setIntercellSpacing:NSMakeSize(0, 8)];
    
    return self;
}

// based on: http://stackoverflow.com/questions/7038709/change-highlighting-color-in-nstableview-in-cocoa
- (void)highlightSelectionInClipRect:(NSRect)theClipRect
{
    NSRange visibleRowIndexes = [self rowsInRect:theClipRect];
    NSIndexSet *selectedRowIndexes = [self selectedRowIndexes];
    unsigned long row = visibleRowIndexes.location;
    unsigned long endRow = row + visibleRowIndexes.length;
    NSGradient *gradient;
    
    // if the view is focused, use highlight color, otherwise use the out-of-focus highlight color
    if (self == [[self window] firstResponder] && [[self window] isMainWindow] && [[self window] isKeyWindow])
    {
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.202 green:0.341 blue:0.580 alpha:1.000] endingColor:[NSColor colorWithCalibratedRed:0.157 green:0.265 blue:0.446 alpha:1.000]];
    } else {
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.350 green:0.391 blue:0.423 alpha:1.000] endingColor:[NSColor colorWithCalibratedRed:0.272 green:0.296 blue:0.329 alpha:1.000]];
    }
    
    // draw highlight for the visible, selected rows
    for (row = row; row < endRow; row++)
    {
        if([selectedRowIndexes containsIndex:row])
        {
            NSRect selectionRect = [self rectOfRow:row];
            NSBezierPath *path = [NSBezierPath bezierPathWithRect:selectionRect]; //6.0
            
            [gradient drawInBezierPath:path angle:90];
        }
    }
}

- (void)initializeCustomLook
{
    NSRect headerRect = self.headerView.frame;
    headerRect.size.height = 32.0;
    self.headerView.frame = headerRect;
    self.backgroundColor = [NSColor colorWithCalibratedRed:0.16f green:0.16f blue:0.17f alpha:1.0f];
    self.rowHeight = kProTableViewStandardRowHeight;
}

- (void)drawBackgroundInClipRect:(NSRect)dirtyRect
{
    [self.backgroundColor setFill];
    NSRectFill(self.frame);
}

@end
