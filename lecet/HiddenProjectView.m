//
//  HiddenProjectView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/13/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "HiddenProjectView.h"

#import "hiddenProjectCellConstants.h"

@interface HiddenProjectView()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation HiddenProjectView

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineView.backgroundColor = HIDDEN_PROJECT_CELL_LINE_COLOR;
}

- (void)setInfo:(id)info {
    
}

@end
