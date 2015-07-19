//
//  BeaconItem.h
//  BeaconTest
//
//  Created by kaden Chiang on 2015/7/15.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface BeaconItem : NSObject <NSCoding>

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSUUID *uuid;
@property (assign, nonatomic, readonly) CLBeaconMajorValue majorValue;
@property (assign, nonatomic, readonly) CLBeaconMinorValue minorValue;
@property (assign, nonatomic) CLProximity proximity;
@property (assign, nonatomic) CLLocationAccuracy accuracy;

- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor;

- (instancetype) initWithName: (NSString *)name beacon: (CLBeacon *)beacon;


@end