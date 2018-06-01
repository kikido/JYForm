//
//  OtherRowViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/7.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "OtherRowViewController.h"
#import "JYForm.h"

@interface OtherRowViewController ()

@end

@implementation OtherRowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Other Rows";
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    //第一段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"OTHER ROWS"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeSwitch title:@"Switch"];
    row.value = @(YES);
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeCheck title:@"Check"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"02" rowType:JYFormRowDescriptorTypeStepCounter title:@"Step Counter"];
    row.value = @50;
    [row.cellConfigAtConfigure setObject:@YES forKey:@"stepControl.wraps"];
    [row.cellConfigAtConfigure setObject:@10 forKey:@"stepControl.stepValue"];
    [row.cellConfigAtConfigure setObject:@10 forKey:@"stepControl.minimumValue"];
    [row.cellConfigAtConfigure setObject:@100 forKey:@"stepControl.maximumValue"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"03" rowType:JYFormRowDescriptorTypeSelectorSegmentedControl title:@"时间"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"早上", @"中午", @"晚上"]];
    row.value = [JYFormOptionsObject formOptionsObjectWithValue:@2 displayText:@"中午"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"04" rowType:JYFormRowDescriptorTypeSlider title:@"重量(KG)"];
    row.value = @(30);
    [row.cellConfigAtConfigure setObject:@(100) forKey:@"slider.maximumValue"];
    [row.cellConfigAtConfigure setObject:@(10) forKey:@"slider.minimumValue"];
    [row.cellConfigAtConfigure setObject:@(4) forKey:@"steps"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"05" rowType:JYFormRowDescriptorTypeInfo title:@"版本"];
    row.value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
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
