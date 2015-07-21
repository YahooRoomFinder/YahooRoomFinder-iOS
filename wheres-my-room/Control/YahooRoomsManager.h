//
//  YahooRoomClient.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomMeetingInfo.h"

@interface YahooRoomsManager : NSObject
+ (YahooRoomsManager *) sharedInstance;

- (void) getRoomMeetingInfoById:(NSString *)roomId complete:(void(^)(RoomMeetingInfo *room, NSError *error))completion;
@end
