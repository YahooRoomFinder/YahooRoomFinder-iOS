//
//  Room.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "RoomMeetingInfo.h"
#import "Meeting.h"

@implementation RoomMeetingInfo

- (id)initWithDictionary:(NSDictionary *)dictionary {
 
    self = [super init];
    if (self) {
        
        self.roomId = dictionary[@"id"];
        self.capacity = [dictionary[@"capacity"] integerValue];
        self.name = dictionary[@"display_name"];
        self.available = [dictionary[@"available"] boolValue];
        self.nextAvailableTime = dictionary[@"next_available"];
        self.meetings = [Meeting  meetingWithArray:dictionary[@"meetings"]];
    }
    return self;
}


@end
