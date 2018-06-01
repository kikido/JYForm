//
//  JYFormOptionsViewController.m
//  JYForm
//
//  Created by dqh on 2018/4/27.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormOptionsViewController.h"
#import "JYFormOptionsObject.h"
#import "JYForm.h"

@interface JYFormOptionsViewController ()
@property (nonatomic, copy) NSString *sectionHeaderTitle;
@property (nonatomic, copy) NSString *sectionFooterTitle;
@end

#define JYForm_CELL_REUSE_IDENTIFIER  @"OptionCell"


@implementation JYFormOptionsViewController

@synthesize rowDescriptor = _rowDescriptor;
@synthesize form = _form;

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.sectionFooterTitle = nil;
        self.sectionHeaderTitle = nil;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style sectionHeaderTitle:(NSString *)sectionHeaderTitle sectionFooterTitle:(NSString *)sectionFooterTitle
{
    self = [self initWithStyle:style];
    if (self){
        _sectionFooterTitle = sectionFooterTitle;
        _sectionHeaderTitle = sectionHeaderTitle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:JYForm_CELL_REUSE_IDENTIFIER];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.form updateFormRow:self.rowDescriptor];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self selectorOptions].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JYForm_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    JYFormOptionsObject *cellObject = [self selectorOptions][indexPath.row];
    
    [self.rowDescriptor.cellConfigForSelector enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [cell setValue:obj == [NSNull null] ? nil : obj forKey:key];
    }];
    
    cell.textLabel.text = [self valueDisplayTextForOption:cellObject];
    
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeMultipleSelector]) {
        cell.accessoryType = [self selectedValuesContainsOption:cellObject] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        if ([[self.rowDescriptor.value valueData] isEqual:[cellObject valueData]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return self.sectionFooterTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderTitle;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JYFormOptionsObject *cellObject = [self selectorOptions][indexPath.row];
    if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeMultipleSelector]) {
        if ([self selectedValuesContainsOption:cellObject]) {
            self.rowDescriptor.value = [self selectedValuesRemoveOption:cellObject];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            self.rowDescriptor.value = [self selectedValuesAddOption:cellObject];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        if ([[self.rowDescriptor.value valueData] isEqual:[cellObject valueData]]) {
            if (!self.rowDescriptor.required) {
                self.rowDescriptor.value = nil;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            if (self.rowDescriptor.value) {
                NSInteger index = NSNotFound;;
                for (JYFormOptionsObject *selectObject in [self selectorOptions]) {
                    if ([[selectObject valueData] isEqual:[self.rowDescriptor.value valueData]]) {
                        index = [[self selectorOptions] indexOfObject:selectObject];
                    }
                }
                if (index != NSNotFound) {
                    NSIndexPath *oldSelectIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    UITableViewCell *oldSelectCell = [tableView cellForRowAtIndexPath:oldSelectIndexPath];
                    oldSelectCell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            self.rowDescriptor.value = cellObject;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (self.modalPresentationStyle == UIModalPresentationPopover) {
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        } else if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helper

- (NSArray *)selectorOptions
{
    return self.rowDescriptor.selectorOptions;
}

- (NSMutableArray *)selectedValues
{
    if ([self.rowDescriptor.value isKindOfClass:[NSArray class]]) {
        return [NSMutableArray arrayWithArray:self.rowDescriptor.value];
      }
    return @[].mutableCopy;
}

- (NSString *)valueDisplayTextForOption:(JYFormOptionsObject *)option
{
    if (self.rowDescriptor.valueTransformer){
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
        NSString * transformedValue = [valueTransformer transformedValue:option.displayText];
        if (transformedValue){
            return transformedValue;
        }
    }
    return [option displayText];
}

-(BOOL)selectedValuesContainsOption:(JYFormOptionsObject *)option
{
    NSInteger objectIndex = NSNotFound;
    for (JYFormOptionsObject *cellObject in self.selectedValues) {
        if ([[cellObject valueData] isEqual:[option valueData]]) {
            objectIndex = [self.selectedValues indexOfObject:cellObject];
        }
    }
    return objectIndex == NSNotFound ? NO : YES;
}

-(NSMutableArray *)selectedValuesRemoveOption:(JYFormOptionsObject *)option
{
    for (JYFormOptionsObject *selectedValueItem in self.selectedValues) {
        if ([[selectedValueItem valueData] isEqual:[option valueData]]){
            NSMutableArray * result = self.selectedValues;
            [result removeObject:selectedValueItem];
            return result;
        }
    }
    return self.selectedValues;
}

-(NSMutableArray *)selectedValuesAddOption:(JYFormOptionsObject *)option
{
    for (JYFormOptionsObject *selectObject in self.selectedValues) {
        if ([[selectObject valueData] isEqual:[option valueData]]) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"JYFormRowDescriptor value must not contain the option" userInfo:nil];
        }
    }
    NSMutableArray * result = self.selectedValues;
    [result addObject:option];
    return result;
}
@end
