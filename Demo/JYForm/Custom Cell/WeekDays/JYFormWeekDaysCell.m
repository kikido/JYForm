//
//  JYFormWeekDaysCell.m
//  JYForm
//
//  Created by dqh on 2018/5/10.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormWeekDaysCell.h"

NSString *const JYFormRowDescriptorTypeWeekDays = @"JYFormRowDescriptorTypeWeekDays";

NSString *const kSunday= @"sunday";
NSString *const kMonday = @"monday";
NSString *const kTuesday = @"tuesday";
NSString *const kWednesday = @"wednesday";
NSString *const kThursday = @"thursday";
NSString *const kFriday = @"friday";
NSString *const kSaturday = @"saturday";

@interface JYFormWeekDaysCell()
@property (nonatomic, strong) UIButton *sundayButton;
@property (nonatomic, strong) UIButton *mondayButton;
@property (nonatomic, strong) UIButton *tuesdayButton;
@property (nonatomic, strong) UIButton *wednesdayButton;
@property (nonatomic, strong) UIButton *thursdayButton;
@property (nonatomic, strong) UIButton *fridayButton;
@property (nonatomic, strong) UIButton *saturdayButton;
@end

@implementation JYFormWeekDaysCell


+ (void)load
{
    [JYForm.cellClassesForRowDescriptorTypes setObject:[JYFormWeekDaysCell class] forKey:JYFormRowDescriptorTypeWeekDays];
}

#pragma mark - JYFormDescriptorCell

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *buttons = @[@"sundayButton", @"mondayButton", @"tuesdayButton", @"wednesdayButton", @"thursdayButton", @"fridayButton", @"saturdayButton"];
    NSArray *buttonTitles = @[@"S", @"M", @"T", @"W", @"T", @"F", @"S"];

    NSMutableArray *dynamicCustomConstraints = @[].mutableCopy;
    
    UIButton *lastButton;
    UIView *lastView;
    UIButton *firstButton;

    for (NSInteger i = 0; i < buttons.count; i++) {
        UIButton *button = [UIButton autolayoutView];
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dayTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIView *view = [UIView autolayoutView];
        view.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:button];
        [self.contentView addSubview:view];
        [self setValue:button forKey:buttons[i]];
        
        NSDictionary *views = @{@"button" : button, @"view" : view};

        //分割线的布局
        [dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        [dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:1.]];
        [dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[view]-10-|" options:0 metrics:0 views:views]];

        //按钮的布局
        [dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[button]-|" options:0 metrics:0 views:views]];

        if (i == buttons.count - 1) {
            [dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:firstButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
            [dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        }
        if (lastButton) {
            [dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
            [dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        } else {
            firstButton = button;
            [dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        }
        lastButton = button;
        lastView = view;
    }
    [self.contentView addConstraints:dynamicCustomConstraints];
    
    [self configureButtons];
}

- (void)update
{
    [super update];
    [self updateButtons];
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(JYFormRowDescriptor *)rowDescriptor
{
    return 60.;
}

#pragma mark - Helper

- (void)dayTapped:(UIButton *)sender
{
    NSString *day = [self getDayFormButton:sender];
    
    sender.selected = !sender.selected;
    NSMutableDictionary *values = [self.rowDescriptor.value mutableCopy];
    [values setObject:@(sender.selected) forKey:day];
    self.rowDescriptor.value = values;
}

-(NSString *)getDayFormButton:(id)sender
{
    if (sender == self.sundayButton) return kSunday;
    if (sender == self.mondayButton) return kMonday;
    if (sender == self.tuesdayButton) return kTuesday;
    if (sender == self.wednesdayButton) return kWednesday;
    if (sender == self.thursdayButton) return kThursday;
    if (sender == self.fridayButton) return kFriday;
    return kSaturday;
}

-(void)configureButtons
{
    for (UIView *subview in self.contentView.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton * button = (UIButton *)subview;
            [button setImage:[UIImage imageNamed:@"uncheckedDay"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"checkedDay"] forState:UIControlStateSelected];
            button.adjustsImageWhenHighlighted = NO;
            [self imageTopTitleBottom:button];
        }
    }
}

-(void)imageTopTitleBottom:(UIButton *)button
{
    // the space between the image and text
    CGFloat spacing = 3.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

-(void)updateButtons
{
    NSDictionary * value = self.rowDescriptor.value;
    self.sundayButton.selected = [[value objectForKey:kSunday] boolValue];
    self.mondayButton.selected = [[value objectForKey:kMonday] boolValue];
    self.tuesdayButton.selected = [[value objectForKey:kTuesday] boolValue];
    self.wednesdayButton.selected = [[value objectForKey:kWednesday] boolValue];
    self.thursdayButton.selected = [[value objectForKey:kThursday] boolValue];
    self.fridayButton.selected = [[value objectForKey:kFriday] boolValue];
    self.saturdayButton.selected = [[value objectForKey:kSaturday] boolValue];
    
    [self.sundayButton setAlpha:((self.rowDescriptor.disabled) ? .6 : 1)];
    [self.mondayButton setAlpha:self.sundayButton.alpha];
    [self.tuesdayButton setAlpha:self.sundayButton.alpha];
    [self.wednesdayButton setAlpha:self.sundayButton.alpha];
    [self.thursdayButton setAlpha:self.sundayButton.alpha];
    [self.fridayButton setAlpha:self.sundayButton.alpha];
    [self.saturdayButton setAlpha:self.sundayButton.alpha];
}


@end
