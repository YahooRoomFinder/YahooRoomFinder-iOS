//
//  FavoriteRoomsManager.h
//  wheres-my-room
//
//  Created by Pei-Chih Tsai on 7/21/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteRoomsManager : NSObject

+ (FavoriteRoomsManager *) sharedInstance;

- (NSArray *) getFavoriteRooms;
- (void) addFavoriteRoom:(NSString *)roomId;
- (void) removeFavoriteRoom:(NSString *)roomId;
- (BOOL) isFavoriteRoom:(NSString *)roomId;

@end
