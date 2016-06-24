//
//  ProjectFilterSelectionView.h
//  lecet
//
//  Created by Michael San Minay on 24/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol ProjectFilterSelectionViewDelegate <NSObject>
- (void)tappedCheckButtonAtTag:(int)tag;
@end

@interface ProjectFilterSelectionView : BaseViewClass
@property(nonatomic,strong) id <ProjectFilterSelectionViewDelegate> projectFilterSelectionViewDelegate;
- (void)setLabelTitleText:(NSString *)text;
- (void)setCheckButtonSelected:(BOOL)selected;
- (void)setButtonTag:(int)tag;
@end
