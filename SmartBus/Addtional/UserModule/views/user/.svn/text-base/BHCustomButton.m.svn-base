//
//  BHCustomButton.m
//  SmartBus
//
//  Created by user on 13-10-18.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHCustomButton.h"


@interface BHCustomButton()
{
    UIImageView  *img;
    UILabel  *textLabel;
    
    NSString *feedID;
}

@end

@implementation BHCustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_comment.png"]];
        img.frame = CGRectMake(10.f, 5.f, 20.f, 20.f);
        [self addSubview:img];
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 4.f, 20.f ,20.f)];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.font = FONT_SIZE(12);
        textLabel.textColor = [UIColor flatDarkGrayColor];
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
    }
    
    return self;
}


-(void)setFeedID:(NSString *)feedid
{
    feedID = feedid;
}

-(NSString *)getFeedID
{
    return feedID;
}

- (void)setTextLabel:(NSString *)txt
{
    textLabel.text = txt;
}

- (UILabel *)getTextLabel
{
    return textLabel;
}


- (void)setImage:(UIImage *)image
{
    img.image = image;
}

- (UIImageView *)getImage
{
    return img;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
