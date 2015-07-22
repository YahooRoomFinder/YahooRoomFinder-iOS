//
//  Meeting.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "Meeting.h"

@implementation Meeting

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.organizerId = dictionary[@"organizer"];
        self.organizerName = dictionary[@"organizerName"];
        self.subject = dictionary[@"subject"];
        
        //NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStampString doubleValue]/1000.0];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        //return [_formatter stringFromDate:date];
        double startTs = [dictionary[@"start"] doubleValue] / 1000;
        long endTs = [dictionary[@"end"] longValue] / 1000;
        self.startTime = [_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startTs]];
        self.endTime = [_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endTs]];
        //self.startTime = dictionary[@"start"];
        //self.endTime = dictionary[@"end"];
    }
    
    return self;
}

+ (NSArray * ) meetingWithArray:(NSArray * ) array {
    NSMutableArray *meetings = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [meetings addObject:[[Meeting alloc] initWithDictionary:dictionary]];
    }
    
    return meetings;
}

@end
