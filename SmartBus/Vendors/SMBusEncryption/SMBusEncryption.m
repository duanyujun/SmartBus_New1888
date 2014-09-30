//
//  SMBusEncryption.m
//  SmartBus
//
//  Created by 王 正星 on 14-6-25.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "SMBusEncryption.h"

#define APIKEY    @"fa6ea67bafae6709557430523e00802a"
#define APISECRET @"ae6709a"

@implementation SMBusEncryption

+ (NSDictionary *)encryption:(NSDictionary *)dic
{
    NSMutableArray *paramsArray = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableDictionary *encyptDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [encyptDic setObject:APIKEY forKey:@"api_key"];
    [encyptDic setObject:[NSString stringWithFormat:@"%d",(int)([[NSDate date] timeIntervalSince1970] - [BHAPP timeIntervalWithServer])] forKey:@"timestamp"];
    
    NSMutableString *encyptString = [[NSMutableString alloc]initWithString:APISECRET];
    for ( NSString *key in encyptDic.allKeys ) {
        [paramsArray addObject:[NSDictionary dictionaryWithObject:[encyptDic objectForKey:key] forKey:key]];
    }
    NSArray *sortArray = [paramsArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSString *key1 = [[obj1 allKeys] objectAtIndex:0];
        NSString *key2 = [[obj2 allKeys] objectAtIndex:0];
        
        NSComparisonResult result = [key1 compare:key2];
        
        return result;
    }];
    
    NSNumberFormatter *formartter = [[NSNumberFormatter alloc] init];
    
    for (NSDictionary *keyDic in sortArray) {
        [encyptString appendString:keyDic.allKeys[0]];
        if ([keyDic.allValues[0] isKindOfClass:[NSString class]]) {
            [encyptString appendString:keyDic.allValues[0]];
        } else {
            [encyptString appendString:[formartter stringFromNumber:keyDic.allValues[0]]];
        }
    }
    [encyptDic setObject:[encyptString MD5] forKey:@"api_sig"];
    
    [formartter release];
    [encyptString release];
    [paramsArray release];
    
    return [encyptDic autorelease];
}



@end
