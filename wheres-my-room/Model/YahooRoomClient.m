//
//  YahooRoomClient.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "YahooRoomClient.h"
#import "Floor.h"
#import "RoomMeetingInfo.h"

@implementation YahooRoomClient
+ (YahooRoomClient *) sharedInstance {
    static YahooRoomClient *instance = nil;
    
    static dispatch_once_t onceToken;
    
    // Make the block to be thread-safe
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[YahooRoomClient alloc] init];
        }
    });
    return instance;
}

- (void) getFloors:(void(^)(NSArray *floors, NSError *error))completion {
    NSMutableArray* result = [NSMutableArray array];
    for (int i = 10; i <= 16; ++i) {
        Floor *floor = [[Floor alloc] init];
        floor.order = i;
        floor.mapRealWidth = 90;
        floor.mapRealHeight = 30;
        [result addObject:floor];
    }
    completion(result, nil);
}
@end
