//
//  ProjectBidsListViewController.h
//  lecet
//
//  Created by Michael San Minay on 02/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ProjectBidsListViewController : BaseViewController
- (void)setInfoForProjectBids:(NSArray *)bids;
- (void)setContractorName:(NSString *)name;
@end
