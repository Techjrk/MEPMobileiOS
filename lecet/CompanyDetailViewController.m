//
//  CompanyDetailViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CompanyDetailViewController.h"

#import "companyDetailsConstants.h"
#import "companyHeaderConstants.h"
#import "CompanyHeaderView.h"
#import "CustomEntryField.h"

@interface CompanyDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentHeight;
@property (weak, nonatomic) IBOutlet CompanyHeaderView *companyHeader;
@property (weak, nonatomic) IBOutlet CustomEntryField *fieldAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldAddress;

@end

@implementation CompanyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _containerView.backgroundColor = COMPANY_DETAIL_CONTAINER_BG_COLOR;
    
    [_fieldAddress changeConstraintHeight:_constraintFieldAddress];
    
    [_fieldAddress setTitle:NSLocalizedLanguage(@"COMPANY_DETAIL_ADDRESS") line1Text:@"38881 Schoolcraft Rd\nLivonia, MI 48150-1033" line2Text:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)setInfo:(id)info {
    
}

@end
