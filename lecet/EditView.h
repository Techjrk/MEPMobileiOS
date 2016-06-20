//
//  EditView.h
//  lecet
//
//  Created by Michael San Minay on 20/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol EditViewDelegate <NSObject>
- (void)tappedButtonSelect;
- (void)tappedButtonSelectAtTag:(int)tag;
@end
@interface EditView : BaseViewClass
@property (nonatomic,assign) id <EditViewDelegate> editViewDelegate;
- (BOOL)isButtonSelected;
- (void)setButtonTag:(int)tag;
- (void)setAddressOneText:(NSString *)text;
- (void)setAddressTwoText:(NSString *)text;
- (void)setButotnSelected:(BOOL)selected;
@end
