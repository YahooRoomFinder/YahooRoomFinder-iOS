//
//  CalendarRoomViewController.m
//  wheres-my-room
//
//  Created by kaden Chiang on 2015/7/30.
//  Copyright (c) 2015年 Chu-An Hsieh. All rights reserved.
//

#import "CalendarRoomViewController.h"
#import "CalendarCell.h"
#import "RoomDetailControllerViewController.h"


NSString * const CALENDER_CELL = @"CalendarCell";

@interface CalendarRoomViewController ()

@property NSMutableArray *tableData;

@end

@implementation CalendarRoomViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self.title = @"Meeting";
    [self.tabBarItem setImage:[UIImage imageNamed:@"calendar"]];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableData = [NSMutableArray arrayWithCapacity:20];
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([CalendarCell class]) bundle:nil]forCellReuseIdentifier:CALENDER_CELL];
    self.calendarManager = [[CalendarManager alloc] init];
    self.calendarManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.calendarManager loadCalendar];
}

- (void)displayResultWithTicket:(GTLServiceTicket *)ticket
             finishedWithObject:(GTLCalendarEvents *)events
                          error:(NSError *)error {
    if (error == nil) {
        NSMutableString *eventString = [[NSMutableString alloc] init];
        if (events.items.count > 0) {
            [eventString appendString:@"Upcoming 20 events:\n"];
            [self.tableData removeAllObjects];
            for (GTLCalendarEvent *event in events) {
                GTLDateTime *start = event.start.dateTime ?: event.start.date;
                GTLDateTime *end = event.end.dateTime ?: event.end.date;

                for (GTLCalendarEventAttendee *attende in event.attendees) {
                    if ([attende.displayName containsString:@"-TW-"]) {
                        BookRoom *room = [[BookRoom alloc] init];
                        room.startDate = [start date];
                        room.endDate = [end date];
                        room.roomName = attende.displayName;
                        room.summary = event.summary;
                        [self.tableData addObject: room];
                        NSLog(@"%@",attende);
//                        [eventString appendFormat:@"%@ - %@ \n@%@\n\n", startString, event.summary, attende.displayName];
                    }
                }
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"No upcoming events found.");
        }
//        self.output.text = eventString;
    } else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookRoom *selectedRoom = [self.tableData objectAtIndex:indexPath.row];
    RoomDetailControllerViewController *detailViewController = [[RoomDetailControllerViewController alloc] init];
    NSRange range = [selectedRoom.roomName rangeOfString:@" " options:NSBackwardsSearch];
    
    detailViewController.roomId = [selectedRoom.roomName substringToIndex:range.location];
    detailViewController.roomId = [[detailViewController.roomId componentsSeparatedByString:@" "] componentsJoinedByString:@""];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:CALENDER_CELL];
    BookRoom *book = self.tableData[indexPath.row];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd"];
    cell.bookDate.text = [format stringFromDate:book.startDate];
    [format setDateFormat:@"hh:mm aaa"];
    cell.bookHourStart.text = [format stringFromDate:book.startDate];
    cell.bookHourEnd.text = [format stringFromDate:book.endDate];
    cell.bookSummary.text = book.summary;
    cell.bookRoomName.text = [NSString stringWithFormat:@"@%@", book.roomName];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
