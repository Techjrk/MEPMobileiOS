//
//  SearchResultView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol SearchResultViewDelegate <NSObject>
- (void)currentTabChanged:(id)object;
@end

@interface SearchResultView : BaseViewClass
@property (weak, nonatomic) id<SearchResultViewDelegate>searchResultViewDelegate;
@property (weak, nonatomic) UINavigationController *navigationController;
- (void) setCollectionItems:(NSMutableDictionary*)collectionItems tab:(NSNumber*)tab;
- (void)reloadData;
@end
