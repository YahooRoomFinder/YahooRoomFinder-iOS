//
//  CalendarRoomViewController.h
//  wheres-my-room
//
//  Created by kaden Chiang on 2015/7/30.
//  Copyright (c) 2015年 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarManager.h"
#import "BookRoom.h"

@interface CalendarRoomViewController : UIViewController<CalendarManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CalendarManager *calendarManager;


@end
