//
//  CUINamedImage.h
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

@interface CUINamedImage : NSObject

@property(copy, nonatomic) NSString *name;
@property(readonly, nonatomic) BOOL hasSliceInformation;
@property(readonly, nonatomic) long long resizingMode;
@property(readonly, nonatomic) int blendMode;
@property(readonly, nonatomic) double opacity;
@property(readonly, nonatomic) double scale;
@property(readonly, nonatomic) NSSize size;
@property(readonly, nonatomic) CGImageRef image;

- (id)initWithName:(id)arg1 usingRenditionKey:(id)arg2 fromTheme:(unsigned long long)arg3;

@end
