//
//  CustomCallOut.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/8/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomCallOut.h"

#import <MapKit/MapKit.h>
#import "TriangleView.h"

#define CALLOUT_BID_STATUS_POST_BID_COLOR               RGB(195, 10, 10)
#define CALLOUT_BID_STATUS_PRE_BID_COLOR                RGB(77, 135, 10)
#define CALLOUT_COMPANY_COLOR                           RGB(248, 173, 64)

#define CALLOUT_BID_STATUS_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 10)
#define CALLOUT_BID_STATUS_COLOR                        [UIColor whiteColor]

#define CALLOUT_COMPANY_NAME_FONT                       fontNameWithSize(FONT_NAME_LATO_BLACK, 13)
#define CALLOUT_COMPANY_NAME_COLOR                      [UIColor whiteColor]

#define CALLOUT_COMPANY_ADDR_FONT                       fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)
#define CALLOUT_COMPANY_ADDR_COLOR                      [UIColor whiteColor]

#define CALLOUT_PROJECT_FONT                            fontNameWithSize(FONT_NAME_LATO_BLACK, 13)
#define CALLOUT_PROJECT_COLOR                           RGB(34, 34, 34)

#define CALLOUT_PROJECT_ADDR_FONT                       fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)
#define CALLOUT_PROJECT_ADDR_COLOR                      RGB(159, 164, 166)

#define CALLOUT_BUTTON_DIRECTION_FONT                   fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)
#define CALLOUT_BUTTON_DIRECTION_COLOR                  RGB(76, 145, 209)

@interface CustomCallOut(){
    CGFloat cornerRadius;
    CGFloat lat, lng;
}
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *containerBidStatus;
@property (weak, nonatomic) IBOutlet UIView *containerCompany;
@property (weak, nonatomic) IBOutlet UILabel *labelBidStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *labelCompanyAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelProjectName;
@property (weak, nonatomic) IBOutlet UILabel *labelProjectAddress;
@property (weak, nonatomic) IBOutlet UIButton *buttonGetDirection;
- (IBAction)tappedButtonDirection:(id)sender;
@end

@implementation CustomCallOut

- (void)awakeFromNib {
    
    _containerCompany.backgroundColor = CALLOUT_COMPANY_COLOR;
    
    _labelBidStatus.font = CALLOUT_BID_STATUS_FONT;
    _labelBidStatus.textColor = CALLOUT_BID_STATUS_COLOR;
    
    _labelCompanyName.font = CALLOUT_COMPANY_NAME_FONT;
    _labelCompanyName.textColor = CALLOUT_COMPANY_NAME_COLOR;
    
    _labelCompanyAddress.font = CALLOUT_COMPANY_ADDR_FONT;
    _labelCompanyAddress.textColor = CALLOUT_COMPANY_ADDR_COLOR;
    
    _labelProjectName.font = CALLOUT_PROJECT_FONT;
    _labelProjectName.textColor = CALLOUT_PROJECT_COLOR;
    
    _labelProjectAddress.font = CALLOUT_PROJECT_ADDR_FONT;
    _labelProjectAddress.textColor = CALLOUT_PROJECT_ADDR_COLOR;
    
    [_buttonGetDirection setTitle:NSLocalizedLanguage(@"CALLOUT_GET_DIRECTION") forState:UIControlStateNormal];
    [_buttonGetDirection setTitleColor:CALLOUT_BUTTON_DIRECTION_COLOR forState:UIControlStateNormal];
    _buttonGetDirection.titleLabel.font = CALLOUT_BUTTON_DIRECTION_FONT;
    _buttonGetDirection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
}

- (void)setInfo:(id)info {

    NSDictionary *dict = info;
    
    _labelProjectName.text = dict[@"title"];
    _labelProjectAddress.text = [NSString stringWithFormat:@"%@ %@, %@ %@", dict[@"address1"], dict[@"city"], dict[@"state"], dict[@"zipPlus4"]];
    
    NSArray *contacts = dict[@"contacts"];
    if (contacts != nil) {
        for (NSDictionary *contact in contacts) {
            
            NSDictionary *company = contact[@"company"];
            if (company != nil) {
                _labelCompanyName.text = company[@"name"];
                
                _labelCompanyAddress.text = [NSString stringWithFormat:@"%@, %@", company[@"city"], company[@"state"]];
            }
            
            break;
        }
    }
    
    NSDictionary *projectStage = dict[@"projectStage"];
    _labelBidStatus.text = NSLocalizedLanguage(@"CALLOUT_PRE_BID");
    _containerBidStatus.backgroundColor = CALLOUT_BID_STATUS_PRE_BID_COLOR;
    if (projectStage != nil) {
        NSNumber *bidId = projectStage[@"parentId"];
        if (bidId.integerValue != 102) {
            _labelBidStatus.text = NSLocalizedLanguage(@"CALLOUT_POST_BID");
            _containerBidStatus.backgroundColor = CALLOUT_BID_STATUS_POST_BID_COLOR;
        }
    }
    
    NSDictionary *geoCode = dict[@"geocode"];
    if (geoCode != nil) {
        lat = [geoCode[@"lat"] floatValue];
        lng = [geoCode[@"lng"] floatValue];
    }
}

- (IBAction)tappedButtonDirection:(id)sender {
    
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake(lat, lng);
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];
}
@end
