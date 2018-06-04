//
//  JYFormDescriptor.m
//  JYForm
//
//  Created by dqh on 2018/4/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormDescriptor.h"
#import "JYFormSectionDescriptor.h"
#import "NSObject+JYFormAdditions.h"
#import "UIView+JYFormAdditions.h"

#import "JYFormRowDescriptor.h"

NSString *const JYFormErrorDomain = @"JYFormErrorDomain";
NSString *const JYValidationStatusErrorKey = @"JYValidationStatusErrorKey";


@interface JYFormSectionDescriptor (JYFormDescriptor)
@property (nonatomic, strong) NSArray *allRows;

- (void)evaluateIsHidden;
@end

@interface JYFormRowDescriptor (JYFormDescriptor)
- (BOOL)evaluateIsDisabled;
- (BOOL)evaluateIsHidden;
@end

@interface JYFormDescriptor()
@property (nonatomic, strong) NSMutableArray *formSections;
@property (nonatomic, strong, readonly) NSMutableArray *allSections;
@property (nonatomic, strong, readonly) NSMutableDictionary *allRowsByTag;
@property (nonatomic, strong) NSMutableDictionary *rowObservers;
@end

@implementation JYFormDescriptor

#pragma mark - Initialize

- (instancetype)init
{
    return [self initWithTitle:nil];
}

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        _formSections = @[].mutableCopy;
        _allSections = @[].mutableCopy;
        _allRowsByTag = @{}.mutableCopy;
        _rowObservers = @{}.mutableCopy;
        _title = title;
        
        _addAsteriskToRequiredRowsTitle = NO;
        _disabled = NO;
        _endEditingTableViewOnScroll = YES;
        _formFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        [self addObserver:self forKeyPath:@"formSections" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)  context:nil];
    }
    return self;
}

+ (instancetype)formDescriptor
{
    return [[self class] formDescriptorWithTitle:nil];
}

+ (instancetype)formDescriptorWithTitle:(NSString *)title
{
    return [[[self class] alloc] initWithTitle:title];
}

#pragma mark - Form Sections

- (void)insertObject:(JYFormSectionDescriptor *)formSection inFormSectionsAtIndex:(NSUInteger)index
{
    [self.formSections insertObject:formSection atIndex:index];
}

- (void)removeObjectFromFormSectionsAtIndex:(NSUInteger)index
{
    [self.formSections removeObjectAtIndex:index];
}

- (id)objectInFormSectionsAtIndex:(NSUInteger)index
{
    return [self.formSections objectAtIndex:index];
}

#pragma mark - Rows

- (void)addFormRow:(JYFormRowDescriptor *)formRow beforeRow:(JYFormRowDescriptor *)beforeRow
{
    if (beforeRow.sectionDescriptor) {
        [beforeRow.sectionDescriptor addFormRow:formRow beforeRow:beforeRow];
    } else {
        [self.allSections.lastObject addFormRow:formRow beforeRow:beforeRow];
    }
}

- (void)addFormRow:(JYFormRowDescriptor *)formRow beforeRowTag:(NSString *)beforeRowTag
{
    JYFormRowDescriptor *beforeRow = [self formRowWithTag:beforeRowTag];
    [self addFormRow:formRow beforeRow:beforeRow];
}

- (void)addFormRow:(JYFormRowDescriptor *)formRow afterRow:(JYFormRowDescriptor *)afterRow
{
    if (afterRow.sectionDescriptor) {
        [afterRow.sectionDescriptor addFormRow:formRow afterRow:afterRow];
    } else {
        [self.allSections.lastObject addFormRow:formRow afterRow:afterRow];
    }
}

- (void)addFormRow:(JYFormRowDescriptor *)formRow afterRowTag:(NSString *)afterRowTag
{
    JYFormRowDescriptor *afterRow = [self formRowWithTag:afterRowTag];
    [self addFormRow:formRow afterRow:afterRow];
}

- (void)removeFormRow:(JYFormRowDescriptor *)formRow
{
    if (!formRow.sectionDescriptor) {
        return;
    }
    if ([formRow.sectionDescriptor.formRows containsObject:formRow]) {
        [formRow.sectionDescriptor removeFormRow:formRow];
    }
}

- (void)removeFormRowWithTag:(NSString *)rowTag
{
    JYFormRowDescriptor *formRow = [self formRowWithTag:rowTag];
    [self  removeFormRow:formRow];
}

- (JYFormRowDescriptor *)formRowAtIndex:(NSIndexPath *)indexPath
{
    if (self.formSections.count > indexPath.section && [self.formSections[indexPath.section] formRows].count > indexPath.row) {
        return [self.formSections[indexPath.section] formRows][indexPath.row];
    }
    return nil;
}

- (JYFormSectionDescriptor *)formSectionAtIndex:(NSUInteger)index
{
    return [self objectInFormSectionsAtIndex:index];
}

- (NSIndexPath *)indexPathOfFormRow:(JYFormRowDescriptor *)formRow
{
    JYFormSectionDescriptor *section = formRow.sectionDescriptor;
    
    if (section) {
        NSUInteger sectionIndex = [self.formSections indexOfObject:section];
        if (sectionIndex != NSNotFound) {
            NSUInteger rowIndex = [section.formRows indexOfObject:formRow];
            if (rowIndex != NSNotFound) {
                return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            }
        }
    }
    return nil;
}

#pragma mark - Public

- (void)addFormSection:(JYFormSectionDescriptor *)formSection
{
    [self insertObject:formSection inAllSectionsAtIndex:self.allSections.count];
}

- (void)addFormSection:(JYFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    if (index == 0) {
        [self insertObject:formSection inAllSectionsAtIndex:0];
    } else {
        JYFormSectionDescriptor *previousSection = [self.formSections objectAtIndex:MIN(self.formSections.count - 1, index-1)];
        [self addFormSection:formSection afterSection:previousSection];
    }
}

- (void)addFormSection:(JYFormSectionDescriptor *)formSection afterSection:(JYFormSectionDescriptor *)afterSection
{
    NSUInteger sectionIndex = [self.allSections indexOfObject:formSection];
    NSUInteger afterSectionIndex = [self.allSections indexOfObject:afterSection];;
    
    if (sectionIndex == NSNotFound) {
        if (afterSectionIndex != NSNotFound) {
            [self insertObject:formSection inAllSectionsAtIndex:afterSectionIndex + 1];
        } else {
            [self addFormSection:formSection];
        }
    }
}

- (void)removeFormSectionsAtIndex:(NSUInteger)index
{
    if (self.formSections.count > index) {
        JYFormSectionDescriptor *formSection = [self.formSections objectAtIndex:index];
        [self removeFormSectionsAtIndex:index];
        NSUInteger allSectionIndex = [self.allSections indexOfObject:formSection];
        [self removeObjectFromAllSectionsAtIndex:allSectionIndex];
    }
}

- (void)removeFormSection:(JYFormSectionDescriptor *)formSection
{
    NSUInteger index = [self.formSections indexOfObject:formSection];
    if (index != NSNotFound) {
        [self removeFormSectionsAtIndex:index];
    } else if ((index = [self.allSections indexOfObject:formSection]) != NSNotFound) {
        [self removeObjectFromAllSectionsAtIndex:index];
    }
}

- (JYFormRowDescriptor *)formRowWithTag:(NSString *)tag
{
    return self.allRowsByTag[tag];
}

- (NSDictionary *)formValues
{
    NSMutableDictionary *result = @{}.mutableCopy;
    
    for (JYFormSectionDescriptor *section in self.allSections) {
        for (JYFormRowDescriptor *row in section.allRows) {
            if (row.tag.length > 0) {
                [result setObject:row.value ? row.value : [NSNull null] forKey:row.tag];
            }
        }
    }
    return result.copy;
}

- (NSDictionary *)httpParameters:(JYForm *)form
{
    NSMutableDictionary *result = @{}.mutableCopy;

    for (JYFormSectionDescriptor *section in self.allSections) {
        for (JYFormRowDescriptor *row in section.allRows) {
            if (!row.required) {
                continue;
            }
            NSString *httpParameterKey = [self httpParameterKeyForRow:row cell:((UITableViewCell<JYFormDescriptorCell> *)[row cellForForm:form])];
            if (httpParameterKey) {
                id parameterValue = [row.value valueData] ?: [NSNull null];
                [result setObject:parameterValue forKey:httpParameterKey];
            }
        }
    }
    return result.copy;
}

- (NSString *)httpParameterKeyForRow:(JYFormRowDescriptor *)row cell:(UITableViewCell<JYFormDescriptorCell> *)descriptorCell
{
    if ([descriptorCell respondsToSelector:@selector(formDescriptorHttpParameterName)]) {
        return [descriptorCell formDescriptorHttpParameterName];
    }
    if (row.tag.length > 0) {
        return row.tag;
    }
    return nil;
}

- (NSArray *)localValidationErrors
{
    NSMutableArray *result = @[].mutableCopy;
    
    for (JYFormSectionDescriptor *section in self.formSections) {
        for (JYFormRowDescriptor *row in section.formRows) {
            JYFormValidationObject *valiObject = [row doValidation];
            if (valiObject != nil && !valiObject.isValid) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey  : valiObject.msg,
                                           JYValidationStatusErrorKey : valiObject
                                           };
                NSError *error = [[NSError alloc] initWithDomain:JYFormErrorDomain code:JYFormErrorCodeGen userInfo:userInfo];
                if (error) {
                    [result addObject:error];
                }
            }
        }
    }
    return result.copy;
}

- (void)setFirstResponder:(JYForm *)form
{
    for (JYFormSectionDescriptor *section in self.formSections) {
        for (JYFormRowDescriptor *row in section.formRows) {
            UITableViewCell<JYFormDescriptorCell> *cell = (UITableViewCell<JYFormDescriptorCell> *)[row cellForForm:form];
            if ([cell respondsToSelector:@selector(formDescriptorCellCanBecomeFirstResponder)]) {
                if ([cell formDescriptorCellCanBecomeFirstResponder]) {
                    [cell formDescriptorCellBecomeFirstResponder];
                }
            }
        }
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (!self.delegate) {
        return;
    }
    if ([keyPath isEqualToString:@"formSections"]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)]) {
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            JYFormSectionDescriptor *section = [self.formSections objectAtIndex:indexSet.firstIndex];
            [self.delegate formSectionHasBeenAdded:section atIndex:indexSet.firstIndex];
        } else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)]) {
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            JYFormSectionDescriptor *section = change[NSKeyValueChangeOldKey][0];
            [self.delegate formSectionHasBeenRemoved:section atIndex:indexSet.firstIndex];
        }
    }
    
}

- (void)dealloc
{
    @try {
        [self removeObserver:self forKeyPath:@"formSections"];
    }
    @catch (NSException * __unused exception) {}
}

#pragma mark - Category

- (void)showFormSection:(JYFormSectionDescriptor *)formSection
{
    NSUInteger formIndex = [self.formSections indexOfObject:formSection];
    if (formIndex != NSNotFound) {
        return;
    }
    NSUInteger index = [self.allSections indexOfObject:formSection];
    if (index != NSNotFound) {
        while (formIndex == NSNotFound && index > 0) {
            JYFormSectionDescriptor *previous = [self.allSections objectAtIndex:--index];
            formIndex = [self.formSections indexOfObject:previous];
        }
        [self insertObject:formSection inFormSectionsAtIndex:formIndex==NSNotFound ? 0 : ++formIndex];
    }
}

-(void)hideFormSection:(JYFormSectionDescriptor *)formSection
{
    NSUInteger index = [self.formSections indexOfObject:formSection];
    if (index != NSNotFound) {
        [self removeObjectFromFormSectionsAtIndex:index];
    }
}

#pragma mark - All Sections

- (void)insertObject:(JYFormSectionDescriptor *)section inAllSectionsAtIndex:(NSUInteger)index
{
    section.formDescriptor = self;
    [self.allSections insertObject:section atIndex:index];
    section.hidden = section.hidden;
    
    [section.allRows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JYFormRowDescriptor *row = (JYFormRowDescriptor *)obj;
        [self addRowToTagCollection:row];
    }];
}

- (void)removeObjectFromAllSectionsAtIndex:(NSInteger)index
{
    [self.allSections removeObjectAtIndex:index];
}

#pragma mark - EvaluateForm

- (void)forceEvaluate
{
    for (JYFormSectionDescriptor *section in self.allSections) {
        for (JYFormRowDescriptor *row in section.allRows) {
            [self addRowToTagCollection:row];
        }
    }
    for (JYFormSectionDescriptor *section in self.allSections) {
//        for (JYFormRowDescriptor *row in section.allRows) {
//            [row evaluateIsDisabled];
//            [row evaluateIsHidden];
//        }
        [section evaluateIsHidden];
    }
}

#pragma mark - Helper

- (JYFormRowDescriptor *)nextRowDescriptorForRow:(JYFormRowDescriptor *)currentRow
{
    NSUInteger indexOfRow = [currentRow.sectionDescriptor.formRows indexOfObject:currentRow];
    if (indexOfRow != NSNotFound) {
        if (indexOfRow+1 < currentRow.sectionDescriptor.formRows.count) {
            return [currentRow.sectionDescriptor.formRows objectAtIndex:indexOfRow+1];
        } else {
            NSUInteger sectionIndex = [self.formSections indexOfObject:currentRow.sectionDescriptor];
            if (sectionIndex != NSNotFound && sectionIndex < self.formSections.count - 1) {
                JYFormSectionDescriptor *nextSection = self.formSections[++sectionIndex];
                while (nextSection.formRows.count == 0 && sectionIndex < self.formSections.count-1) {
                    nextSection = [self.formSections objectAtIndex:++sectionIndex];
                }
                return nextSection.formRows.firstObject;
            }
        }
    }
    return nil;
}

- (JYFormRowDescriptor *)previousRowDescriptorForRow:(JYFormRowDescriptor *)currentRow
{
    NSUInteger indexOfRow = [currentRow.sectionDescriptor.formRows indexOfObject:currentRow];
    if (indexOfRow != NSNotFound) {
        if (indexOfRow > 0) {
            return [currentRow.sectionDescriptor.formRows objectAtIndex:indexOfRow - 1];
        } else {
            NSUInteger sectionIndex = [self.formSections indexOfObject:currentRow.sectionDescriptor];
            if (sectionIndex != NSNotFound && sectionIndex > 0) {
                JYFormSectionDescriptor *previousSection = [self.formSections objectAtIndex:--sectionIndex];
                while (previousSection.formRows.count == 0 && sectionIndex > 0) {
                    previousSection = [self.formSections objectAtIndex:--sectionIndex];
                }
                return previousSection.formRows.lastObject;
            }
        }
    }
    return nil;
}

- (void)addRowToTagCollection:(JYFormRowDescriptor *)rowDescriptor
{
    if (rowDescriptor.tag) {
        self.allRowsByTag[rowDescriptor.tag] = rowDescriptor;
    }
}

- (void)removeRowFromTagCollection:(JYFormRowDescriptor *) rowDescriptor
{
    if (rowDescriptor.tag) {
        [self.allRowsByTag removeObjectForKey:rowDescriptor.tag];
    }
}

@end
