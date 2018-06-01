//
//  JYFormTextView.h
//  JYForm
//
//  Created by dqh on 2018/4/26.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYFormTextView : UITextView
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end
