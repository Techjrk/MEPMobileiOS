//
//  DB_Bid.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/23/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "DerivedNSManagedObject.h"
#import <AVFoundation/AVFoundation.h>

@class DB_Company, DB_Contact, DB_Project;

NS_ASSUME_NONNULL_BEGIN

@interface DB_Bid : DerivedNSManagedObject
- (NSString*)bidAmountWithCurrency;
@end

NS_ASSUME_NONNULL_END

#import "DB_Bid+CoreDataProperties.h"
