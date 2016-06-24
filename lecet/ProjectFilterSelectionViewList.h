//
//  ProjectFilterSelectionViewList.h
//  lecet
//
//  Created by Michael San Minay on 24/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"
@protocol ProjectFilterSelectionViewListDelegate <NSObject>
- (void)selectedItem:(NSDictionary *)dict;
@end

@interface ProjectFilterSelectionViewList : BaseViewClass
@property (nonatomic,assign) id <ProjectFilterSelectionViewListDelegate> projectFilterSelectionViewListDelegate;
- (void)setInfo:(NSArray *)item;

@end
