//
//  MeetingSchedule.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingSchedule : NSObject
@property (strong, nonatomic) NSArray *meetings;
@property (strong, nonatomic) NSDate *nextAvailableTime;
@end
