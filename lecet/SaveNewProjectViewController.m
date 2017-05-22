//
//  SaveNewProjectViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/5/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "SaveNewProjectViewController.h"

#define TITLE_FONT                      fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define TITLE_COLOR                     RGB(33, 33, 33)

#define SAVE_FONT                       fontNameWithSize(FONT_NAME_LATO_BOLD, 10)
#define SAVE_COLOR                      RGB(255, 255, 255)
#define SAVE_BGCOLOR                    RGB(0, 63, 114)

#define CANCEL_FONT                     fontNameWithSize(FONT_NAME_LATO_BOLD, 9)
#define CANCEL_COLOR                    RGB(0, 63, 114)

@interface SaveNewProjectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@end

@implementation SaveNewProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableTapGesture:YES];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
   
    self.labelTitle.text = NSLocalizedLanguage(@"SNP_TITLE");
    self.labelTitle.textColor = TITLE_COLOR;
    self.labelTitle.font = TITLE_FONT;
    
    [self.buttonSave setTitle:NSLocalizedLanguage(@"SNP_SAVE_BUTTON") forState:UIControlStateNormal];
    self.buttonSave.titleLabel.font = SAVE_FONT;
    [self.buttonSave setTitleColor:SAVE_COLOR forState:UIControlStateNormal];
    self.buttonSave.backgroundColor = SAVE_BGCOLOR;
    
    [self.buttonCancel setTitle:NSLocalizedLanguage(@"SNP_CANCEL_BUTTON") forState:UIControlStateNormal];
    self.buttonCancel.titleLabel.font = CANCEL_FONT;
    [self.buttonCancel setTitleColor:CANCEL_COLOR forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    UIView* view = sender.view;
    CGPoint loc = [sender locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    if ([subview isEqual:self.view]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)tappedButtonSave:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.saveNewProjectViewControllerDelegate tappedSaveNewProject];
    }];
}

- (IBAction)tappedButtonCancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
