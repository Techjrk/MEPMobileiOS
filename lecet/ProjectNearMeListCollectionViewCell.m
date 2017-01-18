//
//  ProjectNearMeListCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 18/01/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ProjectNearMeListCollectionViewCell.h"
#import <MapKit/MapKit.h>

#define fontTitleName                       fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define fontTitleAddress                    fontNameWithSize(FONT_NAME_LATO_REGULAR, 10)
#define fontTitleFeetAway                   fontNameWithSize(FONT_NAME_LATO_REGULAR, 9)
#define fontUnionLabel                      fontNameWithSize(FONT_NAME_LATO_BOLD, 12)

#define colorFontTitleName                  RGB(34,34,34)
#define colorFontTitleAddress               RGB(159,164,166)
#define colorFontTitleFeetAway              RGB(159,164,166)
#define colorFontUnionLabel                 RGB(255,255,255)
#define colorBackgroundView                 RGB(255,255,255)
#define colorBackgroundContainerUnionView   RGB(0,63,114)
@interface ProjectNearMeListCollectionViewCell ()
    @property (weak, nonatomic) IBOutlet MKMapView *mapView;
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *unionLabel;
    @property (weak, nonatomic) IBOutlet UIView *containerUnionView;
    @property (weak, nonatomic) IBOutlet UILabel *titleAddressLabel;
    @property (weak, nonatomic) IBOutlet UILabel *titleFeetAwayLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *addressIconImageView;

@end

@implementation ProjectNearMeListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5;

    self.unionLabel.textColor = colorFontUnionLabel;
    self.unionLabel.font = fontUnionLabel;
    
    self.containerUnionView.backgroundColor = colorBackgroundContainerUnionView;
    self.containerUnionView.layer.cornerRadius = 5;
    
    self.titleLabel.font = fontTitleName;
    self.titleLabel.textColor = colorFontTitleName;
    
    self.titleAddressLabel.font = fontTitleAddress;
    self.titleAddressLabel.textColor = colorFontTitleAddress;
    
    self.titleFeetAwayLabel.font = fontTitleFeetAway;
    self.titleFeetAwayLabel.textColor = colorFontTitleFeetAway;
    
    //self.titleLabel.text = self.titleNameText;
    //self.titleAddressLabel.text = self.titleAddressText;
    //self.titleFeetAwayLabel.text = self.titleFeetAwayText;
}

@end
