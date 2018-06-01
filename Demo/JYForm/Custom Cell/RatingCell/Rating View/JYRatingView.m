//
//  JYRatingView.m
//  JYForm
//
//  Created by dqh on 2018/5/10.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYRatingView.h"

@implementation JYRatingView

- (instancetype)init
{
    if (self = [super init]) {
        [self customize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self customize];
    }
    return self;
}


- (void)customize
{
    self.baseColor = [UIColor colorWithRed:(205/255.0) green:(201/255.0) blue:(201/255.0) alpha:1];
    self.highlightColor = [UIColor colorWithRed:(255/255.0) green:(215/255.0) blue:0 alpha:1];
    self.markFont = [UIFont systemFontOfSize:23.0f];
    self.stepInterval = 1.0f;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
