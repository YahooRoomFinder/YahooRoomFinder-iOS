//
//  Config.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/20/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../BeaconItem.h"

@interface Config : NSObject
+ (Config *) sharedInstance;

// Get the list of known beacons.
// The elements of the returned array are BeaconItem.
- (NSArray*) knownBeaconItems;
@end
