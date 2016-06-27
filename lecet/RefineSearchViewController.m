//
//  RefineSearchViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/27/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "RefineSearchViewController.h"

#import "ProjectFilterView.h"

#define TITLE_FONT                          fontNameWithSize(FONT_NAME_LATO_REGULAR, 14)
#define TITLE_COLOR                         RGB(255, 255, 255)

#define BUTTON_FILTER_FONT                  fontNameWithSize(FONT_NAME_LATO_SEMIBOLD, 14)
#define BUTTON_FILTER_COLOR                 RGB(168, 195, 230)

@interface RefineSearchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonApply;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet ProjectFilterView *projectFilter;
@property (weak, nonatomic) IBOutlet UIScrollView *projectScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintProjectFilterHeight;
- (IBAction)tappedButtonCancel:(id)sender;
- (IBAction)tappedButtonApply:(id)sender;
@end

@implementation RefineSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_buttonCancel setTitleColor:BUTTON_FILTER_COLOR forState:UIControlStateNormal];
    _buttonCancel.titleLabel.font = BUTTON_FILTER_FONT;
    [_buttonCancel setTitle:NSLocalizedLanguage(@"REFINE_FILTER_CANCEL") forState:UIControlStateNormal];
    
    [_buttonApply setTitleColor:BUTTON_FILTER_COLOR forState:UIControlStateNormal];
    _buttonApply.titleLabel.font = BUTTON_FILTER_FONT;
    [_buttonApply setTitle:NSLocalizedLanguage(@"REFINE_FILTER_APPLY") forState:UIControlStateNormal];
    
    _labelTitle.font = TITLE_FONT;
    _labelTitle.textColor = TITLE_COLOR;
    _labelTitle.text = NSLocalizedLanguage(@"REFINE_FILTER_TITLE");
    
    [_projectFilter setConstraint:_constraintProjectFilterHeight];
    _projectFilter.scrollView = _projectScrollView;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (IBAction)tappedButtonCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tappedButtonApply:(id)sender {
    [[DataManager sharedManager] featureNotAvailable];
}

@end
