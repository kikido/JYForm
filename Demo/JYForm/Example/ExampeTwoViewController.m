//
//  ExampeTwoViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/31.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "ExampeTwoViewController.h"
#import "DateTransformer.h"
#import "CurrencyFormatter.h"

@interface ExampeTwoViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) JYForm *formOne;
@property (nonatomic, strong) JYForm *formTwo;
@property (nonatomic, strong) JYForm *formThree;

@end

@implementation ExampeTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 40)];

    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(70*i, 0, 70, 40);
        [button setTitle:[NSString stringWithFormat:@"表格%ld",i] forState:UIControlStateNormal];
        [button setTitleColor:i==0 ? [UIColor redColor] : [UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        [titleView addSubview:button];
    }
    self.navigationItem.titleView = titleView;
    self.navigationItem.rightBarButtonItems = nil;
    

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.pagingEnabled = YES;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scroll]-0-|" options:0 metrics:nil views:@{@"scroll" : scrollView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scroll]-0-|" options:0 metrics:nil views:@{@"scroll" : scrollView}]];
    
    UIView *containerView = [UIView new];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:containerView];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[container]-0-|" options:0 metrics:nil views:@{@"container" : containerView}]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[container]-0-|" options:0 metrics:nil views:@{@"container" : containerView}]];
    self.containerView = containerView;
    
    [self initializeFormOne];
    [self initializeFormTwo];
    [self initializeFormThree];
    // Do any additional setup after loading the view.
}


- (void)initializeFormOne
{
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    section = [JYFormSectionDescriptor formSectionWithTitle:nil];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeName];
    [row.cellConfigAtConfigure setObject:@"请输入姓名" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentLeft) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    row.required = YES;
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeName title:@"身份证号"];
    [row.cellConfigAtConfigure setObject:@"请输入身份证号" forKey:@"textField.placeholder"];
    [section addFormRow:row];
    
    section = [JYFormSectionDescriptor formSectionWithTitle:nil];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypeSwitch title:@"全天"];
    row.onChangeBlock = ^(id  _Nullable oldValue, id  _Nullable newValue, JYFormRowDescriptor * _Nonnull rowDescriptor) {
        JYFormRowDescriptor *startRow = [self.formOne.formDescriptor formRowWithTag:@"11"];
        JYFormRowDescriptor *endRow = [self.formOne.formDescriptor formRowWithTag:@"12"];

        if ([newValue boolValue]) {
            startRow.valueTransformer = [DateTransformer class];
            endRow.valueTransformer = [DateTransformer class];
        } else {
            startRow.valueTransformer = nil;
            endRow.valueTransformer = nil;
        }
        [self.formOne updateFormRow:startRow];
        [self.formOne updateFormRow:endRow];
    };
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"11" rowType:JYFormRowDescriptorTypeDateTime title:@"开始时间"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"12" rowType:JYFormRowDescriptorTypeDateTime title:@"结束时间"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*25];
    [section addFormRow:row];
    
    
    section = [JYFormSectionDescriptor formSectionWithTitle:nil];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"20" rowType:JYFormRowDescriptorTypeSelectorPush title:@"重复"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1,@2,@3,@4,@5] displayTexts:@[@"永不", @"每天", @"每周",@"每两周", @"每月"]];
    row.value = [JYFormOptionsObject formOptionsObjectWithValue:@1 displayText:@"永不"];
    [section addFormRow:row];
    
    section = [JYFormSectionDescriptor formSectionWithTitle:nil];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"30" rowType:JYFormRowDescriptorTypeTextView title:@"备注"];
    [section addFormRow:row];
    
    JYForm *form = [[JYForm alloc] initWithFormDescriptor:formDescriptor];
    form.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:form];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[form]-0-|" options:0 metrics:nil views:@{@"form" : form}]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:form attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:form attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:form attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [form beginLoading];
    self.formOne = form;
}

- (void)initializeFormTwo
{
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    section = [JYFormSectionDescriptor formSectionWithTitle:nil];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeInfo title:@"单据编号"];
    row.value = @"000012313";
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypeSelectorPush title:@"主贷人"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"主贷人", @"主贷人配偶", @"担保人"]];
    row.selectorTitle = @"主贷人类别";
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"02" rowType:JYFormRowDescriptorTypeName title:@"客户姓名"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"03" rowType:JYFormRowDescriptorTypeName title:@"身份证号码"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"04" rowType:JYFormRowDescriptorTypeInteger title:@"贷款金额"];
    row.valueFormatter = [CurrencyFormatter new];
    row.value = @1000;
    [section addFormRow:row];
    
    section = [JYFormSectionDescriptor formSectionWithTitle:nil];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypeDate title:@"提交日期"];
    row.noValueDisplayText = @"请输入日期";
    [section addFormRow:row];
    
    JYForm *form = [[JYForm alloc] initWithFormDescriptor:formDescriptor];
    form.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:form];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[form]-0-|" options:0 metrics:nil views:@{@"form" : form}]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:form attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:form attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.formOne attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [form beginLoading];
    self.formTwo = form;
}

- (void)initializeFormThree
{
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    section = [JYFormSectionDescriptor formSectionWithTitle:nil];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeName title:@"用户名"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"01" rowType:JYFormRowDescriptorTypePassword title:@"密码"];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"03" rowType:JYFormRowDescriptorTypeSelectorAlertView title:@"性别"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@0, @1] displayTexts:@[@"男", @"女"]];
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"04" rowType:JYFormRowDescriptorTypeTextView title:@"家庭地址"];
    row.height = 80.;
    [section addFormRow:row];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"05" rowType:JYFormRowDescriptorTypeTextView title:@"简介"];
    row.height = 160.;
    [section addFormRow:row];
    
    
    JYForm *form = [[JYForm alloc] initWithFormDescriptor:formDescriptor];
    form.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:form];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[form]-0-|" options:0 metrics:nil views:@{@"form" : form}]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:form attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:form attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.formTwo attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:form attribute:NSLayoutAttributeRight multiplier:1. constant:0]];
    
    [form beginLoading];
    self.formThree = form;
}

- (void)buttonAction:(UIButton *)sender
{
    UIView *titleView = self.navigationItem.titleView;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    UIButton *otherButton = nil;
    if (sender.tag == 100) {
        otherButton = [titleView viewWithTag:100+1];
        [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        otherButton = [titleView viewWithTag:100+2];
        [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender.tag == 101) {
        otherButton = [titleView viewWithTag:100+0];
        [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        otherButton = [titleView viewWithTag:100+2];
        [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.scrollView setContentOffset:CGPointMake(screenWidth * 1, 0) animated:YES];
    } else {
        otherButton = [titleView viewWithTag:100+0];
        [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        otherButton = [titleView viewWithTag:100+1];
        [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.scrollView setContentOffset:CGPointMake(screenWidth * 2, 0) animated:YES];
    }
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
