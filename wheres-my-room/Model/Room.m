//
//  Room.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "Room.h"

@implementation Room

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        self.roomId = dictionary[@"id"];
        self.name = dictionary[@"display_name"];
        
    }
    
    return self;
}

+ (NSArray * ) roomWithArray:(NSArray *)array {
    NSMutableArray *rooms = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [rooms addObject:[[Room alloc] initWithDictionary:dictionary]];
    }
    
    return rooms;
}

@end
