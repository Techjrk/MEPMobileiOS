//
//  FilterEntryView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "FilterEntryView.h"

#import "CustomTitleLabel.h"

@interface FilterEntryView()
@property (weak, nonatomic) IBOutlet CustomTitleLabel *labelTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)tappedButton:(id)sender;
@end

@implementation FilterEntryView

- (void)awakeFromNib {
    [super awakeFromNib];

    _collectionView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    _collectionView.layer.borderWidth = 1.0;
}

- (void)setTitle:(NSString *)title {
    _labelTitle.text = title;
}

- (IBAction)tappedButton:(id)sender {
    [self.filterEntryViewDelegate tappedFilterEntryViewDelegate:self];
}

@end
