//
//  PlayerView.m
//  WSChat
//
//  Created by fengren on 13-3-25.
//  Copyright (c) 2013年 WSChat. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView
@synthesize player;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


+(Class)layerClass{
    
    return [AVPlayerLayer class];
    
}



-(AVPlayer*)player{
    
    return [(AVPlayerLayer*)[self layer] player];
    
}


-(void)setPlayer:(AVPlayer *)thePlayer{
    
    return [(AVPlayerLayer*)[self layer]setPlayer:thePlayer];
    
}

- (void)setVideoFillMode:(NSString *)fillMode
{
	AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
	playerLayer.videoGravity = fillMode;
}

@end
