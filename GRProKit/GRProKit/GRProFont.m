//
//  GRProFont.m
//  GRProKit
//
//  Created by Guilherme Rambo on 25/12/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProFont.h"
#import <objc/runtime.h>

@implementation GRProFont

+ (void)load
{
    Method m0 = class_getClassMethod([NSFont class], @selector(systemFontOfSize:));
    Method m1 = class_getClassMethod([self class], @selector(systemFontOfSize:));
    method_exchangeImplementations(m0, m1);
}

+ (NSRect)preferredFontBoundingBox
{
    return kGRProKitPreferredFontBoundingBox;
}

+ (BOOL)CTFontIsDefaultProFont:(CTFontRef)font
{
    NSRect bbox = CTFontGetBoundingBox(font);
    NSRect pbbox = [self preferredFontBoundingBox];
    
    return  bbox.size.width == pbbox.size.width && bbox.size.height == pbbox.size.height;
}

+ (CGFloat)menuFontSize
{
    return kGRProKitDefaultFontSize+1;
}

+ (NSFont *)systemFontOfSize:(CGFloat)fontSize
{
    return [NSFont fontWithName:[NSString stringWithUTF8String:kGRProKitFontName] size:kGRProKitDefaultFontSize];
}

+ (NSFont *)proLabelFont
{
    NSFontDescriptor *descriptor = [NSFontDescriptor fontDescriptorWithName:[NSString stringWithUTF8String:kGRProKitFontName] size:kGRProKitDefaultFontSize];
    return [NSFont fontWithDescriptor:[descriptor fontDescriptorWithSymbolicTraits:NSFontBoldTrait] size:kGRProKitDefaultFontSize];
}

+ (NSFont *)proControlFont
{
    NSFontDescriptor *descriptor = [NSFontDescriptor fontDescriptorWithName:[NSString stringWithUTF8String:kGRProKitFontName] size:kGRProKitDefaultFontSize-1];
    return [NSFont fontWithDescriptor:descriptor size:kGRProKitDefaultFontSize-1];
}

@end
