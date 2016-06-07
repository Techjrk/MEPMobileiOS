//
//  ContactNavBarView.m
//  lecet
//
//  Created by Michael San Minay on 04/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactNavBarView.h"
#import "contactNavBarConstant.h"

@interface ContactNavBarView ()
@property (weak, nonatomic) IBOutlet UILabel *labelContactTitle;

@end

@implementation ContactNavBarView


- (void)awakeFromNib {
    
    _labelContactTitle.font = CONTACT_NAV_TITLE_LABEL_FONT;
    _labelContactTitle.textColor = CONTACT_NAV_TITLE_LABEL_FONT_COLOR;
    [self.view setBackgroundColor:CONTACT_NAV_VIEW_BG_COLOR];
}
- (IBAction)tappedBackButton:(id)sender {
    [_contactNavViewDelegate tappedContactNavBackButton];
}

- (void)setNameTitle:(NSString *)name {
    _labelContactTitle.text = name;
}

@end
