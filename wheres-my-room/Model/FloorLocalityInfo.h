//
//  FloorLocalityInfo.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/18/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Floor.h"

@interface FloorLocalityInfo : NSObject <Floor>
// For 1st floor, it should be 0; for 2nd floor, it should be 1.
@property (assign, nonatomic) NSInteger order;
@property (strong, nonatomic) NSString *mapImageName;

// The real width of the map image in meters.
@property (assign, nonatomic) double realWidthForMap;

// The real height of the map image in meters.
@property (assign, nonatomic) double realHeightForMap;
@end
