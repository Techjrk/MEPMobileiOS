//
//  CompanySortCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 19/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanySortCollectionViewCell.h"

@interface CompanySortCollectionViewCell() {
    
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end

@implementation CompanySortCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLabelTitleText:(NSString *)text {
    _labelTitle.text = text;
}

@end
