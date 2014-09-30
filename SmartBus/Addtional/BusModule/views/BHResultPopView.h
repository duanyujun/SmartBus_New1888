//
//  BHResultPopView.h
//  SmartBus
//
//  Created by launching on 13-10-21.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#if NS_BLOCKS_AVAILABLE
typedef void (^PopoupSelectedBlock)(AMapPOI *poi);
typedef void (^PopoupCompleteBlock)(BOOL complete);
#endif

@interface BHResultPopView : UIView
{
@private
    BeeUITableView *_tableView;
    UIActivityIndicatorView *_activity;
}

@property (nonatomic, retain) NSString *searchKey;

- (id)initWithTitle:(NSString *)title key:(NSString *)key;
- (void)setTitle:(NSString *)title key:(NSString *)key;
- (void)showInView:(UIView *)view selected:(PopoupSelectedBlock)selected completion:(PopoupCompleteBlock)completion;

@end

@interface BHStartResPopView : BHResultPopView
@end


@interface BHEndResPopView : BHResultPopView
@end
