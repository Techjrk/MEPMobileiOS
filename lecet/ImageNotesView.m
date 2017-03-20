//
//  ImageNotesView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 3/14/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "ImageNotesView.h"
#import "ImageNoteCollectionViewCell.h"
#import "PhotoViewController.h"
#import "AFImageDownloader.h"

#define kCellIdentifier             @"kCellIdentifier"
#define BG_COLOR                    RGB(245, 245, 245)

#define NOTE_ITEM_FONT              fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define NOTE_ITEM_COLOR             RGB(34, 34, 34)

#define NONE_COLOR                  RGBA(34, 34, 34, 50)
#define NONE_FONT                   fontNameWithSize(FONT_NAME_LATO_ITALIC, 13)

#define DATA_TEXT                   @"this is a long text. very long text that needs to be displayed properly. without this it is not going to be juggled up"

@interface ImageNotesView()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *viewNone;
@property (weak, nonatomic) IBOutlet UILabel *labelNone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintNoneMsgHeight;
@end

@implementation ImageNotesView
@synthesize items;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.items = [NSMutableArray new];
    [self.collectionView registerNib:[UINib nibWithNibName:[[ImageNoteCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    self.collectionView.backgroundColor = BG_COLOR;
    
    self.labelNone.text = NSLocalizedLanguage(@"PROJECT_DETAIL_ADD_IMAGE_NOTE");
    self.labelNone.textColor = NONE_COLOR;
    self.labelNone.font = NONE_FONT;
    self.constraintNoneMsgHeight.constant = kDeviceHeight * 0.15;
    self.viewNone.hidden = YES;
}

#pragma mark - Custom Methods
- (void)reloadData {
    self.viewNone.hidden = self.items.count>0;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionDelegate and UICollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageNoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = self.items[indexPath.row];
    
    if ([item[@"cellType"] isEqualToString:@"note"] ) {
        cell.imageId = nil;
        cell.image.image = nil;
    } else {
        NSString *urlString = item[@"url"];
        NSNumber *imageId = item[@"id"];
        
        AFImageDownloader *downloader = [[AFImageDownloader alloc] init];
        NSURL *url = [NSURL URLWithString:urlString];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        BOOL isPNG = [[[url pathExtension] lowercaseString] isEqualToString:@"png"];

        NSString *fileName = [NSString stringWithFormat:@"%li.jpg", imageId.integerValue];

        if (isPNG) {
            fileName = [NSString stringWithFormat:@"%li.png", imageId.integerValue];
        }
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [cell loadImage:image];
        } else {
            
            [cell.activityIndicator startAnimating];
            __weak __typeof(cell)weakCell = cell;
            [downloader downloadImageForURLRequest:[NSURLRequest requestWithURL:url] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                
                BOOL isPNG = [[[request.URL.absoluteString pathExtension] lowercaseString] isEqualToString:@"png"];
                
                weakCell.image.image = responseObject;
                
                if (isPNG) {
                    NSString *fileName = [NSString stringWithFormat:@"%li.png", imageId.integerValue];
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
                    [UIImagePNGRepresentation(responseObject) writeToFile:filePath atomically:YES];
                } else {
                    NSString *fileName = [NSString stringWithFormat:@"%li.jpg", imageId.integerValue];
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
                    
                    [UIImageJPEGRepresentation(responseObject, 1.0) writeToFile:filePath atomically:YES];
                }
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                
            }];
        }
        

    }
    
    cell.titleView.text = item[@"title"];
    
    NSString *text = item[@"text"];
    text = DATA_TEXT;
    NSAttributedString *attributedString = [[NSAttributedString new] initWithString:text attributes:@{NSFontAttributeName: NOTE_ITEM_FONT, NSForegroundColorAttributeName: NOTE_ITEM_COLOR}];
    
    cell.note.attributedText = attributedString;

    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
    
    NSDictionary *item = self.items[indexPath.row];
    NSString *text = item[@"text"];
    text = DATA_TEXT;
    NSAttributedString *attributedString = [[NSAttributedString new] initWithString:text attributes:@{NSFontAttributeName: NOTE_ITEM_FONT, NSForegroundColorAttributeName: NOTE_ITEM_COLOR}];
    
    CGFloat width = collectionView.frame.size.width * 0.9;
    CGFloat height = textHeight(attributedString, width, NOTE_ITEM_FONT.pointSize);
    
    if (item[@"url"] == nil) {
        size = CGSizeMake( width, [ImageNoteCollectionViewCell itemSize] + height);
    } else {
        size = CGSizeMake( width, [ImageNoteCollectionViewCell itemSizeWithImage] + height);
    }
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kDeviceHeight * 0.01;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageNoteCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [self.imageNotesViewDelegate viewNoteAndImage:cell.titleView.text detail:cell.note.text image:cell.image.image];
}

@end
