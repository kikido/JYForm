//
//  JYFormSelectorCell.m
//  JYForm
//
//  Created by dqh on 2018/4/26.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormSelectorCell.h"
#import "JYFormOptionsViewController.h"
#import "NSObject+JYFormAdditions.h"

@interface JYFormSelectorCell() <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation JYFormSelectorCell


- (NSString *)valueDisplayText
{
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeMultipleSelector]) {
        if (!self.rowDescriptor.value || [self.rowDescriptor.value count] == 0) {
            return self.rowDescriptor.noValueDisplayText;
        }
        if (self.rowDescriptor.valueTransformer) {
            NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
            NSValueTransformer *valueTransformer = [self.rowDescriptor.valueTransformer new];
            NSString *transformValue = [valueTransformer transformedValue:[self.rowDescriptor.value valueData]];
            if (transformValue) {
                return transformValue;
            }
        }
        NSMutableArray *descriptionArray = @[].mutableCopy;
        for (JYFormOptionsObject *optionObject in self.rowDescriptor.selectorOptions) {
            NSInteger index = NSNotFound;
            for (JYFormOptionsObject *selectObject in self.rowDescriptor.value) {
                if ([[selectObject valueData] isEqual:[optionObject valueData]]) {
                    index = [self.rowDescriptor.value indexOfObject:selectObject];
                }
            }
            if (index != NSNotFound) {
                if (self.rowDescriptor.valueTransformer) {
                    NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                    NSValueTransformer *valueTransformer = [self.rowDescriptor.valueTransformer new];
                    NSString *transformValue = [valueTransformer transformedValue:optionObject.displayText];
                    if (transformValue) {
                        [descriptionArray addObject:transformValue];
                    }
                } else {
                    [descriptionArray addObject:[optionObject displayText]];
                }
            }
        }
        return [descriptionArray componentsJoinedByString:@", "];
    }
    if (!self.rowDescriptor.value) {
        return self.rowDescriptor.noValueDisplayText;
    }
    
    if (self.rowDescriptor.valueTransformer) {
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer *valueTransformer = [self.rowDescriptor.valueTransformer new];
        NSString *transformValue = [valueTransformer transformedValue:[self.rowDescriptor.value displayText]];
        if (transformValue) {
            return transformValue;
        }
    }
    return self.rowDescriptor.displayTextValue;
}


/**
 The custom input view to display when the receiver becomes the first responder.
 */
- (UIView *)inputView
{
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorPickerView]) {
        return self.pickerView;
    }
    return [super inputView];
}

#pragma mark - Properties
- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [UIPickerView new];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [_pickerView selectRow:[self selectedIndex] inComponent:0 animated:NO];
    }
    return _pickerView;
}

#pragma mark - JYFormDescriptorCell

- (void)configure
{
    [super configure];
}

- (void)update
{
    [super update];
    
    self.accessoryType = self.rowDescriptor.disabled || !([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorPush] || [self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeMultipleSelector]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    self.editingAccessoryType = self.accessoryType;
    self.selectionStyle = self.rowDescriptor.disabled || [self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeInfo] ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    self.textLabel.text = [NSString stringWithFormat:@"%@%@",self.rowDescriptor.title, self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle ? @"*" : @""];
    self.detailTextLabel.text = [self valueDisplayText];
//    if (self.rowDescriptor.disabled) {
//        self.detailTextLabel.textColor = kJYForm_Cell_DetailDisableTextColor;
//    } else {
//        self.detailTextLabel.textColor = [self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeInfo] ? kJYForm_Cell_DetailDisableTextColor : kJYForm_Cell_DetailTextColor;
//    }
//    self.detailTextLabel.textColor = self.rowDescriptor.disabled ? jy
}

- (void)formDescriptorCellDidSelectedWithForm:(JYForm *)form
{
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorPush] || [self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeMultipleSelector]) {
        
        UIViewController *controllerToPresent = [self controllerToPresent];
        if (controllerToPresent) {
            NSAssert([controllerToPresent conformsToProtocol:@protocol(JYFormRowDescriptorViewController)], @"rowDescriptor.action.viewControllerClass must implement JYFormRowDescriptorViewController protocol");
            UIViewController<JYFormRowDescriptorViewController> *selectorViewController = (UIViewController<JYFormRowDescriptorViewController> *)controllerToPresent;
            selectorViewController.rowDescriptor = self.rowDescriptor;
            selectorViewController.title = self.rowDescriptor.selectorTitle;
            [[form formController].navigationController pushViewController:selectorViewController animated:YES];
            
        } else if (self.rowDescriptor.selectorOptions) {
            JYFormOptionsViewController *optionViewController = [[JYFormOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                                sectionHeaderTitle:nil
                                                                                                sectionFooterTitle:nil];
            optionViewController.rowDescriptor = self.rowDescriptor;
            optionViewController.form = self.form;
            optionViewController.title = self.rowDescriptor.selectorTitle;
            
            [[form formController].navigationController pushViewController:optionViewController animated:YES];
        }
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorActionSheet]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];

        [alertController addAction:[UIAlertAction actionWithTitle:[NSString jy_localizedStringForKey:@"JYForm_Alert_Cancle"]
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        __weak typeof(self) weakSelf = self;
        for (JYFormOptionsObject *option in self.rowDescriptor.selectorOptions) {
            NSString *optionTitle = [option displayText];
            if (self.rowDescriptor.valueTransformer) {
                NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
                NSString * transformValue = [valueTransformer transformedValue:option.displayText];
                if (transformValue) {
                    optionTitle = transformValue;
                }
            }
            __strong typeof(weakSelf) strongSelf = self;
            [alertController addAction:[UIAlertAction actionWithTitle:optionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                strongSelf.rowDescriptor.value = option;
                [form reloadFormRow:strongSelf.rowDescriptor];
            }]];
        }
        [[form formController] presentViewController:alertController animated:YES completion:nil];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorAlertView]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:[NSString jy_localizedStringForKey:@"JYForm_Alert_Cancle"]
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        __weak typeof(self) weakSelf = self;
        for (JYFormOptionsObject *option in self.rowDescriptor.selectorOptions) {
            NSString *optionTitle = [option displayText];
            if (self.rowDescriptor.valueFormatter) {
                NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
                NSString * transformValue = [valueTransformer transformedValue:option.displayText];
                if (transformValue) {
                    optionTitle = transformValue;
                }
            }
            __strong typeof(weakSelf) strongSelf = self;
            [alertController addAction:[UIAlertAction actionWithTitle:optionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                strongSelf.rowDescriptor.value = option;
                [form reloadFormRow:strongSelf.rowDescriptor];
            }]];
        }
        [[form formController] presentViewController:alertController animated:YES completion:nil];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorPickerView]) {
    }
    [form.tableView deselectRowAtIndexPath:[form.formDescriptor indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

- (void)highlight
{
    [super highlight];
}

- (void)unhighlight
{
    [super unhighlight];
}

- (BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.disabled && [self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorPickerView]);
}

- (BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorPickerView]) {
        return YES;
    }
    return [super canBecomeFirstResponder];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.rowDescriptor.selectorOptions[row] displayText];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorPickerView]) {
        self.rowDescriptor.value = self.rowDescriptor.selectorOptions[row];
        self.detailTextLabel.text = [self valueDisplayText];
        [self setNeedsLayout];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.rowDescriptor.selectorOptions.count;
}

#pragma mark - Helpers

- (UIViewController *)controllerToPresent
{
    if (self.rowDescriptor.action.viewControllerClass) {
        return [[self.rowDescriptor.action.viewControllerClass alloc] init];
    }
    return nil;
}

-(NSInteger)selectedIndex
{
    if (self.rowDescriptor.value){
        for (id option in self.rowDescriptor.selectorOptions){
            if ([[option valueData] isEqual:[self.rowDescriptor.value valueData]]){
                return [self.rowDescriptor.selectorOptions indexOfObject:option];
            }
        }
    }
    return -1;
}

@end
