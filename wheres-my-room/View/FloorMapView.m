//
//  FloorMapView.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/19/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "FloorMapView.h"
#import "../Model/RoomLocalityInfo.h"

@interface FloorMapView ()
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSMutableArray *customConstraints;
@property (assign, nonatomic) CGFloat absoluteScale;
@property (assign, nonatomic) CGFloat relativeScale;
@property (weak, nonatomic) IBOutlet UIImageView *currentLocImageView;
@property (assign, nonatomic) CGPoint lastPanPoint;
@property (weak, nonatomic) IBOutlet UIImageView *roomPinImageView;
@property (assign, nonatomic) CGSize initialMapSize;
@end

@implementation FloorMapView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commitInit];
    }
    self.currentLocImageView.hidden = YES;
    
    //self.interestedRoomId = @"CR-TW-12FS-LoveRiver";
    [self.roomPinImageView.layer setOpaque:NO];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.absoluteScale = 1.0;
    self.relativeScale = 1.0;
    self.initialMapSize = CGSizeMake(0.0, 0.0);
    [self resetCurrentRatioPoint];
    UIView *view = nil;
    NSArray *viewObjs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FloorMapView class]) owner:self options:nil];
    for (id nowViewObj in viewObjs) {
        if ([nowViewObj isKindOfClass:[UIView class]]) {
            view = nowViewObj;
            break;
        }
    }
    
    if (view == nil) {
        return;
    }
    
    self.containerView = view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    [self setNeedsUpdateConstraints];
    [self.mapImageView addObserver:self forKeyPath:@"bounds" options:0 context:nil];
    [self.mapImageView addObserver:self forKeyPath:@"image" options:0 context:nil];
}

- (void)drawRoomPin:(NSString *)roomId {
    for (RoomLocalityInfo *roomLocalityInfo in self.roomLocalityInfos) {
        if ([roomLocalityInfo.roomId compare:roomId] == NSOrderedSame) {
            CGPoint mapOrigin = [self mapOrigin];
            CGFloat mapWidth = [self mapWidth];
            CGFloat mapHeight = [self mapHeight];

            CGPoint roomOrigin = roomLocalityInfo.ratioLocation;
            CGPoint roomCenter = CGPointMake(roomOrigin.x + roomLocalityInfo.ratioWidth / 2,
                                             roomOrigin.y + roomLocalityInfo.ratioHeight / 2);
            CGPoint realPoint = CGPointMake(roomCenter.x * mapWidth + mapOrigin.x,
                                             roomCenter.y * mapHeight + mapOrigin.y - 12);
            self.roomPinImageView.center = realPoint;
            self.roomPinImageView.hidden = NO;
        }
    }

}

- (void)resetCurrentRatioPoint {
    self.currentRatioPoint = CGPointMake(0.5, 0.5);
}

- (void)resetMapSize {
    CGRect bounds = self.mapImageView.bounds;
    self.mapImageView.center = CGPointMake(bounds.origin.x + bounds.size.width / 2.0, bounds.origin.y + bounds.size.height / 2.0);
    self.mapImageView.transform = CGAffineTransformIdentity;
    self.absoluteScale = 1.0;
    self.relativeScale = 1.0;
}

- (void)updateInitialMapSize {
    UIImage *mapImage = self.mapImageView.image;
    CGRect bounds = self.mapImageView.bounds;
    CGFloat initialScale = MIN(bounds.size.width / mapImage.size.width, bounds.size.height / mapImage.size.height);
    self.initialMapSize = CGSizeMake(initialScale * mapImage.size.width, initialScale * mapImage.size.height);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self resetMapSize];
    [self updateInitialMapSize];
    [self updateCurrentRatioPoint:FALSE];
    [self drawRoomPin:self.interestedRoomId];
}

- (void)setMapImage:(UIImage *)mapImage {
    self.mapImageView.image = mapImage;
    [self resetMapSize];
    [self updateInitialMapSize];
    [self resetCurrentRatioPoint];
}

- (void)updateConstraints {
    //NSLog(@"Constraints updated");
    if (self.customConstraints != nil) {
        [NSLayoutConstraint deactivateConstraints:self.customConstraints];
    }
    self.customConstraints = [[NSMutableArray alloc] init];
    UIView *view = self.containerView;
    NSDictionary *views = @{@"view": view};
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
    if (self.containerView != nil) {
        [self addConstraints:self.customConstraints];
    }
    [super updateConstraints];
}

- (void)pinchBeganAtPoint:(CGPoint)point {
    [self pinchEndedAtPoint:point];
}

- (void)pinchChangedAtPoint:(CGPoint)point :(CGFloat)scale {
    self.relativeScale = scale;
    CGFloat nowScale = self.absoluteScale * scale;
    self.mapImageView.transform = CGAffineTransformMakeScale(nowScale, nowScale);
    [self updateCurrentRatioPoint:FALSE];
    [self drawRoomPin:self.interestedRoomId];
}

- (void)pinchEndedAtPoint:(CGPoint)point {
    self.absoluteScale = self.absoluteScale * self.relativeScale;
    self.relativeScale = 1.0;
    if (self.absoluteScale < 1.0) {
        self.absoluteScale = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.mapImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [self updateCurrentRatioPoint:FALSE];
            [self drawRoomPin:self.interestedRoomId];
        } completion:^(BOOL finished) {
            self.absoluteScale = 1.0;
        }];
    }
}

- (void)panBeganAtPoint:(CGPoint)point {
    self.lastPanPoint = point;
}

- (void)panChangedAtPoint:(CGPoint)point {
    CGPoint center = self.mapImageView.center;
    CGPoint newCenter = CGPointMake(point.x - self.lastPanPoint.x + center.x, point.y - self.lastPanPoint.y + center.y);
    self.mapImageView.center = newCenter;
    self.lastPanPoint = point;
    [self updateCurrentRatioPoint:FALSE];
    [self drawRoomPin:self.interestedRoomId];
}

- (void)panEndedAtPoint:(CGPoint) point {
    self.lastPanPoint = self.mapImageView.center;
}

- (void)showCurrentPoint:(BOOL)enable {
    self.currentLocImageView.hidden = !enable;
}

- (void)setCurrentRatioPoint:(CGPoint)ratioPoint {
    [self setCurrentRatioPoint:ratioPoint animated:FALSE];
}

- (void)setCurrentRatioPoint:(CGPoint)ratioPoint animated:(BOOL)animated {
    _currentRatioPoint = ratioPoint;
    [self updateCurrentRatioPoint:animated];
    [self drawRoomPin:self.interestedRoomId];
}

- (CGFloat)mapWidth {
    CGFloat scale = self.absoluteScale * self.relativeScale;
    return scale * self.initialMapSize.width;
}

- (CGFloat)mapHeight {
    CGFloat scale = self.absoluteScale * self.relativeScale;
    return scale * self.initialMapSize.height;
}

- (CGPoint) mapOrigin {
    CGPoint center = self.mapImageView.center;
    CGFloat mapWidth = [self mapWidth];
    CGFloat mapHeight = [self mapHeight];
    return CGPointMake(center.x - mapWidth / 2.0, center.y - mapHeight / 2);
}
- (CGPoint) realPointForRatioPoint:(CGPoint) ratioPoint {
    CGFloat mapWidth = [self mapWidth];
    CGFloat mapHeight = [self mapHeight];
    CGPoint mapOrigin = [self mapOrigin];
    return CGPointMake(mapOrigin.x + ratioPoint.x * mapWidth,
                       mapOrigin.y + ratioPoint.y * mapHeight);
}

- (void)updateCurrentRatioPoint:(BOOL)animated {
    if (self.mapImageView == nil) {
        return;
    }
    void(^func)() = ^{
        self.currentLocImageView.center = [self realPointForRatioPoint:_currentRatioPoint];
    };
    if (!animated) {
        func();
    } else {
        [UIView animateWithDuration:0.1 animations:func];
    }
}
- (IBAction)onMapImageTap:(UITapGestureRecognizer *)gesture {
    if (self.roomLocalityInfos == nil ||
        self.roomLocalityInfos.count == 0 ||
        self.delegate == nil) {
        return;
    }
    CGPoint point = [gesture locationInView:self];
    CGPoint mapOrigin = [self mapOrigin];
    CGFloat mapWidth = [self mapWidth];
    CGFloat mapHeight = [self mapHeight];
    CGPoint ratioPoint = CGPointMake((point.x - mapOrigin.x) / mapWidth,
                        (point.y - mapOrigin.y) / mapHeight);
    //NSLog(@"aaa : %@", NSStringFromCGPoint(ratioPoint));
    for (RoomLocalityInfo *roomLocalityInfo in self.roomLocalityInfos) {
        CGPoint roomOrigin = roomLocalityInfo.ratioLocation;
        if (ratioPoint.x >= roomOrigin.x &&
            ratioPoint.x <= roomOrigin.x + roomLocalityInfo.ratioWidth &&
            ratioPoint.y >= roomOrigin.y &&
            ratioPoint.y <= roomOrigin.y + roomLocalityInfo.ratioHeight) {
            [self.delegate tapOnRoom:roomLocalityInfo];
            break;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
