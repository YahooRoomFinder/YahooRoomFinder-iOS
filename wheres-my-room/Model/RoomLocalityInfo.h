//
//  RoomLocalityInfo.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/18/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@interface RoomLocalityInfo : NSObject
@property (strong, nonatomic) NSString *roomId;
@property (assign, nonatomic) CGPoint ratioLocation;
@property (assign, nonatomic) double ratioWidth;
@property (assign, nonatomic) double ratioHeight;
@end
