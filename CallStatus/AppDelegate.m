//
//  AppDelegate.m
//  CallStatus
//
//  Created by Simon Maddox on 04/10/2012.
//  Copyright (c) 2012 Simon Maddox. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

// Really, no <CoreTelephony/CoreTelephony.h> ?
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTCall.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
	CTCallCenter *callCenter = [[CTCallCenter alloc] init];
	__block NSString *lastState = nil;
	
	__block void (^block)(void) = ^(void) {
		
		CTCall *call = [[callCenter currentCalls] anyObject];
		
		if (call){
			if (![lastState isEqualToString:call.callState]){
				self.isInCall = YES;	
				lastState = call.callState;
				[self postNotificationWithBody:call.callState];
			}
		} else {
			if (lastState != nil){
				[self postNotificationWithBody:@"CTCallStateDisconnected"]; // this is never fired
				self.isInCall = NO;
			} else {
				if (self.isInCall){
					int64_t delayInSeconds = 3.0;
					dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
					dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
						[self postNotificationWithBody:@"Call Failed"];
					});
					
					self.isInCall = NO;
				}
			}
			lastState = nil;
		}
		
		int64_t delayInSeconds = 0.1;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), block);
	};
	
	block();
	
    return YES;
}

- (void) postNotificationWithBody:(NSString *)body
{
	NSLog(@"Posting: %@", body);
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.alertBody = body;
	[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	
	[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
		
	}];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
