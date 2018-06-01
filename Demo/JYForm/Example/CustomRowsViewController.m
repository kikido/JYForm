
//
//  CustomRowsViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/10.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "CustomRowsViewController.h"
#import "JYForm.h"

#import "JYFormRatingCell.h"
#import "JYFloatLabeledTextFieldCell.h"
#import "JYFormWeekDaysCell.h"

@interface CustomRowsViewController ()

@end

@implementation CustomRowsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    //第一段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"评分"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeRate title:@"一步一颗星"];
    row.value = @(3);
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeRate title:@"一步半颗星"];
    [row.cellConfigAtConfigure setObject:@(.5) forKey:@"ratingView.stepInterval"];;
    row.value = @(3.5);
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"02" rowType:JYFormRowDescriptorTypeRate title:@"六颗星"];
    [row.cellConfigAtConfigure setObject:@(6) forKey:@"ratingView.numberOfStar"];;
    row.value = @(6);
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"03" rowType:JYFormRowDescriptorTypeRate title:@"红色的星星"];
    [row.cellConfigAtConfigure setObject:[UIColor redColor] forKey:@"ratingView.highlightColor"];;
    row.value = @(2);
    [section addFormRow:row];
    
    
    //第2段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Float Labeled Text Field"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypeFloatLabeledTextField title:@"姓名"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"11" rowType:JYFormRowDescriptorTypeFloatLabeledTextField title:@"你最爱吃的食物"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"12" rowType:JYFormRowDescriptorTypeFloatLabeledTextField title:@"你喜欢的运动"];
    [section addFormRow:row];
    
    
    //第3段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Weak Days"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"20" rowType:JYFormRowDescriptorTypeWeekDays];
    row.value = @{kSunday : @YES, kSaturday : @YES};
    [section addFormRow:row];
    
    //
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
