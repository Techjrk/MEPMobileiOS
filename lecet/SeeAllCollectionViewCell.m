//
//  SeeAllCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SeeAllCollectionViewCell.h"

#define TITLE_FONT                  fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 12)
#define TITLE_COLOR                 RGB(121, 120, 120)

@interface SeeAllCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
- (IBAction)tappedButton:(id)sender;
@end

@implementation SeeAllCollectionViewCell
@synthesize seeAllCollectionViewCellDelegate;
@synthesize indexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _labelTitle.font = TITLE_FONT;
    _labelTitle.textColor = TITLE_COLOR;
    
}

- (void)setTitle:(NSString *)title {
    _labelTitle.text = title;
}

- (IBAction)tappedButton:(id)sender {
    
    [self.seeAllCollectionViewCellDelegate tappedSectionFooter:self];
}
@end
