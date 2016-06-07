//
//  DropDownProjectList.m
//  lecet
//
//  Created by Get Devs on 20/05/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DropDownProjectList.h"
#import "dropDownProjectListConstant.h"
#import "ProjectListCVCell.h"

@interface DropDownProjectList ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong,nonatomic) NSDictionary *projects;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *labelSelecTracking;
@property (weak, nonatomic) IBOutlet UIView *selectTrackingListView;

@end

@implementation DropDownProjectList
#define kCellIdentifier     @"kCellIdentifier"

- (void)awakeFromNib {

    _labelSelecTracking.font = DROPDOWN_PROJECTLIST_LABEL_SELECTTRACKING_FONT;
    _labelSelecTracking.text = NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_TITLE_TRACKING_LABEL_TEXT");
    _selectTrackingListView.backgroundColor = DROPDOWN_PROJECTLIST_VIEW_SELECTTRACKINGLIST_BG_COLOR;
    
    [self drawTopTriangle];
    [self drawShadow];
    
    [_collectionView registerNib:[UINib nibWithNibName:[[ProjectListCVCell class] description] bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setBackgroundColor:DROPDOWN_PROJECTLIST_COLLECTIONVIEW_BG_COLOR];
    _collectionView.bounces = NO;
    
    [self setProjects];
    
}

- (void)setProjects {
    
    NSArray *tempPorjectList = @[NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_TRAINANDMETROS_BUTTON_TEXT"),NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_RAILWAYS_BUTTON_TEXT"),NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_ANOTHERLIST_BUTTON_TEXT"),NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_HIGHVALUES_BUTTON_TEXT")];
    
    
    NSArray *tempNumberOfProjects = @[@17,@7,@13,@132];
    NSDictionary *parameter = @{@"projectList":tempPorjectList,
                                @"numberOfProjects":tempNumberOfProjects};
    
    _projects = parameter;
    
}

- (void)reloadData {
    [_collectionView reloadData];
}

- (void)drawTopTriangle {
    
    //Screen Size for Y axiz
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    int height = 0;
    float width = (screenWidth * 0.25f) - 30;
    int triangleTopDirection = -1;
    
    int triangleSize =  9;
    
    UIColor *bgColor = DROPDOWN_PROJECTLIST_VIEW_SELECTTRACKINGLIST_BG_COLOR;
    CAShapeLayer *triangleTop = [[Utilities sharedIntances] drawDropDownTopTriangle:width backgroundColor:bgColor triangleTopDirection:triangleTopDirection heightPlacement:height sizeOfTriangle:triangleSize];
    
    [self.layer insertSublayer:triangleTop atIndex:1];
    
}

- (void)drawShadow {
 
    CGRect screenRect = self.view.frame;
    CGRect customDimRect = screenRect;
    
    if (isiPhone5) {
        customDimRect.size.height = screenRect.size.height - (screenRect.size.height * 0.22f);
        customDimRect.size.width = screenRect.size.width - (screenRect.size.width * 0.22f);
    }
    if (isiPhone6) {
      
        customDimRect.size.height = screenRect.size.height - (screenRect.size.height * 0.08f);
        customDimRect.size.width = screenRect.size.width - (screenRect.size.width * 0.08f);
    }
    
    if(isiPhone4){
        
        customDimRect.size.height = screenRect.size.height - (screenRect.size.height * 0.3f);
        customDimRect.size.width = screenRect.size.width - (screenRect.size.width * 0.2f);
        
    }
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:customDimRect];
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.view.layer.shadowOpacity = 0.5f;
    self.view.layer.shadowPath = shadowPath.CGPath;

    [self.view.layer setCornerRadius:5.0f];
}

#pragma mark - UICollectionView source and delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectListCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSArray *titleArray = _projects[@"projectList"];
    NSString *title = [titleArray objectAtIndex:indexPath.row];
    [cell.buttonProjectTrackList setTitle:title forState:UIControlStateNormal];
    
    NSArray *totalProjects = _projects[@"numberOfProjects"];
    NSString *totalProject = [totalProjects objectAtIndex:indexPath.row];
    
    cell.labelNumberOfProject.text = [NSString stringWithFormat:@"%@ %@",totalProject,NSLocalizedLanguage(@"DROPDOWNPROJECTLIST_NUMBERS_OF_PROJECT_LABEL_TEXT")];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_projects[@"projectList"] count];
}

#pragma mark - UIollection Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size;
    
    CGFloat cellWidth =  collectionView.frame.size.width;
    CGFloat cellHeight = collectionView.frame.size.height / 4;
    size = CGSizeMake( cellWidth, cellHeight);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [_dropDownProjectListDelegate selectedDropDownProjectList:indexPath];
    
}

@end
