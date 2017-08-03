//
//  DB_CompanyContact.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "DerivedNSManagedObject.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DB_Company;

@interface DB_CompanyContact : DerivedNSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (NSString *)fullAddress;

@end

NS_ASSUME_NONNULL_END

#import "DB_CompanyContact+CoreDataProperties.h"
