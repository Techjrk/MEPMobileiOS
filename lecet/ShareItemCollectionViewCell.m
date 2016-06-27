//
//  ShareItemCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/21/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ShareItemCollectionViewCell.h"

@interface ShareItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation ShareItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _label.font = DROPDOWN_SHARELIST_BUTTON_FONT;
    _label.textColor = DROPDOWN_SHARELIST_BUTTON_COLOR;
    _lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
}

- (void)setShareItem:(ShareItem)shareItem {
    _imageView.image = [UIImage imageNamed:shareItem == ShareItemEmail?@"ic_email_black":@"ic_library_add_black"];
    
    _label.text = NSLocalizedLanguage(shareItem == ShareItemEmail?@"DROPDOWNSHARELIST_SENDBYEMAIL_BUTTON_TEXT":@"DROPDOWNPROJECTLIST_COPYLINK_BUTTON_TEXT");
    
}

@end
