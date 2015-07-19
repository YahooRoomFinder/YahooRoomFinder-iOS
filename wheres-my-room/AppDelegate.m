//
//  AppDelegate.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/15/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "AppDelegate.h"
#import "View/FloorMapViewController.h"
#import "View/FloorsViewController.h"
#import "View/FloorMapViewController2.h"
#import "Control/Utils.h"
#import "KDNBeaconManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.window.rootViewController = [[MapViewController alloc] init];
    //self.window.rootViewController = [Utils embedNavBarForViewController:[[FloorsViewController alloc] init]];
    //self.window.rootViewController = [[FloorMapViewController alloc] init];
    self.window.rootViewController = [Utils embedNavBarForViewController:[[FloorMapViewController2 alloc] init]];
    [self.window makeKeyAndVisible];

    // notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:
         [UIUserNotificationSettings
          settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
          categories:nil
          ]
         ];
    }
    
    // beacon
    self.beaconManager = [KDNBeaconManager sharedInstance];
    self.beaconManager.delegate = self;
    [self loadBeaconItems];
    [self.beaconManager setReturnBeanconCount:3];
    [self.beaconManager startMonitoring];
    
    return YES;
}

- (void) loadBeaconItems {

    NSDictionary *existedBeaconInfo = @{
        @"49107DFF-D328-4EBD-A47A-076613B658D6": @[@"kdnbcn1", @3066, @1],
        @"C62BD0D8-432C-4DFC-909D-B678117F8965": @[@"kdnbcn2", @3066, @2],
        @"A7500BC2-AD79-4DCA-959D-1C9FF2563FF7": @[@"kdnbcn3", @3066, @3],
        @"2C0982E6-99AB-4D76-BBE7-012AE2F04270": @[@"kdnbcn4", @3066, @4],
        };
    
    self.beaconItems = [NSArray array];
    for (NSString *uuidString in existedBeaconInfo) {
        NSArray *item = existedBeaconInfo[uuidString];
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
        BeaconItem *beaconItem = [[BeaconItem alloc]
                                  initWithName:item[0]
                                  uuid:uuid major:[item[1] integerValue]
                                  minor:[item[2] integerValue]
                                  ];
        [self.beaconManager addBeaconItem:beaconItem];
        NSLog(@"load %@", uuidString);
    }

}

-(void)beaconManager:(KDNBeaconManager *)beaconManager didRangeBeacons:(NSArray *)orderedBeaconItems inRegion:(CLBeaconRegion *)region
{
    NSLog(@"== Beacon Order ==");
    for (BeaconItem *item in orderedBeaconItems) {
        NSString *proximityString;
        switch (item.proximity) {
            case CLProximityUnknown:
                proximityString = @"Unknown";
                break;
            case CLProximityFar:
                proximityString = @"Far";
                break;
            case CLProximityNear:
                proximityString = @"Near";
                break;
            case CLProximityImmediate:
                proximityString = @"Immediate";
                break;
        }
        NSLog(@"%@ %.2lfm %@", [item name], [item accuracy], proximityString);
    }
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
