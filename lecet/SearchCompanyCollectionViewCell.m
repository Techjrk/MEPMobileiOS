//
//  SearchCompanyCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchCompanyCollectionViewCell.h"

#define LABEL_TITLE_FONT                    fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_TITLE_COLOR                   RGB(34, 34, 34)

#define LABEL_LOCATION_FONT                 fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_LOCATION_COLOR                RGB(159, 164, 166)

@interface SearchCompanyCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation SearchCompanyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _labelTitle.font = LABEL_TITLE_FONT;
    _labelTitle.textColor = LABEL_TITLE_COLOR;
    _labelTitle.text = @"Sims Bayou Line Work";
    
    _labelLocation.font = LABEL_LOCATION_FONT;
    _labelLocation.textColor = LABEL_LOCATION_COLOR;
    _labelLocation.text = @"Houston, TX";
    
    _lineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];

}

- (void)setInfo:(id)info {

    NSDictionary *item = info;
    
    _labelTitle.text = item[@"name"];
    
    NSString *addr = @"";

    NSString *address = [DerivedNSManagedObject objectOrNil:item[@"address1"]];
    NSString *county = [DerivedNSManagedObject objectOrNil:item[@"county"]];
    NSString *state = [DerivedNSManagedObject objectOrNil:item[@"state"]];
    NSString *zip = [DerivedNSManagedObject objectOrNil:item[@"zip5"]];
    
    if (address != nil) {
        addr = [addr stringByAppendingString:address];
        
        if (county != nil) {
            addr = [addr stringByAppendingString:@"\n"];
            
        }
    }
    
    if (county != nil) {
        addr = [addr stringByAppendingString:county];
        
        if (state != nil) {
            addr = [addr stringByAppendingString:@", "];
        }
    }
    
    if (state != nil) {
        addr = [addr stringByAppendingString:state];
        if (zip != nil) {
            [addr stringByAppendingString:@" "];
        }
    }
    
    if (zip != nil) {
        addr = [addr stringByAppendingString:zip];

    }
    _labelLocation.text = addr;

}

@end
