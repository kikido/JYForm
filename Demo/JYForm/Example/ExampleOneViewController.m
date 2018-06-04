//
//  ExampleOneViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/31.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "ExampleOneViewController.h"
#import "JYFloatLabeledTextFieldCell.h"

@interface ExampleOneViewController ()

@end

@implementation ExampleOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    section = [JYFormSectionDescriptor formSectionWithTitle:nil];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeFloatLabeledTextField title:@"姓名"];
    [section addFormRow:row];
    row.required = YES;
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeFloatLabeledTextField title:@"身份证号"];
    [section addFormRow:row];

    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"02" rowType:JYFormRowDescriptorTypeInteger title:@"手机号码"];
    [section addFormRow:row];
    row.required = YES;
    
    section = [JYFormSectionDescriptor formSectionWithTitle:nil];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypeText title:@"身份证地址"];
    row.hidden = YES;
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"11" rowType:JYFormRowDescriptorTypeDate title:@"身份证有效期"];
    [section addFormRow:row];
    
    section = [JYFormSectionDescriptor formSectionWithTitle:nil];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"20" rowType:JYFormRowDescriptorTypeSelectorPush title:@"征信人类别"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"主贷人", @"主贷人配偶", @"担保人"]];
    row.selectorTitle = @"征信人类别";
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"21" rowType:JYFormRowDescriptorTypeSelectorPush title:@"贷款银行"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"工行银行", @"农业银行", @"交通银行"]];
    row.selectorTitle = @"贷款银行";
    [section addFormRow:row];
    
    section = [JYFormSectionDescriptor formSectionWithTitle:nil];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"30" rowType:JYFormRowDescriptorTypeInfo title:@"业务编号"];
    row.value = @"1123131";
    [section addFormRow:row];
    
    
    JYForm *form = [[JYForm alloc] initWithFormDescriptor:formDescriptor autoLayoutSuperView:self.view];
    [form beginLoading];
    self.form = form;
    
    
    self.navigationItem.rightBarButtonItems = @[];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submitAction:)];

}

- (void)submitAction:(UIButton *)sender
{
    NSArray *errors = self.form.formValidationErrors;
    if (errors.count > 0) {
        [self.form showFormValidationError:errors.firstObject];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"提交成功" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:0 handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
