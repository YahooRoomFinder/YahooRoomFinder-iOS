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
#import "FavoriteRoomsManager.h"
#import "FloorMapViewController2.h"

@interface RoomDetailControllerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *roomIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomCapacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *isRoomAvailableLabel;
- (IBAction)meetingsButtonClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *favoritedButton;
- (IBAction)favoriteButtonClicked:(UIButton *)sender;

@property (strong, nonatomic) RoomMeetingInfo *roomMeetingInfo;
@property (strong, nonatomic) IBOutlet UIButton *meetingsBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
- (IBAction)onShowOnMapClicked:(UIButton *)sender;

@end

@implementation RoomDetailControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Room ID: %@", self.roomId);
    self.roomIdLabel.text = @"";
    self.roomNameLabel.text = @"";
    self.roomCapacityLabel.text = @"";
    self.isRoomAvailableLabel.text = @"";
    self.meetingsBtn.enabled = NO;
    YahooRoomsManager *mgr = [YahooRoomsManager sharedInstance];
    [mgr getRoomMeetingInfoById:self.roomId startTs:nil complete:^(RoomMeetingInfo *room, NSError *error) {
        if (error == nil) {
            self.meetingsBtn.enabled = YES;
            self.roomMeetingInfo = room;
            
            self.roomIdLabel.text = room.roomId;
            self.roomNameLabel.text = room.name;
            self.roomCapacityLabel.text = [NSString stringWithFormat:@"%ld", (long)room.capacity];
            self.isRoomAvailableLabel.text = (room.available ? @"YES" : @"NO");
            
            FavoriteRoomsManager *favoriteRoomsMgr = [FavoriteRoomsManager sharedInstance];
            self.favoritedButton.highlighted = [favoriteRoomsMgr isFavoriteRoom:room.roomId];

            self.navigationItem.title = room.name;
        }
    }];
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];
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
    RoomMettingsViewController *controller = [[RoomMettingsViewController alloc] initWithMeetings:self.roomMeetingInfo.meetings];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)favoriteButtonClicked:(UIButton *)sender {
    FavoriteRoomsManager *favoriteRoomsMgr = [FavoriteRoomsManager sharedInstance];

    if ([favoriteRoomsMgr isFavoriteRoom:self.roomMeetingInfo.roomId]) {
        [favoriteRoomsMgr removeFavoriteRoom:self.roomMeetingInfo.roomId];
    } else {
        [favoriteRoomsMgr addFavoriteRoom:self.roomMeetingInfo.roomId];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.favoritedButton setHighlighted:[favoriteRoomsMgr isFavoriteRoom:self.roomMeetingInfo.roomId]];
    });
}

- (IBAction)onShowOnMapClicked:(UIButton *)sender {
    UITabBarController *tabBarController = self.tabBarController;
    UINavigationController *navController = [tabBarController.viewControllers objectAtIndex:2];
    
    FloorMapViewController2 *floorMapViewController = (FloorMapViewController2 *)[((UINavigationController *)navController) topViewController];
    floorMapViewController.pinnedRoomId = self.roomId;
    tabBarController.selectedViewController = navController;
}
@end
