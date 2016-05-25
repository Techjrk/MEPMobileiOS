//
//  DB_Project.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/23/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "DB_Project.h"

@implementation DB_Project

- (NSString *)getProjectType {
    NSString *projectType = [NSString stringWithFormat:@"%@ %@ %@", self.primaryProjectTypeTitle==nil?@"":self.primaryProjectTypeTitle, self.projectCategoryTitle==nil?@"":self.projectCategoryTitle, self.projectGroupTitle==nil?@"":self.projectGroupTitle];

    return projectType;
}
@end
