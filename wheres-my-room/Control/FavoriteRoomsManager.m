//
//  FavoriteRoomsManager.m
//  wheres-my-room
//
//  Created by Pei-Chih Tsai on 7/21/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "FavoriteRoomsManager.h"

@implementation FavoriteRoomsManager

+ (FavoriteRoomsManager *) sharedInstance {
    static FavoriteRoomsManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    // Make the block to be thread-safe
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[FavoriteRoomsManager alloc] init];
        }
    });
    return instance;
}

NSString * const FAVORITE_ROOMS_KEY = @"favorite_rooms";

- (NSArray *) getFavoriteRooms {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *favoriteRooms = [prefs arrayForKey:FAVORITE_ROOMS_KEY];
    if (favoriteRooms) {
        return favoriteRooms;
    } else {
        return [NSArray arrayWithObjects:nil];
    }
}

- (void) setFavoriteRooms:(NSArray *)favoriteRooms {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:favoriteRooms forKey:FAVORITE_ROOMS_KEY];
    [prefs synchronize];
}

- (void) addFavoriteRoom:(NSString *)roomId {
    NSArray *favoriteRooms = [self getFavoriteRooms];
    if (![favoriteRooms containsObject:roomId]) {
        [self setFavoriteRooms:[favoriteRooms arrayByAddingObject:roomId]];
    }
}

- (void) removeFavoriteRoom:(NSString *)roomId {
    NSArray *favoriteRooms = [self getFavoriteRooms];
    if ([favoriteRooms containsObject:roomId]) {
        NSMutableArray *mutableFavoriteRooms = [NSMutableArray arrayWithArray:favoriteRooms];
        [mutableFavoriteRooms removeObject:roomId];
        [self setFavoriteRooms:mutableFavoriteRooms];
    }
}

- (BOOL) isFavoriteRoom:(NSString *)roomId {
    NSArray *favoriteRooms = [self getFavoriteRooms];
    return [favoriteRooms containsObject:roomId];
}


@end
