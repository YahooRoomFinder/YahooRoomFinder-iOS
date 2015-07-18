//
//  MapViewController.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/15/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "FloorMapViewController.h"
#import <MapKit/MapKit.h>
#import "../Control/RoomsLocalityManager.h"
#import "../Model/FloorLocalityInfo.h"
#import "../Control/YahooRoomsManager.h"
#import "../Model/RoomLocalityInfo.h"

@interface FloorMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) RoomsLocalityManager *roomsLocalityManager;

// Array of FloorLocalityInfo
@property (strong, nonatomic) NSArray *floorsLocality;

// Array of RoomLocalityInfo
@property (strong, nonatomic) NSArray *roomsLocality;
@property (strong, nonatomic) YahooRoomsManager *roomsManager;
@property (assign, nonatomic) NSInteger currentFloorIndex;
@property (strong, nonatomic) id<MKOverlay> floorOverlay;

// Array of id<MKOverlay>
@property (strong, nonatomic) NSArray* roomOverlays;
@end

@implementation FloorMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    self.roomsLocalityManager = [RoomsLocalityManager sharedInstance];
    self.roomsManager = [YahooRoomsManager sharedInstance];
    [self.roomsLocalityManager floors:^(NSArray *floors, NSError *error) {
        self.floorsLocality = [self sortFloorsLocality:floors];
        // TODO use user's current floor
        self.currentFloorIndex = 3;
        [self refreshCurrentFloor];
    }];
    /*

    MKCoordinateSpan span;
    span.latitudeDelta = 0.0004823;
    span.longitudeDelta = 0.0009575;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = CLLocationCoordinate2DMake(25.05736765, 121.6147612);
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
    
    // Floor
    CLLocationCoordinate2D floorCords[]={
        CLLocationCoordinate2DMake(25.057158, 121.6142824),
        CLLocationCoordinate2DMake(25.057349400000003, 121.6142964),
        CLLocationCoordinate2DMake(25.0573433, 121.614448),
        CLLocationCoordinate2DMake(25.057435600000005, 121.614454),
        CLLocationCoordinate2DMake(25.057435600000005, 121.6144989),
        CLLocationCoordinate2DMake(25.057608800000004, 121.614505),
        CLLocationCoordinate2DMake(25.0575766, 121.6152399),
        CLLocationCoordinate2DMake(25.0573858, 121.61522780000001),
        CLLocationCoordinate2DMake(25.0573931, 121.61506760000002),
        CLLocationCoordinate2DMake(25.0573154, 121.6150615),
        CLLocationCoordinate2DMake(25.0573135, 121.6150374),
        CLLocationCoordinate2DMake(25.0571265, 121.6150293),
        CLLocationCoordinate2DMake(25.057158, 121.6142824)
    };
    MKPolygon *floorPoly = [MKPolygon polygonWithCoordinates:floorCords count:sizeof(floorCords) / sizeof(floorCords[0])];
    [self.mapView addOverlay:floorPoly];
    
    // Dajia River
    CLLocationCoordinate2D cords1[]={
        CLLocationCoordinate2DMake(25.0574654, 121.6151098),
        CLLocationCoordinate2DMake(25.057431399999995, 121.6151072),
        CLLocationCoordinate2DMake(25.0574241, 121.6152298),
        CLLocationCoordinate2DMake(25.057458700000005, 121.6152318)
    };
    MKPolygon *poly1 = [MKPolygon polygonWithCoordinates:cords1 count:sizeof(cords1) / sizeof(cords1[0])];
    [self.mapView addOverlay:poly1];
    
    // Dongshan River
    CLLocationCoordinate2D cords2[]={
        CLLocationCoordinate2DMake(25.0575371, 121.6149643),
        CLLocationCoordinate2DMake(25.057491, 121.6149603),
        CLLocationCoordinate2DMake(25.0574891, 121.61498849999998),
        CLLocationCoordinate2DMake(25.0575346, 121.6149912)
    };
    
    MKPolygon *poly2 = [MKPolygon polygonWithCoordinates:cords2 count:sizeof(cords2) / sizeof(cords2[0])];
    [self.mapView addOverlay:poly2];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark map view
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay{
    if([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:overlay];
        view.lineWidth = 1;
        if (overlay == self.floorOverlay) {
            view.strokeColor = [UIColor purpleColor];
            view.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        } else {
            view.strokeColor = [UIColor blueColor];
            view.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        }
        return view;
    }
    return nil;
}

#pragma control logic
- (NSArray*) sortFloorsLocality:(NSArray*)floors {
    return [floors sortedArrayUsingComparator:^NSComparisonResult(id floor1, id floor2) {
        NSInteger order1 = ((FloorLocalityInfo*)floor1).order;
        NSInteger order2 = ((FloorLocalityInfo*)floor2).order;
        if (order1 < order2) {
            return NSOrderedAscending;
        } else if (order1 == order2) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
}

- (MKPolygon *)polygonForLocations:(NSArray*)locations {
    NSUInteger count = locations.count;
    CLLocationCoordinate2D* cords = malloc(sizeof(CLLocationCoordinate2D) * count);
    for (int i = 0; i < count; ++i) {
        CLLocation *loc = locations[i];
        cords[i] = loc.coordinate;
    }
    MKPolygon* polygon = [MKPolygon polygonWithCoordinates:cords count:count];
    free(cords);
    return polygon;
}

- (void)clearRoomOverlays {
    if (self.roomOverlays != nil) {
        [self.mapView removeOverlays:self.roomOverlays];
        self.roomOverlays = nil;
    }
}

- (void)clearFloorOverlay {
    if (self.floorOverlay != nil) {
        [self.mapView removeOverlay:self.floorOverlay];
        self.floorOverlay = nil;
    }
}

- (void)refreshCurrentFloor {
    [self clearFloorOverlay];
    [self clearRoomOverlays];
    if (self.floorsLocality == nil || self.currentFloorIndex < 0 || self.currentFloorIndex >= self.floorsLocality.count) {
        return;
    }
    FloorLocalityInfo* floor = self.floorsLocality[self.currentFloorIndex];
    NSArray *boundary = floor.boundary;
    MKPolygon *boundaryPolygon = [self polygonForLocations:boundary];
    
    // Notice that the field must be set before calling addOverlay, since viewForOverlay will be invoked immediately
    self.floorOverlay = boundaryPolygon;
    [self.mapView addOverlay:boundaryPolygon];
    
    NSInteger floorOrder = floor.order;
    [self.roomsLocalityManager roomsForFloorWithOrder:floorOrder complete:^(NSArray *rooms, NSError *error) {
        if (error != nil) {
            NSLog(@"Fail to get the rooms of floor %ld F", floorOrder + 1);
            return;
        }
        self.roomsLocality = rooms;
        [self refreshRooms];
    }];
    [self updateRegion];
}

- (void)refreshRooms {
    [self clearRoomOverlays];
    if (self.roomsLocality == nil) {
        return;
    }
    NSMutableArray *roomPolygons = [NSMutableArray array];
    for (RoomLocalityInfo *room in self.roomsLocality) {
        NSArray *boundary = room.boundary;
        MKPolygon *roomPolygon = [self polygonForLocations:boundary];
        [roomPolygons addObject:roomPolygon];
    }
    
    // Notice that we should set the field prior to calling addOverlay, since viewForOverlay will be invoked immediately
    self.roomOverlays = roomPolygons;
    for (MKPolygon* roomPolygon in roomPolygons) {
        [self.mapView addOverlay:roomPolygon];
    }
}

- (void)updateRegion {
    FloorLocalityInfo* floor = self.floorsLocality[self.currentFloorIndex];
    NSArray *boundary = floor.boundary;
    if (boundary.count == 0) {
        return;
    }
    CLLocationDegrees minLat = 90.0;
    CLLocationDegrees maxLat = -90.0;
    CLLocationDegrees minLng = 180.0;
    CLLocationDegrees maxLng = -180.0;
    
    for (CLLocation *loc in boundary) {
        minLat = MIN(loc.coordinate.latitude, minLat);
        maxLat = MAX(loc.coordinate.latitude, minLat);
        minLng = MIN(loc.coordinate.longitude, minLng);
        maxLng = MAX(loc.coordinate.longitude, maxLng);
    }
    
    MKCoordinateSpan span;
    span.latitudeDelta = (maxLat - minLat) / 1;
    span.longitudeDelta = (maxLng - minLng) / 1;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = CLLocationCoordinate2DMake((minLat + maxLat) / 2.0, (minLng + maxLng) / 2.0);
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
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
