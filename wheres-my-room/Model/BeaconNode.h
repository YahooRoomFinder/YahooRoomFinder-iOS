//
//  BeaconNode.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/18/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface BeaconNode : NSObject
@property (strong, nonatomic) NSUUID* uuid;

// Location of the beacon
@property (strong, nonatomic) CLLocation *location;

// Distance in meters
@property (assign, nonatomic) double distance;
@end
