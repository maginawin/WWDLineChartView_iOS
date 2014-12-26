//
//  WwdCharBarData.h
//  WWDChartLine
//
//  Created by maginawin on 14-12-26.
//  Copyright (c) 2014年 mycj.wwd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WwdCharBarData : NSObject

@property (nonatomic) int value;
@property (weak, nonatomic) NSString* key;

- (id)initWithValue:(int)value andKey:(NSString*)key;
@end
