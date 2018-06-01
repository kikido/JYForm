//
//  AutoThreeViewController.m
//  JYForm
//
//  Created by dqh on 2018/5/8.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "AutoThreeViewController.h"
#import "JYForm.h"

@interface AutoThreeViewController ()
@property (nonatomic, strong) JYFormRowDescriptor *row1;
@property (nonatomic, strong) JYFormRowDescriptor *row2;
@property (nonatomic, strong) JYFormRowDescriptor *row3;
@property (nonatomic, strong) JYFormRowDescriptor *row4;
@property (nonatomic, strong) JYFormSectionDescriptor *section1;
@end

@implementation AutoThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JYFormDescriptor *formDescriptor = [JYFormDescriptor formDescriptor];
    JYFormSectionDescriptor *section = nil;
    JYFormRowDescriptor *row = nil;
    
    //第一段
    section = [JYFormSectionDescriptor formSectionWithTitle:@"Hobbies"];
    [formDescriptor addFormSection:section];
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"00" rowType:JYFormRowDescriptorTypeMultipleSelector title:@"选择爱好"];
    row.selectorOptions = [JYFormOptionsObject formOptionsObjectsWithValues:@[@1,@2,@3] displayTexts:@[@"运动", @"电影", @"音乐"]];
    row.onChangeBlock = ^(id  _Nullable oldValue, id  _Nullable newValue, JYFormRowDescriptor * _Nonnull rowDescriptor) {
        
        if (!newValue || [newValue count] == 0) {
            self.section1.hidden = YES;
            return;
        } else {
            self.section1.hidden = NO;
        }
        NSArray *array = (NSArray *)rowDescriptor.value;
        self.row1.hidden = [self checkTheIndexIfExist:&array displayText:@"运动"] == NSNotFound;
        self.row2.hidden = [self checkTheIndexIfExist:&array displayText:@"电影"] == NSNotFound;
        self.row3.hidden = [self checkTheIndexIfExist:&array displayText:@"音乐"] == NSNotFound;
    };
    [section addFormRow:row];
    
    section = [JYFormSectionDescriptor formSectionWithTitle:@"再回答几个问题"];
    [formDescriptor addFormSection:section];
    section.hidden = YES;
    self.section1 = section;
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"10" rowType:JYFormRowDescriptorTypeTextView title:@"你最喜欢的运动明星"];
    [section addFormRow:row];
    row.hidden = YES;
    self.row1 = row;
    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"11" rowType:JYFormRowDescriptorTypeTextView title:@"你最喜欢的电影"];
    [section addFormRow:row];
    row.hidden = YES;
    self.row2 = row;

    
    row = [JYFormRowDescriptor formRowDescriptorWithTag:@"12" rowType:JYFormRowDescriptorTypeTextView title:@"你最喜欢听的歌"];
    [section addFormRow:row];
    row.hidden = YES;
    self.row3 = row;
    
    
    JYForm *form = [[JYForm alloc] initFormDescriptor:formDescriptor autoLayoutSuperView:self.view];
    [form beginLoading];
    self.form = form;
    // Do any additional setup after loading the view.
}

- (NSInteger)checkTheIndexIfExist:(NSArray **)selectOptions displayText:(NSString *)displayText
{
    NSInteger index = NSNotFound;
    
    for (JYFormOptionsObject *selectOption in *selectOptions) {
        if ([[selectOption displayText] isEqualToString:displayText]) {
            index = 10;
            break;
        }
    }
    return index;
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
