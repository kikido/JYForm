//
//  JYFormTextViewCell.h
//  JYForm
//
//  Created by dqh on 2018/4/26.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormBaseCell.h"
#import "JYFormTextView.h"

@interface JYFormTextViewCell : JYFormBaseCell
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) JYFormTextView *textView;

@property (nonatomic) NSNumber *textViewLengthPercentage;
@property (nonatomic) NSNumber *textViewMaxNumberOfCharacters;
@end
