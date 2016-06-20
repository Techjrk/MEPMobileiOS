//
//  CompanySortCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 19/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanySortCollectionViewCell.h"
#import "companySortViewCellConstant.h"

@interface CompanySortCollectionViewCell() {
    
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end

@implementation CompanySortCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _labelTitle.font = COMPANYSORTVC_LABEL_FONT;
    _labelTitle.textColor = COMPANYSORTVC_LABEL_FONT_COLOR;
}

- (void)setLabelTitleText:(NSString *)text {
    _labelTitle.text = text;
}

@end
