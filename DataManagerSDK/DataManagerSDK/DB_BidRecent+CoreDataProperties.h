//
//  DB_BidRecent+CoreDataProperties.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/10/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DB_BidRecent.h"

NS_ASSUME_NONNULL_BEGIN

@interface DB_BidRecent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *dodgeNumber;
@property (nullable, nonatomic, retain) NSNumber *dodgeVersion;
@property (nullable, nonatomic, retain) NSString *firstPublishDate;
@property (nullable, nonatomic, retain) NSString *lastPublishDate;
@property (nullable, nonatomic, retain) NSString *priorPublishDate;
@property (nullable, nonatomic, retain) NSString *cnProjectUrl;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *address1;
@property (nullable, nonatomic, retain) NSString *address2;
@property (nullable, nonatomic, retain) NSString *county;
@property (nullable, nonatomic, retain) NSString *fipsCounty;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSString *zip5;
@property (nullable, nonatomic, retain) NSString *zipPlus4;
@property (nullable, nonatomic, retain) NSString *statusText;
@property (nullable, nonatomic, retain) NSString *statusProjDlvrySys;
@property (nullable, nonatomic, retain) NSString *currencyType;
@property (nullable, nonatomic, retain) NSNumber *estLow;
@property (nullable, nonatomic, retain) NSString *bidDate;
@property (nullable, nonatomic, retain) NSString *bidTimeZone;
@property (nullable, nonatomic, retain) NSString *bidSubmitTo;
@property (nullable, nonatomic, retain) NSString *contractNbr;
@property (nullable, nonatomic, retain) NSString *projDlvrySys;
@property (nullable, nonatomic, retain) NSString *targetStartDate;
@property (nullable, nonatomic, retain) NSString *targetFinishDate;
@property (nullable, nonatomic, retain) NSString *ownerClass;
@property (nullable, nonatomic, retain) NSString *availableFrom;
@property (nullable, nonatomic, retain) NSString *addendaInd;
@property (nullable, nonatomic, retain) NSString *planInd;
@property (nullable, nonatomic, retain) NSString *specAvailable;
@property (nullable, nonatomic, retain) NSString *details;
@property (nullable, nonatomic, retain) NSString *notes;
@property (nullable, nonatomic, retain) NSString *bondBidInd;
@property (nullable, nonatomic, retain) NSString *bondPaymentInd;
@property (nullable, nonatomic, retain) NSString *bondPfrmInd;
@property (nullable, nonatomic, retain) NSNumber *geocodeLng;
@property (nullable, nonatomic, retain) NSNumber *geocodeLat;
@property (nullable, nonatomic, retain) NSString *geoLocationType;
@property (nullable, nonatomic, retain) NSString *geoType;
@property (nullable, nonatomic, retain) NSNumber *recordId;
@property (nullable, nonatomic, retain) NSNumber *primaryProjectTypeId;
@property (nullable, nonatomic, retain) NSNumber *projectStageId;
@property (nullable, nonatomic, retain) NSString *contactName;
@property (nullable, nonatomic, retain) NSString *contactTitle;
@property (nullable, nonatomic, retain) NSString *contactEmail;
@property (nullable, nonatomic, retain) NSString *contactCkmsContactId;
@property (nullable, nonatomic, retain) NSString *contactPhoneNumber;
@property (nullable, nonatomic, retain) NSString *contactFaxNumber;
@property (nullable, nonatomic, retain) NSNumber *contactId;
@property (nullable, nonatomic, retain) NSNumber *contactCompanyId;
@property (nullable, nonatomic, retain) NSString *companyName;
@property (nullable, nonatomic, retain) NSString *companyAddress1;
@property (nullable, nonatomic, retain) NSString *companyAddress2;
@property (nullable, nonatomic, retain) NSString *companyFipsCounty;
@property (nullable, nonatomic, retain) NSString *companyCity;
@property (nullable, nonatomic, retain) NSString *companyZip5;
@property (nullable, nonatomic, retain) NSString *companyZipPlus4;
@property (nullable, nonatomic, retain) NSString *companyCountry;
@property (nullable, nonatomic, retain) NSString *companyWwwUrl;
@property (nullable, nonatomic, retain) NSString *companyDcisFactorCode;
@property (nullable, nonatomic, retain) NSString *companyDcisFactorCntctCode;
@property (nullable, nonatomic, retain) NSNumber *companyId;
@property (nullable, nonatomic, retain) NSString *companyCreatedAt;
@property (nullable, nonatomic, retain) NSString *companyUpdatedAt;
@property (nullable, nonatomic, retain) NSNumber *bidId;
@property (nullable, nonatomic, retain) NSString *bidCreateDate;
@property (nullable, nonatomic, retain) NSNumber *bidAwardInd;
@property (nullable, nonatomic, retain) NSString *companyCounty;
@property (nullable, nonatomic, retain) NSString *companyState;
@property (nullable, nonatomic, retain) NSString *companyCkmsSiteId;
@property (nullable, nonatomic, retain) NSString *companyCnCompanySiteUrl;

@end

NS_ASSUME_NONNULL_END
