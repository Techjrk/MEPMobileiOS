//
//  IntroViewController.m
//  lecet
//
//  Created by Michael San Minay on 04/08/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "IntroViewController.h"

#define FONT_CONTENT                       fontNameWithSize(FONT_NAME_LATO_BOLD, 11)
#define COLOR_FONT_CONTENT                 RGB(255, 255, 255)

@interface IntroViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.contentLabel.font = FONT_CONTENT;
    self.contentLabel.textColor = COLOR_FONT_CONTENT;
    self.contentLabel.text = @"• Search messages and construction projects using Siri \n• Search for construction projects in your jurisdiction \n• View full project information \n• Share project and company data with associates \n• Contact key project personnel with one touch \n\nTRACK \n• Add projects and companies to custom tracking lists \n• Review updates to targeted projects and companies MAP \n• Access projects near you \n• Obtain driving directions to call on projects and companies \n\nMEP Mobile...The power of construction project tracking in your hands";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tappedCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.introViewControllerDelegate tappedIntroCloseButton];
    }];
}

@end
