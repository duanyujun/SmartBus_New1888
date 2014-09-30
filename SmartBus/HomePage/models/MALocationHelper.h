//
//  MALocationHelper.h
//  SmartBus
//
//  Created by launching on 13-12-5.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MALocationDelegate;

@interface MALocationHelper : NSObject

@property (nonatomic, assign) BOOL usingReGeocode;

- (id)initWithDelegate:(id<MALocationDelegate>)delegate;

- (void)startLocating;
- (void)stopLocating;

@end


@protocol MALocationDelegate <NSObject>
@optional
- (void)locationHelperDidStartLocating:(MALocationHelper *)helper;
- (void)locationHelper:(MALocationHelper *)helper didFinishedReGeocode:(NSString *)address;
- (void)locationHelper:(MALocationHelper *)helper didFinishedLocating:(CLLocationCoordinate2D)coordinate;
- (void)locationHelper:(MALocationHelper *)helper didFaildLocating:(NSError *)error;
@end
