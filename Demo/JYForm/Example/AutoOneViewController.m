//
//  AutoOneViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/8.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "AutoOneViewController.h"
#import "JYForm.h"

@interface AutoOneViewController ()
@property (nonatomic, strong) JYFormRowDescriptor *dateRow;
@property (nonatomic, strong) JYFormRowDescriptor *emailRow;
@end

@implementation AutoOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    JYFormRowDescriptor *numberRow, *nameRow;
    
    //第一段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"独立行"];
    section.footerTitle = @"当Switch行为On的时候，Number行会被隐藏掉\n当Number行的值大于50时，Date行将被禁用\n如果Name行的value包括cc字符，并且Date行被禁用的话，Email行会被隐藏";
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeName title:@"Name"];
    row.onChangeBlock = ^(id oldValue, id newValue, JYFormRowDescriptor *rowDescriptor) {
        if ([rowDescriptor.value containsString:@"cc"] && self.dateRow.disabled) {
            self.emailRow.hidden = YES;
        } else {
            self.emailRow.hidden = NO;
        }
    };
    [section addFormRow:row];
    nameRow = row;
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeNumber title:@"Number"];
    row.onChangeBlock = ^(id oldValue, id newValue, JYFormRowDescriptor *rowDescriptor) {
        if ([newValue integerValue] > 50) {
            self.dateRow.disabled = YES;
        } else {
            self.dateRow.disabled = NO;
        }
    };
    [section addFormRow:row];
    numberRow = row;
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"02" rowType:JYFormRowDescriptorTypeSwitch title:@"Switch"];
    row.onChangeBlock = ^(id oldValue, id newValue, JYFormRowDescriptor *rowDescriptor) {
        if (![newValue boolValue]) {
            numberRow.hidden = YES;
        } else {
            numberRow.hidden = NO;
        }
    };
    row.value = @YES;
    [section addFormRow:row];
    
    
    //第二段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"依赖的section"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypeDate title:@"Date"];
    [section addFormRow:row];
    self.dateRow = row;
    
    //第三段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"依赖的section"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"20" rowType:JYFormRowDescriptorTypeDate title:@"Email"];
    [section addFormRow:row];
    self.emailRow = row;
    
    //
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
