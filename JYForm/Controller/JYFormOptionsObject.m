//
//  JYFormOptionsObject.m
//  JYForm
//
//  Created by dqh on 2018/4/27.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormOptionsObject.h"

@implementation JYFormOptionsObject

- (instancetype)initWithValue:(id)value displayText:(NSString *)displayText
{
    if (self = [super init]){
        self.formValue = value;
        self.formDisplaytext = displayText;
    }
    return self;
}

+ (JYFormOptionsObject *)formOptionsObjectWithValue:(id)value displayText:(NSString *)displayText
{
    return [[JYFormOptionsObject alloc] initWithValue:value displayText:displayText];
}

+ (NSArray<JYFormOptionsObject *> *)formOptionsObjectsWithValues:(NSArray *)values displayTexts:(NSArray *)displayTexts
{
    if (values.count != displayTexts.count) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"values count must be the same with displayTexts count" userInfo:nil];
    }
    NSMutableArray *results = @[].mutableCopy;
    for (NSInteger i = 0; i < values.count; i++) {
        JYFormOptionsObject *optionObject = [[JYFormOptionsObject alloc] initWithValue:values[i] displayText:displayTexts[i]];
        [results addObject:optionObject];
    }
    return results.copy;
}

@end
