//
//  CustomCollectionViewFlowLayout.m
//  lecet
//
//  Created by Michael San Minay on 24/08/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"
#define ITEM_SPACING kDeviceHeight * 0.008

@implementation CustomCollectionViewFlowLayout

//static CGFloat const ITEM_SPACING = 10.0f;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGRect contentRect = {CGPointZero, self.collectionViewContentSize};
    
    NSArray *attributesForElementsInRect = [super layoutAttributesForElementsInRect:contentRect];
    NSMutableArray *newAttributesForElementsInRect = [[NSMutableArray alloc] initWithCapacity:attributesForElementsInRect.count];
    
    CGFloat leftMargin = self.sectionInset.left + ITEM_SPACING; //initalized to silence compiler, and actaully safer, but not planning to use.
    NSMutableDictionary *leftMarginDictionary = [[NSMutableDictionary alloc] init];
    
    for (UICollectionViewLayoutAttributes *attributes in attributesForElementsInRect) {
        UICollectionViewLayoutAttributes *attr = attributes.copy;
        
        CGFloat lastLeftMargin = [[leftMarginDictionary valueForKey:[[NSNumber numberWithFloat:attributes.frame.origin.y] stringValue]] floatValue];
        if (lastLeftMargin == 0) lastLeftMargin = leftMargin;
        
        CGRect newLeftAlignedFrame = attr.frame;
        newLeftAlignedFrame.origin.x = lastLeftMargin;
        attr.frame = newLeftAlignedFrame;
        
        lastLeftMargin += attr.frame.size.width + ITEM_SPACING;
        [leftMarginDictionary setObject:@(lastLeftMargin) forKey:[[NSNumber numberWithFloat:attributes.frame.origin.y] stringValue]];
        [newAttributesForElementsInRect addObject:attr];
    }
    
    return newAttributesForElementsInRect;
}


@end
