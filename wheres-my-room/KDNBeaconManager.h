//
//  KDNBeaconManager.h
//  BeaconTest
//
//  Created by kaden Chiang on 2015/7/19.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconItem.h"

@class KDNBeaconManager;

@protocol KDNBeaconManagerDelegate <NSObject>

- (void)beaconManager: (KDNBeaconManager *)beaconManager didRangeBeacons:(NSArray *)orderedBeaconItems inRegion: (CLBeaconRegion *)region;

@end

@interface KDNBeaconManager : NSObject<CLLocationManagerDelegate>

@property (weak, nonatomic) id<KDNBeaconManagerDelegate> delegate;
@property (assign, nonatomic) NSInteger returnBeanconCount;

+ (KDNBeaconManager *) sharedInstance;
- (void)addBeaconItem: (BeaconItem *)beaconItem;
- (void)startMonitoring;
- (void)stopMonitoring;

@end
