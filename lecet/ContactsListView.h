//
//  ContactsListView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/18/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol ContactListViewDelegate <NSObject>
@required
- (void)tappededSeeAllContactsProject;
- (void)selectedContact:(id)item;

@end



@interface ContactsListView : BaseViewClass
- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint;
- (void)setItems:(NSMutableArray*)items;
@property (nonatomic,assign) id<ContactListViewDelegate> contactListViewDelegate;
@end
