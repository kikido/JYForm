//
//  JYFormTextFieldCell.h
//  JYForm
//
//  Created by dqh on 2018/4/17.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormBaseCell.h"

@interface JYFormTextFieldCell : JYFormBaseCell <JYFormReturnKeyProtocol>
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UITextField *textField;

@property (nonatomic, strong) NSNumber *textFieldLengthPercentage;
@property (nonatomic, strong) NSNumber *textFieldMaxNumberOfCharacters;
@end

