//
//  ProjectTrackItemView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectTrackItemView.h"

#import <MapKit/MapKit.h>

#define PROJECT_TRACK_ITEM_TITLE_FONT                   fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define PROJECT_TRACK_ITEM_TITLE_COLOR                  RGB(34, 34, 34)

#define PROJECT_TRACK_ITEM_LOCATION_FONT                fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define PROJECT_TRACK_ITEM_LOCATION_COLOR               RGB(159, 164, 166)

#define PROJECT_TRACK_ITEM_TYPE_FONT                    fontNameWithSize(FONT_NAME_LATO_REGULAR, 10)
#define PROJECT_TRACK_ITEM_TYPE_COLOR                   RGB(159, 164, 166)

#define PROJECT_TRACK_UPDATE_FONT                       fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define PROJECT_TRACK_UPDATE_COLOR                      RGB(255, 255, 255)

#define PROJECT_TRACK_TEXT_BG_COLOR                     RGB(255, 255, 255)
#define PROJECT_TRACK_UPDATE_BG_COLOR                   RGB(76, 145, 209)

#define PROJECT_TRACK_CARET_FONT                        fontNameWithSize(FONT_NAME_AWESOME, 16)
#define PROJECT_TRACK_CARET_COLOR                       RGB(0, 63, 114)
#define PROJECT_TRACK_DOWN_TEXT                         [NSString stringWithFormat:@"%C", 0xf0d7]
#define PROJECT_TRACK_UP_TEXT                           [NSString stringWithFormat:@"%C", 0xf0d8]

@interface ProjectTrackItemView()<MKMapViewDelegate>{
    NSMutableDictionary *stateStatus;
    BOOL isUserProject;
    NSNumber *projectId;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelType;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *labelContainer;
@property (weak, nonatomic) IBOutlet UILabel *labelUpdateDetails;
@property (weak, nonatomic) IBOutlet UIButton *buttonExpand;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSpaceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constaintContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintUpdateContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrintLeftLabelWidth;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *labelUpdateType;
@property (weak, nonatomic) IBOutlet UILabel *labelLeftDesc;
@property (weak, nonatomic) IBOutlet UILabel *labelRightDesc;
@property (weak, nonatomic) IBOutlet UIImageView *iconMarker;
- (IBAction)tappedButtonExppand:(id)sender;
@end

@implementation ProjectTrackItemView
@synthesize projectTrackItemViewDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _constraintSpaceTop.constant = kDeviceHeight * 0.018;
    _constaintContainerHeight.constant = kDeviceHeight * 0.092;
    
    _labelTitle.font = PROJECT_TRACK_ITEM_TITLE_FONT;
    _labelTitle.textColor = PROJECT_TRACK_ITEM_TITLE_COLOR;
    
    _labelLocation.font = PROJECT_TRACK_ITEM_LOCATION_FONT;
    _labelLocation.textColor = PROJECT_TRACK_ITEM_LOCATION_COLOR;
    
    _labelType.font = PROJECT_TRACK_ITEM_TYPE_FONT;
    _labelType.textColor = PROJECT_TRACK_ITEM_TYPE_COLOR;
    
    _container.layer.cornerRadius = kDeviceWidth * 0.01;
    _container.layer.masksToBounds = YES;
    _container.backgroundColor = PROJECT_TRACK_UPDATE_BG_COLOR;
    
    _labelUpdateDetails.font = PROJECT_TRACK_UPDATE_FONT;
    _labelUpdateDetails.textColor = PROJECT_TRACK_UPDATE_COLOR;
    
    _labelLeftDesc.font = PROJECT_TRACK_UPDATE_FONT;
    _labelLeftDesc.textColor = PROJECT_TRACK_UPDATE_COLOR;
    
    _labelRightDesc.font = PROJECT_TRACK_UPDATE_FONT;
    _labelRightDesc.textColor = PROJECT_TRACK_UPDATE_COLOR;
    [_labelRightDesc setTextAlignment:NSTextAlignmentRight];
    
    _labelUpdateType.font = PROJECT_TRACK_UPDATE_FONT;
    _labelUpdateType.textColor = PROJECT_TRACK_UPDATE_COLOR;
    
    _labelContainer.layer.cornerRadius = kDeviceWidth * 0.008;
    _labelContainer.layer.masksToBounds = YES;
    _labelContainer.backgroundColor = [PROJECT_TRACK_TEXT_BG_COLOR colorWithAlphaComponent:0.4];

    [_buttonExpand setTitleColor:PROJECT_TRACK_CARET_COLOR forState:UIControlStateNormal];
    _buttonExpand.titleLabel.font = PROJECT_TRACK_CARET_FONT;
    
    _constrintLeftLabelWidth.constant = _labelUpdateDetails.frame.size.width * 0.45;
    
    _container.hidden = YES;
    [self hideLeftAndRightLavel:YES];
}

- (void)setButtonTitle:(BOOL)isExpanded {

    [_buttonExpand setTitle:isExpanded?PROJECT_TRACK_DOWN_TEXT:PROJECT_TRACK_UP_TEXT forState:UIControlStateNormal];
    
}

- (void)setInfo:(id)info {
    NSDictionary *project = info[kStateData];
    
    if (project == nil) {
        project = info;
    }
    _labelTitle.text = project[@"title"];
    
    isUserProject = [DerivedNSManagedObject objectOrNil:project[@"dodgeNumber"]] == nil;
    
    NSString *addr = @"";
    
    NSString *county = [DerivedNSManagedObject objectOrNil:project[@"county"]];
    NSString *state = [DerivedNSManagedObject objectOrNil:project[@"state"]];
    NSDictionary *update = [DerivedNSManagedObject objectOrNil:info[@"update"]];
    
    if (county != nil) {
        addr = [addr stringByAppendingString:county];
        
        if (state != nil) {
            addr = [addr stringByAppendingString:@", "];
        }
    }
    
    if (state != nil) {
        addr = [addr stringByAppendingString:state];
    }
    
    _labelLocation.text = addr;
    
    NSString *primaryProjectTypeTitle = nil;
    NSString *projectCategoryTitle = nil;
    NSString *projectGroupTitle = nil;
    
    NSDictionary *primaryProjectType = [DerivedNSManagedObject objectOrNil:project[@"primaryProjectType"]];
    if (primaryProjectType != nil) {
        primaryProjectTypeTitle = [DerivedNSManagedObject objectOrNil:primaryProjectType[@"title"]];
        
        NSDictionary *category = [DerivedNSManagedObject objectOrNil:primaryProjectType[@"projectCategory"]];
        if (category != nil) {
            projectCategoryTitle = category[@"title"];
        }
        
        NSDictionary *projectGroup = [DerivedNSManagedObject objectOrNil:category[@"projectGroup"]];
        if (projectGroup != nil) {
            projectGroupTitle = [DerivedNSManagedObject objectOrNil:projectGroup[@"title"]];
        }
    }

    NSString *projectType = [NSString stringWithFormat:@"%@ %@ %@", primaryProjectTypeTitle==nil?@"":primaryProjectTypeTitle, projectCategoryTitle==nil?@"":projectCategoryTitle, projectGroupTitle==nil?@"":projectGroupTitle];

    _labelType.text = projectType;
    stateStatus = info[kStateStatus];
    
     if (stateStatus != nil) {

        BOOL shouldShowUpdates = [stateStatus[kStateShowUpdate] boolValue];
        
        ProjectTrackUpdateType updateType = (ProjectTrackUpdateType)[stateStatus[kStateUpdateType] integerValue];
        _container.hidden = (updateType == ProjectTrackUpdateTypeNone);
        
        if(!_container.hidden){
            
            if (shouldShowUpdates) {
                
                BOOL isExpanded = [stateStatus[kStateExpanded] boolValue];
                
                _labelUpdateDetails.hidden = !isExpanded;
                _labelContainer.hidden = _labelUpdateDetails.hidden;
                _constraintUpdateContainerHeight.constant = kDeviceHeight * (!isExpanded?0.06:0.133);
                
                [self setButtonTitle:isExpanded];
                [self setImageViewType:updateType];
                
                switch ((long)updateType) {
                    case ProjectTrackUpdateTypeNewBid:{
                        [self updateNewBidInfo:update];
                        [self hideLeftAndRightLavel:NO];
                        break;
                    }
                    case ProjectTrackUpdateTypeStage: {
                        [self updateNewStage:update];
                        [self hideLeftAndRightLavel:YES];
                        break;
                    }
                        
                    case ProjectTrackUpdateTypeWorkType: {
                        //_labelUpdateType.text = @"Work Type";
                        //_labelUpdateDetails.text = @"Work Type";
                        break;
                    }
                    case ProjectTrackUpdateTypeContact: {
                        [self updateNewContactInfo:update];
                        [self hideLeftAndRightLavel:NO];
                        break;
                    }
                        
                    case ProjectTrackUpdateTypeNewNote: {
                        _labelUpdateType.text = NSLocalizedLanguage(@"PROJECT_UPDATE_NEW_NOTE");
                        [self hideLeftAndRightLavel:YES];
                        break;
                    }
                        
                }
            } else {
                _container.hidden = YES;
            }
            
        }

    } else {
        _container.hidden = YES;
    }
    
    
    NSDictionary *geocode = [DerivedNSManagedObject objectOrNil:project[@"geocode"]];
    _mapView.delegate = nil;

    if (geocode != nil) {

        _mapView.hidden = NO;

        CGFloat geocodeLat = [geocode[@"lat"] floatValue];
        CGFloat geocodeLng = [geocode[@"lng"] floatValue];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geocodeLat, geocodeLng);
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region = {coordinate, span};
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:coordinate];
        
        [_mapView removeAnnotations:_mapView.annotations];
        
        [_mapView setRegion:region];
        _mapView.delegate = self;
        [_mapView addAnnotation:annotation];
        
    } else {

        [_mapView removeAnnotations:_mapView.annotations];
        _mapView.hidden = YES;
    }
    
    self.iconMarker.hidden = YES;
    projectId = project[@"id"];
    
    NSArray *userImages = project[@"images"];
    NSArray *userNotes = project[@"userNotes"];
    
    self.iconMarker.hidden = !((userImages.count>0)&&(userNotes.count>0));

}


- (void)setImageViewType:(ProjectTrackUpdateType)updateType {
    
    UIImage *imageType;
    switch ((long)updateType) {
        case ProjectTrackUpdateTypeNewBid:{
            imageType = [UIImage imageNamed:@"icon_trackUpdateTypeBid"];
            break;
        }
        case ProjectTrackUpdateTypeStage: {
            imageType = [UIImage imageNamed:@"Info"];
            break;
        }
            
        case ProjectTrackUpdateTypeWorkType: {
            imageType = [UIImage imageNamed:@"icon_trackUpdateTypeBid"];
            break;
        }
        case ProjectTrackUpdateTypeContact: {
            imageType = [UIImage imageNamed:@"addAcct_icon"];
            break;
        }
            
        case ProjectTrackUpdateTypeNewNote: {
            imageType = [UIImage imageNamed:@"icon_trackUpdateTypeBid"];
            break;
        }
            
    }

    _imageView.image = imageType;
    
}

- (NSMutableAttributedString *)attributedStringLeftDesc:(NSString *)amount RightDesc:(NSString *)desc {
    
    NSMutableAttributedString *amountAttribute = [[NSMutableAttributedString alloc] initWithString:amount];
    
    NSString *descString = [NSString stringWithFormat:@"%@",desc];
    NSMutableAttributedString *descAttribute = [[NSMutableAttributedString alloc] initWithString:descString];
    
    NSMutableParagraphStyle *amountStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [amountStyle setAlignment:NSTextAlignmentLeft];
    
    NSMutableParagraphStyle *descStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [descStyle setAlignment:NSTextAlignmentRight];
    
    [amountAttribute addAttribute:NSParagraphStyleAttributeName value:amountStyle range:NSMakeRange(0, amount.length)];
    
    [descAttribute addAttribute:NSParagraphStyleAttributeName value:descStyle range:NSMakeRange(0, desc.length)];
    CGFloat textLength = amount.length + desc.length;
    CGFloat space = 170 - textLength;
    [amountAttribute addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:space] range:NSMakeRange(amountAttribute.length - 1, 1)];
    
    [amountAttribute appendAttributedString:[descAttribute mutableCopy]];
    
    return amountAttribute;
}

#pragma mark - DetailsInfo
- (void)updateNewBidInfo:(id)update {
    NSString *summary;
    NSString *detailsUpdate;
    NSString *amountDetails = @"$0";
    
    if (update != nil) {
        
        summary = [DerivedNSManagedObject objectOrNil:update[@"summary"]];
        
        if (summary != nil) {
            detailsUpdate = update[@"modelObject"][@"company"][@"name"];
            NSString *amount = [DerivedNSManagedObject objectOrNil:update[@"modelObject"][@"amount"]];
            amountDetails = [amount isEqual:(id)[NSNull null]] || amount == nil?@"$0":[NSString stringWithFormat:@"$%@",amount];
        }
    }
    
    _labelUpdateType.text = summary;
    _labelLeftDesc.text = amountDetails;
    _labelRightDesc.text = detailsUpdate;
    
}

- (void)updateNewContactInfo:(id)update{
    NSString *summary;
    NSString *contactTitle;
    NSString *company;
    
    if (update != nil) {
        
        summary = [DerivedNSManagedObject objectOrNil:update[@"summary"]];
        
        if (summary!=nil) {
            company = update[@"modelObject"][@"company"][@"name"];
            contactTitle = [DerivedNSManagedObject objectOrNil:update[@"modelObject"][@"contact"][@"title"]];
        }
        
    }

    _labelUpdateType.text = summary;
    _labelLeftDesc.text = company;
    _labelRightDesc.text = contactTitle;
}

- (void)updateNewStage:(id)update {
    NSString *summary;
 
    if ([DerivedNSManagedObject objectOrNil:update] != nil) {
        summary = [DerivedNSManagedObject objectOrNil:update[@"summary"]];
    }
    
    _labelUpdateType.text = summary;
}

- (void)hideLeftAndRightLavel:(BOOL)hide {
    [_labelLeftDesc setHidden:hide];
    [_labelRightDesc setHidden:hide];
}

#pragma mark - Map Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *userAnnotationView = nil;
    if (![annotation isKindOfClass:MKUserLocation.class])
    {
        userAnnotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"UserLocation"];
        if (userAnnotationView == nil)  {
            userAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"UserLocation"];
        }
        else
            userAnnotationView.annotation = annotation;
        
        userAnnotationView.enabled = NO;
        
        userAnnotationView.canShowCallout = NO;
        
        if (isUserProject) {
            userAnnotationView.image = [UIImage imageNamed:@"icon_userPinNew"];
        } else {
            userAnnotationView.image = [UIImage imageNamed:@"icon_pin"];
        }
        
    }
    
    return userAnnotationView;
}

- (IBAction)tappedButtonExppand:(id)sender {
    BOOL expanded = [stateStatus[kStateExpanded] boolValue];
    stateStatus[kStateExpanded] = [NSNumber numberWithBool:!expanded];
    [self.projectTrackItemViewDelegate tappedButtonExpand:self view:nil];
}

@end
