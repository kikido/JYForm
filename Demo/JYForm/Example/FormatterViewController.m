//
//  FormatterViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/7.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "FormatterViewController.h"
#import "JYForm.h"
#import "CurrencyFormatter.h"

@interface FormatterViewController ()

@end

@implementation FormatterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Text Formatter";
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    //第一段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Text Formatter"];
    section.footerTitle = @"Rows can be configured to use the formatter as you type or to toggle on and off during for display/editing.  You will most likely need custom NSFormatter objects to do on the fly formatting since NSNumberFormatter is pretty limited in this regard";
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeDecimal title:@"人民币"];
    row.valueFormatter = [CurrencyFormatter new];
    row.value = @(1000000);
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeNumber title:@"百分比"];
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    row.valueFormatter = numberFormatter;
    row.value = @(100);
    [section addFormRow:row];
    
    row  = [JYFormRowDescriptor formRowDescriptorWithTag:@"02" rowType:JYFormRowDescriptorTypeNumber title:@"缓存"];
    row.valueFormatter = [NSByteCountFormatter new];
    row.value = @(1024);
    [section addFormRow:row];
    
    
    JYForm *form = [[JYForm alloc] initWithFormDescriptor:formDescriptor autoLayoutSuperView:self.view];
    [form beginLoading];
    self.form = form;
    
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
