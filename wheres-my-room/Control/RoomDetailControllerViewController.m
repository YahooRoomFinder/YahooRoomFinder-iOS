//
//  RoomDetailControllerViewController.m
//  wheres-my-room
//
//  Created by Pei-Chih Tsai on 7/20/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "RoomDetailControllerViewController.h"
#import "YahooRoomsManager.h"
#import "RoomMettingsViewController.h"

@interface RoomDetailControllerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *roomIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomCapacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *isRoomAvailableLabel;
- (IBAction)meetingsButtonClicked:(UIButton *)sender;

@property (strong, nonatomic) RoomMeetingInfo *roomMeetingInfo;

@end

@implementation RoomDetailControllerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self.title = @"Detail";
    [self.tabBarItem setImage:[UIImage imageNamed:@"ingredients_list"]];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    YahooRoomsManager *mgr = [YahooRoomsManager sharedInstance];
    [mgr getRoomMeetingInfoById:self.roomId complete:^(RoomMeetingInfo *room, NSError *error) {
        if (error == nil) {
            self.roomMeetingInfo = room;
            
            self.roomIdLabel.text = room.roomId;
            self.roomNameLabel.text = room.name;
            self.roomCapacityLabel.text = [NSString stringWithFormat:@"%ld", (long)room.capacity];
            self.isRoomAvailableLabel.text = (room.available ? @"YES" : @"NO");

            self.navigationController.title = room.name;            
            self.navigationItem.title = room.name;
        }
    }];    
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

- (IBAction)meetingsButtonClicked:(UIButton *)sender {
    RoomDetailControllerViewController *controller = [[RoomMettingsViewController alloc] initWithMeetings:self.roomMeetingInfo.meetings];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
