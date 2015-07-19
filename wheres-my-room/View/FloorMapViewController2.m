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
#import "Floor.h"

@interface FloorMapViewController2 () <UIGestureRecognizerDelegate, FloorsViewDelegate>
@property (weak, nonatomic) IBOutlet FloorMapView *floorMapView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGesture;

@end

@implementation FloorMapViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pinchGesture.delegate = self;
    [self.floorMapView showCurrentPoint:YES];
    [self setCurrentFloor:12];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Floors" style:UIBarButtonItemStylePlain target:self action:@selector(doFloorSelect)];
    // Prevent the navigation bar from overlapping the view
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)doFloorSelect {
    FloorsViewController *vc = [[FloorsViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setCurrentFloor:(NSInteger)floorOrder {
    [self.floorMapView setMapImage:[UIImage imageNamed:[NSString stringWithFormat:@"TW-%ldF", floorOrder + 1]]];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld F", floorOrder + 1];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
