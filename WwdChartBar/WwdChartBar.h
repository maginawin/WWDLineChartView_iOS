//
//  WwdChartBar.h
//  WWDChartLine
//
//  Created by maginawin on 14-12-26.
//  Copyright (c) 2014年 mycj.wwd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WwdCharBarData.h"

@interface WwdChartBar : UIView
@property (nonatomic) NSInteger endYaxisValue; //Y轴的最大值
@property (strong, nonatomic) UIColor* barColor; //线条的颜色
@property (nonatomic) CGFloat barWidth; //线条的宽度
@property (strong, nonatomic) UIColor* axisColor; //xy轴的颜色
@property (strong, nonatomic) UIColor* textColor; //字的颜色
@property (strong, nonatomic) UIColor* bgColor; //view的背景颜色

- (void)drawBarWithArray:(NSArray*)valueAndKeyArray; //传入一零点键值词典,用来绘制bar与bar下的字

- (void)test1;
@end
