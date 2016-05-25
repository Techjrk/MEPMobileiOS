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
@property (strong, nonatomic) ActivityView *activity;
- (IBAction)tappedButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end

@implementation BusyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _activity = [ActivityView new];
    _activity.frame = self.view.frame;
    _activity.startAngle = 0;
    _activity.endAngle = 10;
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
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"endAngle";
    animation.fromValue = @0;
    animation.toValue = @360;
    animation.duration = 5;

    [_activity addAnimation:animation forKey:@"endAngle"];
    
    
}
@end
