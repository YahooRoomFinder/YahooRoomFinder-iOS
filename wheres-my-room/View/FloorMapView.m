//
//  FloorMapView.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/19/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "FloorMapView.h"

@interface FloorMapView ()
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSMutableArray *customConstraints;
@property (assign, nonatomic) CGFloat absoluteScale;
@property (assign, nonatomic) CGFloat relativeScale;
@property (weak, nonatomic) IBOutlet UIImageView *currentLocImageView;
@property (assign, nonatomic) CGPoint lastPanPoint;
@property (assign, nonatomic) CGSize initialMapSize;
@end

@implementation FloorMapView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commitInit];
    }
    self.currentLocImageView.hidden = YES;
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
}

- (void)resetCurrentRatioPoint {
    self.currentRatioPoint = CGPointMake(0.5, 0.5);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIImage *mapImage = self.mapImageView.image;
    //NSLog(@"Property updated for map with key path: %@", keyPath);
    CGRect bounds = self.mapImageView.bounds;
    self.mapImageView.center = CGPointMake(bounds.origin.x + bounds.size.width / 2.0, bounds.origin.y + bounds.size.height / 2.0);
    self.mapImageView.transform = CGAffineTransformIdentity;
    
    CGFloat initialScale = MIN(bounds.size.width / mapImage.size.width, bounds.size.height / mapImage.size.height);
    self.initialMapSize = CGSizeMake(initialScale * mapImage.size.width, initialScale * mapImage.size.height);
    //NSLog(@"Initial map size: (%f, %f)", self.initialMapSize.width, self.initialMapSize.height);
    [self updateCurrentRatioPoint];
}

- (void)setMapImage:(UIImage *)mapImage {
    self.mapImageView.image = mapImage;
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
    [self updateCurrentRatioPoint];
}

- (void)pinchEndedAtPoint:(CGPoint)point {
    self.absoluteScale = self.absoluteScale * self.relativeScale;
    self.relativeScale = 1.0;
    if (self.absoluteScale < 1.0) {
        self.absoluteScale = 1.0;
        [UIView animateWithDuration:0.2 animations:^{
            self.mapImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [self updateCurrentRatioPoint];
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
    [self updateCurrentRatioPoint];
}

- (void)panEndedAtPoint:(CGPoint) point {
    self.lastPanPoint = self.mapImageView.center;
}

- (void)showCurrentPoint:(BOOL)enable {
    self.currentLocImageView.hidden = !enable;
}

- (void)setCurrentRatioPoint:(CGPoint)ratioPoint{
    _currentRatioPoint = ratioPoint;
    [self updateCurrentRatioPoint];
}

- (void)updateCurrentRatioPoint {
    if (self.mapImageView == nil) {
        return;
    }
    CGPoint center = self.mapImageView.center;
    //NSLog(@"Bounds: (%f, %f) width: %f, height: %f", self.mapImageView.bounds.origin.x, self.mapImageView.bounds.origin.y, self.mapImageView.bounds.size.width, self.mapImageView.bounds.size.height);
    CGFloat scale = self.absoluteScale * self.relativeScale;
    CGFloat mapWidth = scale * self.initialMapSize.width;
    CGFloat mapHeight = scale * self.initialMapSize.height;
    CGPoint mapOrigin = CGPointMake(center.x - mapWidth / 2.0, center.y - mapHeight / 2);
    self.currentLocImageView.center = CGPointMake(mapOrigin.x + _currentRatioPoint.x * mapWidth,
                                                  mapOrigin.y + _currentRatioPoint.y * mapHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
