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
#define FONT_NAV_TITLE_LABEL                fontNameWithSize(FONT_NAME_LATO_BOLD, 10)
#define FONT_TILE                           fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define FONT_TITLE_SECOND_LABEL             fontNameWithSize(FONT_NAME_LATO_ITALIC, 9)
#define FONT_NAV_BUTTON                     fontNameWithSize(FONT_NAME_LATO_BOLD, 14)

#pragma mark - COLOR
#define COLOR_FONT_NAV_TITLE_LABEL          RGB(184,184,184)
#define COLOR_BG_NAV_VIEW                   RGB(5, 35, 74)
#define COLOR_FONT_TILE                     RGB(8, 73, 124)
#define COLOR_FONT_TITLE_SECOND_LABEL       RGB(34,34,34)
#define COLOR_BORDER_TEXTVIEW               RGB(0, 0, 0)
#define COLOR_FONT_NAV_BUTTON               RGB(168,195,230)

@interface MobileProjectAddNoteViewController ()<UITextViewDelegate,UITextFieldDelegate,MobileProjectNotePopUpViewControllerDelegate>{
    CGFloat defaultBodyTextViewHeight;
}
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
    self.navTitleLabel.text = self.isAddPhoto?NSLocalizedLanguage(@"MPANV_NAV_PHOTO_TITLE"): NSLocalizedLanguage(@"MPANV_NAV_TITLE");
    self.navTitleLabel.font = FONT_NAV_TITLE_LABEL;
    self.navTitleLabel.textColor = COLOR_FONT_NAV_TITLE_LABEL;
    
    [self.cancelButton setTitle:NSLocalizedLanguage(@"MPANV_NAV_CANCEL") forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:COLOR_FONT_NAV_BUTTON forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = FONT_NAV_BUTTON;
    
    [self.addButton setTitle:NSLocalizedLanguage(@"MPANV_NAV_ADD") forState:UIControlStateNormal];
    [self.addButton setTitleColor:COLOR_FONT_NAV_BUTTON forState:UIControlStateNormal];
    self.addButton.titleLabel.font = FONT_NAV_BUTTON;
    
    self.postTitleLabel.attributedText = [self addLabelInTitle:NSLocalizedLanguage(@"MPANV_POST_TITLE") label:NSLocalizedLanguage(@"MPANV_POST_TITLE_DES")];
    self.postTitleTextField.placeholder = NSLocalizedLanguage(@"MPANV_POST_TITLE_PLACEHOLDER");
    self.postTitleTextField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    self.postTitleTextField.layer.borderWidth = 0.5f;
    self.postTitleTextField.leftView = [self paddingView];
    self.postTitleTextField.leftViewMode = UITextFieldViewModeAlways;
    
    NSString *countText = NSLocalizedLanguage(@"MPANV_POST_TITLE_COUNT");
    self.postTitleCountLabel.text = [NSString stringWithFormat:countText,self.postTitleTextField.text.length];
    
    if (self.isAddPhoto) {
        self.bodyTitleLabel.attributedText = [self addLabelInTitle:NSLocalizedLanguage(@"MPANV_BODY_TITLE") label:NSLocalizedLanguage(@"MPANV_POST_TITLE_DES")];
    } else {
        self.bodyTitleLabel.attributedText = [self addLabelInTitle:NSLocalizedLanguage(@"MPANV_BODY_TITLE") label:@""];
    }
    
    [self bodyTextView];
    self.bodyTextView.textColor = [UIColor lightGrayColor];
    self.bodyTextView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    self.bodyTextView.layer.borderWidth = 0.5f;
    
    self.footerLabel.text = NSLocalizedLanguage(@"MPANV_FOOTER_TILE");
    self.bodyViewContainer.backgroundColor = [UIColor clearColor];
    
    [self updateHeighForBodyTextEndEditing];
    defaultBodyTextViewHeight = self.constraintTextViewHeight.constant;
    
    self.constraintHeightContainerCapturedImage.constant = self.isAddPhoto ? kDeviceHeight * 0.15 :0;
    
    [self.postTitleTextField addTarget:self action:@selector(onEditing:) forControlEvents:UIControlEventEditingChanged];
    
    self.addButton.userInteractionEnabled = NO;
    self.capturedImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.capturedImageView.image = self.capturedImage;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
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

- (void)bodyTextViewPlaceHolder {
    if (self.isAddPhoto) {
        self.bodyTextView.attributedText = [self addLabelInTitle:NSLocalizedLanguage(@"MPANV_BODY_PLACEHOLDER") label:NSLocalizedLanguage(@"MPANV_POST_TITLE_DES")];
    } else {
        self.bodyTextView.text = NSLocalizedLanguage(@"MPANV_BODY_PLACEHOLDER");
    }
}

- (NSAttributedString *)addLabelInTitle:(NSString *)title label:(NSString *)lText {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",title]  attributes:@{NSFontAttributeName: FONT_TILE, NSForegroundColorAttributeName: COLOR_FONT_TILE}];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:lText attributes:@{NSFontAttributeName: FONT_TITLE_SECOND_LABEL, NSForegroundColorAttributeName: [COLOR_FONT_TITLE_SECOND_LABEL colorWithAlphaComponent:0.5]}]];

    return [attributedString copy];
}

- (NSString *)stripStringAndToLowerCaser:(NSString *)text {
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [text lowercaseString];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    /*
    if (!isKeyboardShown) {
        [UIView animateWithDuration:0.5 animations:^{
            self.constraintTextViewHeight.constant = kDeviceHeight * 0.25;
            [self.view layoutIfNeeded];
        }completion:^(BOOL fin){
            isKeyboardShown = YES;
        }];
    }
    */
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    /*
    if (isKeyboardShown) {
        [UIView animateWithDuration:0.5 animations:^{
            [self updateHeighForBodyTextEndEditing];
            [self.view layoutIfNeeded];
        }completion:^(BOOL fin){
            if (fin) {
                NSString *stripSpaceString = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (stripSpaceString.length == 0) {
                    [self bodyTextViewPlaceHolder];
                    textView.textColor = [UIColor lightGrayColor];
                }
                isKeyboardShown = NO;
            }
        }];
    }
    */
}

- (void)textViewDidChange:(UITextView *)textView {
    
    NSString *placeHolder = [NSString stringWithFormat:@"%@ %@",NSLocalizedLanguage(@"MPANV_BODY_PLACEHOLDER"),NSLocalizedLanguage(@"MPANV_POST_TITLE_DES")];
    NSString *bodyPlaceHolder = [self stripStringAndToLowerCaser:NSLocalizedLanguage(@"MPANV_BODY_PLACEHOLDER")];
    NSString *bodyPlaceHolderPhoto = [self stripStringAndToLowerCaser:placeHolder];
    NSString *text = [self stripStringAndToLowerCaser:textView.text];
    
    if (!self.isAddPhoto) {
        if ([text isEqualToString:bodyPlaceHolder] || [text isEqualToString:bodyPlaceHolderPhoto] || text.length == 0) {
            self.addButton.userInteractionEnabled = NO;
        } else {
            self.addButton.userInteractionEnabled = YES;
        }
    }
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    NSString *placeHolder = [NSString stringWithFormat:@"%@ %@",NSLocalizedLanguage(@"MPANV_BODY_PLACEHOLDER"),NSLocalizedLanguage(@"MPANV_POST_TITLE_DES")];
    NSString *bodyPlaceHolder = [self stripStringAndToLowerCaser:NSLocalizedLanguage(@"MPANV_BODY_PLACEHOLDER")];
    NSString *bodyPlaceHolderPhoto = [self stripStringAndToLowerCaser:placeHolder];
    NSString *text = [self stripStringAndToLowerCaser:textView.text];
    
    if ([text isEqualToString:bodyPlaceHolder] || [text isEqualToString:bodyPlaceHolderPhoto]) {
     textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    /*
    if (!isKeyboardShown) {
        [UIView animateWithDuration:0.5 animations:^{
            self.constraintTextViewHeight.constant = kDeviceHeight * 0.25;
            [self.view layoutIfNeeded];
        }completion:^(BOOL fin){
            isKeyboardShown = YES;
        }];

    }
    */
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {

    /*
    if (isKeyboardShown) {
        [UIView animateWithDuration:0.5 animations:^{
            [self updateHeighForBodyTextEndEditing];
            [self.view layoutIfNeeded];
        }completion:^(BOOL fin){
            isKeyboardShown = NO;
        }];
    }
    */
}

-(void)onEditing:(id)sender {
    NSString *countText = NSLocalizedLanguage(@"MPANV_POST_TITLE_COUNT");
    self.postTitleCountLabel.text = [NSString stringWithFormat:countText,self.postTitleTextField.text.length];
    /*
    NSString *stripString = [self.postTitleTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (stripString.length > 0) {
        self.addButton.userInteractionEnabled = YES;
    } else {
        self.addButton.userInteractionEnabled = NO;
    }
     */
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

#pragma mark - Keyboard Observer

- (void)keyboardDidShow: (NSNotification *) notif{
    NSDictionary *info  = notif.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.constraintTextViewHeight.constant = (defaultBodyTextViewHeight - keyboardFrame.size.height);
        [self.view layoutIfNeeded];
    }completion:^(BOOL fin){
        
    }];
}

- (void)keyboardDidHide: (NSNotification *) notif{
    [UIView animateWithDuration:0.2 animations:^{
        [self updateHeighForBodyTextEndEditing];
        [self.view layoutIfNeeded];
    }completion:^(BOOL fin){
       
    }];

}

@end
