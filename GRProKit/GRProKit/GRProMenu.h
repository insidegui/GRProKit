//
//  GRProMenu.h
//  GRProKit
//
//  Created by Guilherme Rambo on 25/12/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMenu (Dark)
@property (readwrite, nonatomic, setter=setDark:) BOOL isDark;
@end

@interface GRProMenu : NSMenu

+ (void)installGRProMenuImpl:(NSMenu *)menu;

@end
