//
//  ViewController.m
//  WWDChartLine
//
//  Created by maginawin on 14-11-3.
//  Copyright (c) 2014年 mycj.wwd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

        
    [_wwdChartView initWWDChartViewWithYAxisCount:5 andYAxisMaxValue:100.f];
    NSArray* yValues = [[NSArray alloc]initWithObjects:@"40",@"100",@"20",@"10",@"25",@"30",@"10",@"25",@"30",@"10",@"80",@"30",@"10",@"50",@"30", nil];
    [_wwdChartView addAnotherChartViewWithArray:yValues inColor:[UIColor grayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
