//
//  ProjectNearMeListCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 18/01/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ProjectNearMeListCollectionViewCell.h"
#import <MapKit/MapKit.h>

#define fontTitleName           fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define fontTitleAddress        fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define fontTitleFeetAway       fontNameWithSize(FONT_NAME_LATO_REGULAR, 9)

#define colorFontTitleName      RGB(34,34,34)
#define colorFontTitleAddress   RGB(159,164,166)
#define colorFontTitleFeetAway  RGB(159,164,166)
#define colorBackgroundView     RGB(255,255,255)

@interface ProjectNearMeListCollectionViewCell ()
    @property (weak, nonatomic) IBOutlet MKMapView *mapView;
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *unionLabel;

@end

@implementation ProjectNearMeListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5;
}

@end
