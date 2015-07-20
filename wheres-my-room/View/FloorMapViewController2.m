//
//  FloorMapViewController2.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/19/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "FloorMapViewController2.h"
#import "FloorsViewController.h"
#import "FloorMapView.h"
#import "../Control/RoomsLocalityManager.h"
#import "Floor.h"
#import "../KDNBeaconManager.h"
#import "../Model/Config.h"

@interface FloorMapViewController2 () <UIGestureRecognizerDelegate, FloorsViewDelegate, KDNBeaconManagerDelegate>
@property (weak, nonatomic) IBOutlet FloorMapView *floorMapView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGesture;
@property (strong, nonatomic) RoomsLocalityManager *roomsLocalityManager;
@property (strong, nonatomic) KDNBeaconManager *beaconManager;

// A dictionary mapping floor order to FloorLocalityInfo
@property (strong, nonatomic) NSDictionary *floorsDic;

@end

@implementation FloorMapViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.roomsLocalityManager = [RoomsLocalityManager sharedInstance];
    self.pinchGesture.delegate = self;
    [self.floorMapView showCurrentPoint:YES];
    [self setCurrentFloor:11];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Floors" style:UIBarButtonItemStylePlain target:self action:@selector(doFloorSelect)];
    // Prevent the navigation bar from overlapping the view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Beacon
    self.beaconManager = [[KDNBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    [self loadBeaconItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Beacon
    [self.beaconManager startMonitoring];
    NSLog(@"Start monitoring for beacons");
}

- (void)loadBeaconItems {
    Config *config = [Config sharedInstance];
    NSArray *beaconItems = config.knownBeaconItems;
    for (BeaconItem *beaconItem in beaconItems) {
        [self.beaconManager addBeaconItem:beaconItem];
    }
    NSLog(@"Total %ld known beacons", beaconItems.count);
    [self.beaconManager setReturnBeanconCount:beaconItems.count];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.beaconManager stopMonitoring];
    NSLog(@"Stop monitoring for beacons");
}

- (void)doFloorSelect {
    FloorsViewController *vc = [[FloorsViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setCurrentFloor:(NSInteger)floorOrder {
    [self.roomsLocalityManager floorForOrder:floorOrder complete:^(FloorLocalityInfo *floor, NSError *error) {
        self.navigationItem.title = [NSString stringWithFormat:@"%ld F", floor.order + 1];
        [self.floorMapView setMapImage:[UIImage imageNamed:floor.mapImageName]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (IBAction)onPinch:(UIPinchGestureRecognizer*)gesture {
    CGPoint point = [gesture locationInView:self.floorMapView];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.floorMapView pinchBeganAtPoint:point];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = gesture.scale;
        [self.floorMapView pinchChangedAtPoint:point :scale];
    } else {
        [self.floorMapView pinchEndedAtPoint:point];
    }
}
- (IBAction)onPan:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.floorMapView];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.floorMapView panBeganAtPoint:point];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.floorMapView panChangedAtPoint:point];
    } else {
        [self.floorMapView panEndedAtPoint:point];
    }
}

- (void)floorSelected:(id<Floor>)floor {
    [self setCurrentFloor:floor.order];
}

- (void)beaconManager:(KDNBeaconManager *)beaconManager didRangeBeacons:(NSArray *)orderedBeaconItems inRegion:(CLBeaconRegion *)region
{
    NSLog(@"== Beacon Order ==");
    for (BeaconItem *item in orderedBeaconItems) {
        NSString *proximityString;
        switch (item.proximity) {
            case CLProximityUnknown:
                proximityString = @"Unknown";
                break;
            case CLProximityFar:
                proximityString = @"Far";
                break;
            case CLProximityNear:
                proximityString = @"Near";
                break;
            case CLProximityImmediate:
                proximityString = @"Immediate";
                break;
        }
        NSLog(@"%@ %.2lfm %@", [item name], [item accuracy], proximityString);
    }
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
