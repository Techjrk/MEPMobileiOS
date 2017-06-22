//
//  DB_Project+CoreDataProperties.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/22/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "DB_Project+CoreDataProperties.h"

@implementation DB_Project (CoreDataProperties)

+ (NSFetchRequest<DB_Project *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DB_Project"];
}

@dynamic addendaInd;
@dynamic address1;
@dynamic address2;
@dynamic availableFrom;
@dynamic bidDate;
@dynamic bidSubmitTo;
@dynamic bidTimeZone;
@dynamic bidYearMonth;
@dynamic bidYearMonthDay;
@dynamic bondBidInd;
@dynamic bondPaymentInd;
@dynamic bondPfrmInd;
@dynamic city;
@dynamic cnProjectUrl;
@dynamic contractNbr;
@dynamic country;
@dynamic county;
@dynamic currencyType;
@dynamic details;
@dynamic dodgeNumber;
@dynamic dodgeVersion;
@dynamic estHigh;
@dynamic estLow;
@dynamic fipsCounty;
@dynamic firstPublishDate;
@dynamic geocodeLat;
@dynamic geocodeLng;
@dynamic geoLocationType;
@dynamic geoType;
@dynamic isHappenSoon;
@dynamic isHidden;
@dynamic isRecentAdded;
@dynamic isRecentUpdate;
@dynamic lastPublishDate;
@dynamic notes;
@dynamic ownerClass;
@dynamic planInd;
@dynamic primaryProjectTypeBuildingOrHighway;
@dynamic primaryProjectTypeId;
@dynamic primaryProjectTypeTitle;
@dynamic priorPublishDate;
@dynamic projDlvrySys;
@dynamic projectCategoryId;
@dynamic projectCategoryTitle;
@dynamic projectGroupId;
@dynamic projectGroupTitle;
@dynamic projectNotes;
@dynamic projectStage;
@dynamic projectStageId;
@dynamic projectStageName;
@dynamic projectStageParentId;
@dynamic recordId;
@dynamic specAvailable;
@dynamic state;
@dynamic statusProjDlvrySys;
@dynamic statusText;
@dynamic stdIncludes;
@dynamic targetFinishDate;
@dynamic targetStartDate;
@dynamic title;
@dynamic unionDesignation;
@dynamic zip5;
@dynamic zipPlus4;
@dynamic hasNotesImages;
@dynamic relationshipBid;
@dynamic relationshipCompany;
@dynamic relationshipParticipants;

@end
