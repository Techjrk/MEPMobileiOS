//
//  MobileProjectNotePopUpViewController.m
//  lecet
//
//  Created by Michael San Minay on 11/03/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "MobileProjectNotePopUpViewController.h"

@interface MobileProjectNotePopUpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *postNoteButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *popupView;

@end

@implementation MobileProjectNotePopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = NSLocalizedLanguage(@"MPNPV_TITLE");
    [self.postNoteButton setTitle:NSLocalizedLanguage(@"MPNPV_POST_NOTE") forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedLanguage(@"MPNPV_CANCEL") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
