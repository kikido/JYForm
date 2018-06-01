//
//  DateTimeViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/4.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "DateTimeViewController.h"
#import "JYForm.h"
#import "DateTransformer.h"

@interface DateTimeViewController ()
@end

@implementation DateTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Date&Time";
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Date"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeDate title:@"Date"];
    row.value = [NSDate new];
    [section addFormRow:row];
    
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeTime title:@"Time"];
    [row.cellConfigAtConfigure setObject:@(10) forKey:@"minuteInterval"];
    row.value = [NSDate new];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"02" rowType:JYFormRowDescriptorTypeDateTime title:@"DateTime"];
    row.value = [NSDate new];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"03" rowType:JYFormRowDescriptorTypeCountDownTimer title:@"DownTimer"];
    [section addFormRow:row];
    
    
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Row Inline"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypeDateInline title:@"Date Inline"];
    [section addFormRow:row];
    
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Date with valueTransformer"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"20" rowType:JYFormRowDescriptorTypeDate title:@"Date"];
    row.value = [NSDate new];
    row.valueTransformer = [DateTransformer class];
    [section addFormRow:row];
    
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Date with min and max date"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"30" rowType:JYFormRowDescriptorTypeDate title:@"Date"];
    row.value = [NSDate new];
    [row.cellConfigAtConfigure setObject:[NSDate date] forKey:@"minimumDate"];
    [row.cellConfigAtConfigure setObject:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*3)] forKey:@"maximumDate"];
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
