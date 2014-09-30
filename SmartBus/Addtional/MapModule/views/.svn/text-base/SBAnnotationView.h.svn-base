//
//  SBAnnotationView.h
//  SmartBus
//
//  Created by launching on 14-4-23.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "SBAnnotation.h"
#import "MADepotView.h"
#import "SBCalloutView.h"

@class SBAnnotationView;

@protocol SBAnnotationViewDelegate <NSObject>
@optional
- (void)annotationView:(SBAnnotationView *)annotationView didSelectAnnotation:(id)annotation;
@end

@interface SBAnnotationView : MAAnnotationView
{
@private
    MADepotView *__depotView;
}

@property (nonatomic, assign) id<SBAnnotationViewDelegate> delegate;
@property (nonatomic, retain, readonly) SBCalloutView *calloutView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setPointAnnotation:(SBAnnotation *)annotation;

@end
