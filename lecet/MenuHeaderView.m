//
//  MenuHeaderView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 4/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "MenuHeaderView.h"

#import "menuHeaderConstants.h"

@interface MenuHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *labelHeader;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;

@end

@implementation MenuHeaderView

- (void)awakeFromNib {

    _labelHeader.font = MENUHEADER_LABEL_HEADER_FONT;
    _labelHeader.text = NSLocalizedLanguage(@"MENUHEADER_LABEL_HEADER_TEXT");
    _labelHeader.textColor = MENUHEADER_LABEL_HEADER_COLOR;

    
    _labelCount.font = MENUHEADER_LABEL_COUNT_FONT;
    _labelCount.text = [NSString stringWithFormat:NSLocalizedLanguage(@"MENUHEADER_LABEL_COUNT_RECENT_TEXT"), 12];
    _labelCount.textColor = MENUHEADER_LABEL_COUNT_COLOR;

}

- (void)setTitle:(NSString*)title {
    _labelCount.text = title;
    
}
@end
