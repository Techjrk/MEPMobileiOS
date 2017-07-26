//
//  DB_CompanyContact+CoreDataProperties.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DB_CompanyContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface DB_CompanyContact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *ckmsContactId;
@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSString *faxNumber;
@property (nullable, nonatomic, retain) NSNumber *recordId;
@property (nullable, nonatomic, retain) NSNumber *companyId;
@property (nullable, nonatomic, retain) DB_Company *relationshipCompany;

@end

NS_ASSUME_NONNULL_END
