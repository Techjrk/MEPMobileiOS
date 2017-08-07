//
//  ImageNoteCollectionViewCell.h
//  lecet
//
//  Created by Harry Herrys Camigla on 3/13/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageNoteCollectionViewCellDelegate
- (void)tappedButtonEdit:(UIImage*)image title:(NSString*)string detail:(NSString*)detail recordID:(NSNumber *)recordID indexPath:(NSIndexPath *)indexPath;
- (void)tappedDelete:(UIImage*)image itemID:(NSNumber *)itemID;
@end

@interface ImageNoteCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *stamp;
@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;

@property (strong,nonatomic) id<ImageNoteCollectionViewCellDelegate> imageNoteCollectionViewCellDelegate;

@property (strong, nonatomic) NSNumber *recordID;
@property (strong, nonatomic) NSNumber *imageId;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSIndexPath *indexPath;
+ (CGFloat)itemSize;
+ (CGFloat)itemSizeWithImage;

- (void)loadImage:(UIImage*)image;
@end
