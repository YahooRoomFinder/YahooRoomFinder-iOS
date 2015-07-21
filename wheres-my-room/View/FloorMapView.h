//
//  FloorMapView.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/19/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloorMapView : UIView
@property (assign, nonatomic) CGPoint currentRatioPoint;
- (void)setCurrentRatioPoint:(CGPoint)ratioPoint animated:(BOOL)animated;
- (void)pinchBeganAtPoint:(CGPoint)point;
- (void)pinchChangedAtPoint:(CGPoint)point :(CGFloat)scale;
- (void)pinchEndedAtPoint:(CGPoint)point;
- (void)panBeganAtPoint:(CGPoint)point;
- (void)panChangedAtPoint:(CGPoint)point;
- (void)panEndedAtPoint:(CGPoint) point;
- (void)showCurrentPoint:(BOOL)enable;
- (void)setMapImage:(UIImage *)mapImage;
@end
