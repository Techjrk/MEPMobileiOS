//
//  DB_Project+CoreDataProperties.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/23/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DB_Project.h"

NS_ASSUME_NONNULL_BEGIN

@interface DB_Project (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *addendaInd;
@property (nullable, nonatomic, retain) NSString *address1;
@property (nullable, nonatomic, retain) NSString *address2;
@property (nullable, nonatomic, retain) NSString *availableFrom;
@property (nullable, nonatomic, retain) NSString *bidDate;
@property (nullable, nonatomic, retain) NSString *bidSubmitTo;
@property (nullable, nonatomic, retain) NSString *bidTimeZone;
@property (nullable, nonatomic, retain) NSString *bondBidInd;
@property (nullable, nonatomic, retain) NSString *bondPaymentInd;
@property (nullable, nonatomic, retain) NSString *bondPfrmInd;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *cnProjectUrl;
@property (nullable, nonatomic, retain) NSString *contractNbr;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSString *county;
@property (nullable, nonatomic, retain) NSString *currencyType;
@property (nullable, nonatomic, retain) NSString *details;
@property (nullable, nonatomic, retain) NSString *dodgeNumber;
@property (nullable, nonatomic, retain) NSNumber *dodgeVersion;
@property (nullable, nonatomic, retain) NSDecimalNumber *estLow;
@property (nullable, nonatomic, retain) NSString *fipsCounty;
@property (nullable, nonatomic, retain) NSString *firstPublishDate;
@property (nullable, nonatomic, retain) NSNumber *geocodeLat;
@property (nullable, nonatomic, retain) NSNumber *geocodeLng;
@property (nullable, nonatomic, retain) NSString *geoLocationType;
@property (nullable, nonatomic, retain) NSString *geoType;
@property (nullable, nonatomic, retain) NSString *lastPublishDate;
@property (nullable, nonatomic, retain) NSString *notes;
@property (nullable, nonatomic, retain) NSString *ownerClass;
@property (nullable, nonatomic, retain) NSString *planInd;
@property (nullable, nonatomic, retain) NSString *priorPublishDate;
@property (nullable, nonatomic, retain) NSString *projDlvrySys;
@property (nullable, nonatomic, retain) NSNumber *recordId;
@property (nullable, nonatomic, retain) NSString *specAvailable;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSString *statusProjDlvrySys;
@property (nullable, nonatomic, retain) NSString *statusText;
@property (nullable, nonatomic, retain) NSString *targetFinishDate;
@property (nullable, nonatomic, retain) NSString *targetStartDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *zip5;
@property (nullable, nonatomic, retain) NSString *zipPlus4;
@property (nullable, nonatomic, retain) NSNumber *projectStageId;
@property (nullable, nonatomic, retain) NSString *projectStage;
@property (nullable, nonatomic, retain) NSString *projectStageName;
@property (nullable, nonatomic, retain) NSNumber *projectStageParentId;
@property (nullable, nonatomic, retain) NSNumber *primaryProjectTypeId;
@property (nullable, nonatomic, retain) NSString *primaryProjectTypeTitle;
@property (nullable, nonatomic, retain) NSString *primaryProjectTypeBuildingOrHighway;
@property (nullable, nonatomic, retain) NSNumber *projectCategoryId;
@property (nullable, nonatomic, retain) NSString *projectCategoryTitle;
@property (nullable, nonatomic, retain) NSNumber *projectGroupId;
@property (nullable, nonatomic, retain) NSString *projectGroupTitle;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *relationshipBid;

@end

@interface DB_Project (CoreDataGeneratedAccessors)

- (void)addRelationshipBidObject:(NSManagedObject *)value;
- (void)removeRelationshipBidObject:(NSManagedObject *)value;
- (void)addRelationshipBid:(NSSet<NSManagedObject *> *)values;
- (void)removeRelationshipBid:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
