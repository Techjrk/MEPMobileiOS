//
//  DB_Bid+CoreDataProperties.h
//  lecet
//
//  Created by Harry Herrys Camigla on 9/1/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DB_Bid.h"

NS_ASSUME_NONNULL_BEGIN

@interface DB_Bid (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSNumber *awardInd;
@property (nullable, nonatomic, retain) NSString *createDate;
@property (nullable, nonatomic, retain) NSNumber *isRecentMade;
@property (nullable, nonatomic, retain) NSNumber *rank;
@property (nullable, nonatomic, retain) NSNumber *recordId;
@property (nullable, nonatomic, retain) DB_Company *relationshipCompany;
@property (nullable, nonatomic, retain) DB_Contact *relationshipContact;
@property (nullable, nonatomic, retain) DB_Project *relationshipProject;

@end

NS_ASSUME_NONNULL_END
