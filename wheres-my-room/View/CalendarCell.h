//
//  CalendarCell.h
//  wheres-my-room
//
//  Created by kaden Chiang on 2015/7/30.
//  Copyright (c) 2015年 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bookDate;
@property (weak, nonatomic) IBOutlet UILabel *bookHourStart;
@property (weak, nonatomic) IBOutlet UILabel *bookHourEnd;
@property (weak, nonatomic) IBOutlet UILabel *bookSummary;
@property (weak, nonatomic) IBOutlet UILabel *bookRoomName;

@end
