//
//  YahooRoomClient.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "YahooRoomsManager.h"
#import "../Model/Floor.h"
#import "../Model/RoomMeetingInfo.h"
#import "Meeting.h"

@implementation YahooRoomsManager
+ (YahooRoomsManager *) sharedInstance {
    static YahooRoomsManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    // Make the block to be thread-safe
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[YahooRoomsManager alloc] init];
        }
    });
    return instance;
}

- (void) getRoomMeetingInfoById:(NSString *)roomId complete:(void(^)(RoomMeetingInfo *room, NSError *error))completion {
    // mock, always return Yehliu
    RoomMeetingInfo *result = [[RoomMeetingInfo alloc] init];
    result.roomId = @"CR-TW-10FN-Yehliu";
    result.name = @"Yehliu";
    result.capacity = 10;
    result.available = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    Meeting *m1 = [[Meeting alloc] init];
    m1.organizerName = @"p0";
    m1.organizerId = @"plin";
    m1.subject = @"just meeting";
    m1.startTime = [formatter dateFromString:@"2015-07-21 10:00:00"];
    m1.endTime = [formatter dateFromString:@"2015-07-21 12:00:00"];
    Meeting *m2 = [[Meeting alloc] init];
    m2.organizerName = @"p1";
    m2.organizerId = @"pl";
    m2.subject = @"not again";
    m2.startTime = [formatter dateFromString:@"2015-07-21 14:00:00"];
    m2.endTime = [formatter dateFromString:@"2015-07-21 16:00:00"];
    result.meetings = [NSArray arrayWithObjects:m1, m2, nil];
    
    completion(result, nil);
}
@end
