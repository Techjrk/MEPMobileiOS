//
//  SettingsCPView.m
//  lecet
//
//  Created by Michael San Minay on 09/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "SettingsCPView.h"
#import "SettingConstant.h"

@interface SettingsCPView ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation SettingsCPView
- (void)awakeFromNib {
    _label.font = SETTINGS_LABEL_FONT;
    _label.textColor = SETTINGS_LABEL_FONT_COLOR;
    _label.text = NSLocalizedLanguage(@"SETTING_CPVIEW_TEXT");
}

@end
