//
//  JYFormDescriptor.h
//  JYForm
//
//  Created by dqh on 2018/4/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>

//protocol
#import "JYFormDescriptorDelegate.h"
#import "JYFormDescriptorCell.h"
#import "JYFormInlineRowDescriptorCell.h"

//categories
#import "UIView+JYFormAdditions.h"
#import "NSObject+JYFormAdditions.h"
#import "NSString+JYFormAdditions.h"

//helper
#import "JYFormOptionsObject.h"
#import "JYFormValidationObject.h"
#import "JYFormSectionDescriptor.h"


extern NSString *__nonnull const JYFormErrorDomain;
extern NSString *__nonnull const JYValidationStatusErrorKey;

typedef NS_ENUM(NSUInteger, JYFormErrorCode)
{
    JYFormErrorCodeGen = -999,
    JYFormErrorCodeRequired = -1000
};

@interface JYFormDescriptor : NSObject

///|< A array contains the section which show on the form, if the section's edited to No, the section will removed form formSections
@property (nonnull, nonatomic, strong, readonly) NSMutableArray *formSections;
///|< The title of thr form
@property (nullable, nonatomic, copy, readonly) NSString *title;
///|< Whether the tableview should end edit while scroll begin, default is yes
@property (nonatomic, assign) BOOL endEditingTableViewOnScroll;
///|< Whether add Asterisk to the required rows, default is no
@property (nonatomic, assign) BOOL addAsteriskToRequiredRowsTitle;
///|< Whether the form is disabled
@property (nonatomic, assign, getter=isDisabled) BOOL disabled;
///|< The delegate must conform to the JYFormDescriptorDelegate protocol
@property (nullable, nonatomic, weak) id<JYFormDescriptorDelegate> delegate;


/**
 Initialize a JYFormDescriptor instance

 @return The JYFormDescriptor instance initialized by default
 */
+ (nonnull instancetype)formDescriptor;


/**
 Initialize a JYFormDescriptor instance with the form's title

 */
+ (nonnull instancetype)formDescriptorWithTitle:(nullable NSString *)title;


/**
 Adds a given formSection to the form

 @param formSection The JYFormSectionDescriptor instance add to the form
 */
- (void)addFormSection:(nonnull JYFormSectionDescriptor *)formSection;


/**
 Inserts a given formSection into the form at a given index

 @param formSection The formSection to add to the form. This value must not be nil
 @param index The index in the form at which to insert anObject. This value must not be greater than the count of elements in the formrSecions.
 */
- (void)addFormSection:(nonnull JYFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;


/**
 Add a formSecion after another formSecion in the form

 @param formSection The formSection add after another formSection
 @param afterSection The formSection that in front of added formSection
 */
- (void)addFormSection:(nonnull JYFormSectionDescriptor *)formSection afterSection:(nonnull JYFormSectionDescriptor *)afterSection;


/**
 Add a formrow before another formrow in the form

 @param formRow The formrow add before another formrow
 @param beforeRow The formrow that after the added formrow
 */
- (void)addFormRow:(nonnull JYFormRowDescriptor *)formRow beforeRow:(nonnull JYFormRowDescriptor *)beforeRow;


/**
 Add a formrow before another formrow whose tag is specificied in the form

 @param formRow The formrow add before another formrow
 @param beforeRowTag The formrow's tag which after the added formrow
 */
- (void)addFormRow:(nonnull JYFormRowDescriptor *)formRow beforeRowTag:(nonnull NSString *)beforeRowTag;


/**
 Add a formrow after another formrow in the section

 @param formRow The formrow add after another formrow
 @param afterRow The formrow that in front of added formrow
 */
- (void)addFormRow:(nonnull JYFormRowDescriptor *)formRow afterRow:(nonnull JYFormRowDescriptor *)afterRow;


/**
 Add a formrow after another formrow whose  tag is specificied in the form

 @param formRow The formrow add after another formrow
 @param afterRowTag The formrow's tag which in front of the added formrow
 */
- (void)addFormRow:(nonnull JYFormRowDescriptor *)formRow afterRowTag:(nonnull NSString *)afterRowTag;


/**
 Removes the formSection at index

 @param index The index from which to remove the formSection in the form
 */
- (void)removeFormSectionsAtIndex:(NSUInteger)index;


/**
 Removes the formSection from form

 @param formSection The formSection to remove form the form
 */
- (void)removeFormSection:(nonnull JYFormSectionDescriptor *)formSection;


/**
 Removes the formrow from form

 @param formRow The formrow to remove form the form
 */
- (void)removeFormRow:(nonnull JYFormRowDescriptor *)formRow;


/**
 Removes the formrow whose tag is specificied from form

 @param rowTag The removed formrow's tag
 */
- (void)removeFormRowWithTag:(nonnull NSString *)rowTag;


/**
 Returns the formrow whose tag is specificied

 @param tag The formrow's tag
 @return  Returns the formrow whose tag is specificied
 */
- (nonnull JYFormRowDescriptor *)formRowWithTag:(nonnull NSString *)tag;


/**
 Returns the formrow located at the specified index.

 @param indexPath An formrow's location in the form
 @return The formrow located at index
 */
- (nonnull JYFormRowDescriptor *)formRowAtIndex:(nonnull NSIndexPath *)indexPath;


/**
 Returns the formSection located at the specified index.

 @param index An formSection's location in the form
 @return The formSection located at index
 */
- (nonnull JYFormSectionDescriptor *)formSectionAtIndex:(NSUInteger)index;


/**
 Returns an index path representing the row and section of a given formrow

 @param formRow A formrow object of the form
 @return An index path representing the row and section of the formrow, or nil if the index path is invalid.
 */
- (nonnull NSIndexPath *)indexPathOfFormRow:(nonnull JYFormRowDescriptor *)formRow;


/**
 You can get the form's all row's values invoking this method

 @return JYForm adds a value for each JYFormRowDescriptor that belongs to a JYFormSectionDescriptor. The dictionary key is the value of JYFormRowDescriptor tag property.
 */
- (nonnull NSDictionary *)formValues;


/**
 In same cases the form value we need may different from the value of JYFormRowDescriptor instance. This is usually the case of selectors row and when we need to send the form values to some endpoint, the selected value could be a core data object or any other object. In this cases JYForm need to know how to get the value and the description of the selected object.

 @return  JYForm follows the following rules to get JYFormRowDescriptor value:
           1. If the object is a NSString, NSNumber or NSDate, the value is the object itself.
           2. If the object conforms to protocol JYFormOptionObject, JYForm gets the value from formValue method.
           3. Otherwise it return nil.
 */
- (nonnull NSDictionary *)httpParameters:(nonnull JYForm *)form;



/**
 Return the array of error when each row's value is failured to validate the validator

 @return  Return the array of error when each row's value is failured to validate the validator
 */
- (nonnull NSArray *)localValidationErrors;



/**
 Asks the form to make it's first row which can be first responder to be the first responder in its window.

 */
- (void)setFirstResponder:(nonnull JYForm *)form;


/**
 The nextRow after the currentrow on the form, maybe nil

 */
- (nonnull JYFormRowDescriptor *)nextRowDescriptorForRow:(nonnull JYFormRowDescriptor *)currentRow;


/**
 The previousRow before the currentrow on the form, maybe nil

 */
- (nonnull JYFormRowDescriptor *)previousRowDescriptorForRow:(nonnull JYFormRowDescriptor *)currentRow;


/**
 Make sure the formrows or the formsecions are correctly display on the form
 
 */
- (void)forceEvaluate;

@end






