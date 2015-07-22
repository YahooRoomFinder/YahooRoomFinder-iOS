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
#import "../Control/BeaconLocalityManager.h"
#import "Floor.h"
#import "../KDNBeaconManager.h"
#import "../Model/Config.h"
#import "../Control/RoomDetailControllerViewController.h"

@interface FloorMapViewController2 () <UIGestureRecognizerDelegate, FloorsViewDelegate, KDNBeaconManagerDelegate, FloorMapViewDelegate>
@property (weak, nonatomic) IBOutlet FloorMapView *floorMapView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGesture;
@property (strong, nonatomic) RoomsLocalityManager *roomsLocalityManager;
@property (strong, nonatomic) KDNBeaconManager *beaconManager;
@property (strong, nonatomic) BeaconLocalityManager *beaconLocalityManager;
@property (strong, nonatomic) NSMutableArray *beacons;
@property (strong, nonatomic) FloorLocalityInfo *displayedFloor;
@property (assign, nonatomic) NSInteger currentFloorOrder;
@property (strong, nonatomic) NSArray *detectedBeaconLocalityInfos;
@property (strong, nonatomic) UIImage *displayedFloorImage;
@property (weak, nonatomic) IBOutlet UIButton *currentLocBtn;

// A dictionary mapping floor order to FloorLocalityInfo
@property (strong, nonatomic) NSDictionary *floorsDic;

@end

@implementation FloorMapViewController2

NSInteger const MAX_BEACONS = 20;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self.title = @"Map";
    [self.tabBarItem setImage:[UIImage imageNamed:@"point_objects"]];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beacons = [NSMutableArray array];
    self.floorMapView.delegate = self;
    self.roomsLocalityManager = [RoomsLocalityManager sharedInstance];
    self.beaconLocalityManager = [BeaconLocalityManager sharedInstance];
    self.currentFloorOrder = INT_MAX;
    self.detectedBeaconLocalityInfos = [NSArray array];
    self.pinchGesture.delegate = self;
    [self.floorMapView showCurrentPoint:YES];
    [self setDisplayedFloorOrder:11];
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
    
    // ========== DEBUG
    /*NSMutableArray *beacons = [NSMutableArray array];
    BeaconItem *item1 = [[BeaconItem alloc] initWithName:@"test1" uuid:[[NSUUID alloc] initWithUUIDString:@"49107DFF-D328-4EBD-A47A-076613B658D6"] major:1.0 minor:1.0];
    item1.accuracy = 1;
    [beacons addObject:item1];
    BeaconItem *item2 = [[BeaconItem alloc] initWithName:@"test2" uuid:[[NSUUID alloc] initWithUUIDString:@"C62BD0D8-432C-4DFC-909D-B678117F8965"] major:1.0 minor:1.0];
    item2.accuracy = 1;
    [beacons addObject:item2];
    BeaconItem *item3 = [[BeaconItem alloc] initWithName:@"test2" uuid:[[NSUUID alloc] initWithUUIDString:@"A7500BC2-AD79-4DCA-959D-1C9FF2563FF7"] major:1.0 minor:1.0];
    item3.accuracy = 1;
    [beacons addObject:item3];
    BeaconItem *item4 = [[BeaconItem alloc] initWithName:@"test2" uuid:[[NSUUID alloc] initWithUUIDString:@"2C0982E6-99AB-4D76-BBE7-012AE2F04270"] major:1.0 minor:1.0];
    item4.accuracy = 1;
    [beacons addObject:item4];
    [self beaconManager:nil didRangeBeacons:beacons inRegion:nil];*/
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

- (void)setDisplayedFloorOrder:(NSInteger)floorOrder {
    [self.roomsLocalityManager floorForOrder:floorOrder complete:^(FloorLocalityInfo *floor, NSError *error) {
        self.navigationItem.title = [NSString stringWithFormat:@"%ld F", floor.order + 1];
        self.displayedFloorImage = [UIImage imageNamed:floor.mapImageName];
        [self.floorMapView setMapImage:self.displayedFloorImage];
        self.displayedFloor = floor;
    }];
}

- (void)setDisplayedFloor:(FloorLocalityInfo *)displayedFloor {
    if (_displayedFloor == displayedFloor) {
        return;
    }
    _displayedFloor = displayedFloor;
    [self.roomsLocalityManager roomsForFloorWithOrder:displayedFloor.order complete:^(NSArray *rooms, NSError *error) {
        self.floorMapView.roomLocalityInfos = rooms;
    }];
    [self displayCurrentLocation];
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

- (void)setFloorSelected:(id<Floor>)floor {
    [self setDisplayedFloorOrder:floor.order];
}

- (void)setCurrentFloorOrder:(NSInteger)curentFloorOrder {
    _currentFloorOrder = curentFloorOrder;
    [self displayCurrentLocation];
}

- (void)displayCurrentLocation {
    if (self.displayedFloor == nil || self.currentFloorOrder != self.displayedFloor.order) {
        [self.floorMapView showCurrentPoint:NO];
        return;
    }
   [self.floorMapView showCurrentPoint:YES];
    NSMutableArray *beaconsForCurrentFloor = [NSMutableArray array];
    NSMutableArray *beaconLocalitiesForCurrentFloor = [[self getCurrentFloorBeaconLocalityInfos:self.detectedBeaconLocalityInfos] mutableCopy];
    for (BeaconLocalityInfo* beaconLocalityInfo in beaconLocalitiesForCurrentFloor) {
        NSUUID *uuid = beaconLocalityInfo.uuid;
        for (BeaconItem *beacon in self.beacons) {
            if([beacon.uuid isEqual:uuid]) {
                [beaconsForCurrentFloor addObject:beacon];
                break;
            }
        }
    }
    
    if (beaconsForCurrentFloor.count < 3) {
        return;
    }
    
    [beaconsForCurrentFloor sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        BeaconItem *beacon1 = obj1;
        BeaconItem *beacon2 = obj2;
        if (beacon1.accuracy < beacon2.accuracy) {
            return NSOrderedAscending;
        } else if (beacon1.accuracy > beacon2.accuracy) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    // Get the location and distance of the nearest 3 beacons (in meters)
    CGPoint beanconLocations[3];
    CGFloat beaconDistances[3];
    for (int i = 0; i < 3; ++i) {
        BeaconItem *beacon = beaconsForCurrentFloor[i];
        BeaconLocalityInfo *beaconLocalityInfo;
        for (BeaconLocalityInfo *beaconLocalityForCurrentFloor in beaconLocalitiesForCurrentFloor) {
            if ([beaconLocalityForCurrentFloor.uuid isEqual:beacon.uuid]) {
                beaconLocalityInfo = beaconLocalityForCurrentFloor;
                break;
            }
        }
        CGPoint locationOnMap = beaconLocalityInfo.locationOnMap;
        beanconLocations[i] = CGPointMake(locationOnMap.x * self.displayedFloor.realWidthForMap,
                                          locationOnMap.y * self.displayedFloor.realHeightForMap);
        beaconDistances[i] = beacon.accuracy;
    }
    
    
    // Calculate the current location (in meters)
    CGPoint currentLocation = [self calTrilaterationWithLocations:beanconLocations distances:beaconDistances];
    NSLog(@"Current location (meters): (%lf, %lf)", currentLocation.x, currentLocation.y);
    
    // Translate the current location into ratio point
    CGFloat currentLocX = currentLocation.x / self.displayedFloor.realWidthForMap;
    CGFloat currentLocY = currentLocation.y / self.displayedFloor.realHeightForMap;
    [self.floorMapView setCurrentRatioPoint:CGPointMake(currentLocX, currentLocY) animated:YES];
}

- (CGPoint)calTrilaterationWithLocations:(CGPoint*) locations distances:(CGFloat*)distances {
    
    NSLog(@"Starting trilateration: (%f, %f), dis = %f, (%f, %f), dis = %f, (%f, %f), dis = %f",
          locations[0].x, locations[0].y, distances[0],
          locations[1].x, locations[1].y, distances[1],
          locations[2].x, locations[2].y, distances[2]);
    
    CGFloat x[3], y[3];
    for (int i = 0; i < 3; ++i) {
        x[i] = locations[i].x;
        y[i] = locations[i].y;
    }

    // Shift the points so that point0 is a the origin
    const CGFloat shiftX = x[0], shiftY = y[0];
    for (int i = 0; i < 3; ++i) {
        x[i] -= shiftX;
        y[i] -= shiftY;
    }
    
    NSLog(@"After shifting: (%f, %f), (%f, %f), (%f, %f)",
          x[0], x[0],
          x[1], y[1],
          x[2], y[2]);
    
    // Rotate the points around the origin so that point1 lies on the positive side of x-axis
    CGFloat r1 = sqrt(x[1] * x[1] + y[1] * y[1]);
    CGFloat cosTheta = x[1] / r1;
    CGFloat sinTheta = y[1] / r1;
    
    CGFloat tmpX, tmpY;

    tmpX = x[2];
    tmpY = y[2];

    x[2] = cosTheta * tmpX + sinTheta * tmpY;
    y[2] = -sinTheta * tmpX + cosTheta * tmpY;
    
    x[1] = r1;
    y[1] = 0.0;
    
    NSLog(@"After rotating: (%f, %f), (%f, %f), (%f, %f)",
          x[0], x[0],
          x[1], y[1],
          x[2], y[2]);
    
    // Do trilateration
    CGFloat resultX, resultY;
    resultX = (distances[0] * distances[0] - distances[1] * distances[1] + x[1] * x[1]) / (2 * x[1]);
    resultY = (distances[0] * distances[0] - distances[2] * distances[2] - resultX * resultX + (resultX - x[2]) * (resultX - x[2]) + y[2] * y[2]) / (2 * y[2]);
    
    NSLog(@"After trilateration: (%f, %f)", resultX, resultY);
    
    // Rotate the result back
    tmpX = resultX;
    tmpY = resultY;
    resultX = cosTheta * tmpX - sinTheta * tmpY;
    resultY = sinTheta * tmpX + cosTheta * tmpY;
    
    NSLog(@"After rotating back: (%f, %f)", resultX, resultY);
    
    // Shift the result back
    resultX += shiftX;
    resultY += shiftY;
    
    NSLog(@"After shifting back: (%f, %f)", resultX, resultY);
    return CGPointMake(resultX, resultY);
}

- (void)beaconManager:(KDNBeaconManager *)beaconManager didRangeBeacons:(NSArray *)orderedBeaconItems inRegion:(CLBeaconRegion *)region {
    NSLog(@"Receiving beacon update");
    for (BeaconItem *beacon in orderedBeaconItems) {
        if (beacon.accuracy < 0) {
            continue;
        }
        NSUUID *uuid = beacon.uuid;
        BOOL exists = NO;
        for (int i = 0; i < self.beacons.count; ++i) {
            BeaconItem *oldBeacon = self.beacons[i];
            NSUUID *oldUuid = oldBeacon.uuid;
            if ([oldUuid isEqual:uuid]) {
                [self.beacons replaceObjectAtIndex:i withObject:beacon];
                exists = YES;
                break;
            }
        }
        if (!exists) {
            if (self.beacons.count >= MAX_BEACONS) {
                [self.beacons removeObjectAtIndex:0];
            }
            [self.beacons addObject:beacon];
        }
    }
    [self updateCurrentLocation];
}

- (BeaconItem*)getDetectedBeaconForUUID:(NSUUID*)uuid {
    for (BeaconItem *beaconItem in self.beacons) {
        if([beaconItem.uuid isEqual:uuid]) {
            return beaconItem;
        }
    }
    return nil;
}

- (NSInteger)calCurrentFloorOrder:(NSArray *)beaconLocalityInfos {
    NSInteger nearestFloorOrder = -1;
    CLLocationAccuracy nearestDis = DBL_MAX;
    for (BeaconLocalityInfo* beaconLocalityInfo in beaconLocalityInfos) {
        NSUUID *uuid = beaconLocalityInfo.uuid;
        BeaconItem *beaconItem = [self getDetectedBeaconForUUID:uuid];
        if (beaconItem == nil) {
            continue;
        }
        if (beaconItem.accuracy < nearestDis) {
            nearestDis = beaconItem.accuracy;
            nearestFloorOrder = beaconLocalityInfo.floorOrder;
        }
    }
    if (nearestDis == DBL_MAX) {
        return INT_MAX;
    }
    return nearestFloorOrder;
}

// Get array of BeaconLocalityInfo instances at the current floors.
- (NSArray*)getCurrentFloorBeaconLocalityInfos:(NSArray *)beaconLocalityInfos {
    
    if (self.currentFloorOrder == INT_MAX) {
        return [NSArray array];
    }
    
    // Get the beacons for the floor
    NSMutableArray* beaconsForCurrentFloor = [NSMutableArray array];
    for (BeaconLocalityInfo* beaconLocalityInfo in beaconLocalityInfos) {
        NSInteger floorOrder = beaconLocalityInfo.floorOrder;
        if (self.currentFloorOrder == floorOrder) {
            [beaconsForCurrentFloor addObject:beaconLocalityInfo];
        }
    }
    return beaconsForCurrentFloor;
}

- (void)updateCurrentLocation {
    if (self.beacons.count < 3) {
        return;
    }
    NSMutableArray *uuids = [NSMutableArray array];
    for (BeaconItem* beacon in self.beacons) {
        [uuids addObject:beacon.uuid];
    }
    [self.beaconLocalityManager localityInfoForBeacons:uuids complete:^(NSArray *beaconLocalityInfos, NSError *error) {
        if (error != nil) {
            NSLog(@"Fail to get beacons information");
            return;
        }
        self.detectedBeaconLocalityInfos = beaconLocalityInfos;
        self.currentFloorOrder = [self calCurrentFloorOrder:beaconLocalityInfos];
    }];
}
- (IBAction)goCurrentLocation:(id)sender {
    if(self.currentFloorOrder == INT_MAX) {
        NSLog(@"Current location is unknown");
        return;
    }
    [self setDisplayedFloorOrder:self.currentFloorOrder];
}

- (void)tapOnRoom:(RoomLocalityInfo *)room {
    NSString *roomId = room.roomId;
    RoomDetailControllerViewController *vc = [[RoomDetailControllerViewController alloc] init];
    vc.roomId = roomId;
    [self.navigationController pushViewController:vc animated:YES];
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
