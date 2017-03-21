//
//  MobileProjectAddNoteViewController.m
//  lecet
//
//  Created by Michael San Minay on 09/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "MobileProjectAddNoteViewController.h"
#import "MobileProjectNotePopUpViewController.h"

#pragma mark - FONT
#define FONT_NAV_TITLE_LABEL            fontNameWithSize(FONT_NAME_LATO_BOLD, 10)
#define FONT_TILE                       fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define FONT_NAV_BUTTON                 fontNameWithSize(FONT_NAME_LATO_BOLD, 14)

#pragma mark - COLOR
#define COLOR_FONT_NAV_TITLE_LABEL      RGB(184,184,184)
#define COLOR_BG_NAV_VIEW               RGB(5, 35, 74)
#define COLOR_FONT_TILE                 RGB(8, 73, 124)
#define COLOR_BORDER_TEXTVIEW           RGB(0, 0, 0)
#define COLOR_FONT_NAV_BUTTON           RGB(168,195,230)

@interface MobileProjectAddNoteViewController ()<UITextViewDelegate,UITextFieldDelegate,MobileProjectNotePopUpViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *postTitleTextField;
@property (weak, nonatomic) IBOutlet UILabel *postTitleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIView *bodyViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTextViewHeight;
@property (weak, nonatomic) IBOutlet UIView *containerCapturedImage;
@property (weak, nonatomic) IBOutlet UIButton *trashcanButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightContainerCapturedImage;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImageView;

@end

@implementation MobileProjectAddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navView.backgroundColor = COLOR_BG_NAV_VIEW;
    
    self.navTitleLabel.text = NSLocalizedLanguage(@"MPANV_NAV_TITLE");
    self.navTitleLabel.font = FONT_NAV_TITLE_LABEL;
    self.navTitleLabel.textColor = COLOR_FONT_NAV_TITLE_LABEL;
    
    [self.cancelButton setTitle:NSLocalizedLanguage(@"MPANV_NAV_CANCEL") forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:COLOR_FONT_NAV_BUTTON forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = FONT_NAV_BUTTON;
    
    [self.addButton setTitle:NSLocalizedLanguage(@"MPANV_NAV_ADD") forState:UIControlStateNormal];
    [self.addButton setTitleColor:COLOR_FONT_NAV_BUTTON forState:UIControlStateNormal];
    self.addButton.titleLabel.font = FONT_NAV_BUTTON;
    
    
    self.postTitleLabel.text = NSLocalizedLanguage(@"MPANV_POST_TITLE");
    self.postTitleLabel.font = FONT_TILE;
    self.postTitleLabel.textColor = COLOR_FONT_TILE;
    
    self.postTitleTextField.placeholder = NSLocalizedLanguage(@"MPANV_POST_TITLE_PLACEHOLDER");
    self.postTitleTextField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    self.postTitleTextField.layer.borderWidth = 0.5f;
    self.postTitleTextField.leftView = [self paddingView];
    self.postTitleTextField.leftViewMode = UITextFieldViewModeAlways;
    
    NSString *countText = NSLocalizedLanguage(@"MPANV_POST_TITLE_COUNT");
    self.postTitleCountLabel.text = [NSString stringWithFormat:countText,self.postTitleTextField.text.length];
    
    self.bodyTitleLabel.text = NSLocalizedLanguage(@"MPANV_BODY_TITLE");
    self.bodyTitleLabel.font = FONT_TILE;
    self.bodyTitleLabel.textColor = COLOR_FONT_TILE;
    
    self.bodyTextView.text = NSLocalizedLanguage(@"MPANV_BODY_PLACEHOLDER");
    self.bodyTextView.textColor = [UIColor lightGrayColor];
    self.bodyTextView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    self.bodyTextView.layer.borderWidth = 0.5f;
    
    self.footerLabel.text = NSLocalizedLanguage(@"MPANV_FOOTER_TILE");
    self.bodyViewContainer.backgroundColor = [UIColor clearColor];
    
    [self updateHeighForBodyTextEndEditing];
    self.constraintHeightContainerCapturedImage.constant = self.isAddPhoto ? kDeviceHeight * 0.15 :0;
    
    [self.postTitleTextField addTarget:self action:@selector(onEditing:) forControlEvents:UIControlEventEditingChanged];
    
    self.addButton.userInteractionEnabled = NO;
    self.capturedImageView.contentMode = UIViewContentModeScaleToFill;
    self.capturedImageView.image = self.capturedImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)tappedCancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tappedAddButton:(id)sender {
    if (self.isAddPhoto) {
        [self.loadingIndicator startAnimating];
        [[DataManager sharedManager] addProjectUserImage:self.projectID title:self.postTitleTextField.text text:self.bodyTextView.text image:self.capturedImage success:^(id object){
            [self.loadingIndicator stopAnimating];
            [self.navigationController popViewControllerAnimated:YES];
        }failure:^(id fail){
            [self.loadingIndicator stopAnimating];
            NSLog(@"Failed request");
        }];
    } else {
        MobileProjectNotePopUpViewController *controller = [MobileProjectNotePopUpViewController new];
        controller.mobileProjectNotePopUpViewControllerDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}
- (IBAction)tappedTrashcanButton:(id)sender {
    self.capturedImageView.image = nil;
    self.capturedImage = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - misc
- (UIView *)paddingView {
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth * 0.017, kDeviceHeight * 0.025)];
    return paddingView;
}

- (void)updateHeighForBodyTextEndEditing {
    self.constraintTextViewHeight.constant = kDeviceHeight * (self.isAddPhoto? 0.4:0.6);
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.constraintTextViewHeight.constant = kDeviceHeight * 0.25;
        [self.view layoutIfNeeded];
    }completion:^(BOOL fin){
        
    }];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        [self updateHeighForBodyTextEndEditing];
        [self.view layoutIfNeeded];
    }completion:^(BOOL fin){
        if (fin) {
            NSString *stripSpaceString = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (stripSpaceString.length == 0) {
                textView.text = NSLocalizedLanguage(@"MPANV_BODY_PLACEHOLDER");
                textView.textColor = [UIColor lightGrayColor];
            }
        }
    }];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.constraintTextViewHeight.constant = kDeviceHeight * 0.25;
        [self.view layoutIfNeeded];
    }completion:^(BOOL fin){
        
    }];

    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.5 animations:^{
        [self updateHeighForBodyTextEndEditing];
        [self.view layoutIfNeeded];
    }completion:^(BOOL fin){
        
    }];
}

-(void)onEditing:(id)sender {
    NSString *countText = NSLocalizedLanguage(@"MPANV_POST_TITLE_COUNT");
    self.postTitleCountLabel.text = [NSString stringWithFormat:countText,self.postTitleTextField.text.length];
    
    NSString *stripString = [self.postTitleTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (stripString.length > 0) {
        self.addButton.userInteractionEnabled = YES;
    } else {
        self.addButton.userInteractionEnabled = NO;
    }
    
}

#pragma mark - MobileProjectNotePopUpViewControllerDelegate

- (void)tappedPostNoteButton {
    [self.loadingIndicator startAnimating];
    NSDictionary *dic = @{@"public":@(YES),@"title":self.postTitleTextField.text,@"text":self.bodyTextView.text};
    [[DataManager sharedManager] addProjectUserNotes:self.projectID parameter:dic success:^(id object){
        [self.loadingIndicator stopAnimating];
        [self.mobileProjectAddNoteViewControllerDelegate tappedUpdateUserNotes];
        [self.navigationController popViewControllerAnimated:YES];
    }failure:^(id object){
        [self.loadingIndicator stopAnimating];
        NSLog(@"Failed request");
    }];
}

- (void)tappedDismissedPostNote {
    
}

@end
