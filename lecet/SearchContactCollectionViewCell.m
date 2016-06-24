//
//  SearchContactCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchContactCollectionViewCell.h"

#define LABEL_NAME_FONT                    fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_NAME_COLOR                   RGB(34, 34, 34)

#define LABEL_POSITION_FONT                fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_POSITION_COLOR               RGB(34, 34, 34)

#define LABEL_COMPANY_FONT                 fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_COMPANY_COLOR                RGB(159, 164, 166)

@interface SearchContactCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation SearchContactCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    _labelName.font = LABEL_NAME_FONT;
    _labelName.textColor = LABEL_NAME_COLOR;
    _labelName.text = @"Mike Allen";
    
    
    _lineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    
    [self setTitle:@"Manager" companyName:@"Jay Dee Contractor, Inc."];

}

- (void)setTitle:(NSString*)postion companyName:(NSString*)companyName {
    
    if ( (postion != nil) | (postion.length>0) ) {
        postion = [postion stringByAppendingString:@", "];
    }
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:postion attributes:@{NSFontAttributeName:LABEL_POSITION_FONT, NSForegroundColorAttributeName:LABEL_POSITION_COLOR}];
    
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:companyName attributes:@{NSFontAttributeName:LABEL_COMPANY_FONT, NSForegroundColorAttributeName:LABEL_COMPANY_COLOR}]];
    
    _labelTitle.attributedText = title;
    
    
    
}

@end
