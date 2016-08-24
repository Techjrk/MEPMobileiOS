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
#import "ProjectFilterSelectionViewList.h"

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define BUTTON_COLOR                        RGB(121, 120, 120)

#define BUTTON_OPTION_FONT                  fontNameWithSize(FONT_NAME_AWESOME, 16)
#define BUTTON_OPTION_DOWN                  [NSString stringWithFormat:@"%C", 0xf107]
#define BUTTON_OPTION_UP                    [NSString stringWithFormat:@"%C", 0xf106]

//#define FIELD_VIEW_HEIGHT                   kDeviceHeight * 0.117
#define FIELD_VIEW_HEIGHT                     kDeviceHeight * 0.095

@interface ProjectFilterView()<FilterLabelViewDelegate, FilterEntryViewDelegate>{
    BOOL isExpanded;
    NSLayoutConstraint *constraintObject;
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
@synthesize searchFilter;

- (void)awakeFromNib {
    [super awakeFromNib];

    self.searchFilter = [NSMutableDictionary new];
    CGFloat fieldHeight = FIELD_VIEW_HEIGHT;
    _constraintFieldHeight.constant = fieldHeight;
    _constraintFieldTypeHeight.constant = fieldHeight;
    _constraintFieldValueHeight.constant = fieldHeight;
    
    _constraintLabelHeight.constant = kDeviceHeight * 0.079;
     
    [_fieldLocation setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_LOCATION")];
    _fieldType.filterModel = FilterModelLocation;
    
    [_fieldType setTitle:NSLocalizedLanguage(@"PROJECT_FILTER_TYPE")];
    _fieldType.filterModel = FilterModelProjectType;
    
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
    
    [_fieldLocation setHint:NSLocalizedLanguage(@"PROJECT_FILTER_HINT_LOCATION")];
    [_fieldType setHint:NSLocalizedLanguage(@"PROJECT_FILTER_HINT_TYPE")];
    [_fieldValue setHint:NSLocalizedLanguage(@"PROJECT_FILTER_HINT_VALUE")];
    
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
            [_fieldLocation setInfo:val];
            break;
        }
        case FilterModelType:{
            
            break;
        }
        case FilterModelValue:{
            
            NSDictionary *dict = val;
            NSString *value;
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            NSNumber *min = dict[@"min"];
            NSNumber *max = dict[@"max"];
            
            if (max) {
                value = [NSString stringWithFormat:@"$ %@ - $ %@", [formatter stringFromNumber:min], [formatter stringFromNumber:max]];
            } else {
                value = [NSString stringWithFormat:@"$ %@ - MAX", [formatter stringFromNumber:min]];
            }
                
            [_fieldValue setInfo:@[@{@"entryID": @(0), @"entryTitle": value}]];
            break;
        }
        case FilterModelUpdated:{

            title = [self getItem:val keyName:PROJECT_SELECTION_TITLE];
            [_fieldUpdated setValue:title];
            
            NSNumber *value = (NSNumber*)[self getItem:val keyName:PROJECT_SELECTION_VALUE];
            
            if (value.integerValue>0) {
                
                NSString *date = [DerivedNSManagedObject dateStringFromDateDay:dateAdd(-(value.integerValue))];
                
                self.searchFilter[@"updatedWithin"] = @{ @"min": date };
                
            } else {
                [self.searchFilter removeObjectForKey:@"updatedWithin"];
            }
            
            break;
        }
        case FilterModelJurisdiction:{
            NSArray *juristiction = val;
            [_fieldJurisdiction setValue:[juristiction componentsJoinedByString:@","]];
            break;
        }
        case FilterModelStage:{
            NSArray *stage = val;
            [_fieldStage setValue:[stage componentsJoinedByString:@","]];
            
            break;
        }
        case FilterModelBidding:{
            
            title = [self getItem:val keyName:PROJECT_SELECTION_TITLE];
            [_fieldBidding setValue:title];
            
            NSNumber *value = (NSNumber*)[self getItem:val keyName:PROJECT_SELECTION_VALUE];
            
            if (value.integerValue>0) {
                
                NSString *date = [DerivedNSManagedObject dateStringFromDateDay:dateAdd(-(value.integerValue))];
                
                self.searchFilter[@"biddingWithin"] = @{ @"min": date };
                
            } else {
                [self.searchFilter removeObjectForKey:@"biddingWithin"];
            }

            break;
        }
        case FilterModelBH:{
            
            title = [self getItem:val keyName:PROJECT_SELECTION_TITLE];
            [_fieldBH setValue:title];
            
            NSArray *value = (NSArray*)[self getItem:val keyName:PROJECT_SELECTION_VALUE];
            
            self.searchFilter[@"buildingOrHighway"] = @{@"inq":value};
            
            break;
        }
        case FilterModelOwner:{
            
            title = [self getItem:val keyName:@"title"];
            [_fieldOwner setValue:title];
            self.searchFilter[@"ownerType"] = @{ @"inq":@[title]};
            
            break;
        }
        case FilterModelWork:{
            
            title = [self getItem:val keyName:@"title"];
            [_fieldWork setValue:title];
            self.searchFilter[@"workTypeId"] = @{ @"inq":@[val[@"id"]]};
            
            break;
        }
        case FilterModelProjectType:{
            NSMutableArray *items = [NSMutableArray new];
            for (NSString *item in val) {
                [items addObject:@{@"entryID": @(0), @"entryTitle": item}];
            }
            
            [_fieldType setInfo:items];
            
            break;
        }
        
    }
}

- (NSString *)getItem:(id)info keyName:(id)key {
    return info[key];
}

- (void)reloadDataBeenComplete:(FilterModel)filterModel {
    
    int collectionViewContentSizeHeight = CELL_FILTER_ORIGINAL_HEIGHT;
    NSLayoutConstraint *constraintHeight;
    int rowNumber = 0;
    
    if (filterModel == FilterModelLocation) {
        collectionViewContentSizeHeight = _fieldLocation.collectionView.contentSize.height;
        constraintHeight = _constraintFieldHeight;
    }
    if (filterModel == FilterModelProjectType) {
        collectionViewContentSizeHeight = _fieldType.collectionView.contentSize.height;
        constraintHeight = _constraintFieldTypeHeight;
        [_fieldType.collectionView layoutIfNeeded];
    }
    if (filterModel == FilterModelValue) {
        collectionViewContentSizeHeight = _fieldValue.collectionView.contentSize.height;
        constraintHeight = _constraintFieldValueHeight;
    }
    
    CGFloat additionalHeight;
    CGFloat extraHeight;
    int heightToMultiplyWithRow;
    
    rowNumber = collectionViewContentSizeHeight / (kDeviceHeight * 0.035);
    int filterHeigthOrig = CELL_FILTER_ORIGINAL_HEIGHT;
    if (collectionViewContentSizeHeight > filterHeigthOrig) {
        if (rowNumber == 2) {
            heightToMultiplyWithRow  = (FIELD_VIEW_HEIGHT * 0.25);
        } else if (rowNumber == 4 ) {
            heightToMultiplyWithRow  = (FIELD_VIEW_HEIGHT * 0.34);
        } else if (rowNumber > 4 ) {
            heightToMultiplyWithRow  = (FIELD_VIEW_HEIGHT * 0.34);
        }
        else {
            heightToMultiplyWithRow  = (FIELD_VIEW_HEIGHT * 0.3);
        }

        extraHeight = heightToMultiplyWithRow * rowNumber;
    } else {
        extraHeight = 0;
    }
    
    additionalHeight = FIELD_VIEW_HEIGHT + (extraHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        constraintHeight.constant = additionalHeight;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];

}

- (void)setLocationInfo:(id)info {
    [_fieldLocation setInfo:info];
}

- (NSDate*)dateAdd:(NSInteger)numberOfDays {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = numberOfDays;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *date = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];

    return date;
}

@end
