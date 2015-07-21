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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];

    self.organizerLabel.text = meeting.organizerId;
    self.subjectLabel.text = meeting.subject;
    self.startTimeLabel.text = [formatter stringFromDate:meeting.startTime];
    self.endTimeLabel.text = [formatter stringFromDate:meeting.endTime];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
