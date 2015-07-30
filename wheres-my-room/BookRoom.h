//
//  BookRoom.h
//  wheres-my-room
//
//  Created by kaden Chiang on 2015/7/30.
//  Copyright (c) 2015年 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookRoom : NSObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) NSString *summary;

@end
