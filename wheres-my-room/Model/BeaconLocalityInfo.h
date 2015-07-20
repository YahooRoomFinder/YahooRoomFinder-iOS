//
//  BeaconNode.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/18/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreGraphics/CGGeometry.h>

@interface BeaconLocalityInfo : NSObject
@property (strong, nonatomic) NSUUID* uuid;

// The order of the floor where the beacon is at. 0 for 1st floor.
@property (assign, nonatomic) NSInteger floorOrder;

// Location of the beacon on the map.
// The x and y represent the ratio on the map, and are between 0 and 1.
@property (assign, nonatomic) CGPoint locationOnMap;
@end
