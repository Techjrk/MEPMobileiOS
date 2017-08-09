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
#import <DataManagerSDK/AFImageDownloader.h>

#define kCellIdentifier             @"kCellIdentifier"
#define BG_COLOR                    RGB(245, 245, 245)

#define NOTE_ITEM_FONT              fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define NOTE_ITEM_COLOR             RGB(34, 34, 34)

#define NONE_COLOR                  RGBA(34, 34, 34, 50)
#define NONE_FONT                   fontNameWithSize(FONT_NAME_LATO_ITALIC, 13)

@interface ImageNotesView()<UICollectionViewDataSource, UICollectionViewDelegate,ImageNoteCollectionViewCellDelegate>{
    UITextView *textViewTemp;
}
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

#pragma mark - ImageNoteCollectionViewCell Delegate
- (void)tappedButtonEdit:(UIImage *)image title:(NSString *)string detail:(NSString *)detail recordID:(NSNumber *)recordID indexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = self.items[indexPath.row];
    NSString *urlString;
    if (![item[@"cellType"] isEqualToString:@"note"] ) {
        NSNumber *imageId = item[@"id"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        BOOL isPNG = [[[url pathExtension] lowercaseString] isEqualToString:@"png"];
        
        NSString *fileName = [NSString stringWithFormat:@"%li.jpg", (long)imageId.integerValue];
        
        if (isPNG) {
            fileName = [NSString stringWithFormat:@"%li.png", (long)imageId.integerValue];
        }
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        
        urlString = filePath;
    }
    NSString *fAddress =  [DerivedNSManagedObject objectOrNil:item[@"fullAddress"]];
    [self.imageNotesViewDelegate updateNoteAndImage:string detail:detail image:image itemID:recordID imageLink:urlString address:fAddress];
}
- (void)tappedDelete:(UIImage *)image itemID:(NSNumber *)itemID {
    [self.imageNotesViewDelegate deleteNoteAndImage:itemID image:image];
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
    cell.indexPath = indexPath;
    cell.imageNoteCollectionViewCellDelegate = self;
    
    NSDictionary *item = self.items[indexPath.row];

    NSString *timeStamp = [DerivedNSManagedObject objectOrNil:item[@"createdAt"]];
    NSDate *date = [DerivedNSManagedObject dateFromDateAndTimeString:timeStamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy";
    cell.dateLabel.text = [formatter stringFromDate:date];
    
    NSString *timeUpdated = [DerivedNSManagedObject objectOrNil:item[@"updatedAt"]];
    NSDate *dateUp = [DerivedNSManagedObject dateFromDateAndTimeString:timeUpdated];
    
    double timeDifference =  [dateUp timeIntervalSinceDate:date];
    if (timeDifference > 60) {
        NSString *timeUpdated = timeAgoFromUnixTime([dateUp timeIntervalSince1970]);
        if (![timeUpdated isEqualToString:@"just now"]) {
            timeUpdated = [NSString stringWithFormat:NSLocalizedLanguage(@"INV_LAST_UPDATED"),timeUpdated];
        }
        cell.stamp.text = timeUpdated;
        cell.stamp.hidden = NO;
        cell.constraintHeightStampLabel.constant = kDeviceHeight * 0.03;
        cell.constraintBottomNoteSpacer.constant =  kDeviceHeight * 0.005;
    } else {
        cell.stamp.hidden = YES;
        cell.constraintHeightStampLabel.constant = 0;
        cell.constraintBottomNoteSpacer.constant =  0;
    }
    
    
    if ([item[@"cellType"] isEqualToString:@"note"] ) {
        cell.user.text = [NSString stringWithFormat:@"%@ %@",item[@"author"][@"first_name"], item[@"author"][@"last_name"]];
        
        cell.imageId = nil;
        cell.image.image = nil;
        cell.userId = item[@"authorId"];
        cell.recordID = item[@"id"];
        
    } else {
        NSString *urlString = item[@"url"];
        NSNumber *imageId = item[@"id"];
        cell.imageId = imageId;
        cell.userId = item[@"userId"];
        cell.recordID = item[@"id"];
        
        cell.user.text = [NSString stringWithFormat:@"%@ %@",item[@"user"][@"first_name"], item[@"user"][@"last_name"]];
        
        AFImageDownloader *downloader = [[AFImageDownloader alloc] init];
        NSURL *url = [NSURL URLWithString:urlString];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        BOOL isPNG = [[[url pathExtension] lowercaseString] isEqualToString:@"png"];

        NSString *fileName = [NSString stringWithFormat:@"%li.jpg", (long)imageId.integerValue];

        if (isPNG) {
            fileName = [NSString stringWithFormat:@"%li.png", (long)imageId.integerValue];
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
                NSString *fileNameD;
                NSString *filePathD;
                if (isPNG) {
                    fileNameD = [NSString stringWithFormat:@"%li.png", (long)imageId.integerValue];
                    filePathD = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
                    [UIImagePNGRepresentation(responseObject) writeToFile:filePath atomically:YES];
                } else {
                    fileNameD = [NSString stringWithFormat:@"%li.jpg", (long)imageId.integerValue];
                    filePathD = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
                    [UIImageJPEGRepresentation(responseObject, 1.0) writeToFile:filePath atomically:YES];
                }
                
                UIImage *image = [UIImage imageWithContentsOfFile:filePathD];
                [cell loadImage:image];
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                
            }];
        }
        

    }
    
    cell.titleView.text = [DerivedNSManagedObject objectOrNil:item[@"title"]];
    cell.locationTitleLabel.text = [DerivedNSManagedObject objectOrNil:item[@"fullAddress"]];
    
    NSString *text = [DerivedNSManagedObject objectOrNil:item[@"text"]];
    text = text.length > 0 ? text : @"";
    NSAttributedString *attributedString = [[NSAttributedString new] initWithString:text attributes:@{NSFontAttributeName: NOTE_ITEM_FONT, NSForegroundColorAttributeName: NOTE_ITEM_COLOR}];
    
    cell.note.attributedText = attributedString;

    [cell layoutSubviews];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
    
    NSDictionary *item = self.items[indexPath.row];
    NSString *text = [DerivedNSManagedObject objectOrNil:item[@"text"]];
    text = text.length > 0 ? text : @"";
    NSAttributedString *attributedString = [[NSAttributedString new] initWithString:text attributes:@{NSFontAttributeName: NOTE_ITEM_FONT, NSForegroundColorAttributeName: NOTE_ITEM_COLOR}];
    
    NSString *timeStamp = [DerivedNSManagedObject objectOrNil:item[@"createdAt"]];
    
    
    NSDate *date = [DerivedNSManagedObject dateFromDateAndTimeString:timeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy";
    NSString *timeUpdated = [DerivedNSManagedObject objectOrNil:item[@"updatedAt"]];
    NSDate *dateUp = [DerivedNSManagedObject dateFromDateAndTimeString:timeUpdated];
    
    CGFloat width = collectionView.frame.size.width * 0.9;
    CGFloat height = textHeight(attributedString, width, NOTE_ITEM_FONT.pointSize);
    CGFloat itemSize;
    
    int numLines = height/NOTE_ITEM_FONT.pointSize;
    int noteFontHeight = (height / numLines) + 1;
    height = numLines * noteFontHeight;
    double timeDifference =  [dateUp timeIntervalSinceDate:date];
    if (timeDifference > 60) {
        
    } else {
        
        if (item[@"url"] == nil) {
            height = height - kDeviceHeight * 0.03;
        } else {
            height = height - kDeviceHeight * 0.02;
        }
        
    }

    if (item[@"url"] == nil) {
        itemSize = [ImageNoteCollectionViewCell itemSize];
        size = CGSizeMake( width, itemSize + height);
    } else {
        
        itemSize = [ImageNoteCollectionViewCell itemSizeWithImage];
        CGFloat tempHeight = itemSize + height + (height * 0.3);
        size = CGSizeMake( width, tempHeight);
   
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
    ImageNoteCollectionViewCell *cell = (ImageNoteCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    [self.imageNotesViewDelegate viewNoteAndImage:cell.titleView.text detail:cell.note.text image:cell.image.image imageNoteId:cell.imageId];
}

@end
