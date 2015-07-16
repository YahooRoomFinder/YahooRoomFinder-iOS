//
//  YahooRoomClient.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YahooRoomClient : NSObject
+ (YahooRoomClient *) sharedInstance;
- (void) getFloors:(void(^)(NSArray *floors, NSError *error))completion;
@end
