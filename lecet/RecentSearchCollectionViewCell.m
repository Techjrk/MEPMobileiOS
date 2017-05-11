//
//  RecentSearchCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "RecentSearchCollectionViewCell.h"
#import "RecentSearchView.h"

@interface RecentSearchCollectionViewCell () <RecentSearchViewDelegate>
@property (weak, nonatomic) IBOutlet RecentSearchView *recentSearchView;

@end

@implementation RecentSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.recentSearchView.recentSearchViewDelegate = self;
    
}

- (void)setInfo:(id)info {
    
}

#pragma mark - RecentSearchViewDelegate

- (void)tappedRecentSearch {
    [self.recentSearchCollectionViewCellDelegate tappedRecentSearchView];
}

- (void)endRequestRecentSearch {
    [self.recentSearchCollectionViewCellDelegate endRequestRecentSearchView];
}

@end
