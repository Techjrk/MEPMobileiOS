//
//  ListItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ListItemCollectionViewCell.h"

@implementation ListViewItemDictionary

- (instancetype)init {
    self = [super init];
    proxy = [NSMutableDictionary new];
    self.parent = nil;
    return self;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {

    if (anObject) {
        
        proxy[aKey] = anObject;
        
    } else {

        [proxy removeObjectForKey:aKey];
    }
    
    if ([anObject class] == [ListViewItemDictionary class]) {
        
        ListViewItemDictionary *object = anObject;
        object.parent = self;
        
    }
    
    if ([anObject class] == [ListViewItemArray class]) {
        
        ListViewItemArray *object = anObject;
        object.parent = self;
        
    }

}

- (NSUInteger)count {

    return proxy.count;
}

- (NSEnumerator *)keyEnumerator {

    return [proxy keyEnumerator];
}

- (id)objectForKey:(id)aKey {

    return [proxy objectForKey:aKey];
}

- (void)clearSubItems {
    ListViewItemArray *items = proxy[LIST_VIEW_SUBITEMS];
    
    if (items) {
        [self clearItems:items];
    }
}

- (void)clearItems:(ListViewItemArray*)items {
    
    for (ListViewItemDictionary *item in items) {
        
        item[STATUS_CHECK] = [NSNumber numberWithBool:NO];
        ListViewItemArray *subItems = item[LIST_VIEW_SUBITEMS];
        
        if (subItems) {
            [self clearItems:subItems];
        }
        
    }
}

- (void)filterSubItems:(NSString *)filter {
    ListViewItemArray *items = proxy[LIST_VIEW_SUBITEMS];
    [items filterSubItems:filter];
}

- (NSInteger)subItemCount {
    ListViewItemArray *items = proxy[LIST_VIEW_SUBITEMS];
    return items.count;
}

@end


@implementation ListViewItemArray

- (instancetype)init {
    self = [super init];
    self.parent = nil;
    proxy = [NSMutableArray new];
    filteredProxy = [NSMutableArray new];
    return self;
}

- (void)addObject:(id)anObject {
   
 
    if ([anObject class] == [ListViewItemDictionary class]) {
        
        [proxy addObject:anObject];
       ListViewItemDictionary *object = anObject;
        object.parent = self;
  
    }

    if ([anObject class] == [ListViewItemArray class]) {
        
        [proxy addObject:anObject];
        ListViewItemArray *object = anObject;
        object.parent = self;
        
    }

}

- (id) forwardingTargetForSelector:(SEL)aSelector {
    return proxy;
}

- (NSUInteger)count {
    
    return isFiltered?filteredProxy.count:proxy.count;
}

- (id)objectAtIndex:(NSUInteger)index {
    id anObject = isFiltered?[filteredProxy objectAtIndex:index]:[proxy objectAtIndex:index];
    return anObject;
}

- (void)filterSubItems:(NSString *)filter {
    
    isFiltered = filter != nil;
    
    [filteredProxy removeAllObjects];
    
    if (filter) {
        
        for (ListViewItemDictionary *item in proxy) {
            
            NSString *text = [item[LIST_VIEW_NAME] uppercaseString];
            [item filterSubItems:filter];
            
            if ([text containsString:[filter uppercaseString]] | ([item subItemCount]>0)) {
             
                [filteredProxy addObject:item];
                
                if ([item subItemCount]>0) {
                    item[STATUS_EXPAND] = [NSNumber numberWithBool:YES];
                }
                
            }
            
        }
        
    } else {

        for (ListViewItemDictionary *item in proxy) {
            
            [item filterSubItems:filter];
            
            if ([item subItemCount]>0) {
                
                if ([item subItemCount]>0) {
                    item[STATUS_EXPAND] = [NSNumber numberWithBool:NO];
                }
                
            }
            
        }

        
    }
    
}

@end

@interface ListItemCollectionViewCell()
@end
@implementation ListItemCollectionViewCell
@synthesize level;
@synthesize index;
@synthesize listItemCollectionViewCellDelegate;

+ (CGFloat)itemHeight {
    return kDeviceHeight * 0.087;
}

+ (ListViewItemDictionary *)createItem:(NSString *)name value:(NSString *)value model:(NSString *)model {
    
    ListViewItemDictionary *item = [ListViewItemDictionary new];
    
    item[LIST_VIEW_NAME] = name;
    item[LIST_VIEW_VALUE] = value;
    item[LIST_VIEW_MODEL] = model;
    
    return item;
}

- (id)parentListView {
    
    return [self superview];
}

- (void)setItem:(ListViewItemDictionary *)item {
    localItem = item;
}

- (ListViewItemDictionary *)localItem {
    return localItem;
}
@end
