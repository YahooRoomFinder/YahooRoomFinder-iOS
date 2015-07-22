//
//  YahooRoomClient.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomMeetingInfo.h"
#import "Room.h"

@interface YahooRoomsManager : NSObject
+ (YahooRoomsManager *) sharedInstance;

- (void) getRoomMeetingInfoById:(NSString *)roomId startTs:(NSString *)startTs complete:(void(^)(RoomMeetingInfo *room, NSError *error))completion;
- (void) getRooms:(NSString *)parameter complete:(void(^)(NSArray *rooms, NSError *error))completion;
@end
