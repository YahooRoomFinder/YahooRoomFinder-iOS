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
@end
