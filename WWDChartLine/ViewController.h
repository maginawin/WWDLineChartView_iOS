//
//  ViewController.h
//  WWDChartLine
//
//  Created by maginawin on 14-11-3.
//  Copyright (c) 2014年 mycj.wwd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWDChartView.h"

@interface ViewController : UIViewController
- (IBAction)testadd:(id)sender;

@property (weak, nonatomic) IBOutlet WWDChartView *wwdChartView;

@end

