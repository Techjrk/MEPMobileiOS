//
//  DropDownProjectList.m
//  lecet
//
//  Created by Get Devs on 20/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DropDownProjectList.h"
#import "dropDownProjectListConstant.h"


@interface DropDownProjectList ()
@property (weak, nonatomic) IBOutlet UIButton *buttonTrainAndMetros;
@property (weak, nonatomic) IBOutlet UIButton *buttonRailways;
@property (weak, nonatomic) IBOutlet UIButton *buttonAnotherList;
@property (weak, nonatomic) IBOutlet UIButton *buttonHighValues;



@property (weak, nonatomic) IBOutlet UILabel *labelSelecTracking;
@property (weak, nonatomic) IBOutlet UIView *selectTrackingListView;




@end

@implementation DropDownProjectList


- (void)awakeFromNib{
    _buttonTrainAndMetros.tag =DropDownProjectTrainAndMetros;
    _buttonRailways.tag  = DropDownProjectRailways;
    _buttonAnotherList.tag = DropDownProjectAnotherList;
    _buttonHighValues.tag = DropDownProjectHighValues;
    
    _buttonTrainAndMetros.titleLabel.font = DROPDOWN_PROJECTLIST_BUTTON_TRAINANDMETROS_FONT;
    _buttonRailways.titleLabel.font = DROPDOWN_PROJECTLIST_BUTTON_RAILWAYS_FONT;
    _buttonAnotherList.titleLabel.font = DROPDOWN_PROJECTLIST_BUTTON_ANOTHERLIST_FONT;
    _buttonHighValues.titleLabel.font = DROPDOWN_PROJECTLIST_BUTTON_HIGHVALUES_FONT;
    
    
    [_buttonTrainAndMetros setTitleColor:DROPDOWN_PROJECTLIST_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    [_buttonRailways setTitleColor:DROPDOWN_PROJECTLIST_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    [_buttonAnotherList setTitleColor:DROPDOWN_PROJECTLIST_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    [_buttonHighValues setTitleColor:DROPDOWN_PROJECTLIST_BUTTON_FONT_COLOR forState:UIControlStateNormal];
    
    
    _labelNumberOfProjectsTrainsAndMetros.font = DROPDOWN_PROJECTLIST_LABEL_TRAINANDMETROS_FONT;
    _labelNumberOfProjectsRailways.font = DROPDOWN_PROJECTLIST_LABEL_RAILWAYS_FONT;
    _labelNumberOfProjectsAnotherList.font = DROPDOWN_PROJECTLIST_BUTTON_ANOTHERLIST_FONT;
    _labelNumberOfProjectHighValues.font = DROPDOWN_PROJECTLIST_BUTTON_HIGHVALUES_FONT;
    _labelSelecTracking.font = DROPDOWN_PROJECTLIST_LABEL_SELECTTRACKING_FONT;
    
    
    _labelNumberOfProjectsTrainsAndMetros.textColor = DROPDOWN_PROJECTLIST_LABEL_FONT_COLOR;
    _labelNumberOfProjectsRailways.textColor = DROPDOWN_PROJECTLIST_LABEL_FONT_COLOR;
    _labelNumberOfProjectsAnotherList.textColor = DROPDOWN_PROJECTLIST_LABEL_FONT_COLOR;
    _labelNumberOfProjectHighValues.textColor = DROPDOWN_PROJECTLIST_LABEL_FONT_COLOR;
    
    
    
    
    
    [_buttonTrainAndMetros setTitle:NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_TRAINANDMETROS_BUTTON_TEXT") forState:UIControlStateNormal];
    [_buttonRailways setTitle:NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_RAILWAYS_BUTTON_TEXT") forState:UIControlStateNormal];
    [_buttonAnotherList setTitle:NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_ANOTHERLIST_BUTTON_TEXT") forState:UIControlStateNormal];
    [_buttonHighValues setTitle:NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_HIGHVALUES_BUTTON_TEXT") forState:UIControlStateNormal];
    
    _labelSelecTracking.text = NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_TITLE_TRACKING_LABEL_TEXT");
    
    
    _selectTrackingListView.backgroundColor = DROPDOWN_PROJECTLIST_VIEW_SELECTTRACKINGLIST_BG_COLOR;
    
    
    [self drawTopTriangle];
    
    [self drawShadow];
    
}


- (void)drawTopTriangle{
    
    //Screen Size for Y axiz
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    int height = 0;
    float width = (screenWidth * 0.25f) - 30;
    int triangleTopDirection = -1;
    
    int triangleSize =  9;
    
    UIColor *bgColor = DROPDOWN_PROJECTLIST_VIEW_SELECTTRACKINGLIST_BG_COLOR;
    CAShapeLayer *triangleTop = [[Utilities sharedIntances] drawDropDownTopTriangle:width backgroundColor:bgColor triangleTopDirection:triangleTopDirection heightPlacement:height sizeOfTriangle:triangleSize];
    
    [self.layer insertSublayer:triangleTop atIndex:1];
    
}




- (void)drawShadow{
    CGRect screenRect = self.bounds;
    
    CGRect customDimRect = screenRect;

    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:customDimRect];

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
    

    [self.view.layer setCornerRadius:5.0f];
    
    
}

- (IBAction)tappedDropDownProjectList:(id)sender{
    
    UIButton *button = sender;
    [_dropDownProjectListDelegate tappedDropDownProjectList:(DropDownProjectListItem)button.tag];
    
}





@end
