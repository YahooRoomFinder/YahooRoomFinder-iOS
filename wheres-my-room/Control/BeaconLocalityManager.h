//
//  BeaconLocalityManager.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/20/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/BeaconLocalityInfo.h"

@interface BeaconLocalityManager : NSObject
+ (BeaconLocalityManager *) sharedInstance;
- (void)localityInfoForBeacons:(NSArray*) uuid complete:(void(^)(NSArray *beaconLocalityInfos, NSError *error))completion;
@end
