//
//  KDNBeaconManager.m
//  BeaconTest
//
//  Created by kaden Chiang on 2015/7/19.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import "KDNBeaconManager.h"
#import "AppDelegate.h"

@interface KDNBeaconManager ()

@property (strong, nonatomic) NSMutableArray *itemIndexes;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableDictionary *dictBeaconItems;
@property (strong, nonatomic) NSMutableDictionary *dictBeaconRegion;
@property (assign, nonatomic) BOOL isMonitoring;

@end

@implementation KDNBeaconManager

+ (KDNBeaconManager *) sharedInstance
{
    static KDNBeaconManager *instance = nil;
    static dispatch_once_t onceTocken;
    
    dispatch_once(&onceTocken, ^{
        if (instance == nil) {
            instance = [[KDNBeaconManager alloc] init];
        }
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.dictBeaconItems = [NSMutableDictionary dictionary];
        self.dictBeaconRegion = [NSMutableDictionary dictionary];
        self.itemIndexes = [NSMutableArray array];
        self.isMonitoring = NO;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.activityType = CLActivityTypeFitness;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        [self.locationManager requestAlwaysAuthorization];
    }

    return self;
}

- (void)addBeaconItem: (BeaconItem *)beaconItem
{
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconItem.uuid
                                                                           major:beaconItem.majorValue
                                                                           minor:beaconItem.minorValue
                                                                      identifier:beaconItem.name];
    [beaconRegion setNotifyEntryStateOnDisplay:YES];
    
    beaconItem.proximity = CLProximityUnknown;
    beaconItem.accuracy = -1;
    
    NSString *uuidString = [beaconItem.uuid UUIDString];
    [self.dictBeaconItems setObject:beaconItem forKey:uuidString];
    [self.dictBeaconRegion setObject:beaconRegion forKey:uuidString];
    [self.itemIndexes addObject:uuidString];
    
//    NSLog(@"add %@ %@ %@", [beaconItem.uuid UUIDString], self.dictBeaconItems, self.dictBeaconRegion);
    
    if (self.isMonitoring) {
        [self.locationManager startMonitoringForRegion:beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }

}

- (void)startMonitoring
{
    NSLog(@"startMonitoring %ld", [self.dictBeaconRegion count]);
    if (self.isMonitoring == NO) {
        for (NSString *uuidString in self.dictBeaconRegion) {
//            NSLog(@"%@", [self.dictBeaconRegion[uuidString] description]);
            [self.locationManager startMonitoringForRegion:self.dictBeaconRegion[uuidString]];
            [self.locationManager startRangingBeaconsInRegion:self.dictBeaconRegion[uuidString]];
        }
        self.isMonitoring = YES;
    }
}

- (void)stopMonitoring
{
    if (self.isMonitoring == YES) {
        for (NSString *uuidString in self.dictBeaconRegion) {
            [self.locationManager stopMonitoringForRegion:self.dictBeaconRegion[uuidString]];
            [self.locationManager stopRangingBeaconsInRegion:self.dictBeaconRegion[uuidString]];
        }
        self.isMonitoring = NO;
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"didEnterRegion");
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date];
        notification.alertBody = [NSString stringWithFormat:@"Want book %@?", [beaconRegion identifier]];
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
//    NSLog(@"locationManager: didRangeBeacons:");
//    NSLog(@"region: %@", region);
    if ([beacons count] == 0) {
        return;
    }
    for (CLBeacon *beacon in beacons) {
//        NSLog(@"beacon: %@", beacon);
        NSString *uuidString = [[beacon proximityUUID] UUIDString];
//        NSLog(@"uuid: %@, proximity: %ld, accuracy: %f", uuidString, (long)beacon.proximity, beacon.accuracy);
        
        
        BeaconItem *item = [self.dictBeaconItems objectForKey:uuidString];
        item.proximity = beacon.proximity;
        item.accuracy = beacon.accuracy;
        
        [self.itemIndexes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *uuid1 = (NSString *)obj1;
            NSString *uuid2 = (NSString *)obj2;
            
            BeaconItem *item1 = self.dictBeaconItems[ uuid1 ];
            BeaconItem *item2 = self.dictBeaconItems[ uuid2 ];
            
            if (item1.accuracy == item2.accuracy) {
                return NSOrderedSame;
            } else if (item1.accuracy == -1) {
                return NSOrderedDescending;
            } else if (item2.accuracy == -1) {
                return NSOrderedAscending;
            } else if (item1.accuracy < item2.accuracy) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];

        NSMutableArray *retItems = [NSMutableArray arrayWithCapacity:[self.itemIndexes count]];
        [self.itemIndexes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (self.returnBeanconCount > 0 && self.returnBeanconCount <= [retItems count]) {
                *stop = YES;
                return;
            }
            [retItems addObject:self.dictBeaconItems[obj]];
        }];
        
        [self.delegate beaconManager:self didRangeBeacons:retItems inRegion:region];
    }
}

@end
