//
//  SearchResultView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/25/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

#define RESULT_ITEMS_PROJECT                @"RESULT_ITEMS_PROJECT"
#define RESULT_ITEMS_COMPANY                @"RESULT_ITEMS_COMPANY"
#define RESULT_ITEMS_CONTACT                @"RESULT_ITEMS_CONTACT"

@interface SearchResultView : BaseViewClass
- (void) setCollectionItems:(NSMutableDictionary*)collectionItems tab:(NSInteger)tab;
@end
