//
//  CompanyTrackingView.h
//  lecet
//
//  Created by Michael San Minay on 16/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"
typedef enum {
    changeIndicatorItemAdded = 1,
    changeIndicatorItemAddAccount = 2,
}changeIndicatorItem;

@protocol CompanyTrackingViewDelegate <NSObject>
@required
- (void)tappedButtonAtTag:(int)tag;
@end

@interface CompanyTrackingView : BaseViewClass

@property (nonatomic,assign) id <CompanyTrackingViewDelegate> companyTrackingViewDelegate;
- (void)setName:(NSString *)name;
- (void)setAddress:(NSString *)address;
- (void)setAddressTwo:(NSString *)address;
- (void)setButtonLabelTitle:(NSString *)text;
- (void)setButtonTag:(int)tag;
- (void)setTextViewHidden:(BOOL)hide;
- (void)changeCaretToUp:(BOOL)up;
- (void)setImage:(id)info;
- (void)setLabelDescription:(NSString *)text;
@end
