//
//  BusyViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "BusyViewController.h"
#import "ActivityView.h"

@interface BusyViewController (){
}
@property (strong, nonnull) ActivityView *activity;
- (IBAction)tappedButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end

@implementation BusyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _activity = [ActivityView new];
    _activity.startAngle = 0;
    _activity.currentAngle = 0;
    _activity.layerColor = [UIColor redColor];
    [_viewContainer.layer addSublayer:_activity];
    [_activity setNeedsDisplay];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    
}
- (IBAction)tappedButton:(id)sender {

    _activity.endAngle = 360;
}
@end
