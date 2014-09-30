//
//  AppConfig.m
//



#define kVideoQuality                 @"video_quality"


#import "AppConfig.h"

@implementation AppConfig
@synthesize videoQuality;

+ (AppConfig *)sharedInstance {
	static AppConfig *gAppConfig = nil;
	if (gAppConfig == nil) {
		gAppConfig = [AppConfig new];
	}
	return gAppConfig;
}

// ------------------------------------------------------------

// Set default settings
- (void)setConfigDefaults {
	NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
	
	NSMutableDictionary *dict = [[NSMutableDictionary new] autorelease];
	
    // Pro versioin
    [dict setObject:[NSNumber numberWithInt:0] forKey:kVideoQuality];
    
       	
	[userdef registerDefaults:dict];
}

- (id)init {
	self = [super init];
    
	if (self) {
		// set default settings
		[self setConfigDefaults];
	}
	return self;
}


// ------------------------------------------------------------
// kVideoQuality
- (int)videoQuality {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kVideoQuality];
}

- (void)setVideoQuality:(int)value {
    return [[NSUserDefaults standardUserDefaults] setInteger:value forKey:kVideoQuality];
}



@end
