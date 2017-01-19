//
//  ProjectNearMeListCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 18/01/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectNearMeListCollectionViewCell : UICollectionViewCell
    @property (strong,nonatomic) NSString *titleNameText;
    @property (strong,nonatomic) NSString *titleAddressText;
    @property (strong,nonatomic) NSString *titleFeetAwayText;
    @property (strong,nonatomic) NSString *titlePriceText;
    @property (strong,nonatomic) NSDictionary *geoCode;
    @property (strong,nonatomic) NSString *unionDesignation;
    - (void)setInitInfo;
@end
