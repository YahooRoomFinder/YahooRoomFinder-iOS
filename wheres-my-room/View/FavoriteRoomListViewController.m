//
//  FavoriteRoomListViewController.m
//  wheres-my-room
//
//  Created by Pei-Chih Tsai on 7/22/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "FavoriteRoomListViewController.h"
#import "FavoriteRoomsManager.h"
#import "RoomDetailControllerViewController.h"

@interface FavoriteRoomListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *favoriteRoomsTable;
@property (weak, nonatomic) NSArray *favoriteRooms;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation FavoriteRoomListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self.title = @"Favorite";
    [self.tabBarItem setImage:[UIImage imageNamed:@"star"]];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.favoriteRooms = [[FavoriteRoomsManager sharedInstance] getFavoriteRooms];
    [self.favoriteRoomsTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    FavoriteRoomsManager *mgr = [FavoriteRoomsManager sharedInstance];
    [mgr addFavoriteRoom:@"CR-TW-10FN-Yehliu"];
    
    self.favoriteRoomsTable.delegate = self;
    self.favoriteRoomsTable.dataSource = self;
    

    [self.bgImageView setFrame:self.favoriteRoomsTable.frame];
    
    [self.favoriteRoomsTable setBackgroundView:self.bgImageView];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoriteRooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"classic"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classic"];
    }
    cell.textLabel.text = [self.favoriteRooms objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedRoomId = [self.favoriteRooms objectAtIndex:indexPath.row];
    RoomDetailControllerViewController *detailViewController = [[RoomDetailControllerViewController alloc] init];
    detailViewController.roomId = selectedRoomId;
    [self.navigationController pushViewController:detailViewController animated:YES];
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
