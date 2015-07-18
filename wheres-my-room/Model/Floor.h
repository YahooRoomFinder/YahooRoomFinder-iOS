//
//  Floor.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Floor

// For 1st floor, it should be 0; for 2nd floor, it should be 1.
@property (assign, nonatomic) NSInteger order;
@end
