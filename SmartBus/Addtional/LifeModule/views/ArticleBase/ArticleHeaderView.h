//
//  ArticleHeaderView.h
//  JstvNews
//
//  Created by launching on 13-6-4.
//  Copyright (c) 2013年 kukuasir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleHeaderView : UIView
{
@private
    UILabel *titleLabel;
    UILabel *dateLabel;
    UILabel *complainLabel;
    UIImageView *iconImageView;
    UIView *hline1;
    UIView *hline2;
}

- (void)setArticleBase:(id)base;

@end
