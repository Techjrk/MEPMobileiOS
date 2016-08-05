//
//  ProjectFilterView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterView.h"

#import "FilterEntryView.h"
#import "FilterLabelView.h"

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define BUTTON_COLOR                        RGB(121, 120, 120)

#define BUTTON_OPTION_FONT                  fontNameWithSize(FONT_NAME_AWESOME, 16)
#define BUTTON_OPTION_DOWN                  [NSString stringWithFormat:@"%C", 0xf107]
#define BUTTON_OPTION_UP                    [NSString stringWithFormat:@"%C", 0xf106]

@interface ProjectFilterView()<FilterLabelViewDelegate, FilterEntryViewDelegate>{
    BOOL isExpanded;
    NSLayoutConstraint *constraintObject;
    BOOL selectedItemIsEmpty;
}
@property (weak, nonatomic) IBOutlet FilterEntryView *fieldLocation;
@property (weak, nonatomic) IBOutlet FilterEntryView *fieldType;
@property (weak, nonatomic) IBOutlet FilterEntryView *fieldValue;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldUpdated;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldJurisdiction;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldStage;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldBidding;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldBH;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldOwner;
@property (weak, nonatomic) IBOutlet FilterLabelView *fieldWork;
@property (weak, nonatomic) IBOutlet UIButton *buttonOptions;
@property (weak, nonatomic) IBOutlet UIView *viewOptions;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewOptionsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldTypeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldValueHeight;
- (IBAction)tappedButtonOptions:(id)sender;
@end

@implementation ProjectFilterView
@synthesize scrollView;
@synthesize projectFilterViewDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];

    CGFloat fieldHeight = kDeviceHeight * 0.117;
    _constraintFieldHeight.constant = fieldHeight;
    _constraintFieldTypeHeight.constant = fieldHeight;
    _constraintFieldValueHeight.constant = fieldHeight;
    
    _constraintLabelHeight.constant = kDeviceHeight * 0.079;
     
    [_fieldLocation setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_LOCATION")];
    _fieldType.filterModel = FilterModelLocation;
    
    [_fieldType setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_TYPE")];
    _fieldType.filterModel = FilterModelType;
    
    [_fieldValue setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_VALUE")];
    _fieldValue.filterModel = FilterModelValue;
    
    [_fieldUpdated setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_UPDATED")];
    _fieldUpdated.filterModel = FilterModelUpdated;
    
    [_fieldJurisdiction setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_JURISDICTION")];
    _fieldJurisdiction.filterModel = FilterModelJurisdiction;
    
    [_fieldStage setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_STAGE")];
    _fieldStage.filterModel = FilterModelStage;
    
    [_fieldBidding setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_BIDDING")];
    _fieldBidding.filterModel = FilterModelBidding;
    
    [_fieldBH setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_BH")];
    _fieldBH.filterModel = FilterModelBH;
    
    [_fieldOwner setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_OWNER")];
    _fieldOwner.filterModel = FilterModelOwner;
    
    [_fieldWork setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_WORK")];
    _fieldWork.filterModel = FilterModelWork;
    
    [_fieldUpdated setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldJurisdiction setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldStage setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldBidding setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldBH setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldOwner setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    [_fieldWork setValue:NSLocalizedLanguage(@"PROJECT_FILTER_ANY")];
    
    _fieldLocation.filterEntryViewDelegate = self;
    _fieldType.filterEntryViewDelegate = self;
    _fieldValue.filterEntryViewDelegate = self;
    _fieldUpdated.filterLabelViewDelegate = self;
    _fieldJurisdiction.filterLabelViewDelegate = self;
    _fieldStage.filterLabelViewDelegate = self;
    _fieldBidding.filterLabelViewDelegate = self;
    _fieldBH.filterLabelViewDelegate = self;
    _fieldOwner.filterLabelViewDelegate = self;
    _fieldWork.filterLabelViewDelegate = self;
    
    [self setButtonTitle];
}

- (void)setButtonTitle {
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSLocalizedLanguage(!isExpanded?@"PROJECT_FILTER_MORE":@"PROJECT_FILTER_FEW") stringByAppendingString:@" "]   attributes:@{NSFontAttributeName:BUTTON_FONT, NSForegroundColorAttributeName:BUTTON_COLOR}];
    
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:!isExpanded?BUTTON_OPTION_DOWN:BUTTON_OPTION_UP attributes:@{NSFontAttributeName:BUTTON_OPTION_FONT, NSForegroundColorAttributeName:BUTTON_COLOR}] ];
    
    [ _buttonOptions setAttributedTitle:title forState:UIControlStateNormal];
    
}

- (IBAction)tappedButtonOptions:(id)sender {
    isExpanded = !isExpanded;
    [self setButtonTitle];
    
    _constraintViewOptionsHeight.constant = isExpanded?_fieldUpdated.frame.size.height * 3.0:0;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {

        if (finished) {
            [self layoutSubviews];
       }
    }];
    
}

- (void)setConstraint:(NSLayoutConstraint *)constraint {
    constraintObject = constraint;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    constraintObject.constant = _buttonOptions.frame.size.height + _buttonOptions.frame.origin.y + (kDeviceHeight * 0.02);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, constraintObject.constant);

}

- (void)tappedFilterLabelView:(id)object{

    [self.projectFilterViewDelegate tappedProjectFilterItem:object view:self];
    
}

- (void)tappedFilterEntryViewDelegate:(id)object {
 
    [self.projectFilterViewDelegate tappedProjectFilterItem:object view:self];
    
}

- (void)setFilterModelInfo:(FilterModel)filterModel value:(id)val{
    NSString *title;
    switch (filterModel) {
        case FilterModelLocation:{
            
            break;
        }
        case FilterModelType:{
            
            break;
        }
        case FilterModelValue:{
            
            break;
        }
        case FilterModelUpdated:{

            title = [self getItem:val keyName:@"TITLE"];
            [_fieldUpdated setValue:title];
            
            break;
        }
        case FilterModelJurisdiction:{
            
            break;
        }
        case FilterModelStage:{
            
            break;
        }
        case FilterModelBidding:{
            
            title = [self getItem:val keyName:@"TITLE"];
            [_fieldBidding setValue:title];
            
            break;
        }
        case FilterModelBH:{
            
            title = [self getItem:val keyName:@"TITLE"];
            [_fieldBH setValue:title];
            
            break;
        }
        case FilterModelOwner:{
            
            title = [self getItem:val keyName:@"title"];
            [_fieldOwner setValue:title];
            
            break;
        }
        case FilterModelWork:{
            
            title = [self getItem:val keyName:@"title"];
            [_fieldWork setValue:title];
            
            break;
        }
        case FilterModelProjectType:{
            
            break;
        }
        
    }
}

- (NSString *)getItem:(id)info keyName:(id)key {
    return info[key];
}

- (void)reloadDataBeenComplete:(FilterModel)filterModel {
    
    CGFloat collectionViewHeight = kDeviceHeight * 0.117;
    CGFloat collectionViewContentSizeHeight = kDeviceHeight * 0.117;
    NSLayoutConstraint *constraintHeight;
    if (filterModel == FilterModelLocation) {
        collectionViewHeight = _fieldLocation.collectionView.frame.size.height;
        collectionViewContentSizeHeight = _fieldLocation.collectionView.contentSize.height;
        constraintHeight = _constraintFieldHeight;
    }
    if (filterModel == FilterModelType) {
        collectionViewHeight = _fieldType.collectionView.frame.size.height;
        collectionViewContentSizeHeight = _fieldType.collectionView.contentSize.height;
        constraintHeight = _constraintFieldTypeHeight;
    }
    if (filterModel == FilterModelValue) {
        collectionViewHeight = _fieldValue.collectionView.frame.size.height;
        collectionViewContentSizeHeight = _fieldValue.collectionView.contentSize.height;
        constraintHeight = _constraintFieldValueHeight;
    }
    
    CGFloat additionalHeight;
    
    if (selectedItemIsEmpty) {
       additionalHeight = kDeviceHeight * 0.117;
    } else {
        additionalHeight = (kDeviceHeight * 0.115) + (collectionViewContentSizeHeight + (kDeviceHeight * 0.025));
    }
    
    
  //  if (collectionViewContentSizeHeight > collectionViewHeight || selectedItemIsEmpty) {
        [UIView animateWithDuration:0.25 animations:^{
            constraintHeight.constant = additionalHeight;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
  //  }

}

- (void)setLocationInfo:(id)info {
    NSArray *data = [info copy];
    selectedItemIsEmpty = data.count > 0?NO:YES;
    [_fieldLocation setInfo:info];
}

@end
