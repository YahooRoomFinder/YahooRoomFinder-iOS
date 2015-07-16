//
//  Room.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

// Use it for the response of the API http://matteflat.corp.sg3.yahoo.com/room/v0/room?query=-TW-
@interface Room : NSObject
@property (strong, nonatomic) NSString *roomId;
@property (strong, nonatomic) NSString *name;
@end
