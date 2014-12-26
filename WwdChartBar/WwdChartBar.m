//
//  WwdChartBar.m
//  WWDChartLine
//
//  Created by maginawin on 14-12-26.
//  Copyright (c) 2014年 mycj.wwd. All rights reserved.
//

#import "WwdChartBar.h"

#define LEFT_INTERVAL 40
#define BOTTOM_INTERVAL 20
#define BAR_WIDTH 20
#define BAR_INTERVAL 16
#define YAXIS_COUNT 5

@implementation WwdChartBar
int test = 0;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initMethod];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMethod];
    }
    return self;
}

- (void)initMethod{
    _endYaxisValue = 100;
    _barColor = [UIColor redColor];
    _barWidth = 16;
    _axisColor = [UIColor blackColor];
    _textColor = [UIColor blackColor];
    _bgColor = [UIColor whiteColor];
    self.backgroundColor = _bgColor;
}

- (void)drawRect:(CGRect)rect{
    WwdCharBarData* data1 = [[WwdCharBarData alloc]initWithValue:100 andKey:@"21"];
    WwdCharBarData* data2 = [[WwdCharBarData alloc]initWithValue:150 andKey:@"22"];
    WwdCharBarData* data3 = [[WwdCharBarData alloc]initWithValue:200 andKey:@"23"];
    WwdCharBarData* data4 = [[WwdCharBarData alloc]initWithValue:100 andKey:@"24"];
    WwdCharBarData* data5 = [[WwdCharBarData alloc]initWithValue:150 andKey:@"25"];
    WwdCharBarData* data6 = [[WwdCharBarData alloc]initWithValue:200 andKey:@"26"];
    WwdCharBarData* data7 = [[WwdCharBarData alloc]initWithValue:24 andKey:@"27"];
    
    NSArray* testArray = [[NSArray alloc] initWithObjects:data1, data2, data3, data4, data5, data6, data7, nil];
    [self drawBarWithArray:testArray];
}

- (void)testAddBar:(CGContextRef)ctx{
    test++;
    CGFloat height = self.frame.size.height;
    for (int i = 1; i <= test; i++) {
        
        CGContextBeginPath(ctx);
        const CGPoint points1[] = {CGPointMake((BAR_WIDTH + BAR_INTERVAL) * i, height), CGPointMake((BAR_WIDTH + BAR_INTERVAL) * i, 80)};
        
        CGContextAddLines(ctx, points1, 2);
        CGContextSetLineWidth(ctx, BAR_WIDTH);
        CGContextSetStrokeColorWithColor(ctx, _barColor.CGColor);
        CGContextStrokePath(ctx);
        //        CGContextClosePath(ctx);
    }
   
    
//    [self setNeedsDisplay];
}

- (void)test1{
    [self setNeedsDisplay];
}

- (void)drawBarWithArray:(NSArray*)valueAndKeyArray{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat contentWidth = BAR_WIDTH + BAR_INTERVAL;
    CGFloat halfContentWidth = contentWidth / 2 + LEFT_INTERVAL; //算上了左边的空白间隔
    CGFloat yZero = height - BOTTOM_INTERVAL; //去掉了底部的空白
    CGFloat contentHeight = height - BOTTOM_INTERVAL * 3;
    CGFloat perYaxisHeight = contentHeight / YAXIS_COUNT; //把Y轴分段
    CGFloat maxDataValue = 0;
    for (int i = 0; i < valueAndKeyArray.count; i++) {
        WwdCharBarData* barData = [valueAndKeyArray objectAtIndex:i];
        if (maxDataValue < barData.value) {
            maxDataValue = barData.value;
        }
    }
    CGFloat perYaxisValue = maxDataValue / contentHeight; //计算y轴每像素的值
    
    //画bar
    CGContextSetLineWidth(ctx, BAR_WIDTH);
    CGContextSetStrokeColorWithColor(ctx, _barColor.CGColor);
    for (int i = 0; i < valueAndKeyArray.count; i++) {
        WwdCharBarData* barData = [valueAndKeyArray objectAtIndex:i];
        CGFloat yTop = yZero - barData.value / perYaxisValue; //计算出实际应该的高度
        CGContextBeginPath(ctx);
        const CGPoint points1[] = {CGPointMake(contentWidth * i + halfContentWidth, yZero), CGPointMake(contentWidth * i + halfContentWidth, yTop)};
        CGContextAddLines(ctx, points1, 2);
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
    }
    
    
    //画left_interval
    CGContextSetFillColorWithColor(ctx, _bgColor.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, LEFT_INTERVAL, height));
    
    //画x,y轴
    CGContextSetLineWidth(ctx, 2);
    CGContextSetStrokeColorWithColor(ctx, _axisColor.CGColor);
    const CGPoint pointsXY[] = {CGPointMake(LEFT_INTERVAL - 1, BOTTOM_INTERVAL),CGPointMake(LEFT_INTERVAL - 1, yZero + 2), CGPointMake(LEFT_INTERVAL - 2, yZero + 1), CGPointMake(width - BOTTOM_INTERVAL, yZero + 1)};
    CGContextStrokeLineSegments(ctx, pointsXY, 4);
    
    //画y轴上的小线段
    CGContextSetLineWidth(ctx, 1);
    for (int j = 1; j <= YAXIS_COUNT; j++) {
        const CGPoint pointsYpoints[] = {CGPointMake(LEFT_INTERVAL, yZero - perYaxisHeight * j), CGPointMake(LEFT_INTERVAL + 3, yZero - perYaxisHeight * j)};
        CGContextStrokeLineSegments(ctx, pointsYpoints, 2);
    }
    
    //写x轴,y轴,值,星期几的text
    CGFloat yAxisValueTemp = maxDataValue / YAXIS_COUNT / 3600;
    for (int i = 0; i <= YAXIS_COUNT; i++) {
        NSString* yAxisValueStr = [NSString stringWithFormat:@"%.2f", i * yAxisValueTemp];
        int count = yAxisValueStr.length;
        if(count == 4){
            yAxisValueStr = [NSString stringWithFormat:@" %@", yAxisValueStr];
        }else if(count == 3){
            yAxisValueStr = [NSString stringWithFormat:@"  %@", yAxisValueStr];
        }
        [yAxisValueStr drawAtPoint:CGPointMake(4, yZero - i * perYaxisHeight - 8) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, _textColor, NSForegroundColorAttributeName, nil]];
//        NSLog(@"y:%@",yAxisValueStr);
    }
    NSString* hourStr = @"(H)";
    [hourStr drawAtPoint:CGPointMake(20, BOTTOM_INTERVAL - 10) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, _textColor, NSForegroundColorAttributeName, nil]];
    
}

- (void)testLayer:(CALayer*)subLayer{
    //    CALayer* subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor magentaColor].CGColor;
    subLayer.cornerRadius = 8;
    subLayer.borderWidth = 2;
    subLayer.borderColor = [UIColor blackColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(4, 5);
    subLayer.shadowRadius = 1;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOpacity = 0.8;
    subLayer.frame = CGRectMake(30, 30, 80, 160);
    [self.layer addSublayer:subLayer];
}

- (void)testLayer1:(CALayer*)subLayer{
    //    CALayer* subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor yellowColor].CGColor;
    subLayer.cornerRadius = 8;
    subLayer.borderWidth = 2;
    subLayer.borderColor = [UIColor blackColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(4, 5);
    subLayer.shadowRadius = 1;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOpacity = 0.8;
    subLayer.frame = CGRectMake(30, 30, 160, 80);
    [self.layer addSublayer:subLayer];
}


@end
