//
//  ProjectAnnotationView.h
//  lecet
//
//  Created by Harry Herrys Camigla on 6/8/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ProjectAnnotationView : MKAnnotationView
@property (copy, nonatomic) id cargo;
@property (nonatomic) BOOL isPreBid;
@end
