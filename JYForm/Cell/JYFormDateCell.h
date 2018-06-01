//
//  JYFormDateCell.h
//  JYForm
//
//  Created by dqh on 2018/4/28.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormBaseCell.h"

@interface JYFormDateCell : JYFormBaseCell
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, assign) NSInteger minuteInterval;
@property (nonatomic, strong) NSLocale *locale;
@end
