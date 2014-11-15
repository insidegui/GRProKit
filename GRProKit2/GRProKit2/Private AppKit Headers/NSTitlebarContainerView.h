/*
 *     Generated by class-dump 3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2012 by Steve Nygard.
 */

@import Cocoa;

@class NSThemeFrame;

@interface NSTitlebarContainerView : NSView

@property BOOL shouldRoundCorners; // @synthesize shouldRoundCorners=_shouldRoundCorners;
@property NSThemeFrame *associatedThemeFrame; // @synthesize associatedThemeFrame=_associatedThemeFrame;
@property BOOL transparent; // @synthesize transparent=_transparent;
@property double buttonRevealAmount; // @dynamic buttonRevealAmount;
@property(readonly) double titleHeightToHideInFullScreen; // @dynamic titleHeightToHideInFullScreen;
- (BOOL)layer:(id)arg1 shouldInheritContentsScale:(double)arg2 fromWindow:(id)arg3;
- (void)updateLayer;
- (void)_setCornerMaskIfNeeded;
- (void)_clearCornerMaskIfNeeded;
- (BOOL)wantsUpdateLayer;
- (id)_nextResponderForEvent:(id)arg1;
- (struct CGSRegionObject *)_regionForOpaqueDescendants:(struct CGRect)arg1 forMove:(BOOL)arg2 forUnderTitlebar:(BOOL)arg3;
- (BOOL)mouseDownCanMoveWindow;
- (id)menuForEvent:(id)arg1;
- (id)_themeFrame;
- (void)dealloc;

@end

