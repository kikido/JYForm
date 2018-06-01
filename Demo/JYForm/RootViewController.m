//
//  RootViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/7.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Values" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *button01 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button01 setTitle:@"Disable" forState:UIControlStateNormal];
    [button01 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button01 addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    button01.tag = 99;
    [button01 sizeToFit];
    UIBarButtonItem *item01 = [[UIBarButtonItem alloc] initWithCustomView:button01];
    self.navigationItem.rightBarButtonItems = @[item01,item];
    // Do any additional setup after loading the view.
}

- (void)testAction:(UIButton *)sender
{
    if (sender.tag == 99) {
        self.form.formDescriptor.disabled = !self.form.formDescriptor.disabled;
        [self.form.tableView reloadData];
        
        if (self.form.formDescriptor.disabled) {
            [sender setTitle:@"Enable" forState:UIControlStateNormal];
        } else {
            [sender setTitle:@"Disable" forState:UIControlStateNormal];
        }
    } else {
        NSLog(@"%@",self.form.formValues);
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
