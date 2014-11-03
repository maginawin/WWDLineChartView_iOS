//
//  WWDChartView.m
//  testlayout
//
//  Created by maginawin on 14-10-29.
//  Copyright (c) 2014年 mycj.wwd. All rights reserved.
//

#import "WWDChartView.h"
#import <math.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#define BOTTOM_INTERVAL 20 //x轴与底框的间隔
#define LEFT_INTERVAL 30 //y轴与左框的间隔

@interface WWDChartView()

@property (nonatomic, strong) NSMutableArray* allYValues;
@property (nonatomic, strong) NSMutableArray* allColors;
@property (nonatomic, strong) NSArray* yValues;
@property (nonatomic, strong) UIColor* lineColor;
@property (nonatomic, strong) NSMutableArray* xValues;
@property (nonatomic, strong) NSMutableArray* xLocations;
@property (nonatomic, assign) CGContextRef ctx;
@property (nonatomic, assign) NSInteger yAxisCount;
@property (nonatomic, assign) NSInteger yAxisMaxValue;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) float xInterval;
@property (nonatomic, assign) float contentScrollX;
@property (nonatomic, assign) float chartLineWidth;
@property (nonatomic, assign) NSInteger xAxisMaxCount;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) float autoDiff;

@end

@implementation WWDChartView
CGPoint lastPoint; //最后的节点
//float width; //视图的宽度
//float height; //视图的高度
//float xInterval; //x轴的间隔
//float contentScrollX; //x轴移动的距离
//CGContextRef ctx; //绘图上下文
//float chartLineWidth; //线宽
//NSInteger yAxisCount; //y轴节点个数
//NSInteger yAxisMaxValue; //y轴节点元素最大值
//NSInteger xAxisMaxCount;
//NSInteger maxCount; //x数实际最多的个数
//float autoDiff;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self initMethod];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self initMethod];
    return self;
}

- (void)initMethod{
    //    width = self.bounds.size.width;
    //    height = self.bounds.size.height;
    lastPoint = CGPointMake(LEFT_INTERVAL, _height - BOTTOM_INTERVAL);
    //    yAxisCount = 5;
    //    yAxisMaxValue = 100;
    //    lineColor = [UIColor colorWithRed:255/255.0 green:44/255.0 blue:85/255.0 alpha:1];
    //    yValues = [[NSArray alloc]initWithObjects:@"40",@"100",@"20",@"10",@"25",@"30",@"10",@"25",@"30",@"10",@"80",@"30",@"10",@"50",@"30", nil];
    _xInterval = 20;
    _chartLineWidth = 2;
    _contentScrollX = 0;
    _allYValues = [[NSMutableArray alloc] init];
    _allColors = [[NSMutableArray alloc] init];
    _xValues = [[NSMutableArray alloc] init];
    _xLocations = [[NSMutableArray alloc] init];
    NSLog(@"init method");
}

//初始化方法
- (void)initWWDChartViewWithYAxisCount:(NSInteger)yCount andYAxisMaxValue:(float)yMaxValue{
    _yAxisCount = yCount;
    _yAxisMaxValue = yMaxValue;
}

- (void)drawRect:(CGRect)rect{
    _width = self.bounds.size.width;
    _height = self.bounds.size.height;
    self.clearsContextBeforeDrawing = NO; //设置每次绘制前清除
    _ctx = UIGraphicsGetCurrentContext(); // 获取绘图上下文
    float yInterval = (_height - BOTTOM_INTERVAL) / (_yAxisCount + 1); //求出y轴元素间的间隔
    float yPerValue = _yAxisMaxValue / _yAxisCount; //每一格y的值
    _xAxisMaxCount = (_width - LEFT_INTERVAL) / _xInterval; // x轴最多元素个数
    _maxCount = 0;
    
    //绘制曲线
    NSUInteger allYCount = _allYValues.count;
    if (allYCount > 0) {
        
        //设置线段的端点形状: 圆形kCGLineCapRound, 方形kCGLineCapSquare
        CGContextSetLineCap(_ctx, kCGLineCapRound);
        CGContextSetLineWidth(_ctx, _chartLineWidth); //设置线宽
        
        for (int j = 0; j < allYCount; j++) {
            
            NSArray* temp = [NSArray arrayWithArray:[_allYValues objectAtIndex:j]];
            if (_maxCount < temp.count) {
                _maxCount = temp.count;
            }
        }
        NSInteger diff = _maxCount - _xAxisMaxCount - 1;
        _autoDiff = 0;
        if (diff >= 0) {
            _autoDiff = _xInterval * diff;
        }else{
            _autoDiff = 0;
        }
        
        for (int j = 0; j < allYCount; j++) {
            _yValues = [_allYValues objectAtIndex:j];
            _lineColor = [_allColors objectAtIndex:j];
            CGColorRef cgColorRef = [_lineColor CGColor]; //用UIColor*取得CGColorRef
            CGContextSetStrokeColorWithColor(_ctx, cgColorRef);
            NSUInteger yCount = _yValues.count;
            [_xLocations removeAllObjects];
            if (yCount > 1) {
                for (int i = 0; i < yCount - 1; i++) {
                    NSLog(@"i:%d,max:%ld",i,(long)_xAxisMaxCount);
                    float xValue1 = i * _xInterval + _contentScrollX - _autoDiff;
                    float xValue2 = (i + 1) * _xInterval + _contentScrollX - _autoDiff;
                    float yValue1 = [[_yValues objectAtIndex:i] floatValue];
                    float yValue2 = [[_yValues objectAtIndex:(i + 1)]floatValue];
                    
                    float x1 = xValue1 + LEFT_INTERVAL;
                    float y1 = _height - (yValue1 / yPerValue) * yInterval - BOTTOM_INTERVAL;
                    float x2 = xValue2 + LEFT_INTERVAL;
                    float y2 = _height - (yValue2 / yPerValue) * yInterval - BOTTOM_INTERVAL;
                    
                    [_xLocations addObject:[NSString stringWithFormat:@"%f", x2 - 8]];
                    NSLog(@"xLocations: %d", _xLocations.count);
                    
                    const CGPoint xyPoints[] = {CGPointMake(x1, y1), CGPointMake(x2, y2)};
                    CGContextStrokeLineSegments(_ctx, xyPoints, 2);
                }
            }else{
                
            }
        }
    }
    
    //绘制x轴元素的字
    CGContextSetLineWidth(_ctx, 1); //设置画笔线条粗细
    if (_xInterval == 20 && _xValues.count == _xLocations.count + 1) {
        for(int i = 1; i < _xValues.count; i++){
            NSString* xValue = [_xValues objectAtIndex:i];
            float xLocation = [[_xLocations objectAtIndex:i - 1] floatValue];
            [xValue drawAtPoint:CGPointMake(xLocation, _height - BOTTOM_INTERVAL + 4) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [UIColor colorWithRed:90/255.0 green:200/255.0 blue:251/255.0 alpha:1], NSForegroundColorAttributeName, nil]];
        }
    }
    
    //处理y轴左边空白
    float leftBlackWidth = LEFT_INTERVAL - 1;
    float halfLeftBlackWidth = leftBlackWidth / 2;
    CGContextSetLineWidth(_ctx, leftBlackWidth); //设置线宽
    //    CGContextSetRGBStrokeColor(ctx, 239/255.0, 239/255.0, 244/255.0, 1); //设置颜色
    CGContextSetRGBStrokeColor(_ctx, 1, 1, 1, 1); //设置颜色
    const CGPoint blackPoints[] = {CGPointMake(halfLeftBlackWidth, _height), CGPointMake(halfLeftBlackWidth, 0)};
    CGContextStrokeLineSegments(_ctx, blackPoints, 2); //绘制
    
    //定义4个点, 绘制x, y轴
    CGContextSetLineWidth(_ctx, 2);
    CGContextSetRGBStrokeColor(_ctx, 90/255.0, 200/255.0, 251/255.0, 1); //设置x,y轴颜色
    const CGPoint xyPoints[] = {CGPointMake(LEFT_INTERVAL, _height - BOTTOM_INTERVAL), CGPointMake(LEFT_INTERVAL, 10), CGPointMake(LEFT_INTERVAL, _height - BOTTOM_INTERVAL), CGPointMake(_width, _height - BOTTOM_INTERVAL)};
    //设置线段的端点形状: 圆形kCGLineCapRound, 方形kCGLineCapSquare
    CGContextSetLineCap(_ctx, kCGLineCapRound);
    CGContextStrokeLineSegments(_ctx, xyPoints, 4); //绘制x, y轴
    
    //绘制y轴节点, 0,0点不计入count数
    for (int i = 1; i <= _yAxisCount; i++) {
        float yValue = _height - i * yInterval - BOTTOM_INTERVAL;
        const CGPoint yCountPoints[] = {CGPointMake(LEFT_INTERVAL, yValue), CGPointMake(LEFT_INTERVAL + 1.5, yValue)};
        CGContextStrokeLineSegments(_ctx, yCountPoints, 2);
    }
    
    //绘制y轴元素的字
    CGContextSetLineWidth(_ctx, 1); //设置画笔线条粗细
    NSInteger yAvgValue = _yAxisMaxValue / _yAxisCount; //平均每个元素的增值
    for (int i = 0; i <= _yAxisCount; i++) {
        NSInteger yAxisTextValue = i * yAvgValue;
        NSString* yAxisText = nil;
        if (yAxisTextValue < 10) {
            yAxisText = [NSString stringWithFormat:@"    %d", i * yAvgValue];
        }else if(yAxisTextValue < 100){
            yAxisText = [NSString stringWithFormat:@"  %d", i * yAvgValue];
        }else{
            yAxisText = [NSString stringWithFormat:@"%d", i * yAvgValue];
        }
        
        [yAxisText drawAtPoint:CGPointMake(4, _height - i * yInterval - BOTTOM_INTERVAL - 8) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [UIColor colorWithRed:90/255.0 green:200/255.0 blue:251/255.0 alpha:1], NSForegroundColorAttributeName, nil]];
    }
    
    NSLog(@"%d, %d", _xValues.count, _xLocations.count);
    
}

#pragma mark -
#pragma mark touch handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation=[[touches anyObject] locationInView:self];
    CGPoint prevouseLocation=[[touches anyObject] previousLocationInView:self];
    float xDiffrance = touchLocation.x - prevouseLocation.x;
    //    float xMaxLength = maxCount * xInterval;
    //    float xDiffMax = xMaxLength - (width - LEFT_INTERVAL) / 2;
    //    float xDiffMin = (LEFT_INTERVAL - width) / 2;
    //    autoDiff = 0;
    _contentScrollX += xDiffrance;
    //    if (contentScrollX > xDiffMax) {
    //        contentScrollX = xDiffMax;
    //    }else if(contentScrollX < xDiffMin){
    //        contentScrollX = xDiffMin;
    //    }
    //
    [self setNeedsDisplay];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

//添加一个值到以前的yValues,如果超出范围自动移动一个xInterval
- (void)addAValueToYValues:(NSString*)addValue atIndex:(NSInteger)index{
    if (_allYValues.count < index + 1 ) {
        return;
    }
    _contentScrollX = 0;
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:[_allYValues objectAtIndex:index]];
    [tempArray addObject:addValue];
    [_allYValues replaceObjectAtIndex:index withObject:tempArray];
    [self setNeedsDisplay];
}

//添加新的线条
- (void)addAnotherChartViewWithArray:(NSArray*)values inColor:(UIColor*)color{
    _contentScrollX = 0;
    [_allYValues addObject:values];
    [_allColors addObject:color];
    [self setNeedsDisplay];
}

//添加或更新x轴的值,传入一个NSArray
- (void)addXArray:(NSArray*)xArray{
    [_xValues removeAllObjects];
    [_xValues addObjectsFromArray:xArray];
}

//清除已经存在的chartView
- (void)clearChartViewExist{
    _contentScrollX = 0;
    [_allYValues removeAllObjects];
    [_allColors removeAllObjects];
    [self setNeedsDisplay];
}

//增大x的间隔,每次50%
- (void)zoominXInterval{
    _contentScrollX = 0;
    _xInterval = _xInterval * 0.5;
    [self setNeedsDisplay];
}

//缩小x的间隔,每次50%
- (void)zoomoutXInterval{
    _contentScrollX = 0;
    _xInterval = _xInterval * 2;
    [self setNeedsDisplay];
}

//将xInterval复位
- (void)resetXInterval{
    _contentScrollX = 0;
    _xInterval = 20;
    [self setNeedsDisplay];
}

@end
