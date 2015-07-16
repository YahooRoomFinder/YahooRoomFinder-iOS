//
//  Floor.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Floor : NSObject
@property (assign, nonatomic) NSInteger order;
@property (assign, nonatomic) float mapRealWidth;
@property (assign, nonatomic) float mapRealHeight;
@property (assign, nonatomic) NSString *mapPath;
@end
