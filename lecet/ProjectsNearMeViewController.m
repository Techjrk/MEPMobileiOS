//
//  ProjectsNearMeViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/3/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectsNearMeViewController.h"

#import "projectsNearMeConstants.h"

@interface ProjectsNearMeViewController ()
@property (weak, nonatomic) IBOutlet UIView *topHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
- (IBAction)tappedButtonback:(id)sender;
@end

@implementation ProjectsNearMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableTapGesture:YES];
    
    _textFieldSearch.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    _textFieldSearch.layer.cornerRadius = kDeviceWidth * 0.0106;
    _textFieldSearch.layer.masksToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_searchTextField"]];
    imageView.frame = CGRectMake(0, 0, kDeviceWidth * 0.1, kDeviceHeight * 0.025);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _textFieldSearch.leftView = imageView;
    _textFieldSearch.leftViewMode = UITextFieldViewModeAlways;
    _textFieldSearch.textColor = [UIColor whiteColor];
    _textFieldSearch.font = PROJECTS_TEXTFIELD_TEXT_FONT;
    [_textFieldSearch setTintColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedButtonback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
