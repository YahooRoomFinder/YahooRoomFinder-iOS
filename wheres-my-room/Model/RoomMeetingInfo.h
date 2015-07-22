//
//  Room.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

// Use it for the response of API http://matteflat.corp.sg3.yahoo.com/room/v0/room/CR-TW-11FN-MeihuaLake
@interface RoomMeetingInfo : NSObject
@property (strong, nonatomic) NSString* roomId;
@property (assign, nonatomic) NSInteger capacity;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) BOOL available;

// Array of Meeting's
@property (strong, nonatomic) NSArray *meetings;
@property (strong, nonatomic) NSDate *nextAvailableTime;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end