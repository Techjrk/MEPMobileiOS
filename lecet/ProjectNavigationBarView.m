//
//  ProjectNavigationBarView.m
//  lecet
//
//  Created by Michael San Minay on 03/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectNavigationBarView.h"

#define PRODJECT_NAV_CONTRACTOR_LABEL_FONT              fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 14)
#define PRODJECT_NAV_CONTRACTOR_LABEL_FONT_COLOR        RGB(255,255,255)

#define PRODJECT_NAV_PROJECTTITLE_LABEL_FONT            fontNameWithSize(FONT_NAME_LATO_BOLD, 10)
#define PRODJECT_NAV_PROJECTTITLE_LABEL_FONT_COLOR      RGB(184,184,184)

@interface ProjectNavigationBarView ()
@property (weak, nonatomic) IBOutlet UILabel *labelContractorName;
@property (weak, nonatomic) IBOutlet UILabel *labelProjectTitle;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *reOrderButton;
@end

@implementation ProjectNavigationBarView

-(void)awakeFromNib{
    
    _labelContractorName.font = PRODJECT_NAV_CONTRACTOR_LABEL_FONT;
    _labelContractorName.textColor = PRODJECT_NAV_CONTRACTOR_LABEL_FONT_COLOR;
    
    _labelProjectTitle.font = PRODJECT_NAV_PROJECTTITLE_LABEL_FONT;
    _labelProjectTitle.textColor = PRODJECT_NAV_PROJECTTITLE_LABEL_FONT_COLOR;
    
    _labelContractorName.numberOfLines = 0;
    _labelProjectTitle.numberOfLines = 0;
    _labelContractorName.adjustsFontSizeToFitWidth = YES;
    
    _backButton.tag = ProjectNavBackButton;
    _reOrderButton.tag = ProjectNavReOrder;
    
}

- (void)setContractorName:(NSString *)contractorName {
    _labelContractorName.text = contractorName;
    
}

- (void)setProjectTitle:(NSString *)projectTitle {
    _labelProjectTitle.text = projectTitle;
}

- (IBAction)tappedNavButton:(id)sender {
    UIButton *button = sender;
    [_projectNavViewDelegate tappedProjectNav:(ProjectNavItem)button.tag];
}

- (void)hideReorderButton:(BOOL)hidden {
    _reOrderButton.hidden = hidden;
}

- (UIView*)reOrderButton {

    return _reOrderButton;

}

@end
