//
//  JYFloatLabeledTextFieldCell.m
//  JYForm
//
//  Created by dqh on 2018/5/10.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFloatLabeledTextFieldCell.h"
#import "JVFloatLabeledTextField.h"

NSString *const JYFormRowDescriptorTypeFloatLabeledTextField = @"JYFormRowDescriptorTypeFloatLabeledTextField";

const static CGFloat kFloatingLabelFontSize = 11.0;
const static CGFloat kVMargin = 8.0;


@interface JYFloatLabeledTextFieldCell()<UITextFieldDelegate>
@property (nonatomic, strong) JVFloatLabeledTextField *floatLabeledTextField;
@end

@implementation JYFloatLabeledTextFieldCell


+ (void)load
{
    [JYForm.cellClassesForRowDescriptorTypes setObject:[JYFloatLabeledTextFieldCell class] forKey:JYFormRowDescriptorTypeFloatLabeledTextField];
}

- (JVFloatLabeledTextField *)floatLabeledTextField
{
    if (_floatLabeledTextField == nil) {
        _floatLabeledTextField = [JVFloatLabeledTextField autolayoutView];
        _floatLabeledTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _floatLabeledTextField.floatingLabel.font = [UIFont boldSystemFontOfSize:kFloatingLabelFontSize];
        _floatLabeledTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _floatLabeledTextField.floatingLabelTextColor = kJYForm_Text_PlaceHolderColor;
        _floatLabeledTextField.floatingLabelActiveTextColor = self.tintColor;

    }
    return _floatLabeledTextField;
}

#pragma mark - JYLFormDescriptorCell

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.floatLabeledTextField];
    self.floatLabeledTextField.delegate = self;
    
    NSDictionary *views = @{@"textField" : self.floatLabeledTextField};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textField]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(vMargin)-[textField]-(vMargin)-|"
                                                                             options:0
                                                                             metrics:@{@"vMargin" : @(kVMargin)}
                                                                               views:views]];
}

- (void)update
{
    [super update];
    
    self.floatLabeledTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.rowDescriptor.title
                                                                                       attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    self.floatLabeledTextField.text = self.rowDescriptor.value ? [self.rowDescriptor.value displayText] : self.rowDescriptor.noValueDisplayText;
    self.floatLabeledTextField.enabled = !self.rowDescriptor.disabled;
    self.floatLabeledTextField.alpha = self.rowDescriptor.disabled ? .6 : 1;
}

- (BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return !self.rowDescriptor.disabled;
}

- (BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.floatLabeledTextField becomeFirstResponder];
}

+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(JYFormRowDescriptor *)rowDescriptor
{
    return 55.;
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
    return [self.form textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    return[self.form textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldDidChange:textField];
    return [self.form textFieldDidEndEditing:textField];
}

#pragma mark - Helpers

- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.floatLabeledTextField == textField) {
        if ([self.floatLabeledTextField.text length] > 0) {
            self.rowDescriptor.value = self.floatLabeledTextField.text;
        } else {
            self.rowDescriptor.value = nil;
        }
    }
}

@end
