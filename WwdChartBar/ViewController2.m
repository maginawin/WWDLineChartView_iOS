//
//  ViewController2.m
//  WWDChartLine
//
//  Created by maginawin on 14-12-26.
//  Copyright (c) 2014年 mycj.wwd. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)testAdd:(id)sender {
    [_chartBarView test1];
//    [UIView beginAnimations:@"animation" context:nil];
//    [UIView setAnimationDuration:1.0f];
//    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    [UIView commitAnimations];
    CATransition* transition = [CATransition animation];
    transition.duration = 2.0f;
    transition.type = @"pageCurl";
    transition.subtype = kCATransitionFromLeft;
    [_chartBarView.layer addAnimation:transition forKey:@"animation"];
//    [_chartBarView exerciseAmbiguityInLayout];
}
@end
