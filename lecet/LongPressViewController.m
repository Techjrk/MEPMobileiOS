//
//  LongPressViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/10/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "LongPressViewController.h"

@interface LongPressViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@end

#define LABEL_FONT            fontNameWithSize(FONT_NAME_LATO_BOLD, 14)
#define FONT_COLOR      RGB(255,255,255)

@implementation LongPressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
  
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.labelTitle.text = NSLocalizedLanguage(@"RETURN_HOME");
    self.labelTitle.font = LABEL_FONT;
    self.labelTitle.textColor = FONT_COLOR;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)tappedButtonHome:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:^{
 
        [self.longPressViewControllerDelegate tappedHome];
        self.longPressViewControllerDelegate = nil;
        
    }];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    
    UIView* view = sender.view;
    CGPoint loc = [sender locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    if ([subview isEqual:self.view]) {
        self.longPressViewControllerDelegate = nil;
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

@end
