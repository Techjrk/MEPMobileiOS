//
//  ProjectTrackEditCollectionViewCell.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/20/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectTrackEditCollectionViewCell.h"

#import "projectTrackEditConstants.h"
#import "ProjectTrackItemView.h"

@interface ProjectTrackEditCollectionViewCell(){
    NSMutableDictionary *stateStatus;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageState;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation ProjectTrackEditCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    _labelTitle.font = PROJECT_TRACK_EDIT_TITLE_FONT;
    _labelTitle.textColor = PROJECT_TRACK_EDIT_TITLE_COLOR;
    
    _labelLocation.font = PROJECT_TRACK_EDIT_LOCATION_FONT;
    _labelLocation.textColor = PROJECT_TRACK_EDIT_LOCATION_COLOR;
    
}

- (void)setInfo:(NSMutableDictionary*)info {
    NSDictionary *project = info[kStateData];
    _labelTitle.text = project[@"title"];
    
    NSString *addr = @"";
    
    NSString *county = [DerivedNSManagedObject objectOrNil:project[@"county"]];
    NSString *state = [DerivedNSManagedObject objectOrNil:project[@"state"]];
    if (county != nil) {
        addr = [addr stringByAppendingString:county];
        
        if (state != nil) {
            addr = [addr stringByAppendingString:@", "];
        }
    }
    
    if (state != nil) {
        addr = [addr stringByAppendingString:state];
    }
    
    _labelLocation.text = addr;
    
    
    stateStatus = info[kStateStatus];
    

    BOOL isSelected = [stateStatus[kStateSelected] boolValue];
    
    _imageState.image = [UIImage imageNamed:isSelected?@"icon_stateSelected":@"icon_stateDeselected"];
}

@end
