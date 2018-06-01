//
//  NSString+JYFormAdditions.h
//  JYForm
//
//  Created by dqh on 2018/4/9.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYFormDescriptorDelegate.h"

@interface NSString (JYFormAdditions)

+ (NSString *)jy_localizedStringForKey:(NSString *)key;

- (NSString *)stringByTrim;
@end
