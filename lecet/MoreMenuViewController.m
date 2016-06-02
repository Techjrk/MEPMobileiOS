//
//  MoreMenuViewController.m
//  lecet
//
//  Created by Michael San Minay on 01/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MoreMenuViewController.h"
#import "DropDownMenuView.h"

@interface MoreMenuViewController ()<DropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet DropDownMenuView *dropDownMoreMenuView;

@end

@implementation MoreMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //DropDownMenuMore
    _dropDownMoreMenuView.dropDownMenuDelegate = self;
    [self addTappedGesture];
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


- (void)addTappedGesture{
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDropDownViewController)];
    tapped.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapped];
    
}


- (void)dismissDropDownViewController{

    [self dismissViewControllerAnimated:YES completion:Nil];

}



#pragma mark - DropDown MenuView Delegate

- (void)tappedDropDownMenu:(DropDownMenuItem)menuDropDownItem{
    
    [[DataManager sharedManager] featureNotAvailable];
}



@end
