//
//  JYFormDateCell.m
//  JYForm
//
//  Created by dqh on 2018/4/28.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormDateCell.h"
#import "JYFormDatePickerCell.h"

@interface JYFormDateCell() {
    UIColor *_beforeChangeColor;
}
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation JYFormDateCell

- (UIView *)inputView
{
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeDate] || [self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeTime] || [self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeDateTime] || [self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeCountDownTimer]) {
        if (self.rowDescriptor.value) {
            [self.datePicker setDate:self.rowDescriptor.value animated:[self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeCountDownTimer]];
        }
        [self setConfigToDatePicker:self.datePicker];
        return self.datePicker;
    }
    return [super inputView];
}

- (BOOL)canBecomeFirstResponder
{
    return !self.rowDescriptor.disabled;
}

- (BOOL)becomeFirstResponder
{
    if (self.isFirstResponder) {
        return [super becomeFirstResponder];
    }
    
    _beforeChangeColor = self.textLabel.textColor;
    
    BOOL result = [super becomeFirstResponder];
    if (result) {
        if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeDateInline]) {
            NSIndexPath *selectIndexPath = [self.rowDescriptor.sectionDescriptor.formDescriptor indexPathOfFormRow:self.rowDescriptor];
            
            JYFormSectionDescriptor *formSection = [self.form.formDescriptor.formSections objectAtIndex:selectIndexPath.section];
            JYFormRowDescriptor *datePickerRowDescriptor = [JYFormRowDescriptor formRowDescriptorWithTag:nil rowType:JYFormRowDescriptorTypeDatePicker];
            JYFormDatePickerCell *datePickerCell = (JYFormDatePickerCell *)[datePickerRowDescriptor cellForForm:self.form];
            [self setConfigToDatePicker:datePickerCell.datePicker];
            if (self.rowDescriptor.value) {
                [datePickerCell.datePicker setDate:self.rowDescriptor.value animated:NO];
            }
            NSAssert([datePickerCell conformsToProtocol:@protocol(JYFormInlineRowDescriptorCell)], @"inline cell must conform to JYFormInlineRowDescriptorCell");
            UITableViewCell<JYFormInlineRowDescriptorCell> *inlineCell = (UITableViewCell<JYFormInlineRowDescriptorCell> *)datePickerCell;
            inlineCell.inlineRowDescriptor = self.rowDescriptor;
            
            [formSection addFormRow:datePickerRowDescriptor afterRow:self.rowDescriptor];
            [self.form ensureRowIsVisible:datePickerRowDescriptor];
        }
    }
    return result;
}

- (BOOL)resignFirstResponder
{
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeDateInline]) {
        NSIndexPath *selectPath = [self.form.formDescriptor indexPathOfFormRow:self.rowDescriptor];
        NSIndexPath *nextRowPath = [NSIndexPath indexPathForRow:selectPath.row + 1 inSection:selectPath.section];
        JYFormRowDescriptor *nextRow = [self.form.formDescriptor formRowAtIndex:nextRowPath];
        if ([nextRow.rowType isEqualToString:JYFormRowDescriptorTypeDatePicker]) {
            [self.rowDescriptor.sectionDescriptor removeFormRow:nextRow];
        }
    }
    return [super resignFirstResponder];
}

#pragma mark - JYFormDescriptorCell

- (void)configure
{
    [super configure];
    self.dateFormatter = [[NSDateFormatter alloc] init];
}

- (void)update
{
    [super update];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.editingAccessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = self.rowDescriptor.disabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    self.textLabel.text = [NSString stringWithFormat:@"%@%@",self.rowDescriptor.title, self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle ? @"*" : @""];
    
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeDate]) {
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeTime]) {
        _dateFormatter.dateStyle = NSDateFormatterNoStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    else {
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    self.detailTextLabel.text = [self valueDisplayText];
}

- (void)formDescriptorCellDidSelectedWithForm:(JYForm *)form
{
    [self.form.tableView deselectRowAtIndexPath:[form.formDescriptor indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

- (BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return [self canBecomeFirstResponder];
}

- (BOOL)formDescriptorCellBecomeFirstResponder
{
    if (self.isFirstResponder) {
        return [self resignFirstResponder];
    }
    return [self becomeFirstResponder];
}

- (void)highlight
{
    [super highlight];
    self.textLabel.textColor = self.tintColor;
}

- (void)unhighlight
{
    [super unhighlight];
    self.textLabel.textColor = _beforeChangeColor;
}

#pragma mark - Helpers

- (void)setConfigToDatePicker:(UIDatePicker *)datePicker
{
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeDate] || [self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeDateInline]) {
        datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeTime]) {
        datePicker.datePickerMode = UIDatePickerModeTime;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeCountDownTimer]) {
        datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        datePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    else {
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    if (self.minuteInterval) {
        datePicker.minuteInterval = self.minuteInterval;
    }
    if (self.minimumDate) {
        datePicker.minimumDate = self.minimumDate;
    }
    if (self.maximumDate) {
        datePicker.maximumDate = self.maximumDate;
    }
    if (self.locale) {
        datePicker.locale = self.locale;
    }
}

- (NSString *)valueDisplayText
{
    return self.rowDescriptor.value ? [self formattedDate:self.rowDescriptor.value] : self.rowDescriptor.noValueDisplayText;
}

- (NSString *)formattedDate:(NSDate *)date
{
    if (self.rowDescriptor.valueTransformer) {
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer *valueFormatter = [self.rowDescriptor.valueTransformer new];
        NSString *transformValue = [valueFormatter transformedValue:self.rowDescriptor.value];
        if (transformValue) {
            return transformValue;
        }
    }
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeCountDownTimer]) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDateComponents *time = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
        return [NSString stringWithFormat:@"%ld%@ %ldmin", (long)[time hour], (long)[time hour] == 1 ? @"hour" : @"hours", (long)[time minute]];
    }
    return [_dateFormatter stringFromDate:date];
}

#pragma mark - Properties

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - Target Action

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    self.rowDescriptor.value = sender.date;
    [[self form] updateFormRow:self.rowDescriptor];
}

@end
