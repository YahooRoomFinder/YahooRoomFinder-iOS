//
//  RoomLocalityInfo.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/18/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomLocalityInfo : NSObject
@property (strong, nonatomic) NSString *roomId;

// Array of CLLocation instances
@property (strong, nonatomic) NSArray *boundary;
@end
