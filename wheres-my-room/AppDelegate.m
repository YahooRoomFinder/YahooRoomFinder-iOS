//
//  AppDelegate.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/15/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "AppDelegate.h"
#import "View/FloorsViewController.h"
#import "View/FloorMapViewController2.h"
#import "Control/RoomDetailControllerViewController.h"
#import "Control/Utils.h"
#import "KDNBeaconManager.h"
#import "FavoriteRoomListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = [[MapViewController alloc] init];
//    self.window.rootViewController = [Utils embedNavBarForViewController:[[FloorsViewController alloc] init]];
//    self.window.rootViewController = [[FloorMapViewController alloc] init];
//    self.window.rootViewController = [Utils embedNavBarForViewController:[[FloorMapViewController2 alloc] init]];
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController setViewControllers:@[
                                                [Utils embedNavBarForViewController:[[FloorMapViewController2 alloc] init]],
                                                [Utils embedNavBarForViewController:[[FavoriteRoomListViewController alloc] init]],
                                                [Utils embedNavBarForViewController:[[RoomDetailControllerViewController alloc] init]]                                                ]];
    [self.window setRootViewController:self.tabBarController];
    
    [self.window makeKeyAndVisible];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTranslucent:NO];
    
    // notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:
         [UIUserNotificationSettings
          settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge
          categories:nil
          ]
         ];
    }
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
