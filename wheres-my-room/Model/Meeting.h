//
//  Meeting.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject
@property (strong, nonatomic) NSString *organizerName;
@property (strong, nonatomic) NSString *organizerId;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray * ) meetingWithArray:(NSArray * ) array;


@end
