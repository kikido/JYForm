//
//  JYFormDatePickerCell.h
//  JYForm
//
//  Created by dqh on 2018/5/11.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormBaseCell.h"

@interface JYFormDatePickerCell : JYFormBaseCell <JYFormInlineRowDescriptorCell>
@property (nonatomic, readonly) UIDatePicker * datePicker;
@end
