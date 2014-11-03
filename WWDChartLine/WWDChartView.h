//
//  WWDChartView.h
//  testlayout
//
//  Created by maginawin on 14-10-29.
//  Copyright (c) 2014年 mycj.wwd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWDChartView : UIView<UIGestureRecognizerDelegate>

//初始化方法
- (void)initWWDChartViewWithYAxisCount:(NSInteger)yCount andYAxisMaxValue:(float)yMaxValue;

//添加一个值到以前的yValues,如果超出范围自动移动一个xInterval
- (void)addAValueToYValues:(NSString*)addValue atIndex:(NSInteger)index;

//添加新的线条
- (void)addAnotherChartViewWithArray:(NSArray*)addValues inColor:(UIColor*)lineColor;

//清除已经存在的chartView
- (void)clearChartViewExist;

//增大x的间隔,每次50%
- (void)zoominXInterval;

//缩小x的间隔,每次50%
- (void)zoomoutXInterval;

//将xInterval复位
- (void)resetXInterval;
@end
