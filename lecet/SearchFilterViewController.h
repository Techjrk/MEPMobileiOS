//
//  SearchFilterViewController.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@protocol SearchFilterViewControllerDelegate <NSObject>
- (void)tappedSearchFilterViewControllerApply:(NSDictionary*)projectFilter companyFilter:(NSDictionary*)companyFilter;
@end

@interface SearchFilterViewController : BaseViewController
@property (weak, nonatomic) id<SearchFilterViewControllerDelegate>searchFilterViewControllerDelegate;
@end
