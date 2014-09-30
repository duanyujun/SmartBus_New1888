//
//  UISplashOverView.h
//  SmartBus
//
//  Created by launching on 13-10-17.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "Bee_UIView.h"

@protocol UISplashOverViewDelegate <NSObject>
@optional
- (void)splashOverViewDidFinishLoading:(UIView *)view;
@end

@interface UISplashOverView : UIView

@property (nonatomic, assign) BOOL adShow;
@property (nonatomic, assign) NSInteger adid;
@property (nonatomic, retain) UIView *progressView;

- (id)initWithDelegate:(id<UISplashOverViewDelegate>)delegate;

- (void)show;
- (void)hide;

// 设置广告图片的地址
- (void)setOverImageWithURL:(NSURL *)url withAdvUrl:(NSString *)adurl;

@end
