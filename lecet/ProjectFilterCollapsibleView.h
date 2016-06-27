//
//  ProjectFilterCollapsibleView.h
//  lecet
//
//  Created by Michael San Minay on 27/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"
#import "ProjectFilterCollapsibleDataInfo.h"


@protocol ProjectFilterCollapsibleViewDelegate <NSObject>
- (void)tappedSelectionButton:(int)tag;
- (void)tappedDropDownButton:(int)tag;
@end


@interface ProjectFilterCollapsibleView : BaseViewClass
@property (nonatomic,assign) id <ProjectFilterCollapsibleViewDelegate> projectFilterCollapsibleViewDelegate;

- (void)setLabelTitleText:(NSString *)text;
- (void)setButtonTag:(int)tag;
- (void)setSelectionButtonSelected:(BOOL)selected;
- (void)setDropDonwSelected:(BOOL)selected;
- (void)setLeftSpacingForLineView:(CGFloat)value;

@end
