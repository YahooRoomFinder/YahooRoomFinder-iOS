//
//  BeaconItem.m
//  BeaconTest
//
//  Created by kaden Chiang on 2015/7/15.
//  Copyright (c) 2015年 kaden Chiang. All rights reserved.
//

#import "BeaconItem.h"

static NSString * const kRWTItemNameKey = @"name";
static NSString * const kRWTItemUUIDKey = @"uuid";
static NSString * const kRWTItemMajorValueKey = @"major";
static NSString * const kRWTItemMinorValueKey = @"minor";

@implementation BeaconItem

- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _name = name;
    _uuid = uuid;
    _majorValue = major;
    _minorValue = minor;
    _proximity = CLProximityUnknown;
    _accuracy = -1;
    
    return self;
}

- (instancetype) initWithName: (NSString *)name beacon: (CLBeacon *)beacon
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _name = name;
    _uuid = [beacon proximityUUID];
    _majorValue = [[beacon major] intValue];
    _minorValue = [[beacon minor] intValue];
    _proximity = [beacon proximity];
    _accuracy = [beacon accuracy];
    
    return self;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _name = [aDecoder decodeObjectForKey:kRWTItemNameKey];
    _uuid = [aDecoder decodeObjectForKey:kRWTItemUUIDKey];
    _majorValue = [[aDecoder decodeObjectForKey:kRWTItemMajorValueKey] unsignedIntegerValue];
    _minorValue = [[aDecoder decodeObjectForKey:kRWTItemMinorValueKey] unsignedIntegerValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:kRWTItemNameKey];
    [aCoder encodeObject:self.uuid forKey:kRWTItemUUIDKey];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.majorValue] forKey:kRWTItemMajorValueKey];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.minorValue] forKey:kRWTItemMinorValueKey];
}

@end


