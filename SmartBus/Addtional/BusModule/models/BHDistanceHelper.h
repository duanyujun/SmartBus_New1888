//
//  BHDistanceHelper.h
//  SmartBus
//
//  Created by launching on 14-3-4.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BHDistanceHelper;

@protocol BHDistanceHelperDelegate <NSObject>
@optional
- (void)distanceHelper:(BHDistanceHelper *)helper didUpdateDistance:(CLLocationDistance)distance error:(NSError *)error;
@end

@interface BHDistanceHelper : NSObject<CLLocationManagerDelegate>

AS_SINGLETON( BHDistanceHelper );

@property (nonatomic, assign) id<BHDistanceHelperDelegate> delegate;
@property (nonatomic, assign) int tag;

- (void)startCalculatingDistanceByTargetCoordinate:(CLLocationCoordinate2D)targetCoor;

@end
