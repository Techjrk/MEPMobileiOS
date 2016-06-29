//
//  SearchSavedCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchSavedCollectionViewCell.h"

#define LABEL_TITLE_FONT                        fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_TITLE_COLOR                       RGB(34, 34, 34)

#define LABEL_STATUS_FONT                       fontNameWithSize(FONT_NAME_LATO_BOLD, 9)
#define LABEL_STATUS_COLOR                      RGB(159, 164, 166)

#define LABEL_CARET_FONT                        fontNameWithSize(FONT_NAME_AWESOME, 22)
#define LABEL_CARET_COLOR                       RGB(34, 34, 34)
#define LABEL_CARET_TEXT                        [NSString stringWithFormat:@"%C", 0xf105]

@interface SearchSavedCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *labelChevron;
@end

@implementation SearchSavedCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _labelTitle.font = LABEL_TITLE_FONT;
    _labelTitle.textColor = LABEL_TITLE_COLOR;
    
    _labelStatus.font = LABEL_STATUS_FONT;
    _labelStatus.textColor = LABEL_STATUS_COLOR;
    
    _lineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    
    _labelChevron.font = LABEL_CARET_FONT;
    _labelChevron.textColor = LABEL_CARET_COLOR;
    _labelChevron.text = LABEL_CARET_TEXT;
    
}

- (void)setInfo:(id)info {
    
    NSDictionary *item = info;
    _labelTitle.text = item[@"title"];
    
}

@end
