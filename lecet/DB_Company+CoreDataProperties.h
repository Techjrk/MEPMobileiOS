//
//  DB_Company+CoreDataProperties.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DB_Company.h"

NS_ASSUME_NONNULL_BEGIN

@interface DB_Company (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *address1;
@property (nullable, nonatomic, retain) NSString *address2;
@property (nullable, nonatomic, retain) NSString *county;
@property (nullable, nonatomic, retain) NSString *fipsCounty;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSString *zip5;
@property (nullable, nonatomic, retain) NSString *zipPlus4;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSString *ckmsSiteId;
@property (nullable, nonatomic, retain) NSString *cnCompanysiteUrl;
@property (nullable, nonatomic, retain) NSString *wwwUrl;
@property (nullable, nonatomic, retain) NSString *dcisFactorCntctCode;
@property (nullable, nonatomic, retain) NSString *dcisFactorCode;
@property (nullable, nonatomic, retain) NSNumber *recordId;
@property (nullable, nonatomic, retain) NSString *createdAt;
@property (nullable, nonatomic, retain) NSString *updatedAt;
@property (nullable, nonatomic, retain) DB_Bid *relationshipBid;
@property (nullable, nonatomic, retain) NSSet<DB_CompanyContact *> *relationshipCompanyContact;

@end

@interface DB_Company (CoreDataGeneratedAccessors)

- (void)addRelationshipCompanyContactObject:(DB_CompanyContact *)value;
- (void)removeRelationshipCompanyContactObject:(DB_CompanyContact *)value;
- (void)addRelationshipCompanyContact:(NSSet<DB_CompanyContact *> *)values;
- (void)removeRelationshipCompanyContact:(NSSet<DB_CompanyContact *> *)values;

@end

NS_ASSUME_NONNULL_END
