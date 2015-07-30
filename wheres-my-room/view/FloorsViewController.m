//
//  FloorsViewController.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "FloorsViewController.h"
#import "../Control/YahooRoomsManager.h"
#import "../Control/RoomsLocalityManager.h"
#import "../Model/Floor.h"
#import "FloorCell.h"

@interface FloorsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *floorsTable;
@property (strong, nonatomic) RoomsLocalityManager *roomsLocalityManager;

// Array of FloorLocalityInfo
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
    self.roomsLocalityManager = [RoomsLocalityManager sharedInstance];
    [self.roomsLocalityManager floors:^(NSArray *floors, NSError *error) {
        self.floors = [self sortFloors:floors];
        [self.floorsTable reloadData];
    }];
    // Prevent the navigation bar from overlapping the view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSArray*) sortFloors:(NSArray*) floors {
    return [floors sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        FloorLocalityInfo *floor1 = obj1;
        FloorLocalityInfo *floor2 = obj2;
        if (floor1.order < floor2.order) {
            return NSOrderedDescending;
        } else if (floor2.order > floor2.order) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
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
    id<Floor> floor = self.floors[indexPath.row];
    [cell initWithFloor:floor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate != nil) {
        id<Floor> floor = self.floors[indexPath.row];
        [self.delegate setFloorSelected:floor];
    }
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
