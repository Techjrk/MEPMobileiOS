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

@interface NewProjectViewController ()<FilterLabelViewDelegate, SearchFilterViewControllerDelegate, FilterViewControllerDelegate, MKMapViewDelegate>{
    ListViewItemArray *listItemsProjectTypeId;
    ListViewItemArray *listItemsProjectStageId;
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


@end

@implementation NewProjectViewController
@synthesize location;

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
  
    [self.fieldStage setValue:NSLocalizedLanguage(@"NPVC_NONE")];
    [self.fieldStage setTitle:NSLocalizedLanguage(@"NPVC_STAGE")];
    self.fieldStage.filterModel = FilterModelStage;
    self.fieldStage.filterLabelViewDelegate = self;
    
    [self.fieldTargetSetDate setValue:NSLocalizedLanguage(@"NPVC_NONE")];
    [self.fieldTargetSetDate setTitle:NSLocalizedLanguage(@"NPVC_TARGET_DATE")];
    
    if (self.location != nil) {
        [self findLocation];
        [self setMap];
    }

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.constraintViewHeight.constant = self.fieldTargetSetDate.frame.origin.y + self.fieldTargetSetDate.frame.size.height + (kDeviceHeight * 0.01);
    
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
                         
                     } else if (error != nil) {
                         
                         //[self searchRecursiveLocationGeocode:YES];
                     }
                 }
     ];
}
#pragma mark - IBActions
- (IBAction)tappedCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tappedSave:(id)sender {
}

#pragma mark - FilterLabelViewDelegate

- (void)tappedFilterLabelView:(id)object {
    if ([self.fieldType isEqual:object]) {
        [self filterProjectTypes:object];
    } else if ([self.fieldStage isEqual:object]) {
        [self filterStage:object];
    }
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

@end
