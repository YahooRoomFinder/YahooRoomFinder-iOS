//
//  RoomMeetingCell.m
//  wheres-my-room
//
//  Created by Pei-Chih Tsai on 7/20/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "RoomMeetingCell.h"

@interface RoomMeetingCell ()

@property (weak, nonatomic) IBOutlet UILabel *organizerLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end

@implementation RoomMeetingCell

-(void) setMeetingInfo:(Meeting *)meeting {
    self.organizerLabel.text = meeting.organizerId;
    self.subjectLabel.text = meeting.subject;
    self.startTimeLabel.text = meeting.startTime;
    self.endTimeLabel.text = meeting.endTime;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
