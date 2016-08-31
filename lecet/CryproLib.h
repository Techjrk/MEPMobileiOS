//
//  CryproLib.h
//  lecet
//
//  Created by Harry Herrys Camigla on 8/2/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CryproLib : NSObject

+ (NSString*)encryptData:(NSString*)data key:(NSString*)key;
+ (NSString*)dencryptData:(NSString*)data key:(NSString*)key;

@end
