//
//  AutoTwoViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/8.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "AutoTwoViewController.h"
#import "JYForm.h"

@interface AutoTwoViewController ()
@property (nonatomic, strong) JYFormRowDescriptor *nextRow;
@property (nonatomic, strong) JYFormSectionDescriptor *nextSection;
@end

@implementation AutoTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    
    //第一段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"第一行"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeSwitch title:@"显示下一行"];
    row.onChangeBlock = ^(id oldValue, id newValue, JYFormRowDescriptor *rowDescriptor) {
        if ([newValue boolValue]) {
            self.nextRow.hidden = NO;
        } else {
            self.nextRow.hidden = YES;
        }
    };
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeSwitch title:@"显示下一节"];
    row.onChangeBlock = ^(id oldValue, id newValue, JYFormRowDescriptor *rowDescriptor) {
        if ([newValue boolValue]) {
            self.nextSection.hidden = NO;
        } else {
            self.nextSection.hidden = YES;
        }
    };
    [section addFormRow:row];
    row.hidden = YES;
    self.nextRow = row;
    
    //第二段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"依赖的section"];
    [formDescriptor addFormSection:section];
    section.hidden = YES;
    self.nextSection = section;
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypeName];
    [row.cellConfigAtConfigure setObject:@"这是第二节" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentLeft) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    JYForm *form = [[JYForm alloc] initFormDescriptor:formDescriptor autoLayoutSuperView:self.view];
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
