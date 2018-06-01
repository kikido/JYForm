//
//  TextFieldViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/4.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "TextFieldViewController.h"
#import "CurrencyFormatter.h"
#import "JYFloatLabeledTextFieldCell.h"

@interface TextFieldViewController ()
@end

@implementation TextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Text Fields";
    
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    //Float label textfield
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Float Label TextField"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"-03" rowType:JYFormRowDescriptorTypeFloatLabeledTextField title:@"姓名"];
    row.value = @"张三";
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"-02" rowType:JYFormRowDescriptorTypeFloatLabeledTextField title:@"姓名"];
    row.value = @"张三";
    [row.cellConfigAtConfigure setObject:[UIColor redColor] forKey:@"floatLabeledTextField.floatingLabelTextColor"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"-01" rowType:JYFormRowDescriptorTypeFloatLabeledTextField title:@"身份证号"];
    [section addFormRow:row];
    
    
    //common textfield
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Common TextField"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeText title:@"姓名"];
    [row.cellConfigAtConfigure setObject:@"请输入姓名" forKey:@"textField.placeholder"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"姓名" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentLeft) forKey:@"textField.textAlignment"];
    [row.cellConfigAtConfigure setObject:[UIColor redColor] forKey:@"textField.placeholderLabel.textColor"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"02" rowType:JYFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"身份证号" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentLeft) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"03" rowType:JYFormRowDescriptorTypeText title:JYFormRowDescriptorTypeText];
    row.value = @"这是一段文字。。。";
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"04" rowType:JYFormRowDescriptorTypeName title:JYFormRowDescriptorTypeName];
    row.noValueDisplayText = @"请点击输入";
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"05" rowType:JYFormRowDescriptorTypeEmail title:JYFormRowDescriptorTypeEmail];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"06" rowType:JYFormRowDescriptorTypeNumber title:JYFormRowDescriptorTypeNumber];
    row.value = @(9.9);
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"07" rowType:JYFormRowDescriptorTypeInteger title:JYFormRowDescriptorTypeInteger];
    row.value = @(1024 * 24);
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"08" rowType:JYFormRowDescriptorTypeDecimal title:JYFormRowDescriptorTypeDecimal];
    row.value = @(10.666);
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"09" rowType:JYFormRowDescriptorTypePassword title:JYFormRowDescriptorTypePassword];
    row.value = @(10010);
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypePhone title:JYFormRowDescriptorTypePhone];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"11" rowType:JYFormRowDescriptorTypeURL title:JYFormRowDescriptorTypeURL];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"12" rowType:JYFormRowDescriptorTypeInfo title:JYFormRowDescriptorTypeInfo];
    row.value = @"信息";
    [section addFormRow:row];
    
    //common textfield with valueformatter
    section = [JYFormSectionDescriptor formSectionWithTitle:@"common textfield with valueformatter"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"20" rowType:JYFormRowDescriptorTypeNumber title:JYFormRowDescriptorTypeNumber];
    row.valueFormatter = [[CurrencyFormatter alloc] init];
    row.value = @(9.9);
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"21" rowType:JYFormRowDescriptorTypeInteger title:JYFormRowDescriptorTypeInteger];
    row.valueFormatter = [NSByteCountFormatter new];
    row.value = @(1024*22);
    [section addFormRow:row];
    
    //第二段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Long Text View"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"30" rowType:JYFormRowDescriptorTypeTextView title:@"这个有标题"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"31" rowType:JYFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"这个长文本没有标题..." forKey:@"textView.placeholder"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"32" rowType:JYFormRowDescriptorTypeTextView title:@"这个特别长"];
    row.height = 160.;
    [section addFormRow:row];
    
    
    JYForm *form = [[JYForm alloc] initFormDescriptor:formDescriptor autoLayoutSuperView:self.view];
    [form beginLoading];
    self.form = form;
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
