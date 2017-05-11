//
//  RecentSearchView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/28/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol RecentSearchViewDelegate <NSObject>
@optional
- (void)tappedRecentSearch;
- (void)endRequestRecentSearch;

@end

@interface RecentSearchView : BaseViewClass
@property (strong, nonatomic) id <RecentSearchViewDelegate> recentSearchViewDelegate;
@end
