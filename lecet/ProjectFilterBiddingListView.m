//
//  ProjectFilterBiddingListView.m
//  lecet
//
//  Created by Michael San Minay on 23/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterBiddingListView.h"
#import "ProjectFilterBiddingCollectionViewCell.h"

@interface ProjectFilterBiddingListView (){
    NSMutableArray *collectionDataItems;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ProjectFilterBiddingListView
#define kCellIdentifier             @"kCellIdentifier"

- (void)awakeFromNib {
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectFilterBiddingCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.showsVerticalScrollIndicator = NO;
}

@end
