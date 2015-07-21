//
//  RoomMettingsViewController.m
//  wheres-my-room
//
//  Created by Pei-Chih Tsai on 7/20/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "RoomMettingsViewController.h"
#import "RoomMeetingCell.h"

@interface RoomMettingsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *meetingsTable;

@property NSArray *meetings;

@end

@implementation RoomMettingsViewController

-(RoomMettingsViewController *) initWithMeetings:(NSArray *)meetings {
    self = [super init];
    if (self) {
        self.meetings = meetings;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.meetingsTable.rowHeight = UITableViewAutomaticDimension;
    self.meetingsTable.estimatedRowHeight = 100;
    [self.meetingsTable registerNib:[UINib nibWithNibName: NSStringFromClass([RoomMeetingCell class]) bundle:nil] forCellReuseIdentifier:@"RoomMeetingCell"];
    self.meetingsTable.dataSource = self;
    self.meetingsTable.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meetings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomMeetingCell *cell = [self.meetingsTable dequeueReusableCellWithIdentifier:@"RoomMeetingCell"];
    //id<Floor> floor = self.floors[indexPath.row];
    [cell setMeetingInfo:self.meetings[indexPath.row]];
    return cell;
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
