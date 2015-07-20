//
//  BeaconLocalityManager.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/20/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "BeaconLocalityManager.h"

@interface BeaconLocalityManager ()
@property (strong, nonatomic) NSDictionary *beaconsLocality;
@end

@implementation BeaconLocalityManager
+ (BeaconLocalityManager *) sharedInstance {
    static BeaconLocalityManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    // Make the block to be thread-safe
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[BeaconLocalityManager alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initBeaconsLocality];
    }
    return self;
}

- (void)localityInfoForBeacon:(NSUUID*) uuid complete:(void(^)(BeaconLocalityInfo *beaconLocalityInfo, NSError *error))completion {
    NSString* uuidStr = [uuid UUIDString];
    NSDictionary *beaconDic = self.beaconsLocality[uuidStr];
    if (beaconDic == nil) {
        NSError *err = [[NSError alloc] initWithDomain:@"BeaconLocalityManagerDomain" code:1 userInfo:
                        @{
                          NSLocalizedDescriptionKey: [NSString stringWithFormat: @"Beacon UUID not found: %@", uuidStr]
                          }];

        completion(nil, err);
        return;
    }
    BeaconLocalityInfo *beaconLocalityInfo = [[BeaconLocalityInfo alloc] init];
    beaconLocalityInfo.uuid = uuid;
    NSArray *locationOnMap = beaconDic[@"locationOnMap"];
    beaconLocalityInfo.locationOnMap = CGPointMake([locationOnMap[0] doubleValue], [locationOnMap[1] doubleValue]);
    beaconLocalityInfo.floorOrder = [beaconDic[@"floorOrder"] integerValue];
    completion(beaconLocalityInfo, nil);
}

- (void)initBeaconsLocality {
    self.beaconsLocality =
    @{
      @"49107DFF-D328-4EBD-A47A-076613B658D6": @{
              @"floorOrder": @(12),
              @"locationOnMap": @[@(0.23777565), @(0.74151436)] // LiYu Pond's top-left point
              },
      @"C62BD0D8-432C-4DFC-909D-B678117F8965": @{
              @"floorOrder": @(12),
              @"locationOnMap": @[@(0.40412272), @(0.70931245)] // TsengWen River's bottom-left point
              },
      @"A7500BC2-AD79-4DCA-959D-1C9FF2563FF7": @{
              @"floorOrder": @(12),
              @"locationOnMap": @[@(0.56759348), @(0.74151436)] // XiZi Wan's top-right point
              },
      @"2C0982E6-99AB-4D76-BBE7-012AE2F04270": @{
              @"floorOrder": @(12),
              @"locationOnMap": @[@(0.76222435), @(0.70931245)] // Cijin's bottom-right point
              },
      };
}
@end
