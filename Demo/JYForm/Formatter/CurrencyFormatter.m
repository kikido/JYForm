//
//  CurrencyFormatter.m
//  JYForm
//
//  Created by dqh on 2018/5/2.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "CurrencyFormatter.h"

@interface CurrencyFormatter()
@property (readonly) NSDecimalNumberHandler *roundingBehavior;
@end

@implementation CurrencyFormatter

- (id) init
{
    self = [super init];
    if (self) {
        [self setNumberStyle: NSNumberFormatterCurrencyStyle];
        [self setGeneratesDecimalNumbers:YES];
        
        NSUInteger currencyScale = [self maximumFractionDigits];
        
        _roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:currencyScale raiseOnExactness:false raiseOnOverflow:true raiseOnUnderflow:true raiseOnDivideByZero:true];
    }
    
    return self;
}

@end
