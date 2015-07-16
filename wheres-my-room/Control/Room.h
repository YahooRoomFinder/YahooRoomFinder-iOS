//
//  Room.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject
@property (strong, nonatomic) NSString* roomId;
@property (assign, nonatomic) NSInteger capacity;
@property (strong, nonatomic) NSString* name;
@end
