//
//  CustomPieChart.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/2/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomPieChart.h"

#import "CustomPieChartLayer.h"

@interface CustomPieChart()<CustomPieChartLayerDelegate>{
    NSMutableDictionary *pieItems;
    BOOL isDrawn;
}
@property (weak, nonatomic) IBOutlet UIImageView *selectedSegmentImageView;
@end

@implementation CustomPieChart
@synthesize customPieChartDelegate;

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    pieItems = [[NSMutableDictionary alloc] init];
    
}

-(void)drawRect:(CGRect)rect {
    CGFloat currentAngle = 0;
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:YES selector:@selector(localizedStandardCompare:)];

    NSArray *keys = [pieItems.allKeys sortedArrayUsingDescriptors:@[ descriptor ]];
    for (NSString *tagItem in keys) {
        
        NSDictionary *item = pieItems[tagItem];
        CGFloat percent = [item[@"PERCENT"] floatValue];
        
        CustomPieChartLayer *layer = [CustomPieChartLayer new];
        
        layer.tagName = tagItem;
        layer.startAngle = currentAngle;
        layer.endAngle = currentAngle + (360.0 * (percent/100));
        layer.layerColor = item[@"COLOR"];
        layer.focusImage = item[@"IMAGE"];
        
        layer.focusImageView = _selectedSegmentImageView;
        currentAngle =layer.endAngle;
        layer.customPieChartLayerDelegate = self;
        
        layer.frame = self.bounds;
        [self.view.layer addSublayer:layer];
        [layer setNeedsDisplay];
        
    }
}

- (void)clearLegends {
    [pieItems removeAllObjects];
}

- (void)addPieItem:(NSString *)tagItem percent:(NSNumber *)percent legendColor:(UIColor *)legendColor  focusImage:(UIImage*)focusImage {
    pieItems[tagItem] = @{@"PERCENT":percent, @"COLOR":legendColor,@"IMAGE":focusImage};
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self.view];
        for (id sublayer in self.view.layer.sublayers) {
            if ([sublayer isKindOfClass:[CustomPieChartLayer class]]) {
                CustomPieChartLayer *chartLayer = sublayer;
                if (CGPathContainsPoint(chartLayer.piePath, 0, touchLocation, YES)) {
                    [chartLayer layerTapped];
                    
                }
            }
        }
    }
}

- (void)tappedPieSegmentLayer:(id)object {
    [self.customPieChartDelegate tappedPieSegment:object];
}

- (void)tappedPieSegmentByTagName:(NSString*)tagName {
    for (id sublayer in self.view.layer.sublayers) {
        if ([sublayer isKindOfClass:[CustomPieChartLayer class]]) {
            CustomPieChartLayer *chartLayer = sublayer;
            if ([chartLayer.tagName isEqualToString:tagName]) {
                [chartLayer layerTapped];
                return;
            }
        }
    }
    
}

@end
