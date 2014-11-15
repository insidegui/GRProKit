//
//  GRProThemeReflection.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRProThemeReflection.h"

#import <GRProKit2/GRProTheme.h>

#import <objc/runtime.h>

static const char *getPropertyType(objc_property_t property);

@implementation GRProThemeReflection

+ (NSArray *)proThemeProperties
{
    static NSArray *_properties;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unsigned int outCount, i;
        
        objc_property_t *properties = class_copyPropertyList([GRProTheme class], &outCount);
        NSMutableArray *outArray = [[NSMutableArray alloc] initWithCapacity:outCount];
        
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            if (!propertyName) continue;
            
            const char *propertyType = getPropertyType(property);
            NSDictionary *propertyDescriptor = @{@"name": [NSString stringWithUTF8String:propertyName],
                                                 @"type": [NSString stringWithUTF8String:propertyType]};
            [outArray addObject:propertyDescriptor];
        }
        
        _properties = [outArray copy];
    });
    
    return _properties;
}

@end

// source: http://stackoverflow.com/a/755127/2271555
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}