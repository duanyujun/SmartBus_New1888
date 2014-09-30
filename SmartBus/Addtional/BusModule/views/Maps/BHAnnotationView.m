//
//  BHAnnotationView.m
//  SmartBus
//
//  Created by launching on 13-10-31.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHAnnotationView.h"
#import "BHPointAnnotation.h"

@implementation BHAnnotationView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithAnnotation:nil reuseIdentifier:reuseIdentifier] )
    {
        //
    }
    return self;
}

- (void)setAnnotation:(BHPointAnnotation *)annotation
{
    if ( annotation.mode == AnnoModeStationIndicator )
    {
        self.image = [UIImage imageNamed:@"map_sta_loc.png"];
        self.canShowCallout = YES;
    }
    else if ( annotation.mode == AnnoModeRouteIndicator )
    {
        self.image = [UIImage imageNamed:@"map_pot.png"];
        self.canShowCallout = NO;
    }
    else if ( annotation.mode == AnnoModeBusIndicator )
    {
        self.image = [UIImage imageNamed:@"map_bus.png"];
        self.canShowCallout = NO;
    }
}

@end
