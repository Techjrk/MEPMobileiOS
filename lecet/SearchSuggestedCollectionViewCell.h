//
//  SearchSuggestedCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/24/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SearchSuggestedHeaderProject,
    SearchSuggestedHeaderCompany,
    SearchSuggestedHeaderContact,
} SearchSuggestedHeader;

@interface SearchSuggestedCollectionViewCell : UICollectionViewCell
- (void)setInfo:(NSString*)title count:(NSInteger)count headerType:(SearchSuggestedHeader)headerType;
@end
