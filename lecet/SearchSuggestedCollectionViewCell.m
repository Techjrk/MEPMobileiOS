//
//  SearchSuggestedCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchSuggestedCollectionViewCell.h"

@interface SearchSuggestedCollectionViewCell()

#define LABEL_TITLE_FONT_REGULAR                fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define LABEL_TITLE_FONT_BOLD                   fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define LABEL_TITLE_COLOR                       RGB(34, 34, 34)

#define LABEL_COUNT_FONT                        fontNameWithSize(FONT_NAME_LATO_BOLD, 9)
#define LABEL_COUNT_COLOR                       RGB(159, 164, 166)

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
@implementation SearchSuggestedCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _labelCount.font = LABEL_COUNT_FONT;
    _labelCount.textColor = LABEL_COUNT_COLOR;
    
    _lineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
}

- (void)setInfo:(NSString *)title count:(NSInteger)count headerType:(SearchSuggestedHeader)headerType {

    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:[title stringByAppendingString:@" "] attributes:@{NSFontAttributeName:LABEL_TITLE_FONT_REGULAR, NSForegroundColorAttributeName:LABEL_TITLE_COLOR}];
    
    NSString *appendedString = @"";
    NSString *countString = @"";
  
    switch (headerType) {
    
        case SearchSuggestedHeaderProject: {
            appendedString = NSLocalizedLanguage(@"SEARCH_SUGGEST_HEADER_PROJECT");
            countString = NSLocalizedLanguage(count<=1?@"SEARCH_SUGGEST_COUNT_PROJECT":@"SEARCH_SUGGEST_COUNT_PROJECTS");
            break;
        }
   
        case SearchSuggestedHeaderCompany: {
            appendedString = NSLocalizedLanguage(@"SEARCH_SUGGEST_HEADER_COMPANY");
            countString = NSLocalizedLanguage(count<=1?@"SEARCH_SUGGEST_COUNT_COMPANY":@"SEARCH_SUGGEST_COUNT_COMPANIES");
            break;
        }
            
        case SearchSuggestedHeaderContact: {
            appendedString = NSLocalizedLanguage(@"SEARCH_SUGGEST_HEADER_CONTACT");
            countString = NSLocalizedLanguage(count<=1?@"SEARCH_SUGGEST_COUNT_CONTACT":@"SEARCH_SUGGEST_COUNT_CONTACTS");
            break;
        }
            
    }
    
    [titleString appendAttributedString:[[NSAttributedString alloc] initWithString:appendedString attributes:@{NSFontAttributeName:LABEL_TITLE_FONT_BOLD, NSForegroundColorAttributeName:LABEL_TITLE_COLOR}]];
    _labelTitle.attributedText = titleString;
    
    _labelCount.text = [NSString stringWithFormat:countString, count];
    
}

@end
