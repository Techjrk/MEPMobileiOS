//
//  MoreMenuViewController.m
//  lecet
//
//  Created by Michael San Minay on 01/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MoreMenuViewController.h"
#import "DropDownMenuView.h"
#import "TriangleView.h"

@interface MoreMenuViewController ()<DropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet DropDownMenuView *dropDownMoreMenuView;
@property (weak, nonatomic) IBOutlet TriangleView *triangleView;

@end

@implementation MoreMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //DropDownMenuMore
    _dropDownMoreMenuView.dropDownMenuDelegate = self;
    [_triangleView setObjectColor:[UIColor whiteColor]];
    [self addTappedGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
