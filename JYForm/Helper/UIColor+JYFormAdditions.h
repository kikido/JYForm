//
//  UIColor+JYFormAdditions.h
//  JYForm
//
//  Created by dqh on 2018/5/28.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

@interface UIColor (JYFormAdditions)

+ (UIColor *)colorWithHexString:(NSString *)hexStr;

@end
