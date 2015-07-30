//
//  CalendarManager.h
//  wheres-my-room
//
//  Created by kaden Chiang on 2015/7/30.
//  Copyright (c) 2015年 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLCalendar.h"

@interface CalendarManager : NSObject

@property (nonatomic, strong) GTLServiceCalendar *service;

@end
