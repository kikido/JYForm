//
//  ExampleViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/4.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "ExampleViewController.h"
#import "JYForm.h"

#import "ExampleOneViewController.h"
#import "ExampeTwoViewController.h"

#import "TextFieldViewController.h"
#import "SelectorViewController.h"
#import "DateTimeViewController.h"
#import "FormatterViewController.h"
#import "OtherRowViewController.h"

#import "DeleteViewController.h"

#import "ValidationViewController.h"

#import "AutoOneViewController.h"
#import "AutoTwoViewController.h"
#import "AutoThreeViewController.h"

#import "CustomRowsViewController.h"


@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"JYForm";
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    //第一段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Real Examples"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeButton title:@"iOS Event Form One"];
    row.action.viewControllerClass = [ExampleOneViewController class];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeButton title:@"iOS Event Form Two"];
    row.action.viewControllerClass = [ExampeTwoViewController class];
    [section addFormRow:row];
    
    //第二段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"常用例子"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypeButton title:@"Text Fields"];
    row.action.viewControllerClass = [TextFieldViewController class];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"11" rowType:JYFormRowDescriptorTypeButton title:@"Selectors"];
    row.action.viewControllerClass = [SelectorViewController class];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"12" rowType:JYFormRowDescriptorTypeButton title:@"Date And Time"];
    row.action.viewControllerClass = [DateTimeViewController class];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"13" rowType:JYFormRowDescriptorTypeButton title:@"Formatter"];
    row.action.viewControllerClass = [FormatterViewController class];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"15" rowType:JYFormRowDescriptorTypeButton title:@"Other Rows"];
    row.action.viewControllerClass = [OtherRowViewController class];
    [section addFormRow:row];
    
    //第三段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Delete Examples"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"20" rowType:JYFormRowDescriptorTypeButton title:@"Delete"];
    row.action.viewControllerClass = [DeleteViewController class];
    [section addFormRow:row];
    
    //第四段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"验证"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"30" rowType:JYFormRowDescriptorTypeButton title:@"验证"];
    row.action.viewControllerClass = [ValidationViewController class];
    [section addFormRow:row];
    
    
    //第五段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"控制"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"40" rowType:JYFormRowDescriptorTypeButton title:@"控制1"];
    row.action.viewControllerClass = [AutoOneViewController class];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"41" rowType:JYFormRowDescriptorTypeButton title:@"控制2"];
    row.action.viewControllerClass = [AutoTwoViewController class];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"42" rowType:JYFormRowDescriptorTypeButton title:@"控制3"];
    row.action.viewControllerClass = [AutoThreeViewController class];
    [section addFormRow:row];
    
    //第六段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"自定义视图"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"50" rowType:JYFormRowDescriptorTypeButton title:@"自定义视图"];
    row.action.viewControllerClass = [CustomRowsViewController class];
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
