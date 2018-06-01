//
//  NSString+JYFormAdditions.m
//  JYForm
//
//  Created by dqh on 2018/4/9.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "NSString+JYFormAdditions.h"
#import <UIKit/UIKit.h>

@implementation NSString (JYFormAdditions)

- (NSString *)stringByTrim
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

+ (NSString *)jy_localizedStringForKey:(NSString *)key
{
    NSLog(@"");
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language rangeOfString:@"zh-Hans"].location != NSNotFound) {
            language = @"zh-Hans";
        } else {
            language = @"en";
        }
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"JYForm" withExtension:@"bundle"];
        bundle = [NSBundle bundleWithURL:url];
        
        bundle = [NSBundle bundleWithPath:[bundle pathForResource:language ofType:@"lproj"]];
    }
    NSString *value1 = [bundle localizedStringForKey:key value:key table:nil];

    return value1;
}
@end
