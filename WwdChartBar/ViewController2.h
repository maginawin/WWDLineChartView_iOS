//
//  ViewController2.h
//  WWDChartLine
//
//  Created by maginawin on 14-12-26.
//  Copyright (c) 2014年 mycj.wwd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WwdChartBar.h"

@interface ViewController2 : UIViewController
@property (weak, nonatomic) IBOutlet WwdChartBar *chartBarView;

- (IBAction)testAdd:(id)sender;
@end
