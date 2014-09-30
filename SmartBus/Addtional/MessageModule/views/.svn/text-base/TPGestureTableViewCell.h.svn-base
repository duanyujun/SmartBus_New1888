//
//  TPGestureTableViewCell.h
//  TangGestureTableViewDemo
//
//  Created by kavin on 13-3-16.
//  Copyright (c) 2013年 TangPin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    kFeedStatusNormal = 0,
    kFeedStatusLeftExpanded,
    kFeedStatusLeftExpanding,
    kFeedStatusRightExpanded,
    kFeedStatusRightExpanding,
}kFeedStatus;

@class TPGestureTableViewCell;

@protocol TPGestureTableViewCellDelegate <NSObject>

- (void)cellDidBeginPan:(TPGestureTableViewCell *)cell;  
- (void)cellDidReveal:(TPGestureTableViewCell *)cell;      
- (void)deleteMsgWithIndex:(int)index;
@end

@interface TPGestureTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>
{
@public
    int index;
}
@property (nonatomic,assign) id<TPGestureTableViewCellDelegate> delegate;                     
@property (nonatomic,assign) kFeedStatus currentStatus;                 
@property (nonatomic,assign) BOOL revealing;

@end
