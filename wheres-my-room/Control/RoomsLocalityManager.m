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

- (void) floors:(void(^)(NSArray *floors, NSError *error))completion {
    // TODO Don't hard-code the data here
    NSMutableArray *floors = [NSMutableArray array];
    for (int i = 10; i <= 16; ++i) {
        FloorLocalityInfo* floor = [[FloorLocalityInfo alloc] init];
        NSMutableArray *boundary = [NSMutableArray array];
        for (NSDictionary* boundaryDic in self.building[@"boundary"]) {
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:[boundaryDic[@"lat"] doubleValue] longitude:[boundaryDic[@"lng"] doubleValue]];
            [boundary addObject:loc];
        }

        floor.boundary = boundary;
        floor.order = i - 1;
        [floors addObject:floor];
    }
    completion(floors, nil);
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
        NSMutableArray *boundary = [NSMutableArray array];
        for (NSDictionary *boundaryPointDic in roomDic[@"boundary"]) {
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:[boundaryPointDic[@"lat"] doubleValue] longitude:[boundaryPointDic[@"lng"] doubleValue]];
            [boundary addObject:loc];
        }
        roomInfo.boundary = boundary;
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
      @(12): @{
              @"rooms": @[
                      @{
                          @"id": @"VC-TW-12FN-DajiaRiver",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.057412599999996),
                                      @"lng": @(121.6151051)
                                      },
                                  @{
                                      @"lat": @(25.0573786),
                                      @"lng": @(121.6151025)
                                      },
                                  @{
                                      @"lat": @(25.057371300000003),
                                      @"lng": @(121.61522510000002)
                                      },
                                  @{
                                      @"lat": @(25.057405899999996),
                                      @"lng": @(121.6152271)
                                      },
                                  @{
                                      @"lat": @(25.057412599999996),
                                      @"lng": @(121.6151051)
                                      },
                                  
                                  ]
                          },
                      @{
                          @"id": @"CR-TW-12FN-DanshuiRiver",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.057481800000005),
                                      @"lng": @(121.6147014)
                                      },
                                  @{
                                      @"lat": @(25.057436200000005),
                                      @"lng": @(121.6147001)
                                      },
                                  @{
                                      @"lat": @(25.057435000000005),
                                      @"lng": @(121.6147336)
                                      },
                                  @{
                                      @"lat": @(25.057480600000005),
                                      @"lng": @(121.6147356)
                                      },
                                  @{
                                      @"lat": @(25.057481800000005),
                                      @"lng": @(121.6147014)
                                      },
                                  
                                  ]
                          },
                      @{
                          @"id": @"CR-TW-12FN-DongshanRiver",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.0575371),
                                      @"lng": @(121.6149643)
                                      },
                                  @{
                                      @"lat": @(25.057491),
                                      @"lng": @(121.6149603)
                                      },
                                  @{
                                      @"lat": @(25.0574891),
                                      @"lng": @(121.61498849999998)
                                      },
                                  @{
                                      @"lat": @(25.0575346),
                                      @"lng": @(121.6149912)
                                      },
                                  @{
                                      @"lat": @(25.0575371),
                                      @"lng": @(121.6149643)
                                      },
                                  
                                  ]
                          },
                      @{
                          @"id": @"CR-TW-12FN-HoneymoonBay",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.057412499999998),
                                      @"lng": @(121.61490190000002)
                                      },
                                  @{
                                      @"lat": @(25.057385200000002),
                                      @"lng": @(121.61489990000001)
                                      },
                                  @{
                                      @"lat": @(25.0573821),
                                      @"lng": @(121.6149697)
                                      },
                                  @{
                                      @"lat": @(25.0574089),
                                      @"lng": @(121.6149723)
                                      },
                                  @{
                                      @"lat": @(25.057412499999998),
                                      @"lng": @(121.61490190000002)
                                      },
                                  
                                  ]
                          },
                      @{
                          @"id": @"CR-TW-12FN-NanFangAo",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.057418000000002),
                                      @"lng": @(121.6147664)
                                      },
                                  @{
                                      @"lat": @(25.0573913),
                                      @"lng": @(121.6147651)
                                      },
                                  @{
                                      @"lat": @(25.0573901),
                                      @"lng": @(121.6148215)
                                      },
                                  @{
                                      @"lat": @(25.057416900000003),
                                      @"lng": @(121.6148221)
                                      },
                                  @{
                                      @"lat": @(25.057418000000002),
                                      @"lng": @(121.6147664)
                                      },
                                  ]
                          },
                      @{
                          @"id": @"CR-TW-12FS-Cijin",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.057243700000004),
                                      @"lng": @(121.6149415)
                                      },
                                  @{
                                      @"lat": @(25.057215800000005),
                                      @"lng": @(121.61493950000002)
                                      },
                                  @{
                                      @"lat": @(25.0572139),
                                      @"lng": @(121.61499179999998)
                                      },
                                  @{
                                      @"lat": @(25.057241300000005),
                                      @"lng": @(121.6149938)
                                      },
                                  @{
                                      @"lat": @(25.057243700000004),
                                      @"lng": @(121.6149415)
                                      },
                                  
                                  ]
                          },
                      @{
                          @"id": @"CR-TW-12FS-LianchiPond",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.0572485),
                                      @"lng": @(121.6147323)
                                      },
                                  @{
                                      @"lat": @(25.0572218),
                                      @"lng": @(121.61473099999999)
                                      },
                                  @{
                                      @"lat": @(25.057220600000004),
                                      @"lng": @(121.6147765)
                                      },
                                  @{
                                      @"lat": @(25.057247900000004),
                                      @"lng": @(121.6147786)
                                      },
                                  @{
                                      @"lat": @(25.0572485),
                                      @"lng": @(121.6147323)
                                      },
                                  
                                  ]
                          },
                      @{
                          @"id": @"CR-TW-12FS-LiyuPond",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.0572127),
                                      @"lng": @(121.6145472)
                                      },
                                  @{
                                      @"lat": @(25.057165299999998),
                                      @"lng": @(121.6145452)
                                      },
                                  @{
                                      @"lat": @(25.0571635),
                                      @"lng": @(121.6145754)
                                      },
                                  @{
                                      @"lat": @(25.057211499999998),
                                      @"lng": @(121.61457800000001)
                                      },
                                  @{
                                      @"lat": @(25.0572127),
                                      @"lng": @(121.6145472)
                                      },
                                  
                                  ]
                          },
                      @{
                          @"id": @"CR-TW-12FS-LoveRiver",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.057246700000004),
                                      @"lng": @(121.61480270000001)
                                      },
                                  @{
                                      @"lat": @(25.0572212),
                                      @"lng": @(121.61480129999998)
                                      },
                                  @{
                                      @"lat": @(25.057220000000004),
                                      @"lng": @(121.61485229999998)
                                      },
                                  @{
                                      @"lat": @(25.057246099999997),
                                      @"lng": @(121.61485370000001)
                                      },
                                  @{
                                      @"lat": @(25.057246700000004),
                                      @"lng": @(121.61480270000001)
                                      },
                                  ]
                          },
                      @{
                          @"id": @"VC-TW-12FS-QixingTan",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.0572674),
                                      @"lng": @(121.61433469999999)
                                      },
                                  @{
                                      @"lat": @(25.057241300000005),
                                      @"lng": @(121.61433340000002)
                                      },
                                  @{
                                      @"lat": @(25.057240100000005),
                                      @"lng": @(121.6143877)
                                      },
                                  @{
                                      @"lat": @(25.057266800000004),
                                      @"lng": @(121.61438899999999)
                                      },
                                  @{
                                      @"lat": @(25.0572674),
                                      @"lng": @(121.61433469999999)
                                      },
                                  ]
                          },
                      @{
                          @"id": @"CR-TW-12FS-TsengwenRiver",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.0572491),
                                      @"lng": @(121.6147329)
                                      },
                                  @{
                                      @"lat": @(25.0572504),
                                      @"lng": @(121.61466920000001)
                                      },
                                  @{
                                      @"lat": @(25.057224200000004),
                                      @"lng": @(121.61466860000002)
                                      },
                                  @{
                                      @"lat": @(25.0572224),
                                      @"lng": @(121.61473160000001)
                                      },
                                  @{
                                      @"lat": @(25.0572491),
                                      @"lng": @(121.6147329)
                                      },
                                  ]
                          },
                      @{
                          @"id": @"CR-TW-12FS-XiziWan",
                          @"boundary": @[
                                  @{
                                      @"lat": @(25.0572066),
                                      @"lng": @(121.6147759)
                                      },
                                  @{
                                      @"lat": @(25.057159199999997),
                                      @"lng": @(121.61477450000001)
                                      },
                                  @{
                                      @"lat": @(25.057159800000004),
                                      @"lng": @(121.61480600000002)
                                      },
                                  @{
                                      @"lat": @(25.057206),
                                      @"lng": @(121.61480609999998)
                                      },
                                  @{
                                      @"lat": @(25.0572066),
                                      @"lng": @(121.6147759)
                                      },
                                  ]
                          }
                      ]
              }
      };
}
@end
