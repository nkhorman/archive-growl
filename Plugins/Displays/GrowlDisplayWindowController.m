//
//  GrowlDisplayWindowController.m
//  Display Plugins
//
//  Created by Mac-arena the Bored Zo on 2005-06-03.
//  Copyright 2004-2005 The Growl Project. All rights reserved.
//

#import "GrowlDisplayWindowController.h"
#import "GrowlPathUtilities.h"
#import "GrowlDefines.h"
#import "GrowlWindowTransition.h"
#import "GrowlPositionController.h"
#import "NSViewAdditions.h"

static NSMutableDictionary *existingInstances;

static void stopDisplay(CFRunLoopTimerRef timer, void *context) {
#pragma unused(timer)
	[(GrowlDisplayWindowController *)context stopDisplay];
}

@implementation GrowlDisplayWindowController

#pragma mark -
#pragma mark cacheing

+ (void) registerInstance:(id)instance withIdentifier:(NSString *)ident {
	if (!existingInstances)
		existingInstances = [[NSMutableDictionary alloc] init];
	
	NSDictionary *classInstances = nil;
	if (![existingInstances objectForKey:self]) {
		classInstances = [[NSMutableDictionary alloc] init];
		[existingInstances setObject:classInstances forKey:self];
	} else {
		classInstances = [existingInstances objectForKey:self];
	}
	[classInstances setValue:instance forKey:ident];
}

+ (id) instanceWithIdentifier:(NSString *)ident {
	NSMutableDictionary *classInstances = [existingInstances objectForKey:self];
	if (classInstances)
		return [classInstances objectForKey:ident];
	else
		return nil;
}

+ (void) unregisterInstanceWithIdentifier:(NSString *)ident {
	NSMutableDictionary *classInstances = [existingInstances objectForKey:self];
	if (classInstances)
		[classInstances removeObjectForKey:ident];
}

#pragma mark -

- (id) initWithWindow:(NSWindow *)window {
	if ((self = [super initWithWindow:window])) {
		windowTransitions = [[NSMutableDictionary alloc] init];
		ignoresOtherNotifications = NO;
	}

	return self;
}

- (void) dealloc {
	[self stopDisplayTimer];

	[self setDelegate:nil];

	[target              release];
	[clickContext        release];
	[clickHandlerEnabled release];
	[appName             release];
	[appPid              release];
	[windowTransitions   release];

	[super dealloc];
}

#pragma mark -
#pragma mark Screenshot mode

- (void) takeScreenshot {
	NSView *view = [[self window] contentView];
	NSString *path = [[[GrowlPathUtilities screenshotsDirectory] stringByAppendingPathComponent:[GrowlPathUtilities nextScreenshotName]] stringByAppendingPathExtension:@"png"];
	[[view dataWithPNGInsideRect:[view frame]] writeToFile:path atomically:NO];
}

#pragma mark -
#pragma mark Display control

- (BOOL) startDisplay {
	NSWindow *window = [self window];

	//Make sure we don't cover any other notification (or not)
	if (ignoresOtherNotifications || [[GrowlPositionController sharedInstance] reserveRect:[window frame] inScreen:[window screen]]) {
		[self willDisplayNotification];
		[window orderFront:nil];
		[self didDisplayNotification];
		return YES;
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:GrowlDisplayWindowControllerNotificationBlockedNotification 
															object:self];
		return NO;
	}
}

- (void) stopDisplay {
	NSWindow *window = [self window];

	[self willTakeDownNotification];
	[[GrowlPositionController sharedInstance] clearReservedRect:[window frame] inScreen:[window screen]];	//Clear the rect we reserved
	[window orderOut:nil];
	[self didTakeDownNotification];
}

#pragma mark -
#pragma mark Display stages

- (void) willDisplayNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:GrowlDisplayWindowControllerWillDisplayWindowNotification 
														object:self];
}

- (void) didDisplayNotification {
	if (screenshotMode)
		[self takeScreenshot];

	[[NSNotificationCenter defaultCenter] postNotificationName:GrowlDisplayWindowControllerDidDisplayWindowNotification 
														object:self];
}

- (void) willTakeDownNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:GrowlDisplayWindowControllerWillTakeWindowDownNotification 
														object:self];
}

- (void) didTakeDownNotification {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	if (clickContext) {
		NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:2U];
		[userInfo setValue:clickContext forKey:GROWL_KEY_CLICKED_CONTEXT];
		if (appPid)
			[userInfo setValue:appPid forKey:GROWL_APP_PID];
		[nc postNotificationName:GROWL_NOTIFICATION_TIMED_OUT object:appName userInfo:userInfo];
		[userInfo release];

		//Avoid duplicate click messages by immediately clearing the clickContext
		clickContext = nil;
	}
	[nc postNotificationName:GrowlDisplayWindowControllerWillDisplayWindowNotification object:self];
}

#pragma mark -
#pragma mark Display timer

- (void) startDisplayTimer {
	CFRunLoopTimerContext context = {0, self, NULL, NULL, NULL};
	displayTimer = CFRunLoopTimerCreate(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent()+displayDuration, 0, 0, 0, stopDisplay, &context);
	CFRunLoopAddTimer(CFRunLoopGetCurrent(), displayTimer, kCFRunLoopCommonModes);
}

- (void) stopDisplayTimer {
	if (displayTimer) {
		CFRunLoopTimerInvalidate(displayTimer);
		CFRelease(displayTimer);
		displayTimer = NULL;
	}
}

#pragma mark -
#pragma mark Click feedback

- (void) notificationClicked:(id)sender {
#pragma unused(sender)
	if (clickContext) {
		NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:3U];
		[userInfo setValue:clickHandlerEnabled forKey:@"ClickHandlerEnabled"];
		[userInfo setValue:clickContext forKey:GROWL_KEY_CLICKED_CONTEXT];
		if (appPid)
			[userInfo setValue:appPid forKey:GROWL_APP_PID];
		[[NSNotificationCenter defaultCenter] postNotificationName:GROWL_NOTIFICATION_CLICKED 
															object:appName
														  userInfo:userInfo];
		[userInfo release];

		//Avoid duplicate click messages by immediately clearing the clickContext
		clickContext = nil;
	}

	if (target && action && [target respondsToSelector:action])
		[target performSelector:action withObject:self];
}

#pragma mark -
#pragma mark Window Transitions

- (BOOL) addTransition:(GrowlWindowTransition *)transition {
	[transition setWindow:[self window]];
	[transition setDelegate:self];
	if (![windowTransitions objectForKey:[transition class]])
	{
		[windowTransitions setObject:transition forKey:[transition class]];
		return TRUE;
	}
	return FALSE;
}

- (void) removeTransition:(GrowlWindowTransition *)transition {
	[windowTransitions removeObjectForKey:[transition class]];
	[transition setDelegate:nil];
	[transition setWindow:nil];
}

- (NSArray *) allTransitions {
	return (NSArray *)windowTransitions;
}

- (NSArray *) activeTransitions {
	int count = [windowTransitions count];
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
	NSArray *transitionArray = [windowTransitions allValues];

	int i;
	for (i=0; i<count; ++i) {
		GrowlWindowTransition *transition = [transitionArray objectAtIndex:i];
		if ([transition isAnimating])
			[result addObject:transition];
	}

	return (NSArray *)result;
}

- (NSArray *) inactiveTransitions {
	int count = [windowTransitions count];
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
	NSArray *transitionArray = [windowTransitions allValues];

	int i;
	for (i=0; i<count; ++i) {
		GrowlWindowTransition *transition = [transitionArray objectAtIndex:i];
		if (![transition isAnimating])
			[result addObject:transition];	
	}

	return (NSArray *)result;
}

- (void) startAllTransitions {
	[[windowTransitions allValues] makeObjectsPerformSelector:@selector(startAnimation)];
}

- (void) startTransitionOfKind:(Class)transitionClass {
	GrowlWindowTransition *transition = [windowTransitions objectForKey:transitionClass];
	if (transition)
		[transition startAnimation];
}

- (void) stopAllTransitions {
	[[windowTransitions allValues] makeObjectsPerformSelector:@selector(stopAnimation)];
}

- (void) stopTransitionOfKind:(Class)transitionClass {
	GrowlWindowTransition *transition = [windowTransitions objectForKey:transitionClass];
	if (transition)
		[transition stopAnimation];
}

#pragma mark -
#pragma mark Accessors

- (CFTimeInterval) displayDuration {
	return displayDuration;
}

- (void) setDisplayDuration:(CFTimeInterval)newDuration {
	displayDuration = newDuration;
}

#pragma mark -

- (BOOL) screenshotModeEnabled {
	return screenshotMode;
}

- (void) setScreenshotModeEnabled:(BOOL)newScreenshotMode {
	screenshotMode = newScreenshotMode;
}

#pragma mark -

- (NSScreen *) screen {
	NSArray *screens = [NSScreen screens];
	if (screenNumber < [screens count])
		return [screens objectAtIndex:screenNumber];
	else
		return [NSScreen mainScreen];
}

- (void) setScreen:(NSScreen *)newScreen {
	unsigned newScreenNumber = [[NSScreen screens] indexOfObjectIdenticalTo:newScreen];
	if (newScreenNumber == NSNotFound)
		[NSException raise:NSInternalInconsistencyException format:@"Tried to set %@ %p to a screen %p that isn't in the screen list", [self class], self, newScreen];
	[self willChangeValueForKey:@"screenNumber"];
	screenNumber = newScreenNumber;
	[self  didChangeValueForKey:@"screenNumber"];
}

- (void) setScreenNumber:(unsigned)newScreenNumber {
	screenNumber = newScreenNumber;
}

#pragma mark -

- (id) target {
	return target;
}

- (void) setTarget:(id)object {
	if (object != target) {
		[target release];
		target = [object retain];
	}
}

#pragma mark -

- (SEL) action {
	return action;
}

- (void) setAction:(SEL) selector {
	action = selector;
}

#pragma mark -

- (NSString *) notifyingApplicationName {
	return appName;
}

- (void) setNotifyingApplicationName:(NSString *)inAppName {
	if (inAppName != appName) {
		[appName release];
		appName = [inAppName copy];
	}
}

#pragma mark -

- (NSNumber *) notifyingApplicationProcessIdentifier {
	return appPid;
}

- (void) setNotifyingApplicationProcessIdentifier:(NSNumber *)inAppPid {
	if (inAppPid != appPid) {
		[appPid release];
		appPid = [inAppPid retain];
	}
}

#pragma mark -

- (id) clickContext {
	return clickContext;
}

- (void) setClickContext:(id)inClickContext {
	if (clickContext != inClickContext) {
		[clickContext release];
		clickContext = [inClickContext retain];
	}
}

#pragma mark -

- (BOOL) ignoresOtherNotifications {
	return ignoresOtherNotifications;
}

- (void) setIgnoresOtherNotifications:(BOOL)flag {
	ignoresOtherNotifications = flag;
}

#pragma mark -

- (id) delegate {
	return delegate;
}

- (void) setDelegate:(id)newDelegate {
	if (delegate)
		[self removeNotificationObserver:delegate];

	if (newDelegate)
		[self addNotificationObserver:newDelegate];

	delegate = newDelegate;
}

#pragma mark -

- (NSNumber *) clickHandlerEnabled {
	return clickHandlerEnabled;
}

- (void) setClickHandlerEnabled:(NSNumber *)flag {
	if (flag != clickHandlerEnabled) {
		[clickHandlerEnabled release];
		clickHandlerEnabled = [flag retain];
	}
}

#pragma mark -

- (void) addNotificationObserver:(id)observer {
	NSParameterAssert(observer != nil);

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

	if (observer) {
		//register the new delegate.
		if ([observer respondsToSelector:@selector(displayWindowControllerWillDisplayWindow:)])
			[nc addObserver:observer
				   selector:@selector(displayWindowControllerWillDisplayWindow:)
					   name:(NSString *)GrowlDisplayWindowControllerWillDisplayWindowNotification
					 object:self];
		if ([observer respondsToSelector:@selector(displayWindowControllerDidDisplayWindow:)])
			[nc addObserver:observer
				   selector:@selector(displayWindowControllerDidDisplayWindow:)
					   name:(NSString *)GrowlDisplayWindowControllerDidDisplayWindowNotification
					 object:self];

		if ([observer respondsToSelector:@selector(displayWindowControllerWillTakeDownWindow:)])
			[nc addObserver:observer
				   selector:@selector(displayWindowControllerWillTakeWindowDown:)
					   name:(NSString *)GrowlDisplayWindowControllerWillTakeWindowDownNotification
					 object:self];
		if ([observer respondsToSelector:@selector(displayWindowControllerDidTakeWindowDown:)])
			[nc addObserver:observer
				   selector:@selector(displayWindowControllerDidTakeWindowDown:)
					   name:(NSString *)GrowlDisplayWindowControllerDidTakeWindowDownNotification
					 object:self];
		if ([observer respondsToSelector:@selector(displayWindowControllerNotificationBlocked:)])
			[nc addObserver:observer
				   selector:@selector(displayWindowControllerNotificationBlocked:)
					   name:(NSString *)GrowlDisplayWindowControllerNotificationBlockedNotification
					 object:self];
	}
}
- (void) removeNotificationObserver:(id)observer {
	[[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
