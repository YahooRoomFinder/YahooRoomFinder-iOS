//
//  FloorsViewController.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "FloorsViewController.h"
#import "YahooRoomClient.h"
#import "FloorCell.h"

@interface FloorsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *floorsTable;
@property (strong, nonatomic) YahooRoomClient *client;
@property (strong, nonatomic) NSArray *floors;
@end

@implementation FloorsViewController

NSString * const FLOOR_CELL = @"FloorCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Floors";
    self.floorsTable.dataSource = self;
    self.floorsTable.delegate = self;
    
    [self.floorsTable registerNib:[UINib nibWithNibName: NSStringFromClass([FloorCell class]) bundle:nil] forCellReuseIdentifier:FLOOR_CELL];
    self.client = [YahooRoomClient sharedInstance];
    [self.client getFloors:^(NSArray *floors, NSError *error) {
        self.floors = floors;
        [self.floorsTable reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.floors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FloorCell *cell = [self.floorsTable dequeueReusableCellWithIdentifier:FLOOR_CELL];
    Floor* floor = self.floors[indexPath.row];
    [cell initWithFloor:floor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate != nil) {
        Floor *floor = self.floors[indexPath.row];
        [self.delegate floorSelected:floor];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
