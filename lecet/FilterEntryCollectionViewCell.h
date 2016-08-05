//
//  FilterEntryCollectionViewCell.h
//  lecet
//
//  Created by Michael San Minay on 04/08/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterEntryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
- (void)setLabelAttributedText:(id)attriText;
@end
