//
//  FloorCell.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "FloorCell.h"

@interface FloorCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FloorCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithFloor:(id<Floor>)floor {
    self.nameLabel.text = [NSString stringWithFormat:@"%ld F", floor.order];
}

@end
