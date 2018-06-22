//
//  DeleteViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/7.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "DeleteViewController.h"
#import "JYForm.h"

@interface DeleteViewController ()
@end

@implementation DeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Delete rows";
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    //第一段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Delete" sectionOptions:JYFormSectionOptionCanDelete];
    section.footerTitle = @"当form处于unEdited的状态时，可以通过左滑删除";
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeName title:@"姓"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeName title:@"名"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"02" rowType:JYFormRowDescriptorTypeName title:@"父亲"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"03" rowType:JYFormRowDescriptorTypeName title:@"母亲"];
    [section addFormRow:row];
    
    JYForm *form = [[JYForm alloc] initWithFormDescriptor:formDescriptor autoLayoutSuperView:self.view];
    [form beginLoading];
    self.form = form;
    
    self.navigationItem.rightBarButtonItems = @[];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Edit" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    // Do any additional setup after loading the view.
}

- (void)testAction:(UIButton *)sender
{
    [self.form.tableView setEditing:!self.form.tableView.editing animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.form.tableView setEditing:YES animated:NO];
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
