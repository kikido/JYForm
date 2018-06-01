//
//  ValidationViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/7.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "ValidationViewController.h"
#import "JYForm.h"

@interface ValidationViewController ()
@end

@implementation ValidationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    //第一段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"验证姓名"];
    [formDescriptor addFormSection:section];

    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeName title:@"姓名"];
    [section addFormRow:row];

    //第二段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"验证邮箱"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypeEmail title:@"邮箱"];
    [row addValidator:[JYFormRegexValidator formRegexValidatorWithMsg:@"邮箱格式不正确" regexString:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,11}"]];
    [section addFormRow:row];
    
    //第三段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"验证密码"];
    section.footerTitle = @"密码长度需在6~20位之间";
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"20" rowType:JYFormRowDescriptorTypePassword title:@"密码"];
    [row addValidator:[JYFormRegexValidator formRegexValidatorWithMsg:@"密码长度应在6~32位之间" regexString:@"^(?=.*\\d)(?=.*[A-Za-z]).{6,32}$"]];
    row.required = YES;
    [section addFormRow:row];
    
    //第四段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"验证数字"];
    section.footerTitle = @"应大于50小于100";
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"30" rowType:JYFormRowDescriptorTypeDecimal title:@"密码"];
    [row addValidator:[JYFormRegexValidator formRegexValidatorWithMsg:@"应大于等于50或者小于等于100" regexString:@"^([5-9][0-9]|100)$"]];
    row.required = YES;
    [section addFormRow:row];
    
    
    JYForm *form = [[JYForm alloc] initFormDescriptor:formDescriptor autoLayoutSuperView:self.view];
    [form beginLoading];
    self.form = form;
    
    
    self.navigationItem.rightBarButtonItems = nil;
    UIButton *a = [UIButton buttonWithType:UIButtonTypeCustom];
    [a setTitle:@"验证" forState:UIControlStateNormal];
    [a setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [a addTarget:self action:@selector(validationAction:) forControlEvents:UIControlEventTouchUpInside];
    [a sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:a];
    self.navigationItem.rightBarButtonItem = item;
    // Do any additional setup after loading the view.
}


- (void)validationAction:(UIButton *)sender
{
    NSArray *results = [self.form formValidationErrors];
    [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JYFormValidationObject *validationObject = [[obj userInfo] objectForKey:JYValidationStatusErrorKey];        
        if ([validationObject.rowDescriptor.tag isEqualToString:@"10"]) {
            UITableViewCell *cell = [validationObject.rowDescriptor cellForForm:self.form];
            [self animateCell:cell];
        }
        if ([validationObject.rowDescriptor.tag isEqualToString:@"20"]) {
            UITableViewCell *cell = [validationObject.rowDescriptor cellForForm:self.form];
            [self animateCell:cell];
        }
        if ([validationObject.rowDescriptor.tag isEqualToString:@"30"]) {
            UITableViewCell *cell = [validationObject.rowDescriptor cellForForm:self.form];
            [self animateCell:cell];
        }
    }];
}

- (void)animateCell:(UITableViewCell *)cell
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values =  @[ @0, @20, @-20, @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.additive = YES;
    
    [cell.layer addAnimation:animation forKey:@"shake"];
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
