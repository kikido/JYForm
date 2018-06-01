//
//  JYFormRatingCell.h
//  JYForm
//
//  Created by dqh on 2018/5/10.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormBaseCell.h"
#import "JYRatingView.h"

extern NSString *const JYFormRowDescriptorTypeRate;

@interface JYFormRatingCell : JYFormBaseCell
@property (nonatomic, strong) JYRatingView *ratingView;
@property (nonatomic, strong) UILabel *rateTitle;
@end
