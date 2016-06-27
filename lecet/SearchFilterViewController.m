//
//  SearchFilterViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SearchFilterViewController.h"

#import "ProjectFilterView.h"
#import "CompanyFilterView.h"

#define TITLE_FONT                          fontNameWithSize(FONT_NAME_LATO_REGULAR, 14)
#define TITLE_COLOR                         RGB(255, 255, 255)

#define BUTTON_FILTER_FONT                  fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 14)
#define BUTTON_FILTER_COLOR                 RGB(168, 195, 230)

#define BUTTON_FONT                         fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 11)
#define BUTTON_COLOR                        RGB(255, 255, 255)
#define BUTTON_MARKER_COLOR                 RGB(248, 152, 28)

#define TOP_HEADER_BG_COLOR                 RGB(5, 35, 74)

@interface SearchFilterViewController ()
@property (weak, nonatomic) IBOutlet UIView *topHeader;
@property (weak, nonatomic) IBOutlet UIView *markerView;
@property (weak, nonatomic) IBOutlet UIButton *buttonProject;
@property (weak, nonatomic) IBOutlet UIButton *buttonCompany;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonApply;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet ProjectFilterView *projectFilter;
@property (weak, nonatomic) IBOutlet UIScrollView *projectScrollView;
@property (weak, nonatomic) IBOutlet CompanyFilterView *companyFilter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintMarkerLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintProjectFilterHeight;
- (IBAction)tappedButton:(id)sender;
- (IBAction)tappedButtonCancel:(id)sender;
- (IBAction)tappedButtonApply:(id)sender;
@end

@implementation SearchFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topHeader.backgroundColor = TOP_HEADER_BG_COLOR;
    _markerView.backgroundColor = BUTTON_MARKER_COLOR;
    
    _buttonProject.titleLabel.font = BUTTON_FONT;
    [_buttonProject setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [_buttonProject setTitle:NSLocalizedLanguage(@"SEARCH_FILTER_PROJECT") forState:UIControlStateNormal];

    _buttonCompany.titleLabel.font = BUTTON_FONT;
    [_buttonCompany setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
    [_buttonCompany setTitle:NSLocalizedLanguage(@"SEARCH_FILTER_COMPANY") forState:UIControlStateNormal];

    [_buttonCancel setTitleColor:BUTTON_FILTER_COLOR forState:UIControlStateNormal];
    _buttonCancel.titleLabel.font = BUTTON_FILTER_FONT;
    [_buttonCancel setTitle:NSLocalizedLanguage(@"SEARCH_FILTER_CANCEL") forState:UIControlStateNormal];


    [_buttonApply setTitleColor:BUTTON_FILTER_COLOR forState:UIControlStateNormal];
    _buttonApply.titleLabel.font = BUTTON_FILTER_FONT;
    [_buttonApply setTitle:NSLocalizedLanguage(@"SEARCH_FILTER_APPLY") forState:UIControlStateNormal];

    
    _labelTitle.font = TITLE_FONT;
    _labelTitle.textColor = TITLE_COLOR;
    _labelTitle.text = NSLocalizedLanguage(@"SEARCH_FILTER_TITLE");
    
    [_projectFilter setConstraint:_constraintProjectFilterHeight];
    _projectFilter.scrollView = _projectScrollView;
    

    _companyFilter.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return  UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}


- (IBAction)tappedButton:(id)sender {
    UIButton *button = sender;

    _constraintMarkerLeading.constant = button.frame.origin.x;
    
    
    [UIView animateWithDuration:0.25 animations:^{
    
        [self.view layoutIfNeeded];
    
    } completion:^(BOOL finished) {
        
        if (finished) {
            _projectScrollView.hidden = _constraintMarkerLeading.constant != 0;
            _companyFilter.hidden = !_projectScrollView.hidden;
        }
    }];
    
}

- (IBAction)tappedButtonCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)tappedButtonApply:(id)sender {
}
@end
