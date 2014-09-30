//
//  BHChannelsPopoup.h
//  SmartBus
//
//  Created by launching on 13-10-22.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BHChannelsPopoupDelegate;

@interface BHChannelsPopoup : UIView

@property (nonatomic ,retain) id<BHChannelsPopoupDelegate> delegate;

AS_SINGLETON( BHChannelsPopoup );

- (void)setChannels:(NSArray *)channels;

- (void)showInView:(UIView *)view atPosition:(CGPoint)point;
- (void)dismissPopoup;

@end

@protocol BHChannelsPopoupDelegate <NSObject>

- (void)BHChannelsPopoup:(BHChannelsPopoup *)view selectIndex:(int)index;

@end
