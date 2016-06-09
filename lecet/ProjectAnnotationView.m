//
//  ProjectAnnotationView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/8/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectAnnotationView.h"

#import "ProjectPointAnnotation.h"

@implementation ProjectAnnotationView

@synthesize cargo;

- (BOOL)isPreBid {
    
    BOOL returnValue = YES;
    ProjectPointAnnotation *projectPoint = (ProjectPointAnnotation*)self.annotation;
    NSDictionary *dict = projectPoint.cargo;
    NSDictionary *projectStage = dict[@"projectStage"];
    if (projectStage != nil) {
        NSNumber *bidId = projectStage[@"parentId"];
        returnValue = bidId.integerValue == 102;
    }

    return returnValue;
}

@end
