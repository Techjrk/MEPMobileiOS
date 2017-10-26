//
//  IntroViewController.m
//  lecet
//
//  Created by Michael San Minay on 04/08/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "IntroViewController.h"
#import "IntroCollectionViewCell.h"

#define FONT_CONTENT                       fontNameWithSize(FONT_NAME_LATO_BOLD, 15.0)


#define COLOR_FONT_CONTENT                 RGB(248, 152, 28)
#define COLOR_BG_BUTTON                    RGB(8, 73, 124)

@interface IntroViewController () <UICollectionViewDelegate,UICollectionViewDelegate> {
    NSArray *collectionItems;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation IntroViewController
#define kCellIdentifier                 @"kCellIdentifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.titleLabel.font = FONT_CONTENT;
    self.titleLabel.textColor = COLOR_FONT_CONTENT;
    self.titleLabel.text = @"What's new";
    
    collectionItems = [NSArray new];
    collectionItems = @[@{@"title":@"A. Fix Siri Support For iOS 11"},
                        @{@"title":@"  User can now use their voice to:"},
                        @{@"title":@"• List projects near them"},
                        @{@"title":@"• List projects recently updated"},
                        @{@"title":@"• Display project tracking list"},
                        @{@"title":@"• Display company tracking list"},
                        @{@"title":@"B. Help Center is added to support users"},
                        @{@"title":@"C. Lecet MEP now requires iOS 10 and later"}];
    
    [self.collectionView registerNib:[UINib nibWithNibName:[[IntroCollectionViewCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    self.containerView.layer.cornerRadius = 2.0f;
    self.containerView.layer.masksToBounds = YES;
    
    [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
    
    self.closeButton.titleLabel.font = FONT_CONTENT;
    self.closeButton.backgroundColor = COLOR_BG_BUTTON;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tappedCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.introViewControllerDelegate tappedIntroCloseButton];
    }];
}

#pragma mark Collection Datasource and Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dicInfo = [collectionItems objectAtIndex:indexPath.row];
    
    IntroCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.cellContentLabel.text = dicInfo[@"title"];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = collectionItems.count;
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    size = CGSizeMake( self.collectionView.frame.size.width, kDeviceHeight * 0.055);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    
    return UIEdgeInsetsMake(0, 0, kDeviceHeight * 0.015, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
}


@end
