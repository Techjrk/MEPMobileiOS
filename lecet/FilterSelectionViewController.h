//
//  FilterSelectionViewController.h
//  lecet
//
//  Created by Michael San Minay on 05/07/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterSelectionViewControllerDelegate <NSObject>
- (void)tappedApplyButton:(id)items;

@end

@interface FilterSelectionViewController : UIViewController

@property (nonatomic,assign) id <FilterSelectionViewControllerDelegate> filterSelectionViewControllerDelegate;

@property (nonatomic,strong) NSDictionary *dataBeenSelected;
@property (nonatomic,strong) NSArray *dataInfo;
@property (nonatomic,weak) NSString *navTitle;

@end
