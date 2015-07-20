//
//  Config.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/20/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "Config.h"

@implementation Config
+ (Config *) sharedInstance {
    static Config *instance = nil;
    
    static dispatch_once_t onceToken;
    
    // Make the block to be thread-safe
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[Config alloc] init];
        }
    });
    return instance;
}

- (NSArray*) knownBeaconItems {
    NSMutableArray* result = [NSMutableArray array];
    NSDictionary *existedBeaconInfo = @{
                                        @"49107DFF-D328-4EBD-A47A-076613B658D6": @[@"kdnbcn1", @3066, @1],
                                        @"C62BD0D8-432C-4DFC-909D-B678117F8965": @[@"kdnbcn2", @3066, @2],
                                        @"A7500BC2-AD79-4DCA-959D-1C9FF2563FF7": @[@"kdnbcn3", @3066, @3],
                                        @"2C0982E6-99AB-4D76-BBE7-012AE2F04270": @[@"kdnbcn4", @3066, @4],
                                        };
    for (NSString *uuidString in existedBeaconInfo) {
        NSArray *item = existedBeaconInfo[uuidString];
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
        BeaconItem *beaconItem = [[BeaconItem alloc]
                                  initWithName:item[0]
                                  uuid:uuid major:[item[1] integerValue]
                                  minor:[item[2] integerValue]
                                  ];
        [result addObject:beaconItem];
    }
    return result;
}
@end
