//
//  NewTrackingListCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 10/4/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "NewTrackingListCollectionViewCell.h"

#define labelFont                         fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define labelColor                        RGB(255, 255, 255)

#define colorCellBackground                   RGB(248, 153, 0)

@implementation NewTrackingListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labelTitle.font = labelFont;
    self.labelTitle.textColor = labelColor;
    self.contentView.backgroundColor = colorCellBackground;
}
- (IBAction)tappedButtonTrack:(id)sender {
    if(self.newtrackingListCollectionViewCellDelegate) {
        [self.newtrackingListCollectionViewCellDelegate didTappedNewTrackingList:self];
    }
}

@end
