//
//  AppConfig.h
//


#import <Foundation/Foundation.h>


@interface AppConfig : NSObject {
}

+ (AppConfig *)sharedInstance;

// ------------------------------------------------------------

@property (nonatomic, assign) int  videoQuality;

@end
