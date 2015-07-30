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

@class CalendarManager;

@protocol CalendarManagerDelegate <NSObject>

@required
- (void)displayResultWithTicket:(GTLServiceTicket *)ticket
             finishedWithObject:(GTLCalendarEvents *)events
                          error:(NSError *)error;

- (void)showAlert:(NSString *)title message:(NSString *)message;

@end

@interface CalendarManager : NSObject

@property (nonatomic, strong) GTLServiceCalendar *service;
@property (nonatomic, weak)   UIViewController<CalendarManagerDelegate> *delegate;

+ (CalendarManager *) sharedInstance;
- (void)loadCalendar;

@end
