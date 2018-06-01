//
//  JYFormTextView.m
//  JYForm
//
//  Created by dqh on 2018/4/26.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormTextView.h"

@implementation JYFormTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.scrollsToTop = NO;
        self.placeholder = @"";
        self.placeholderColor = [UIColor colorWithRed:.78 green:.78 blue:.8 alpha:1.];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if (self.placeholder.length == 0) {
        return;
    }
    if (self.text.length == 0) {
        _placeHolderLabel.alpha = 1.;
    } else {
        _placeHolderLabel.alpha = 0.;
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if (self.placeholder.length > 0) {
        if (_placeHolderLabel == nil) {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4., 8., self.bounds.size.width - 16., 0.)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0.;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0.;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        _placeHolderLabel.font = self.font;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    if (self.text.length == 0 && self.placeholder.length > 0) {
        _placeHolderLabel.alpha = 1.;
    }
    [super drawRect:rect];
}


@end
