//
//  SBAnnotationView.m
//  SmartBus
//
//  Created by launching on 14-4-23.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "SBAnnotationView.h"
#import "MADepotView.h"

#define kDepotViewTag   152472

@implementation SBAnnotationView

@synthesize calloutView = __calloutView;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(__depotView);
    SAFE_RELEASE_SUBVIEW(__calloutView);
    [super dealloc];
}

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier] )
    {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.userInteractionEnabled = YES;
        
        __depotView = [[MADepotView alloc] init];
        [self addSubview:__depotView];
        __depotView.hidden = YES;
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithAnnotation:nil reuseIdentifier:reuseIdentifier];
}

- (void)setPointAnnotation:(SBAnnotation *)annotation
{
    if ( !annotation ) return;
    
    __depotView.hidden = YES;
    
    if ( annotation.mode == SBAnnoModeStationIndicator )
    {
        __depotView.hidden = NO;
        [__depotView setDepotName:annotation.title];
        self.frame = __depotView.bounds;
        
        self.centerOffset = CGPointMake(0, -31);
    }
    else if ( annotation.mode == SBAnnoModeRouteIndicator )
    {
        self.image = [UIImage imageNamed:@"map_pot.png"];
    }
    else if ( annotation.mode == SBAnnoModeBusIndicator )
    {
        self.image = [UIImage imageNamed:@"map_bus.png"];
    }
    else if ( annotation.mode == SBAnnoModeFeetIndicator )
    {
        self.image = [UIImage imageNamed:@"map_footprint.png"];
    }
}


- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if ( self.selected == selected )
        return;
    
    SBAnnotation *annotation = (SBAnnotation *)self.annotation;
    if ( annotation.mode == SBAnnoModeRouteIndicator || annotation.mode == SBAnnoModeBusIndicator )
    {
        if ( !annotation.canCallout )
            return;
        
        if ( selected )
        {
            if (self.calloutView == nil)
            {
                /* Construct custom callout. */
                CGSize size = annotation.mode == SBAnnoModeRouteIndicator ? CGSizeMake(120, 60) : CGSizeMake(180, 60);
                __calloutView = [[SBCalloutView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                      -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            }
            [self.calloutView fillCalloutTitle:annotation.title andSubtitle:annotation.subtitle];
            [self.calloutView showInView:self];
        }
        else
        {
            [self.calloutView dismiss];
        }
        
        [super setSelected:selected animated:animated];
    }
    else if ( annotation.mode == SBAnnoModeStationIndicator )
    {
        if ( [self.delegate respondsToSelector:@selector(annotationView:didSelectAnnotation:)] )
        {
            [self.delegate annotationView:self didSelectAnnotation:self.annotation];
        }
    }
}

@end
