//
//  NSData+AES128.h
//  LxtvMtv
//
//  Created by 王 正星 on 14-8-13.
//  Copyright (c) 2014年 WSChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AES128)
- (NSData *)AES128Operation:(CCOperation)operation keyData:(NSData *)keyData keyData:(NSData *)ivData;
- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;
@end
