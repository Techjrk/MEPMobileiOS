//
//  ListItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ListItemCollectionViewCell.h"

@interface ListItemCollectionViewCell()
@end
@implementation ListItemCollectionViewCell
@synthesize level;
@synthesize index;
@synthesize listItemCollectionViewCellDelegate;

+ (CGFloat)itemHeight {
    return kDeviceHeight * 0.087;
}

+ (NSMutableDictionary *)createItem:(NSString *)name value:(NSString *)value model:(NSString *)model {
    
    NSMutableDictionary *item = [NSMutableDictionary new];
    
    item[LIST_VIEW_NAME] = name;
    item[LIST_VIEW_VALUE] = value;
    item[LIST_VIEW_MODEL] = model;
    
    return item;
}

- (id)parentListView {
    
    return [self superview];
}

- (void)setItem:(NSMutableDictionary *)item {
    localItem = item;
}
@end
