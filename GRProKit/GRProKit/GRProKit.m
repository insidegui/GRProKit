//
//  GRProKit.m
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProKit.h"

int GRProApplicationMain(int argc, const char **argv)
{
    [GRProKit install];
    
    return NSApplicationMain(argc, argv);
}

@implementation GRProKit

+ (void)install
{
    [[NSUserDefaults standardUserDefaults] setVolatileDomain:@{@"AppleAquaColorVariant": @6} forName:NSArgumentDomain];
}

+ (BOOL)isInSyrah
{
    NSOperatingSystemVersion version = [NSProcessInfo processInfo].operatingSystemVersion;
    
    return (version.majorVersion >= 10 && version.minorVersion >= 10);
}

@end
