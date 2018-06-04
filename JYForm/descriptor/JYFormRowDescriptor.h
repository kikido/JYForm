//
//  JYFormRowDescriptor.h
//  JYForm
//
//  Created by dqh on 2018/4/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "JYFormInlineRowDescriptorCell.h"


extern CGFloat const JYFormUnspecifiedCellHeight;

@class JYForm, JYFormBaseCell, JYFormAction, JYFormBaseCell, JYFormSectionDescriptor, JYFormValidationObject, JYFormOptionsObject;
@protocol JYFormValidatorProtocol;

typedef NS_ENUM(NSUInteger, JYFormPresentationMode) {
    JYFormPresentationModeDefault = 0,
    JYFormPresentationModePush,
    JYFormPresentationModePresent
};

@interface JYFormRowDescriptor : NSObject

///|< The class of the row
@property (nullable, nonatomic, assign) id cellClass;
///|< An NSString that you can identity row object in you form, default is nil
@property (nullable, nonatomic, copy) NSString *tag;
///|< The row's type
@property (nonnull, nonatomic, strong, readonly) NSString *rowType;
///|< The row's title text
@property (nullable, nonatomic, strong) NSString *title;
///|< The value of row
@property (nullable, nonatomic, strong) id value;
///|< The UITableViewCellStyle of the row, default is UITableViewCellStyleValue1, if the rowType is JYFormRowDescriptorTypeButton the cellStyle is UITableViewCellStyleDefault
@property (nonatomic, assign) UITableViewCellStyle cellStyle;
///|< The height of the row, default is 55.0f
@property (nonatomic, assign) CGFloat height;
///|< The block invoked when the value of the row changed
@property (nullable, nonatomic, copy) void(^onChangeBlock)(id __nullable oldValue,id __nullable newValue,JYFormRowDescriptor *__nonnull rowDescriptor);

///|< Whether use the valueFormatter when input
@property (nonatomic, assign) BOOL useValueFormatterDuringInput;
///|< An object that create, interpret, and validate the textual representation of row's value.
@property (nullable, nonatomic, strong) NSFormatter *valueFormatter;
///|< A subclass of the NSValueTransformer, transform values from one representation to another.
@property (nullable, nonatomic, assign) Class valueTransformer;
///|< When the row's value is nil, you can show the noValueDisplayText on the row
@property (nullable, nonatomic, copy) NSString *noValueDisplayText;


/**
 The display text for the row descriptor, taking into account NSFormatters and default placeholder values

 */
- (nonnull NSString *)displayTextValue;


/**
 The editing text value for the row descriptor, taking into account NSFormatters.

 */
- (nonnull NSString *)editTextValue;

///|< 配置cell，当JYForm调用update方法后使用
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigAfterUpdate;
///|< 配置cell，在JYFormOptionsViewController中的cellForRowAtIndexPath方法中被使用
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigForSelector;
///|< 配置cell，当JYForm调用update方法后，且disable属性为Yes时被使用
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigIfDisabled;
///|< 配置cell，当cell调用config之后，update方法之前调用
@property (nonnull, nonatomic, strong, readonly) NSMutableDictionary *cellConfigAtConfigure;

///|< Whether the row is hidden, default is NO
@property (nonatomic, assign) BOOL hidden;
///|< Whether the row is disabled, default is NO
@property (nonatomic, assign) BOOL disabled;
///|< Whether the row is required, default is NO, if YES
@property (nonatomic, assign, getter=isRequired) BOOL required;

///|< The action of the row when you touch thr row
@property (nullable, nonatomic, strong) JYFormAction *action;
///|< Which section contain this row
@property (null_unspecified, nonatomic, weak) JYFormSectionDescriptor *sectionDescriptor;


/**
 Initializes an instance with the tag and rowtype

 @param tag The tag of the row, nullable.
 @param rowType The rowtype of the row, can't be null.
 @return Initializes an instance of JYFormRowDescriptor, or nil if an error occurs.
 */
+ (nonnull instancetype)formRowDescriptorWithTag:(nullable NSString *)tag rowType:(nonnull NSString *)rowType;


/**
 Initializes an instance with the tag and rowtype, title

 @param tag The tag of the row
 @param rowType The rowtype of the row, nullable
 @param title The title of the row
 @return Initializes an instance of JYFormRowDescriptor, or nil if an error occurs.
 */
+ (nonnull instancetype)formRowDescriptorWithTag:(nullable NSString *)tag rowType:(nonnull NSString *)rowType title:(nullable NSString *)title;


/**
 Initializes an instance with the tag and rowtype, title

 @param tag The tag of the row
 @param rowType The rowtype of the row, nullable
 @param title The title of the row
 @return Initializes an instance of JYFormRowDescriptor, or nil if an error occurs.
 */
- (nonnull instancetype)initWithTag:(nullable NSString *)tag rowType:(nonnull NSString *)rowType title:(nullable NSString *)title;


/**
 Return The related cell(must subclas of JYFormBaseCell) through the form

 @param form Which contain the row,nonnull
 @return The related cell
 */
- (nonnull JYFormBaseCell *)cellForForm:(nonnull JYForm *)form;

///|< The error msg where the row's value is empty
@property (nullable, nonatomic, copy) NSString *requireMsg;

/**
 Add a own custom validator just defining an object conforms to protocol JYFormValidatorProtocol

 @param validator Custom validator which conforms to protocol JYFormValidatorProtocol
 */
- (void)addValidator:(nonnull id<JYFormValidatorProtocol>)validator;

/**
 Remove the custom validator form JYFormRowDescriptor's lists of validators

 @param validator Custom validator which conforms to protocol JYFormValidatorProtocol
 */
- (void)removeValidator:(nonnull id<JYFormValidatorProtocol>)validator;


/**
 Valitor a particular row by the JYFormRowDescriptor's validators lists

 @return A instance of JYFormValidationObject which determined the row is valid or not
 */
- (nullable JYFormValidationObject *)doValidation;

///|< JYForm has several types of selectors rows. Almost all of them need to know which are the values to be selected. For a particular JYFormRowDescriptor instance you specify these values setting a NSArray instance to this property.
@property (nullable, nonatomic, copy) NSArray<JYFormOptionsObject *> *selectorOptions;
///|< The title of the selectors rows
@property (nullable, nonatomic, copy) NSString *selectorTitle;

@end

@interface JYFormAction : NSObject

///|< The selector controller class
@property (nullable, nonatomic, assign) Class viewControllerClass;
///|< The presentation of the selctor controller class, default is JYFormPresentationModeDefault
@property (nonatomic, assign) JYFormPresentationMode viewControllerPresentationMode;
///|< The selector block
@property (nullable, nonatomic, copy) void(^rowBlock)(JYFormRowDescriptor *__nonnull sender);
@end

