//
//  ContactsView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ContactsView.h"

#import "contactsConstants.h"

@interface ContactsView()
@property (weak, nonatomic) IBOutlet UIImageView *contactImage;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelCompany;
@end

@implementation ContactsView

- (void)awakeFromNib {
    _labelName.font = CONTACT_LABEL_NAME_FONT;
    _labelName.textColor = CONTACT_LABEL_NAME_COLOR;
    
    _labelCompany.font = CONTACT_LABEL_COMPANY_FONT;
    _labelCompany.textColor = CONTACT_LABEL_COMPANY_COLOR;
    
    self.layer.shadowColor = [CONTACT_SHADOW_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 4.0;

}

- (void)setInfo:(id)info {
    NSDictionary *infoDict = info;    
    _labelName.text = infoDict[CONTACT_NAME];
    _labelCompany.text = infoDict[CONTACT_COMPANY];
}

@end
