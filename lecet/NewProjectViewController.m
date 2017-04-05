//
//  NewProjectViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 3/21/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "NewProjectViewController.h"
#import "FilterLabelView.h"
#import "SearchFilterViewController.h"
#import "CameraControlListViewItem.h"
#import "ListItemCollectionViewCell.h"
#import "FilterViewController.h"
#import "SaveNewProjectViewController.h"
#import <MapKit/MapKit.h>

//#define LABEL_FONT                          fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
//#define LABEL_COLOR                         RGB(34, 34, 34)

#pragma mark - Fonts
#define TITLE_FONT                          fontNameWithSize(FONT_NAME_LATO_REGULAR, 13)
#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_REGULAR, 13)
#define LABEL_FONT                          fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define PLACEHOLDER_FONT                    fontNameWithSize(FONT_NAME_LATO_REGULAR, 11)

#pragma mark - Colors
#define TITLE_COLOR                         [UIColor whiteColor]
#define BUTTON_COLOR                        RGB(168, 195, 230)
#define LABEL_COLOR                         RGB(8, 73, 124)
#define LINE_COLOR                          [[UIColor lightGrayColor] colorWithAlphaComponent:0.5]
#define HEADER_BGROUND                      RGBA(21, 78, 132, 95)
#define PLACEHOLDER_COLOR                   RGBA(34, 34, 34, 50)

#define KEY_PROJECTSTAGEID                  @"projectStageId"
#define KEY_TYPEID                          @"projectTypeId"
#define KEY_JURISDICTION                    @"jurisdictions"

@interface NewProjectViewController ()<FilterLabelViewDelegate, SearchFilterViewControllerDelegate, FilterViewControllerDelegate, MKMapViewDelegate, SaveNewProjectViewControllerDelegate>{
    ListViewItemArray *listItemsProjectTypeId;
    ListViewItemArray *listItemsProjectStageId;
    ListViewItemArray *listItemsJurisdictions;
    
    NSNumber *typeId;
    NSNumber *estLow;
    NSNumber *stageId;
    NSString *targetDate;
    NSString *county;
    NSString *countryCode;
    NSNumber *jurisdictionId;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *spacerView;
@property (weak, nonatomic) IBOutlet UILabel *labelProjectTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldProjectTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCity;
@property (weak, nonatomic) IBOutlet UITextField *textFieldState;
@property (weak, nonatomic) IBOutlet UITextField *textFieldZip;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldCounty;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldBidStatus;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldType;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldEstLow;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldStage;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldTargetSetDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) id<SearchFilterViewControllerDelegate>searchFilterViewControllerDelegate;
@property (weak, nonatomic) id<FilterViewControllerDelegate>filterViewControllerDelegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIButton *buttonDone;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldJurisdiction;

@end

@implementation NewProjectViewController
@synthesize location;

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self enableTapGesture:YES];
    
    self.headerView.backgroundColor = HEADER_BGROUND;
    self.spacerView.backgroundColor = HEADER_BGROUND;
    
    self.labelTitle.text = NSLocalizedLanguage(@"NPVC_TITLE");
    self.labelTitle.textColor = TITLE_COLOR;
    self.labelTitle.font = TITLE_FONT;
    
    [self.buttonCancel setTitle:NSLocalizedLanguage(@"NPVC_CANCEL") forState:UIControlStateNormal];
    [self.buttonCancel setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    self.buttonCancel.titleLabel.font = BUTTON_FONT;
    
    [self.buttonSave setTitle:NSLocalizedLanguage(@"NPVC_SAVE") forState:UIControlStateNormal];
    [self.buttonSave setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    self.buttonSave.titleLabel.font = BUTTON_FONT;
    
    self.labelProjectTitle.text = NSLocalizedLanguage(@"NPVC_LABEL_TITLE");
    [self changeLabelStyle:self.labelProjectTitle];
  
    self.labelAddress.text = NSLocalizedLanguage(@"NPVC_LABEL_ADDRESS");
    [self changeLabelStyle:self.labelAddress];
    
    [self changeTextFieldStyle:self.textFieldProjectTitle placeHolder:NSLocalizedLanguage(@"NPVC_PROJECT_TITLE")];
    [self changeTextFieldStyle:self.textFieldAddress1 placeHolder:NSLocalizedLanguage(@"NPVC_STREET1")];
    self.textFieldAddress1.userInteractionEnabled = NO;
    
    [self changeTextFieldStyle:self.textFieldAddress2 placeHolder:NSLocalizedLanguage(@"NPVC_STREET2")];
    self.textFieldAddress2.userInteractionEnabled = NO;
    
    [self changeTextFieldStyle:self.textFieldCity placeHolder:NSLocalizedLanguage(@"NPVC_CITY")];
    self.textFieldCity.userInteractionEnabled = NO;
    
    [self changeTextFieldStyle:self.textFieldState placeHolder:NSLocalizedLanguage(@"NPVC_STATE")];
    self.textFieldState.userInteractionEnabled = NO;
    
    [self changeTextFieldStyle:self.textFieldZip placeHolder:NSLocalizedLanguage(@"NPVC_ZIP")];
    self.textFieldZip.userInteractionEnabled = NO;
    
    [self.fieldCounty setTitle:NSLocalizedLanguage(@"NPVC_COUNTY")];
    
    [self.fieldBidStatus setValue:NSLocalizedLanguage(@"NPVC_SELECT")];
    [self.fieldBidStatus setTitle:NSLocalizedLanguage(@"NPVC_BIDSTATUS")];
    
    [self.fieldType setValue:NSLocalizedLanguage(@"NPVC_NONE")];
    [self.fieldType setTitle:NSLocalizedLanguage(@"NPVC_TYPE")];
    self.fieldType.filterModel = FilterModelProjectType;
    self.fieldType.filterLabelViewDelegate = self;
  
    [self.fieldEstLow setValue:NSLocalizedLanguage(@"NPVC_NONE")];
    [self.fieldEstLow setTitle:NSLocalizedLanguage(@"NPVC_ESTLOW")];
    self.fieldEstLow.filterModel = FilterModelEstLow;
    self.fieldEstLow.filterLabelViewDelegate = self;
    
    [self.fieldStage setValue:NSLocalizedLanguage(@"NPVC_NONE")];
    [self.fieldStage setTitle:NSLocalizedLanguage(@"NPVC_STAGE")];
    self.fieldStage.filterModel = FilterModelStage;
    self.fieldStage.filterLabelViewDelegate = self;
    
    [self.fieldTargetSetDate setValue:NSLocalizedLanguage(@"NPVC_NONE")];
    [self.fieldTargetSetDate setTitle:NSLocalizedLanguage(@"NPVC_TARGET_DATE")];
    self.fieldTargetSetDate.filterLabelViewDelegate = self;
    
    [self.fieldJurisdiction setValue:NSLocalizedLanguage(@"NPVC_NONE")];
    [self.fieldJurisdiction setTitle:NSLocalizedLanguage(@"NPVC_JURISDICTION")];
    self.fieldStage.filterModel = FilterModelJurisdiction;
    self.fieldJurisdiction.filterLabelViewDelegate = self;
    
    if (self.location != nil) {
        [self findLocation];
        [self setMap];
    }

    self.viewPicker.hidden = YES;
    self.dateTimePicker.backgroundColor = [UIColor whiteColor];
    
    [self.buttonDone setTitle:NSLocalizedLanguage(@"NPVC_DONE") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)tappedDoneButton:(id)sender {
    self.viewPicker.hidden = YES;
    
    [self.fieldTargetSetDate setValue:[DerivedNSManagedObject shortDateStringFromDate:self.dateTimePicker.date]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.constraintViewHeight.constant = self.fieldJurisdiction.frame.origin.y + self.fieldJurisdiction.frame.size.height + (kDeviceHeight * 0.01);
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.constraintViewHeight.constant  );
}

#pragma mark - Custom Methods

- (void)changeLabelStyle:(UILabel*)label {
    label.font = LABEL_FONT;
    label.textColor = LABEL_COLOR;
}

- (void)changeTextFieldStyle:(UITextField*)textField placeHolder:(NSString*)placeHolder{
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = LINE_COLOR.CGColor;
    textField.layer.sublayerTransform = CATransform3DMakeTranslation(kDeviceWidth*0.02, 0, 0);
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:PLACEHOLDER_FONT, NSForegroundColorAttributeName:PLACEHOLDER_COLOR}];
    textField.attributedPlaceholder = attributedString;
}

#pragma mark - FindLocation

- (void)findLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     
                     if (placemarks && placemarks.count > 0) {
                         
                         CLPlacemark *result = [placemarks objectAtIndex:0];
                         NSDictionary *address = result.addressDictionary;
                         NSLog(@"%@", [address description]);
                         
                         self.textFieldAddress1.text = [DerivedNSManagedObject objectOrNil:address[@"Street"]];
                    
                         self.textFieldCity.text = [DerivedNSManagedObject objectOrNil:address[@"City"]];
                         
                         self.textFieldState.text = [DerivedNSManagedObject objectOrNil:address[@"State"]];
                         
                         self.textFieldZip.text = [DerivedNSManagedObject objectOrNil:address[@"ZIP"]];
                         
                         countryCode = [DerivedNSManagedObject objectOrNil:address[@"CountryCode"]];
                         
                         county = [DerivedNSManagedObject objectOrNil:address[@"SubAdministrativeArea"]];
                     } else if (error != nil) {
                         
                     }
                 }
     ];
}
#pragma mark - IBActions
- (IBAction)tappedCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tappedSave:(id)sender {
    SaveNewProjectViewController *controller = [SaveNewProjectViewController new];
    controller.saveNewProjectViewControllerDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:NO completion:nil];
}

- (void)tappedSaveNewProject {
    [self saveNewProject];
}

- (void)saveNewProject {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    dict[@"title"] = self.textFieldProjectTitle.text;
    
    if (self.textFieldAddress1.text.length>0) {
        dict[@"address1"] = self.textFieldAddress1.text;
    }
    
    if (self.textFieldAddress2.text.length>0) {
        dict[@"address2"] = self.textFieldAddress2.text;
    }
    
    if (self.textFieldCity.text.length>0) {
        dict[@"city"] = self.textFieldCity.text;
    }
    
    if (self.textFieldState.text.length>0) {
        dict[@"state"] = self.textFieldState.text;
    }
    
    if (self.textFieldZip.text.length>0) {
        dict[@"zip5"] = self.textFieldZip.text;
    }
    
    NSMutableDictionary *geoCode = [NSMutableDictionary new];
    geoCode[@"lat"] = [NSNumber numberWithFloat:self.location.coordinate.latitude];
    geoCode[@"lng"] = [NSNumber numberWithFloat:self.location.coordinate.longitude];
    
    dict[@"geocode"] = geoCode;
    
    if (typeId != nil) {
        dict[@"primaryProjectTypeId"] = typeId;
    }
    
    if (stageId != nil) {
        dict[@"projectStageId"] = stageId;
    }
    
    if (targetDate != nil) {
        dict[@"targetStartDate"] = targetDate;
    }
    
    if (estLow != nil) {
        dict[@"estLow"] = estLow;
    }
    
    if (countryCode != nil) {
        dict[@"country"] = countryCode;
    }
    
    if (county != nil) {
        dict[@"county"] = county;
    }
    
    if (jurisdictionId != nil) {
        dict[@"jurisdictionCityId"] = jurisdictionId;
    }
    [[DataManager sharedManager] createProject:dict success:^(id object) {
        
        NSNumber *projectId = object[@"id"];
        [[DataManager sharedManager] createPin:self.location projectId:projectId success:^(id object) {
            
            [self.navigationController popViewControllerAnimated:NO];
            [self.projectViewControllerDelegate tappedSavedNewProject:projectId];
            
        } failure:^(id object) {
            
        }];
        
    } failure:^(id object) {
        
    }];
    
}

#pragma mark - FilterLabelViewDelegate

- (void)tappedFilterLabelView:(id)object {
    if ([self.fieldType isEqual:object]) {
        [self filterProjectTypes:object];
    } else if ([self.fieldStage isEqual:object]) {
        [self filterStage:object];
    } else if ([self.fieldTargetSetDate isEqual:object]) {
        self.viewPicker.hidden = NO;
        self.dateTimePicker.date = [NSDate date];
    } else if ([self.fieldEstLow isEqual:object]) {
        [self promptEstLow];
    } else if ([self.fieldJurisdiction isEqual:object]) {
        [self filterJurisdiction:object];
    }
}

- (void) promptEstLow {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedLanguage(@"NPVC_ESTLOW_TITLE") message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"0.00";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    UIAlertAction *actionAccept = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"PROJECT_FILTER_LOCATION_ACCEPT") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        for (int i=0; i<alert.textFields.count; i++) {
            UITextField *alertTextField = alert.textFields[i];
            estLow = [NSNumber numberWithFloat: [alertTextField.text floatValue]];
        }
        
    }];
    
    [alert addAction:actionAccept];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedLanguage(@"PROJECT_FILTER_LOCATION_CANCEL") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:actionCancel];
    
    
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - SearchFilterViewControllerDelegate
- (void)tappedSearchFilterViewControllerApply:(NSDictionary *)projectFilter companyFilter:(NSDictionary *)companyFilter {
    
}

#pragma mark - Project Types
- (void)filterProjectTypes:(UIView*)view {
    
    if (listItemsProjectTypeId == nil) {
        [[DataManager sharedManager] projectTypes:^(id groups) {
            
            ListViewItemArray *listItems = [ListViewItemArray new];
            
            for (NSDictionary *group in groups) {
                
                ListViewItemDictionary *groupItem = [ListItemCollectionViewCell createItem:group[@"title"] value:group[@"id"] model:@"projectGroup"];
                
                NSArray *categories = [DerivedNSManagedObject objectOrNil:group[@"projectCategories"]];
                
                if (categories) {
                    
                    ListViewItemArray *groupItems = [ListViewItemArray new];
                    
                    for (NSDictionary *category in categories) {
                        
                        ListViewItemDictionary *categoryItem = [ListItemCollectionViewCell createItem:category[@"title"] value:category[@"id"] model:@"projectCategory"];
                        [groupItems addObject:categoryItem];
                        
                        NSArray *projectTypes = [DerivedNSManagedObject objectOrNil:category[@"projectTypes"]];
                        
                        if (projectTypes) {
                            
                            ListViewItemArray *projectTypeItems = [ListViewItemArray new];
                            
                            for (NSDictionary *projectType in projectTypes) {
                                
                                ListViewItemDictionary *projectTypeItem = [ListItemCollectionViewCell createItem:projectType[@"title"] value:projectType[@"id"] model:@"projectType"];
                                
                                [projectTypeItems addObject:projectTypeItem];
                            }
                            
                            categoryItem[LIST_VIEW_SUBITEMS] = projectTypeItems;
                            
                        }
                        
                    }
                    
                    groupItem[LIST_VIEW_SUBITEMS] = groupItems;
                    
                }
                
                [listItems addObject:groupItem];
                
            }
            
            listItemsProjectTypeId = listItems;
            
            [self displayProjectTypeId];
            
        } failure:^(id object) {
            
        }];
    } else {
        [self displayProjectTypeId];
    }
    
}

- (void)displayProjectTypeId {
    
    FilterViewController *controller = [FilterViewController new];
    controller.searchTitle = NSLocalizedLanguage(@"FILTER_VIEW_PROJECTTYPE");
    controller.listViewItems = listItemsProjectTypeId;
    controller.filterViewControllerDelegate = self;
    controller.fieldValue = @"projectTypeId";
    controller.singleSelect = YES;
    controller.parentOnly = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)tappedFilterViewControllerApply:(NSMutableArray *)selectedItems key:(NSString *)key titles:(NSMutableArray *)titles {
    
    if ([key isEqualToString:KEY_PROJECTSTAGEID]) {
        [self.fieldStage setValue:titles[0]];
        stageId = selectedItems[0];
    } else if ([key isEqualToString:KEY_TYPEID]) {
        [self.fieldType setValue:titles[0]];
        typeId = selectedItems[0];
    } else if ([key isEqualToString:KEY_JURISDICTION]){
        [self.fieldJurisdiction setValue:titles[0]];
        jurisdictionId = selectedItems[0];
    }
}

#pragma mark - Stage

- (void)filterStage:(UIView*)view {
    
    if (listItemsProjectStageId == nil) {
        
        ListViewItemArray *listItems = [ListViewItemArray new];
        
        [[DataManager sharedManager] parentStage:^(id object) {
            
            for (NSDictionary *item in object) {
                
                ListViewItemDictionary *listItem = [ListItemCollectionViewCell createItem:item[@"name"] value:item[@"id"] model:@"parentStage"];
                
                NSArray *stages = [DerivedNSManagedObject objectOrNil:item[@"stages"]];
                
                if (stages != nil) {
                    
                    ListViewItemArray *subItems = [ListViewItemArray new];
                    
                    for (NSDictionary *stage in stages) {
                        
                        ListViewItemDictionary *subItem = [ListItemCollectionViewCell createItem:stage[@"name"] value:stage[@"id"] model:@"stage"];
                        [subItems addObject:subItem];
                        
                    }
                    
                    listItem[LIST_VIEW_SUBITEMS] = subItems;
                }
                
                [listItems addObject:listItem];
                
            }
            
            listItemsProjectStageId = listItems;
            [self displayProjectStageId];
            
        } failure:^(id object) {
            
        }];
    } else {
        
        [self displayProjectStageId];
        
    }
    
}

- (void) displayProjectStageId {
    
    FilterViewController *controller = [FilterViewController new];
    controller.searchTitle = NSLocalizedLanguage(@"FILTER_VIEW_STAGES");
    controller.listViewItems = listItemsProjectStageId;
    controller.filterViewControllerDelegate = self;
    controller.fieldValue = @"projectStageId";
    controller.singleSelect = YES;
    controller.parentOnly = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - Jurisdiction

- (void)filterJurisdiction:(UIView*)view {
    
    if (listItemsJurisdictions == nil) {
        
        ListViewItemArray *listItems = [ListViewItemArray new];
        
        [[DataManager sharedManager] jurisdiction:^(id object) {
            
            NSArray *items = object;
            
            for (NSDictionary *item in items) {
                
                NSMutableDictionary *jurisdiction = [ListItemCollectionViewCell createItem:item[@"name"] value:item[@"id"] model:@"jurisdiction"];
                
                [listItems addObject:jurisdiction];
                
                NSArray *locals = [DerivedNSManagedObject objectOrNil:item[@"localsWithNoDistrict"]];
                
                if (locals != nil) {
                    
                    if (locals.count>0) {
                        
                        ListViewItemArray *localItems = [ListViewItemArray new];
                        
                        for (NSDictionary *local in locals) {
                            
                            NSMutableDictionary *localItem = [ListItemCollectionViewCell createItem:local[@"name"] value:local[@"id"] model:@"local"];
                            
                            [localItems addObject:localItem];
                        }
                        
                        jurisdiction[LIST_VIEW_SUBITEMS] = localItems;
                        
                    }
                    
                }
                
                NSArray *districtCouncils = [DerivedNSManagedObject objectOrNil:item[@"districtCouncils"]];
                
                if (districtCouncils != nil) {
                    
                    ListViewItemArray *localItems = jurisdiction[LIST_VIEW_SUBITEMS];
                    
                    if (localItems == nil) {
                        localItems = [ListViewItemArray new];
                        jurisdiction[LIST_VIEW_SUBITEMS] = localItems;
                        
                    }
                    for (NSDictionary *districtItem in districtCouncils) {
                        
                        NSMutableDictionary *localItem = [ListItemCollectionViewCell createItem:districtItem[@"name"] value:districtItem[@"id"] model:@"district"];
                        
                        [localItems addObject:localItem];
                        
                        
                        NSArray *locals = [DerivedNSManagedObject objectOrNil:districtItem[@"locals"]];
                        
                        ListViewItemArray *localDistrict = [ListViewItemArray new];
                        
                        for (NSDictionary *local in locals) {
                            
                            NSMutableDictionary *item = [ListItemCollectionViewCell createItem:local[@"name"] value:local[@"id"] model:@"localDisctrict"];
                            
                            [localDistrict addObject:item];
                            
                        }
                        
                        localItem[LIST_VIEW_SUBITEMS] = localDistrict;
                        
                        
                    }
                    
                }
                
                
            }
            
            listItemsJurisdictions = listItems;
            [self displayJurisdiction];
        } failure:^(id object) {
            
        }];
        
    } else {
        [self displayJurisdiction];
    }
    
}

- (void)displayJurisdiction {
    FilterViewController *controller = [FilterViewController new];
    controller.searchTitle = NSLocalizedLanguage(@"FILTER_VIEW_JURISRICTION");
    controller.listViewItems = listItemsJurisdictions;
    controller.singleSelect = YES;
    controller.parentOnly = YES;
    controller.fieldValue = @"jurisdictions";
    controller.filterViewControllerDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - Pin

- (void)setMap {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {coordinate, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    [_mapView setRegion:region];
    [_mapView addAnnotation:annotation];
    
}

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
        switch (self.pinType) {
            case pinTypeUserNew:
                userAnnotationView.image = [UIImage imageNamed:@"icon_userPinNew"];
                break;
                
            case pinTypeOrange:
                userAnnotationView.image = [UIImage imageNamed:@"icon_pinOrange"];
                break;
                
            case pinTypeOrageUpdate:
                userAnnotationView.image = [UIImage imageNamed:@"icon_dodgeProjectUpdates"];
                break;
                
            case pinTypeUser:
                userAnnotationView.image = [UIImage imageNamed:@"icon_userProject"];
                break;
                
            default:
                userAnnotationView.image = [UIImage imageNamed:@"icon_userProjectUpdates"];
                break;
        }
        
    }
    
    return userAnnotationView;
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    [super handleSingleTap:sender];
    if (!self.viewPicker.hidden) {
        self.viewPicker.hidden = YES;
    }
}
@end
