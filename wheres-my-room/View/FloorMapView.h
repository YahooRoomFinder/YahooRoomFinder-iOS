//
//  FloorMapView.h
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/19/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/RoomLocalityInfo.h"

@protocol FloorMapViewDelegate
@optional
- (void)tapOnRoom:(RoomLocalityInfo *)room;
@end

@interface FloorMapView : UIView
@property (assign, nonatomic) CGPoint currentRatioPoint;
@property (strong, nonatomic) NSArray *roomLocalityInfos;
@property (weak, nonatomic) id<FloorMapViewDelegate> delegate;
@property (strong, nonatomic) NSString *interestedRoomId;

- (void)setCurrentRatioPoint:(CGPoint)ratioPoint animated:(BOOL)animated;
- (void)pinchBeganAtPoint:(CGPoint)point;
- (void)pinchChangedAtPoint:(CGPoint)point :(CGFloat)scale;
- (void)pinchEndedAtPoint:(CGPoint)point;
- (void)panBeganAtPoint:(CGPoint)point;
- (void)panChangedAtPoint:(CGPoint)point;
- (void)panEndedAtPoint:(CGPoint) point;
- (void)showCurrentPoint:(BOOL)enable;
- (void)setMapImage:(UIImage *)mapImage;

// @param rooms array of RoomLocalityInfo
- (void)setRoomLocalityInfos:(NSArray*)rooms;
@end
