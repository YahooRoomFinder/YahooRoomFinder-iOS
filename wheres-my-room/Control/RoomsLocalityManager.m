//
//  RoomsManager.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "RoomsLocalityManager.h"
#import "../Model/FloorLocalityInfo.h"
#import "../Model/RoomLocalityInfo.h"
#import <CoreLocation/CLLocation.h>
@interface RoomsLocalityManager ()
@property (strong, nonatomic) NSDictionary *building;
@property (strong, nonatomic) NSDictionary *floors;
@end

@implementation RoomsLocalityManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initBuilding];
        [self initFloors];
    }
    return self;
}

+ (RoomsLocalityManager *) sharedInstance {
    static RoomsLocalityManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    // Make the block to be thread-safe
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[RoomsLocalityManager alloc] init];
        }
    });
    return instance;
}

- (FloorLocalityInfo*) floorInfoForOrder:(NSInteger)floorOrder {
    NSDictionary *floorDic = [self.floors objectForKey:@(floorOrder)];
    FloorLocalityInfo* floor = [[FloorLocalityInfo alloc] init];
    floor.order = floorOrder;
    floor.realWidthForMap = [floorDic[@"realWidth"] doubleValue];
    floor.realHeightForMap = [floorDic[@"realHeight"] doubleValue];
    floor.mapImageName = [NSString stringWithFormat:@"TW-%ldF", floorOrder + 1];
    return floor;
}

- (void) floors:(void(^)(NSArray *floors, NSError *error))completion {
    // TODO Don't hard-code the data here
    NSMutableArray *floors = [NSMutableArray array];
    for (id key in self.floors) {
        NSInteger floorOrder = [key integerValue];
        [floors addObject:[self floorInfoForOrder:floorOrder]];
    }
    completion(floors, nil);
}

- (void) floorForOrder:(NSInteger) floorOrder complete:(void(^)(FloorLocalityInfo *floor, NSError *error))completion {
    completion([self floorInfoForOrder:floorOrder], nil);
}

- (void) roomsForFloorWithOrder:(NSInteger)floorOrder complete:(void(^)(NSArray *rooms, NSError *error))completion {
    NSDictionary *floorDic = self.floors[@(floorOrder)];
    if (floorDic == nil) {
        NSError *err = [[NSError alloc] initWithDomain:@"RoomsLocalityManagerDomain" code:1 userInfo:
        @{
          NSLocalizedDescriptionKey: [NSString stringWithFormat: @"Invalid floor order: %ld", floorOrder]
          }];
        completion(nil, err);
        return;
    }
    NSMutableArray *rooms = [NSMutableArray array];
    for (NSDictionary *roomDic in floorDic[@"rooms"]) {
        RoomLocalityInfo* roomInfo = [[RoomLocalityInfo alloc] init];
        roomInfo.roomId = roomDic[@"id"];
        roomInfo.ratioWidth = [roomDic[@"ratioWidth"] doubleValue];
        roomInfo.ratioHeight = [roomDic[@"ratioHeight"] doubleValue];
        roomInfo.ratioLocation = CGPointMake([roomDic[@"ratioLocation"][0] doubleValue], [roomDic[@"ratioLocation"][1] doubleValue]);
        [rooms addObject:roomInfo];
    }
    
    completion(rooms, nil);
}

- (void)initBuilding {
    self.building =
    @{
      @"boundary": @[
              @{
                  @"lat": @(25.0571082),
                  @"lng": @(121.6142797)
                  },
              @{
                  @"lat": @(25.0572996),
                  @"lng": @(121.6142937)
                  },
              @{
                  @"lat": @(25.0572935),
                  @"lng": @(121.6144453)
                  },
              @{
                  @"lat": @(25.0573858),
                  @"lng": @(121.6144513)
                  },
              @{
                  @"lat": @(25.0573858),
                  @"lng": @(121.6144962)
                  },
              @{
                  @"lat": @(25.057559),
                  @"lng": @(121.6145023)
                  },
              @{
                  @"lat": @(25.0575268),
                  @"lng": @(121.61523720000001)
                  },
              @{
                  @"lat": @(25.057336),
                  @"lng": @(121.61522510000002)
                  },
              @{
                  @"lat": @(25.0573433),
                  @"lng": @(121.6150649)
                  },
              @{
                  @"lat": @(25.0572656),
                  @"lng": @(121.6150588)
                  },
              @{
                  @"lat": @(25.057263700000004),
                  @"lng": @(121.61503470000001)
                  },
              @{
                  @"lat": @(25.0570767),
                  @"lng": @(121.61502660000001)
                  },
              @{
                  @"lat": @(25.0571082),
                  @"lng": @(121.6142797)
                  },
              ]
      };
}

- (void)initFloors {
    self.floors =
    @{
      @(9): @{
              @"realWidth": @(90.0),
              @"realHeight": @(49.7277937),
              @"rooms": @[]
              },
      @(10): @{
              @"realWidth": @(90.04297994),
              @"realHeight": @(49.59885387),
              @"rooms": @[]
              },
      @(11): @{
              @"realWidth": @(90.04297994),
              @"realHeight": @(49.51289398),
              @"rooms": @[
                      @{
                          @"id": @"CR-TW-12FN-DanshuiRiver",
                          @"ratioLocation": @[@(0.4415231188), @(0.1449752883)],
                          @"ratioWidth": @(0.04079782412),
                          @"ratioHeight": @(0.1136738056)
                          },
                      @{
                          @"id": @"CR-TW-12FN-NanFangAo",
                          @"ratioLocation": @[@(0.5496326455), @(0.2841784860)],
                          @"ratioWidth": @(0.0481584),
                          @"ratioHeight": @(0.06747215)
                          },
                      @{
                          @"id": @"CR-TW-12FN-HoneymoonBay",
                          @"ratioLocation": @[@(0.6656059560), @(0.2841784860)],
                          @"ratioWidth": @(0.06584925),
                          @"ratioHeight": @(0.06791898)
                          },
                      @{
                          @"id": @"CR-TW-12FN-DongshanRiver",
                          @"ratioLocation": @[@(0.7265410852), @(0.1447658311)],
                          @"ratioWidth": @(0.03685592),
                          @"ratioHeight": @(0.10902785)
                          },
                      @{
                          @"id": @"VC-TW-12FN-DajiaRiver",
                          @"ratioLocation": @[@(0.8833016193), @(0.2837316506)],
                          @"ratioWidth": @(0.11302484),
                          @"ratioHeight": @(0.06791899)
                          },
                      @{
                          @"id": @"CR-TW-12FS-Cijin",
                          @"ratioLocation": @[@(0.7001571599), @(0.6463596483)],
                          @"ratioWidth": @(0.06262159),
                          @"ratioHeight": @(0.06748572)
                          },
                      @{
                          @"id": @"CR-TW-12FS-LianchiPond",
                          @"ratioLocation": @[@(0.4828102552), @(0.6474392987)],
                          @"ratioWidth": @(0.05362174),
                          @"ratioHeight": @(0.06625437)
                          },
                      @{
                          @"id": @"CR-TW-12FS-LiyuPond",
                          @"ratioLocation": @[@(0.2382853401), @(0.7428453919)],
                          @"ratioWidth": @(0.03829487),
                          @"ratioHeight": @(0.11149959)
                          },
                      @{
                          @"id": @"VC-TW-12FS-QixingTan",
                          @"ratioLocation": @[@(0.0427145067), @(0.6454382755)],
                          @"ratioWidth": @(0.076030223),
                          @"ratioHeight": @(0.06712535)
                          },
                      @{
                          @"id": @"CR-TW-12FS-TsengwenRiver",
                          @"ratioLocation": @[@(0.4041441568), @(0.6461221598)],
                          @"ratioWidth": @(0.07793321),
                          @"ratioHeight": @(0.06701843)
                          },
                      @{
                          @"id": @"CR-TW-12FS-XiziWan",
                          @"ratioLocation": @[@(0.5308108067), @(0.7417058282)],
                          @"ratioWidth": @(0.03806041),
                          @"ratioHeight": @(0.11133117)
                          },
                      @{
                          @"id": @"CR-TW-12FS-LoveRiver",
                          @"ratioLocation": @[@(0.5631983736), @(0.6449581064)],
                          @"ratioWidth": @(0.07088467),
                          @"ratioHeight": @(0.06989051)
                          }
                      ]
              },
      @(12): @{
              @"realWidth": @(90.47277937),
              @"realHeight": @(33.43839542),
              @"rooms": @[]
              },
      @(13): @{
              @"realWidth": @(90.17191977),
              @"realHeight": @(49.64183381),
              @"rooms": @[
                      @{
                          @"id": @"VC-TW-14FN-Taipei101",
                          @"ratioLocation": @[@(0.3083916084), @(0.01013941698)],
                          @"ratioWidth": @(0.09440559441),
                          @"ratioHeight": @(0.124207858)
                          },
                      @{
                          @"id": @"CR-TW-14FN-MetroOperaHouse",
                          @"ratioLocation": @[@(0.4615384615), @(0.2877059569)],
                          @"ratioWidth": @(0.04195804196),
                          @"ratioHeight": @(0.06717363752)
                          },
                      @{
                          @"id": @"CR-TW-14FN-FineArtMuseum",
                          @"ratioLocation": @[@(0.3), @(0.2877059569)],
                          @"ratioWidth": @(0.04265734266),
                          @"ratioHeight": @(0.06337135615)
                          },
                      @{
                          @"id": @"CR-TW-14FN-LanyangMuseum",
                          @"ratioLocation": @[@(0.2601398601), @(0.2864385298)],
                          @"ratioWidth": @(0.04125874126),
                          @"ratioHeight": @(0.06590621039)
                          }
                      ]
              },
      @(14): @{
              @"realWidth": @(91.67621777),
              @"realHeight": @(49.51289398),
              @"rooms": @[]
              },
      @(15): @{
              @"realWidth": @(90),
              @"realHeight": @(49.64183381),
              @"rooms": @[]
              },
      };
}
@end
