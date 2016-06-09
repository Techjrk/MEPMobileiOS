//
//  ChnagePasswordCollectionViewCell.m
//  lecet
//
//  Created by Michael San Minay on 08/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ChnagePasswordCollectionViewCell.h"
#import "CPCustomTextFieldView.h"

@interface ChnagePasswordCollectionViewCell ()
@property (weak, nonatomic) IBOutlet CPCustomTextFieldView *changePasswordView;

@end
@implementation ChnagePasswordCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (NSString *)getText{
    return [_changePasswordView text];
}

- (void)setTitle:(NSString *)title {
    [_changePasswordView setLefTitleText:title];
}

- (void)setPlaceHolderForTextField:(NSString *)placeHolderText {    
    [_changePasswordView setPlaceHolder:placeHolderText];
}

- (void)setSecureTextField:(BOOL)secure {
    [_changePasswordView setSecure:secure];
}

@end
