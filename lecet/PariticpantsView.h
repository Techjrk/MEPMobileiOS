//
//  PariticpantsView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 5/16/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewClass.h"

@protocol PariticipantsDelegate <NSObject>
- (void)tappedParticipant:(id)object;
- (void)tappedParticipantSeeAll;
@end

@interface PariticpantsView : BaseViewClass
@property (strong, nonatomic) id<PariticipantsDelegate>pariticipantsDelegate;
- (void)changeConstraintHeight:(NSLayoutConstraint*)constraint;
- (void)setItems:(NSMutableArray*)items;
@end
