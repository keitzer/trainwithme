//
//  AppDelegate.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	[Parse setApplicationId:@"Wmgt9TmgJIxFgupu4BDhUzKQCCElRIiSYutk5ypA"
				  clientKey:@"HsRD4EIfbxQJcxmpBKRfUx2YwhnsEWheZgldTGJd"];
	
	[SVProgressHUD setFont:[UIFont fontWithName:@"Comfortaa-Bold" size:24]];
	[SVProgressHUD setRingThickness:5];
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
	[SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
	[SVProgressHUD setBackgroundColor:[UIColor colorWithRed:245/255.f green:89/255.f blue:113/255.f alpha:1]];
	[SVProgressHUD setForegroundColor:[UIColor whiteColor]];
	
	[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Comfortaa-Bold" size:24]}];
	
	//this Transluscent nav bar crap is only on iOS 8+... it'll crash pre-8
	if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
		[[UINavigationBar appearance] setTranslucent:NO];
	}
	[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
	[[UITextField appearance] setTintColor:[UIColor colorWithRed:245/255.f green:89/255.f blue:113/255.f alpha:1]];
	[[UITextView appearance] setTintColor:[UIColor colorWithRed:245/255.f green:89/255.f blue:113/255.f alpha:1]];
	
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
	 setTitleTextAttributes:
	 @{NSForegroundColorAttributeName:[UIColor whiteColor],
	   NSFontAttributeName:[UIFont fontWithName:@"Comfortaa-Regular" size:16]
	   }
	 forState:UIControlStateNormal];
	
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
