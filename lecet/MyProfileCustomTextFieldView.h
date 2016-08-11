//
//  MyProfileCustomTextFieldView.h
//  lecet
//
//  Created by Michael San Minay on 12/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"
#import "TextfieldViewDelegate.h"



@interface MyProfileCustomTextFieldView : BaseViewClass
@property (nonatomic,assign) id <TextfieldViewDelegate> textFieldViewDelegate;
- (void)setTileLeftLabelText:(NSString *)title;
- (void)setHideTitleRightLabel:(BOOL)hide;

- (void)setTextFieldOneText:(NSString *)text;
- (void)setTextFieldTwoText:(NSString *)text;

- (NSString *)getTextOne;
- (NSString *)getTextTwo;

-(void)setPlaceHolderOne:(NSString *)placeHolder;
- (void)setPlaceHolderTwo:(NSString *)placeholder;

@end
