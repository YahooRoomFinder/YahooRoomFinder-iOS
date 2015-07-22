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

- (void)localityInfoForBeacons:(NSArray*) uuids complete:(void(^)(NSArray *beaconLocalityInfos, NSError *error))completion {
    NSMutableArray *beaconLocalityInfos = [NSMutableArray array];
    for (NSUUID *uuid in uuids) {
        NSString* uuidStr = [uuid UUIDString];
        NSDictionary *beaconDic = self.beaconsLocality[uuidStr];
        if (beaconDic == nil) {
            continue;
        }
        BeaconLocalityInfo *beaconLocalityInfo = [[BeaconLocalityInfo alloc] init];
        beaconLocalityInfo.uuid = uuid;
        NSArray *locationOnMap = beaconDic[@"locationOnMap"];
        beaconLocalityInfo.locationOnMap = CGPointMake([locationOnMap[0] doubleValue], [locationOnMap[1] doubleValue]);
        beaconLocalityInfo.floorOrder = [beaconDic[@"floorOrder"] integerValue];
        [beaconLocalityInfos addObject:beaconLocalityInfo];
    }
    completion(beaconLocalityInfos, nil);
}

- (void)initBeaconsLocality {
    self.beaconsLocality =
    @{
      @"49107DFF-D328-4EBD-A47A-076613B658D6": @{ // 1
              //@"floorOrder": @(11),
              //@"locationOnMap": @[@(0.23777565), @(0.74151436)] // LiYu Pond's top-left point
              @"floorOrder": @(13),
              @"locationOnMap": @[@(0.3999039846), @(0.00872600349)] // Top-left of TaipeiArena + Scicence Museum
              },
      @"C62BD0D8-432C-4DFC-909D-B678117F8965": @{  // 2
              //@"floorOrder": @(11),
              //@"locationOnMap": @[@(0.40412272), @(0.70931245)] // TsengWen River's bottom-left point
              @"floorOrder": @(13),
              @"locationOnMap": @[@(0.3999039846), @(0.2434554974)] // Bottom-left of TaipeiArena + Scicence Museum
              },
      @"A7500BC2-AD79-4DCA-959D-1C9FF2563FF7": @{ // 3
              //@"floorOrder": @(11),
              //@"locationOnMap": @[@(0.56759348), @(0.74151436)] // XiZi Wan's top-right point
              @"floorOrder": @(13),
              @"locationOnMap": @[@(0.5986557849), @(0.2434554974)] // Bottom-right of TaipeiArena + Scicence Museum
              },
      @"2C0982E6-99AB-4D76-BBE7-012AE2F04270": @{ // 4
              //@"floorOrder": @(11),
              //@"locationOnMap": @[@(0.76222435), @(0.70931245)] // Cijin's bottom-right point
              @"floorOrder": @(13),
              @"locationOnMap": @[@(0.5986557849), @(0.007853403141)] // Top-right of TaipeiArena + Scicence Museum
              },
      };
}
@end
