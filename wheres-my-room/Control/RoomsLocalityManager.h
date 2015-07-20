//
//  RoomsManager.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/FloorLocalityInfo.h"

@interface RoomsLocalityManager : NSObject

+ (RoomsLocalityManager *) sharedInstance;

// Get all the floors
// floors: array of FloorLocalityInfo instances
- (void) floors:(void(^)(NSArray *floors, NSError *error))completion;

- (void) floorForOrder:(NSInteger) floorOrder complete:(void(^)(FloorLocalityInfo *floor, NSError *error))completion;

// Get all the rooms of the given floor.
// rooms: array of RoomLocalityInfo instances
- (void) roomsForFloorWithOrder:(NSInteger)floorOrder complete:(void(^)(NSArray *rooms, NSError *error))completion;
@end
