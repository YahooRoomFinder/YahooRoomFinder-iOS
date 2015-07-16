//
//  Utils.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (UIViewController*)embedNavBarForViewController:(UIViewController*)viewController {
    return [[UINavigationController alloc] initWithRootViewController:viewController];
}
@end
