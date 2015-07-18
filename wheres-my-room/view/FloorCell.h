//
//  FloorCell.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Floor.h"

@interface FloorCell : UITableViewCell
- (void)initWithFloor:(id<Floor>)floor;
@end
