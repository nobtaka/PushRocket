//
//  PRAppDelegate.m
//  PushRocket
//
//  Created by MATSUMOTO, Keiichiro on 2013/09/16.
//  Copyright (c) 2013年 nobtaka. All rights reserved.
//

#import "PRAppDelegate.h"
#import "Orbiter.h"

@implementation PRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    LoggerSetViewerHost(NULL, (CFStringRef)@"MosbprLogger", (UInt32)57088);
    LoggerSetOptions(NULL, kLoggerOption_BufferLogsUntilConnection |
                           kLoggerOption_UseSSL |
                           kLoggerOption_BrowseBonjour);

    XLog(@"app", XLOG_TRACE, @"application didFinishLaunchingWithOptions");
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound)];
    
    return YES;
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"application didRegisterForRemoteNotificationsWithDeviceToken");
    
    NSURL *serverURL = [NSURL URLWithString:@"http://fast-sea-8622.herokuapp.com/push_notification"];
    Orbiter *orbiter = [[Orbiter alloc] initWithBaseURL:serverURL credential:nil];
    [orbiter registerDeviceToken:deviceToken withAlias:nil success:^(id responseObject) {
        XLog(@"app", XLOG_TRACE, @"Registration Success: %@", responseObject);
    } failure:^(NSError *error) {
        XLog(@"app", XLOG_ERROR, @"Registration Error: %@", error);
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    XLog(@"app", XLOG_TRACE, @"application didFailToRegisterForRemoteNotificationsWithError");
    XLog(@"app", XLOG_ERROR, @"Registration Error: %@", error);
}


@end
