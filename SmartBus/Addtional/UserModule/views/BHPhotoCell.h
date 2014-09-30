//
//  BHPhotoCell.h
//  SmartBus
//
//  Created by launching on 13-11-13.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHPhotoModel.h"

@class BHPhotoCell;

@protocol BHPhotoCellDelegate <NSObject>
- (void)photoCell:(BHPhotoCell *)cell didSelectWithView:(UIImageView *)view;
@end

@interface BHPhotoCell : BeeUITableViewCell

@property (nonatomic, retain) BHPhotoModel *photo;
@property (nonatomic, retain, readonly) NSMutableArray *imageViews;
@property (nonatomic, assign) id<BHPhotoCellDelegate> delegate;

@end
