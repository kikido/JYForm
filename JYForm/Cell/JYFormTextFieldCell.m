//
//  JYFormTextFieldCell.m
//  JYForm
//
//  Created by dqh on 2018/4/17.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormTextFieldCell.h"
#import "UIView+JYFormAdditions.h"
#import "JYFormSectionDescriptor.h"
#import "JYFormDescriptor.h"

@interface JYFormTextFieldCell() <UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *dynamicCustomConstraints;
@end

@implementation JYFormTextFieldCell

@synthesize returnKeyType = _returnKeyType;
@synthesize nextReturnKeyType = _nextReturnKeyType;
@synthesize textLabel = _textLabel;

#pragma mark - KVO
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _returnKeyType = UIReturnKeyDefault;
        _nextReturnKeyType = UIReturnKeyNext;
    }
    return self;
}

- (void)dealloc
{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
}

#pragma mark - JYFormDescriptorCell

- (void)configure
{
    [super configure];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.textLabel) {
        _textLabel = [UILabel autolayoutView];
    }
    if (!self.textField) {
        _textField = [UITextField autolayoutView];
        _textField.textAlignment = NSTextAlignmentRight;
    }
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.textField];
    
    [self.contentView addConstraints:[self layoutConstraints]];
    
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)update
{
    [super update];
    
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;

    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeText]) {
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeName]) {
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeEmail]) {
        self.textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeNumber]) {
        self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeInteger]) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeDecimal]) {
        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypePassword]) {
        self.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.textField.secureTextEntry = YES;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypePassword]) {
        self.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeURL]) {
        self.textField.keyboardType = UIKeyboardTypeURL;
    }
    
    self.textLabel.text = (self.rowDescriptor.required && self.rowDescriptor.title && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle) ? [NSString stringWithFormat:@"%@*",self.rowDescriptor.title] : self.rowDescriptor.title;
    self.textField.text = self.rowDescriptor.value ? [self.rowDescriptor displayTextValue] : self.rowDescriptor.noValueDisplayText;
    [self.textField setEnabled:!self.rowDescriptor.disabled];
    self.textField.textColor = self.rowDescriptor.disabled ? kJYForm_Cell_DetailDisableTextColor : kJYForm_Cell_DetailTextColor;
    self.textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
#ifdef kJYForm_Cell_DetailTextFont
    self.textField.font = kJYForm_Cell_DetailTextFont;
#endif
}

- (BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return !self.rowDescriptor.disabled;
}

- (BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.textField becomeFirstResponder];
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
    NSMutableArray *results = @[].mutableCopy;

    [self.textLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [results addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[textField]-(margin)-|"
                                                                    options:NSLayoutFormatAlignAllBaseline
                                                                    metrics:@{@"margin" : @11.0}
                                                                      views:@{@"textField" : _textField}]];
    [results addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[textLabel]-(margin)-|"
                                                                    options:NSLayoutFormatAlignAllBaseline
                                                                    metrics:@{@"margin" : @11.0}
                                                                      views:@{@"textLabel" : _textLabel}]];
    return results.copy;
}

- (void)updateConstraints
{
    if (self.dynamicCustomConstraints) {
        [self.contentView removeConstraints:self.dynamicCustomConstraints];
    }
    NSDictionary *views = @{@"label" : self.textLabel, @"textField" : self.textField, @"image" : self.imageView};
    
    if (self.textLabel.text.length > 0) {
        self.dynamicCustomConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-[textField]-|" options:0 metrics:nil views:views].mutableCopy;
        [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:_textField
                                                                              attribute:NSLayoutAttributeWidth
                                                                              relatedBy:self.textFieldLengthPercentage ? NSLayoutRelationEqual : NSLayoutRelationGreaterThanOrEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeWidth
                                                                             multiplier:self.textFieldLengthPercentage ? [self.textFieldLengthPercentage floatValue] : 0.3
                                                                               constant:0.0]];
    } else {
        self.dynamicCustomConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textField]-|" options:0 metrics:nil views:views]];
    }
    [self.contentView addConstraints:self.dynamicCustomConstraints];
    
    [super updateConstraints];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return [self.form textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.form textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self.form textFieldShouldBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return [self.form textFieldShouldEndEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.textFieldMaxNumberOfCharacters) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length > self.textFieldMaxNumberOfCharacters.integerValue) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.form beginEditing:self.rowDescriptor];
    [self.form textFieldDidBeginEditing:textField];
    if (self.rowDescriptor.valueFormatter) {
        self.textField.text = [self.rowDescriptor editTextValue];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.rowDescriptor.valueFormatter) {
        self.textField.text = [self.rowDescriptor.value displayText];
    }
    [self.form endEditing:self.rowDescriptor];
    [self.form textFieldDidEndEditing:textField];
}

#pragma mark - Helper

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 0) {
        BOOL didUserFormatter = NO;
        
        if (self.rowDescriptor.valueFormatter && self.rowDescriptor.useValueFormatterDuringInput) {
            NSString *errorDescription = nil;
            NSString *objectValue = nil;
            
            if ([self.rowDescriptor.valueFormatter getObjectValue:&objectValue forString:textField.text errorDescription:&errorDescription]) {
                NSString *formatteValue = [self.rowDescriptor.valueFormatter stringForObjectValue:objectValue];
                self.rowDescriptor.value = objectValue;
                textField.text = formatteValue;
                didUserFormatter = YES;
            }
        }
        if (!didUserFormatter) {
            if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeNumber] || [self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeDecimal]) {
                self.rowDescriptor.value = [NSDecimalNumber decimalNumberWithString:textField.text locale:NSLocale.currentLocale];
            } else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeInteger]  ){
                self.rowDescriptor.value = @([self.textField.text integerValue]);
            } else {
                self.rowDescriptor.value = self.textField.text;
            }
        }
    } else {
        self.rowDescriptor.value = nil;
    }
}
@end

