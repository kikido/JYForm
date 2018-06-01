//
//  JYFormBaseCell.m
//  JYForm
//
//  Created by dqh on 2018/4/4.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormBaseCell.h"

@implementation JYFormBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    
}

- (void)update
{
    self.textLabel.textColor = self.rowDescriptor.disabled ? kJYForm_Cell_MainDisableTextColor : kJYForm_Cell_MainTextColor;
    self.detailTextLabel.textColor = self.rowDescriptor.disabled ? kJYForm_Cell_DetailDisableTextColor : kJYForm_Cell_DetailTextColor;

#ifdef kJYForm_Cell_MainTextFont
    self.textLabel.font = kJYForm_Cell_MainTextFont;
#endif
    
#ifdef kJYForm_Cell_DetailTextFont
    self.detailTextLabel.font = kJYForm_Cell_DetailTextFont;
#endif
}

- (void)highlight
{
    
}

- (void)unhighlight
{
    
}

- (JYForm *)form
{
    id responder= self;
    while (responder) {
        if ([responder isKindOfClass:[JYForm class]]) {
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}


/**
 The custom input accessory view to display when the receiver becomes the first responder.

 */
- (UIView *)inputAccessoryView
{
    UIView * inputAccessoryView = [self.form inputAccessoryViewForRowDescriptor:self.rowDescriptor];
    if (inputAccessoryView){
        return inputAccessoryView;
    }
    return [super inputAccessoryView];
}

- (BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return NO;
}

- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    if (result) {
        [self.form beginEditing:self.rowDescriptor];
    }
    return result;
}

- (BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    if (result) {
        [[self form] endEditing:self.rowDescriptor];
    }
    return result;
}

@end
