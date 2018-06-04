//
//  SelectorViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/4.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "SelectorViewController.h"
#import "JYForm.h"
#import "TTTransform.h"

@interface SelectorViewController ()

@end

@implementation SelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Selectors";
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    //selector
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Selectors"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeSelectorPush title:@"Push"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"选择1", @"选择2", @"选择3"]];
    row.selectorTitle = @"Push Select";
    row.value = [JYFormOptionsObject formOptionsObjectWithValue:@1 displayText:@"选择1"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"03" rowType:JYFormRowDescriptorTypeMultipleSelector title:@"Push Multiple"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"选择1", @"选择2", @"选择3"]];
    row.selectorTitle = @"Push Select";
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"04" rowType:JYFormRowDescriptorTypeSelectorActionSheet title:@"Sheet"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3,@1, @2, @3,@1, @2, @3,@1, @2, @3,@1, @2, @3] displayTexts:@[@"选择1", @"选择2", @"选择3",@"选择1", @"选择2", @"选择3",@"选择1", @"选择2", @"选择3",@"选择1", @"选择2", @"选择3",@"选择1", @"选择2", @"选择3"]];
    row.selectorTitle = @"Sheet";
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"05" rowType:JYFormRowDescriptorTypeSelectorAlertView title:@"Alert"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3,@1, @2, @3,@1, @2, @3,@1, @2, @3,@1, @2, @3] displayTexts:@[@"选择1", @"选择2", @"选择3",@"选择1", @"选择2", @"选择3",@"选择1", @"选择2", @"选择3",@"选择1", @"选择2", @"选择3",@"选择1", @"选择2", @"选择3"]];
    row.selectorTitle = @"Alert";
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"06" rowType:JYFormRowDescriptorTypeSelectorPickerView title:@"Picker"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"选择1", @"选择2", @"选择3"]];
    row.selectorTitle = @"Picker";
    row.noValueDisplayText = @"请点击选择";
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"07" rowType:JYFormRowDescriptorTypeSelectorPickerView title:@"Picker"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"选择1", @"选择2", @"选择3"]];
    row.selectorTitle = @"选择";
    row.value = [JYFormOptionsObject formOptionsObjectWithValue:@2 displayText:@"选择2"];
    [section addFormRow:row];
    
    
    //selector with valueTransformer
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Selectors with valueTransformer"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypeMultipleSelector title:@"Push Multiple"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"选择1", @"选择2", @"选择3"]];
    row.valueTransformer = [TTTransform class];
    row.selectorTitle = @"Push Select";
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"11" rowType:JYFormRowDescriptorTypeSelectorActionSheet title:@"sheet"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"选择1", @"选择2", @"选择3"]];
    row.selectorTitle = @"选择";
    row.valueTransformer = [TTTransform class];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"12" rowType:JYFormRowDescriptorTypeSelectorActionSheet title:@"sheet"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"选择1", @"选择2", @"选择3"]];
    row.selectorTitle = @"选择";
    row.valueTransformer = [TTTransform class];
    row.value = [JYFormOptionsObject formOptionsObjectWithValue:@2 displayText:@"选择2"];
    [section addFormRow:row];

    JYForm *form = [[JYForm alloc] initWithFormDescriptor:formDescriptor autoLayoutSuperView:self.view];
    [form beginLoading];
    self.form = form;

    [form beginLoading];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
