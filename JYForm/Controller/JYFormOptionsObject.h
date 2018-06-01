//
//  JYFormOptionsObject.h
//  JYForm
//
//  Created by dqh on 2018/4/27.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYFormOptionsObject : NSObject
@property (nonatomic, copy) NSString *formDisplaytext;
@property (nonatomic, assign) id formValue;


/**
 创建一个JYFormOptionsObject实例，指定其value以及formDisplaytext
 
 */
+(JYFormOptionsObject *)formOptionsObjectWithValue:(id)value displayText:(NSString *)displayText;



/**
 创建一个数组，元素均为JYFormOptionsObject实例。values与displayTexts同一个索引的元素需要一一对应

 */
+ (NSArray<JYFormOptionsObject *> *)formOptionsObjectsWithValues:(NSArray *)values displayTexts:(NSArray *)displayTexts;
@end
