//
//  DB_Project+CoreDataProperties.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/22/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "DB_Project.h"


NS_ASSUME_NONNULL_BEGIN

@interface DB_Project (CoreDataProperties)

+ (NSFetchRequest<DB_Project *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *addendaInd;
@property (nullable, nonatomic, copy) NSString *address1;
@property (nullable, nonatomic, copy) NSString *address2;
@property (nullable, nonatomic, copy) NSString *availableFrom;
@property (nullable, nonatomic, copy) NSString *bidDate;
@property (nullable, nonatomic, copy) NSString *bidSubmitTo;
@property (nullable, nonatomic, copy) NSString *bidTimeZone;
@property (nullable, nonatomic, copy) NSString *bidYearMonth;
@property (nullable, nonatomic, copy) NSString *bidYearMonthDay;
@property (nullable, nonatomic, copy) NSString *bondBidInd;
@property (nullable, nonatomic, copy) NSString *bondPaymentInd;
@property (nullable, nonatomic, copy) NSString *bondPfrmInd;
@property (nullable, nonatomic, copy) NSString *city;
@property (nullable, nonatomic, copy) NSString *cnProjectUrl;
@property (nullable, nonatomic, copy) NSString *contractNbr;
@property (nullable, nonatomic, copy) NSString *country;
@property (nullable, nonatomic, copy) NSString *county;
@property (nullable, nonatomic, copy) NSString *currencyType;
@property (nullable, nonatomic, copy) NSString *details;
@property (nullable, nonatomic, copy) NSString *dodgeNumber;
@property (nullable, nonatomic, copy) NSNumber *dodgeVersion;
@property (nullable, nonatomic, copy) NSDecimalNumber *estHigh;
@property (nullable, nonatomic, copy) NSDecimalNumber *estLow;
@property (nullable, nonatomic, copy) NSString *fipsCounty;
@property (nullable, nonatomic, copy) NSString *firstPublishDate;
@property (nullable, nonatomic, copy) NSNumber *geocodeLat;
@property (nullable, nonatomic, copy) NSNumber *geocodeLng;
@property (nullable, nonatomic, copy) NSString *geoLocationType;
@property (nullable, nonatomic, copy) NSString *geoType;
@property (nullable, nonatomic, copy) NSNumber *isHappenSoon;
@property (nullable, nonatomic, copy) NSNumber *isHidden;
@property (nullable, nonatomic, copy) NSNumber *isRecentAdded;
@property (nullable, nonatomic, copy) NSNumber *isRecentUpdate;
@property (nullable, nonatomic, copy) NSString *lastPublishDate;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSString *ownerClass;
@property (nullable, nonatomic, copy) NSString *planInd;
@property (nullable, nonatomic, copy) NSString *primaryProjectTypeBuildingOrHighway;
@property (nullable, nonatomic, copy) NSNumber *primaryProjectTypeId;
@property (nullable, nonatomic, copy) NSString *primaryProjectTypeTitle;
@property (nullable, nonatomic, copy) NSString *priorPublishDate;
@property (nullable, nonatomic, copy) NSString *projDlvrySys;
@property (nullable, nonatomic, copy) NSNumber *projectCategoryId;
@property (nullable, nonatomic, copy) NSString *projectCategoryTitle;
@property (nullable, nonatomic, copy) NSNumber *projectGroupId;
@property (nullable, nonatomic, copy) NSString *projectGroupTitle;
@property (nullable, nonatomic, copy) NSString *projectNotes;
@property (nullable, nonatomic, copy) NSString *projectStage;
@property (nullable, nonatomic, copy) NSNumber *projectStageId;
@property (nullable, nonatomic, copy) NSString *projectStageName;
@property (nullable, nonatomic, copy) NSNumber *projectStageParentId;
@property (nullable, nonatomic, copy) NSNumber *recordId;
@property (nullable, nonatomic, copy) NSString *specAvailable;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *statusProjDlvrySys;
@property (nullable, nonatomic, copy) NSString *statusText;
@property (nullable, nonatomic, copy) NSString *stdIncludes;
@property (nullable, nonatomic, copy) NSString *targetFinishDate;
@property (nullable, nonatomic, copy) NSString *targetStartDate;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *unionDesignation;
@property (nullable, nonatomic, copy) NSString *zip5;
@property (nullable, nonatomic, copy) NSString *zipPlus4;
@property (nullable, nonatomic, copy) NSNumber *hasNotesImages;
@property (nullable, nonatomic, retain) NSSet<DB_Bid *> *relationshipBid;
@property (nullable, nonatomic, retain) DB_Company *relationshipCompany;
@property (nullable, nonatomic, retain) NSSet<DB_Participant *> *relationshipParticipants;

@end

@interface DB_Project (CoreDataGeneratedAccessors)

- (void)addRelationshipBidObject:(DB_Bid *)value;
- (void)removeRelationshipBidObject:(DB_Bid *)value;
- (void)addRelationshipBid:(NSSet<DB_Bid *> *)values;
- (void)removeRelationshipBid:(NSSet<DB_Bid *> *)values;

- (void)addRelationshipParticipantsObject:(DB_Participant *)value;
- (void)removeRelationshipParticipantsObject:(DB_Participant *)value;
- (void)addRelationshipParticipants:(NSSet<DB_Participant *> *)values;
- (void)removeRelationshipParticipants:(NSSet<DB_Participant *> *)values;

@end

NS_ASSUME_NONNULL_END
