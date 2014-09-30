//
//  BHTransferBar.m
//  SmartBus
//
//  Created by launching on 13-10-11.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHTransferBar.h"
#import "MALocationHelper.h"

@interface BHTransferBar ()<UITextFieldDelegate, MALocationDelegate>
{
    UILabel *_tickerLabel;
    UIActivityIndicatorView *_indicator;
    MALocationHelper *_locationHelper;
}
@end

@implementation BHTransferBar

@synthesize startTextField = _startTextField;
@synthesize endTextField = _endTextField;
@synthesize coor = _coordinate;

- (void)dealloc
{
    SAFE_RELEASE_SUBVIEW(_startTextField);
    SAFE_RELEASE_SUBVIEW(_endTextField);
    SAFE_RELEASE_SUBVIEW(_tickerLabel);
    SAFE_RELEASE_SUBVIEW(_indicator);
    SAFE_RELEASE(_locationHelper);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        _tickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 300.f, 24.f)];
        _tickerLabel.backgroundColor = [UIColor clearColor];
        _tickerLabel.font = [UIFont systemFontOfSize:12];
        _tickerLabel.textAlignment = UITextAlignmentCenter;
        _tickerLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_tickerLabel];
        
        BeeUIButton *exchangeButton = [BeeUIButton new];
        exchangeButton.frame = CGRectMake(10.f, 18.f+(self.frame.size.height-40.f)/2, 40.f, 40.f);
        exchangeButton.stateNormal.backgroundImage = [UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)];
        exchangeButton.stateNormal.image = [UIImage imageNamed:@"icon_refresh_hl.png"];
        exchangeButton.layer.masksToBounds = YES;
        exchangeButton.layer.cornerRadius = 3.f;
        [exchangeButton addSignal:@"exchange" forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:exchangeButton];
        
        BeeUIButton *transferButton = [BeeUIButton new];
        transferButton.frame = CGRectMake(self.frame.size.width-50.f, 18.f+(self.frame.size.height-40.f)/2, 40.f, 40.f);
        transferButton.stateNormal.backgroundImage = [UIImage imageNamed:@"bubble.png" stretched:CGPointMake(5.f, 5.f)];
        transferButton.stateNormal.image = [UIImage imageNamed:@"icon_search.png"];
        transferButton.layer.masksToBounds = YES;
        transferButton.layer.cornerRadius = 3.f;
        [transferButton addSignal:@"transfer" forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:transferButton];
        
        for (int i = 0; i < 2; i++)
        {
            UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:10.f topCapHeight:10.f]];
            bubbleImageView.frame = CGRectMake(60.f, 35.f+i*45.f, self.frame.size.width-120.f, 40.f);
            [self addSubview:bubbleImageView];
            [bubbleImageView release];
        }
        
        _startTextField = [[BeeUITextField alloc] initWithFrame:CGRectMake(70.f, 35.f, 180.f, 40.f)];
        _startTextField.backgroundColor = [UIColor clearColor];
        _startTextField.font = FONT_SIZE(14);
//        _startTextField.delegate = self;
        _startTextField.placeholder = @"我的位置";
//        _startTextField.enabled = NO;
        [self addSubview:_startTextField];
        
        _endTextField = [[BeeUITextField alloc] initWithFrame:CGRectMake(70.f, 80.f, 180.f, 40.f)];
        _endTextField.backgroundColor = [UIColor clearColor];
        _endTextField.font = FONT_SIZE(14);
//        _endTextField.delegate = self;
        _endTextField.placeholder = @"目的地";
        [self addSubview:_endTextField];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.frame = CGRectMake(150.f, 5.f, 20.f, 20.f);
        _indicator.hidesWhenStopped = YES;
        [self addSubview:_indicator];
        
        _locationHelper = [[MALocationHelper alloc] initWithDelegate:self];
        _locationHelper.usingReGeocode = YES;
        
        [self performSelector:@selector(start) withObject:nil afterDelay:0.2];
    }
    return self;
}


ON_SIGNAL2( BeeUIButton, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:@"exchange"] )
    {
        [_startTextField resignFirstResponder];
        [_endTextField resignFirstResponder];
        
//        BeeUIButton *button = (BeeUIButton *)signal.source;
//        button.selected = !button.selected;
//        if (button.selected) {
//            _startTextField.frame = CGRectMake(70.f, 50.f, 180.f, 40.f);
//            _endTextField.frame = CGRectMake(70.f, 0.f, 180.f, 40.f);
//            _endTextField.placeholder = @"起始地";
//        } else {
//            _startTextField.frame = CGRectMake(70.f, 0.f, 180.f, 40.f);
//            _endTextField.frame = CGRectMake(70.f, 50.f, 180.f, 40.f);
//            _endTextField.placeholder = @"目的地";
//        }
    }
}

ON_SIGNAL2( BeeUITextField, signal )
{
    [super handleUISignal:signal];
}


#pragma mark -
#pragma mark private methods

- (void)disActiveAllKeyboard
{
    [_startTextField resignFirstResponder];
    [_endTextField resignFirstResponder];
}

- (void)start
{
    [_indicator startAnimating];
    [_locationHelper startLocating];
}


#pragma mark -
#pragma mark MALocationDelegate

- (void)locationHelperDidStartLocating:(MALocationHelper *)helper
{
    [_indicator startAnimating];
}

- (void)locationHelper:(MALocationHelper *)helper didFinishedReGeocode:(NSString *)address
{
    [_indicator stopAnimating];
    _tickerLabel.text = address;
}

- (void)locationHelper:(MALocationHelper *)helper didFaildLocating:(NSError *)error
{
    [_indicator stopAnimating];
}


@end
