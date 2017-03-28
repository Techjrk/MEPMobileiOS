//
//  ImageNotesView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 3/14/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewClass.h"

@protocol ImageNotesViewDelegate
- (void)viewNoteAndImage:(NSString*)title detail:(NSString*)detail image:(UIImage*)image;
- (void)updateNoteAndImage:(NSString*)title detail:(NSString*)detail image:(UIImage*)image;
- (void)deleteNoteAndImage:(id)itemsID;
@end

@interface ImageNotesView : BaseViewClass
@property (strong, nonatomic) NSMutableArray *items;
@property (weak, nonatomic) id<ImageNotesViewDelegate>imageNotesViewDelegate;
- (void)reloadData;
@end
