//
//  JYForm.h
//  JYForm
//
//  Created by dqh on 2018/4/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JYFormDescriptor.h"
#import "JYFormSectionDescriptor.h"
#import "JYFormRowDescriptor.h"
#import "JYFormBaseCell.h"

#import "JYFormRegexValidator.h"

extern NSString *const JYFormRowDescriptorTypeText;
extern NSString *const JYFormRowDescriptorTypeName;
extern NSString *const JYFormRowDescriptorTypeEmail;
extern NSString *const JYFormRowDescriptorTypeNumber;
extern NSString *const JYFormRowDescriptorTypeInteger;
extern NSString *const JYFormRowDescriptorTypeDecimal;
extern NSString *const JYFormRowDescriptorTypePassword;
extern NSString *const JYFormRowDescriptorTypePhone;
extern NSString *const JYFormRowDescriptorTypeURL;
extern NSString *const JYFormRowDescriptorTypeTextView;

//Selector
extern NSString *const JYFormRowDescriptorTypeSelectorPush;
extern NSString *const JYFormRowDescriptorTypeMultipleSelector;
extern NSString *const JYFormRowDescriptorTypeSelectorActionSheet;
extern NSString *const JYFormRowDescriptorTypeSelectorAlertView;
extern NSString *const JYFormRowDescriptorTypeSelectorPickerView;
extern NSString *const JYFormRowDescriptorTypeInfo;

//Date
extern NSString *const JYFormRowDescriptorTypeDate;
extern NSString *const JYFormRowDescriptorTypeTime;
extern NSString *const JYFormRowDescriptorTypeDateTime;
extern NSString *const JYFormRowDescriptorTypeCountDownTimer;
extern NSString *const JYFormRowDescriptorTypeDateInline;
//Date Inline
extern NSString *const JYFormRowDescriptorTypeDatePicker;

extern NSString *const JYFormRowDescriptorTypeSwitch;
extern NSString *const JYFormRowDescriptorTypeCheck;
extern NSString *const JYFormRowDescriptorTypeStepCounter;
extern NSString *const JYFormRowDescriptorTypeSelectorSegmentedControl;
extern NSString *const JYFormRowDescriptorTypeSlider;
extern NSString *const JYFormRowDescriptorTypeButton;



/**
 The direction of the uitoolbar control

 - JYFormRowNavigationDirectionPrevious: make the previous row which can be first responder become the first responder on window
 - JYFormRowNavigationDirectionNext: make the next row which can be first responder become the first responder on window
 */
typedef NS_ENUM (NSUInteger, JYFormRowNavigationDirection) {
    JYFormRowNavigationDirectionPrevious = 0,
    JYFormRowNavigationDirectionNext
};

@protocol JYFormViewDelegate <NSObject>

@optional
- (void)formRowDescriptorValueHasChanged:(JYForm *)form formRow:(JYFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue;

@end


@interface JYForm : UIView <JYFormViewDelegate,UITextFieldDelegate,UITextViewDelegate>

///|< The table view managed by the jyform
@property (nonatomic, strong) UITableView *tableView;
///|< We declare a form through JYFormDescriptor instance and assign it to form instance.We can change the property of JYFormDescriptor to change the tableview behavior
@property (nonatomic, strong) JYFormDescriptor *formDescriptor;

@property (nonatomic, weak) id<JYFormViewDelegate> delegate;



- (instancetype)initWithFormDescriptor:(JYFormDescriptor *)form autoLayoutSuperView:(UIView *)superView;

+ (instancetype)formWithFormDescriptor:(JYFormDescriptor *)form autoLayoutSuperView:(UIView *)superView;

/**
 Initialize a form instance with JYFormDescriptor object

 */
- (instancetype)initWithFormDescriptor:(JYFormDescriptor *)form;


/**
 Initialize a form instance with JYFormDescriptor object and specified the frame rectangle of the form.

 */
- (instancetype)initWithFormDescriptor:(JYFormDescriptor *)form frame:(CGRect)frame;


/**
 Initialize a form instance with JYFormDescriptor object and specified the frame rectangle of the form and the UITableViewStyle of the tableview

 */
- (instancetype)initWithFormDescriptor:(JYFormDescriptor *)form frame:(CGRect)frame style:(UITableViewStyle)style;


/**
 A dictionary which key is the cell's type  and the value is the class of the cell. Once a custom cell has been created you need to let JYForm know about this cell by adding the row definition to cellClassesForRowDescriptorTypes dictionary.

 */
+ (NSMutableDictionary *)cellClassesForRowDescriptorTypes;


/**
 A dictionary which key is the inline cell's type  and the value is the type of the associated cell. Once a custom inline cell has been created you need to let JYForm know about this cell by adding the row definition to inlineRowDescriptorTypesForRowDescriptorTypes dictionary.

 */
+ (NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes;



/**
 Start load the tableview
 
 */
- (void)beginLoading;


- (void)didSelectFormRow:(JYFormRowDescriptor *)formRow;
- (void)deselectFormRow:(JYFormRowDescriptor *)formRow;
- (void)reloadFormRow:(JYFormRowDescriptor *)formRow;
- (JYFormBaseCell *)updateFormRow:(JYFormRowDescriptor *)formRow;

- (NSDictionary *)formValues;
- (NSDictionary *)httpParameters;

- (NSArray *)formValidationErrors;
- (void)showFormValidationError:(NSError *)error;
- (void)showFormValidationError:(NSError *)error withTitle:(NSString*)title;

- (UIView *)inputAccessoryViewForRowDescriptor:(JYFormRowDescriptor *)rowDescriptor;

- (void)beginEditing:(JYFormRowDescriptor *)rowDescriptor;
- (void)endEditing:(JYFormRowDescriptor *)rowDescriptor;

- (void)ensureRowIsVisible:(JYFormRowDescriptor *)inlineRowDescriptor;
@end
