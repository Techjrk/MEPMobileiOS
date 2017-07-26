//
//  CryproLib.m
//  lecet
//
//  Created by Harry Herrys Camigla on 8/2/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CryproLib.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation CryproLib

+ (NSString*)encryptData:(NSString*)data key:(NSString*)key {
    
    NSData *_data = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSData *_key = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *_cryptData = [NSMutableData dataWithLength:data.length +
                  kCCBlockSizeBlowfish];
    size_t outLength;
    
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmBlowfish, kCCOptionPKCS7Padding, _key.bytes, _key.length, NULL, _data.bytes, _data.length, _cryptData.mutableBytes, _cryptData.length, &outLength);
    
    if (status == kCCSuccess) {
        _cryptData.length = outLength;
        
        return [_cryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    return @"";
}

+ (NSString*)dencryptData:(NSString*)data key:(NSString*)key {
    
    NSData *_data = [[NSData alloc] initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *_key = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *_cryptData = [NSMutableData dataWithLength:data.length];
    size_t outLength;
    
    CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmBlowfish, kCCOptionPKCS7Padding, _key.bytes, _key.length, NULL, _data.bytes, _data.length, _cryptData.mutableBytes, _cryptData.length, &outLength);
    
    if (status == kCCSuccess) {
        _cryptData.length = outLength;
        
        NSString *str = [[NSString stringWithUTF8String:_cryptData.bytes] stringByAppendingString:@"<->"];
        return [str stringByReplacingOccurrencesOfString:@"<->" withString:@""];
    }

    return @"";
}

@end
