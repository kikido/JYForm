//
//  JYFormSectionDescriptor.h
//  JYForm
//
//  Created by dqh on 2018/4/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 A bitwise enum parameter that used to choose the multivalued section type

 - JYFormSectionOptionNone: NO section stype
 - JYFormSectionOptionCanInsert: NO implementation
 - JYFormSectionOptionCanDelete: You can delete the row by left swipe the row or when thr tableview is in edited status
 - JYFormSectionOptionCanReorder: NO implementation
 */
typedef NS_OPTIONS(NSUInteger, JYFormSectionOptions) {
    JYFormSectionOptionNone        = 0,
    JYFormSectionOptionCanInsert   = 1 << 0,
    ///|< unimplementation
    JYFormSectionOptionCanDelete   = 1 << 1,
    ///|< unimplementation
    JYFormSectionOptionCanReorder  = 1 << 2
};

@class JYFormDescriptor, JYFormRowDescriptor;

@interface JYFormSectionDescriptor : NSObject

///|< An JYFormDescriptor instance which contain the JYFormSectionDescriptor instance
@property (null_unspecified, nonatomic, weak) JYFormDescriptor *formDescriptor;
///|< A string to use as the title of the section header. If nil , the section will have no title.
@property (nullable, nonatomic, strong) NSString *headerTitle;
///|< A string to use as the title of the section footer. If nil , the section will have no title.
@property (nullable, nonatomic, strong) NSString *footerTitle;
///|< A array contain the row which is on the form, if the row's hidden is YES, the row will be removed form the formrows, but still in allrows
@property (nonnull, nonatomic, strong, readonly) NSMutableArray *formRows;
///|< The edit style when table is in edited status
@property (nonatomic, assign) JYFormSectionOptions sectionOptions;
///|< Whether the section is hidden
@property (nonatomic, assign) BOOL hidden;

@property (nullable, nonatomic, strong) UIView *headerView;
///|< default is 30.0f
@property (nonatomic, assign) CGFloat headerHieght;


@property (nullable, nonatomic, strong) UIView *footerView;
///|< default is 30.0f
@property (nonatomic, assign) CGFloat footerHieght;

/**
 Initialize a JYFormSectionDescriptor instance by default
 
 @return The JYFormSectionDescriptor instance
 */
+ (nonnull instancetype)formSection;


/**
 Initialize a JYFormSectionDescriptor instance and specify the section's header title

 @param title The section's header title
 @return The JYFormSectionDescriptor instance
 */
+ (nonnull instancetype)formSectionWithTitle:(nullable NSString *)title;


/**
 Initialize a JYFormSectionDescriptor instance, specify the section's header title and the edited style

 */
+ (nonnull instancetype)formSectionWithTitle:(nullable NSString *)title sectionOptions:(JYFormSectionOptions)sectionOptions;


/**
 Adds a given formrow to the end of this section

 @param formRow The JYFormRowDescriptor instance add to the section
 */
- (void)addFormRow:(nonnull JYFormRowDescriptor *)formRow;


/**
 Add a formrow after another formrow in the section

 @param formRow The formrow add after another formrow
 @param afterRow The formrow that in front of added formrow
 */
- (void)addFormRow:(nonnull JYFormRowDescriptor *)formRow afterRow:(nonnull JYFormRowDescriptor *)afterRow;


/**
 Add a formrow before another formrow in the section

 @param formRow The formrow add before another formrow
 @param beforeRow The formrow that after the added formrow
 */
- (void)addFormRow:(nonnull JYFormRowDescriptor *)formRow beforeRow:(nonnull JYFormRowDescriptor *)beforeRow;


/**
 Removes the formrow at index in this section
 
 @param index The index from which to remove the formrow in the section. The value must not exceed the bounds of the section.formrowList.
 
 */
- (void)removeFormRowAtIndex:(NSUInteger)index;


/**
 Removes the formrow in this section
 
 @param formRow The formrow to remove form the section
 */
- (void)removeFormRow:(nonnull JYFormRowDescriptor *)formRow;


/**
 Move a formrow at a specific location in the section to another location

 @param sourceIndex An index path locating the formrow to be moved in tableView
 @param destinationIndex An index path locating the formrow in tableView that is the destination of the move
 */
- (void)moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndex toIndexPath:(nonnull NSIndexPath *)destinationIndex;

@end
