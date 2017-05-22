//
//  ProjectListCVCell.m
//  lecet
//
//  Created by Michael San Minay on 30/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectListCVCell.h"

#define DROPDOWN_PROJECTLISTCELL_BUTTON_FONT_COLOR             RGB(72, 72, 72)
#define DROPDOWN_PROJECTLISTCELL_BUTTON_FONT                   fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 13)

#define DROPDOWN_PROJECTLISTCELL_LABEL_FONT                    fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define DROPDOWN_PROJECTLIST_LABEL_FONT_COLOR                  RGB(136, 136, 136)

@interface ProjectListCVCell ()
@end

@implementation ProjectListCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBackgroundColor:[UIColor whiteColor]];
    _buttonProjectTrackList.titleLabel.font = DROPDOWN_PROJECTLISTCELL_BUTTON_FONT;
    [_buttonProjectTrackList setTitleColor:DROPDOWN_PROJECTLISTCELL_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    
    _labelNumberOfProject.textColor = DROPDOWN_PROJECTLIST_LABEL_FONT_COLOR;
    _labelNumberOfProject.font = DROPDOWN_PROJECTLISTCELL_LABEL_FONT;
}
@end
