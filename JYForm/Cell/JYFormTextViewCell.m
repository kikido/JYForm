//
//  JYFormTextViewCell.m
//  JYForm
//
//  Created by dqh on 2018/4/26.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormTextViewCell.h"

@interface JYFormTextViewCell() <UITextViewDelegate>
@property (nonatomic, strong) NSMutableArray *dynamicCustomConstraints;
@end

@implementation JYFormTextViewCell

@synthesize textLabel = _textLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _dynamicCustomConstraints = @[].mutableCopy;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == self.textLabel && [keyPath isEqualToString:@"text"]) {
        if ([change[NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]) {
            NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
            NSString *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
            if (![newValue isEqual:oldValue]) {
                [self setNeedsUpdateConstraints];
            }
        }
    }
}

- (void)dealloc
{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
}

#pragma mark - properties

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [UILabel autolayoutView];
        [_textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
        [_textLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _textLabel;
}

- (JYFormTextView *)textView
{
    if (_textView == nil) {
        _textView = [JYFormTextView autolayoutView];
    }
    return _textView;
}

#pragma mark - JYFormDescriptorCell

- (void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.textView];
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    [self.contentView addConstraints:[self layoutConstraints]];
}

- (void)update
{
    [super update];
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.placeHolderLabel.font = self.textView.font;
    self.textView.delegate = self;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.text = self.rowDescriptor.value;
    [self.textView setEditable:!self.rowDescriptor.disabled];
    self.textView.textColor = self.rowDescriptor.disabled ? kJYForm_Cell_DetailDisableTextColor : kJYForm_Cell_DetailTextColor;
    self.textLabel.text = (self.rowDescriptor.required && self.rowDescriptor.title && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle) ? [NSString stringWithFormat:@"%@*",self.rowDescriptor.title] : self.rowDescriptor.title;
    
#ifdef kJYForm_Cell_DetailTextFont
    self.textView.font = kJYForm_Cell_DetailTextFont;
#endif
}

+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(JYFormRowDescriptor *)rowDescriptor
{
    return 110.0f;
}

- (BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return !self.rowDescriptor.disabled;
}

- (BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.textView becomeFirstResponder];
}

- (void)highlight
{
    [super highlight];
    self.textLabel.textColor = self.tintColor;
}

- (void)unhighlight
{
    [super unhighlight];
    [self.form updateFormRow:self.rowDescriptor];
}

#pragma mark - LayoutConstraints

- (NSArray *)layoutConstraints
{
    NSMutableArray *jy = @[].mutableCopy;
    NSDictionary *views = @{@"textLabel" : self.textLabel, @"textView" : self.textView};
    
    [self.textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.textLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    
    [jy addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[textLabel]"
                                                                    options:NSLayoutFormatAlignAllLastBaseline
                                                                    metrics:nil
                                                                      views:views]];
    [jy addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[textView]-0-|"
                                                                    options:NSLayoutFormatAlignAllLastBaseline
                                                                    metrics:nil
                                                                      views:views]];
    [jy addObject:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [jy addObject:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    return jy.copy;
}

- (void)updateConstraints
{
    if (_dynamicCustomConstraints) {
        [self.contentView removeConstraints:_dynamicCustomConstraints];
        [_dynamicCustomConstraints removeAllObjects];
    }
    NSDictionary *views = @{@"textLabel" : self.textLabel, @"textView" : self.textView};
    
    if (!self.textLabel.text || [self.textLabel.text isEqualToString:@""]) {
        [_dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView]-|"
                                                                                     options:NSLayoutFormatAlignAllLastBaseline
                                                                                     metrics:nil
                                                                                       views:views]];
    } else {
        [_dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-[textView]-|"
                                                                                               options:0
                                                                                               metrics:0
                                                                                                 views:views]];
        if (self.textViewLengthPercentage) {
            [_dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:[self.textViewLengthPercentage floatValue] constant:0.]];
        }
    }
    [self.contentView addConstraints:_dynamicCustomConstraints];
    [super updateConstraints];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.form beginEditing:self.rowDescriptor];
    [self.form textViewDidBeginEditing:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.textView.text.length > 0) {
        self.rowDescriptor.value = self.textView.text;
    } else {
        self.rowDescriptor.value = nil;
    }
    [self.form endEditing:self.rowDescriptor];
    [self.form textViewDidEndEditing:textView];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return [self.form textViewShouldBeginEditing:textView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.textView.text.length > 0) {
        self.rowDescriptor.value = self.textView.text;
    } else {
        self.rowDescriptor.value = nil;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.textViewMaxNumberOfCharacters) {
        NSString *newTextString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if (newTextString.length > [self.textViewMaxNumberOfCharacters integerValue]) {
            return NO;
        }
    }
    return [self.form textView:textView shouldChangeTextInRange:range replacementText:text];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
