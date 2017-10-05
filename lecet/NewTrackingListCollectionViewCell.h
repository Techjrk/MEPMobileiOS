//
//  NewTrackingListCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 10/4/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewTrackingListCollectionViewCellDelegate
- (void) didTappedNewTrackingList:(id)sender;
@end

@interface NewTrackingListCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) id<NewTrackingListCollectionViewCellDelegate>newtrackingListCollectionViewCellDelegate;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
