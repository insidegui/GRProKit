//
//  GRProAlert.h
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GRProWindow.h"
#import "GRProButton.h"
#import "GRProLabel.h"

typedef void(^AlertCompletionHandlerBlockType)(NSUInteger);

@interface GRProAlert : NSObject

- (void)runModal;
- (void)beginSheetModalForWindow:(NSWindow *)hostWindow completionHandler:(void (^)(NSUInteger))handler;

@property (nonatomic, assign) NSUInteger result;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *informativeText;
@property (nonatomic, assign) BOOL showCancelButton;

@property (nonatomic, assign) AlertCompletionHandlerBlockType completionHandler;

@property (nonatomic, copy) NSString *okButtonTitle;
@property (nonatomic, copy) NSString *cancelButtonTitle;

@property (weak) IBOutlet GRProLabel *titleLabel;
@property (weak) IBOutlet GRProLabel *informativeTextLabel;

@property (strong) IBOutlet GRProWindow *window;
@property (weak) IBOutlet GRProButton *cancelButton;
@property (weak) IBOutlet GRProButton *okButton;


@end
