//
//  JYFormSectionDescriptor.m
//  JYForm
//
//  Created by dqh on 2018/4/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormSectionDescriptor.h"
#import "JYFormRowDescriptor.h"
#import "JYFormDescriptor.h"
#import "JYForm.h"
#import "JYFormBaseCell.h"

@interface JYFormDescriptor (JYFormSectionDescriptor)

- (void)addRowToTagCollection:(JYFormRowDescriptor *)rowDescriptor;
- (void)removeRowFromTagCollection:(JYFormRowDescriptor *) rowDescriptor;
- (void)showFormSection:(JYFormSectionDescriptor *)formSection;
- (void)hideFormSection:(JYFormSectionDescriptor *)formSection;
@end

@interface JYFormSectionDescriptor ()
@property (nonatomic, strong) NSMutableArray *formRows;
@property (nonatomic, strong) NSMutableArray *allRows;
@end

@implementation JYFormSectionDescriptor

#pragma mark - Initialize

- (instancetype)init
{
    if (self = [super init]) {
        self.formRows = @[].mutableCopy;
        self.allRows = @[].mutableCopy;
        self.sectionOptions = JYFormSectionOptionNone;
        self.headerTitle = nil;
        self.footerTitle = nil;
        self.hidden = NO;
        
        self.headerView = nil;
        self.headerHieght = 30.;
        self.footerView = nil;
        self.footerHieght = 30.;

        [self addObserver:self forKeyPath:@"formRows" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title sectionOptions:(JYFormSectionOptions)sectionOptions
{
    if (self = [self init]) {
        self.sectionOptions = sectionOptions;
        self.headerTitle = title;
    }
    return self;
}

+ (instancetype)formSection
{
    return [[self class] formSectionWithTitle:nil];
}

+ (instancetype)formSectionWithTitle:(NSString *)title
{
    return [[self class] formSectionWithTitle:title sectionOptions:JYFormSectionOptionNone];
}

+ (instancetype)formSectionWithTitle:(NSString *)title sectionOptions:(JYFormSectionOptions)sectionOptions
{
    return [[JYFormSectionDescriptor alloc] initWithTitle:title sectionOptions:sectionOptions];
}

#pragma mark - Public

- (void)addFormRow:(JYFormRowDescriptor *)formRow
{
    NSInteger index = self.allRows.count;
    [self insertObject:formRow inAllRowsAtIndex:index];
}

- (void)addFormRow:(JYFormRowDescriptor *)formRow afterRow:(JYFormRowDescriptor *)afterRow
{
    NSInteger allRowIndex = [self.allRows indexOfObject:afterRow];
    
    if (allRowIndex != NSNotFound) {
        [self insertObject:formRow inAllRowsAtIndex:allRowIndex + 1];
    } else {
        [self addFormRow:formRow];
    }
}

- (void)addFormRow:(JYFormRowDescriptor *)formRow beforeRow:(JYFormRowDescriptor *)beforeRow
{
    NSInteger allRowIndex = [self.allRows indexOfObject:beforeRow];
    
    if (allRowIndex != NSNotFound) {
        [self insertObject:formRow inAllRowsAtIndex:allRowIndex];
    } else {
        [self addFormRow:formRow];
    }
}

- (void)removeFormRowAtIndex:(NSUInteger)index
{
    if (self.formRows.count > index) {
        JYFormRowDescriptor *formRow = [self.formRows objectAtIndex:index];
        NSInteger allRowIndex = [self.allRows indexOfObject:formRow];
        [self removeObjectFromFormRowsAtIndex:index];
        [self removeObjectFromAllRowsAtIndex:allRowIndex];
    }
}

- (void)removeFormRow:(JYFormRowDescriptor *)formRow
{
    NSInteger index;
    index = [self.formRows indexOfObject:formRow];
    
    if (index != NSNotFound) {
        [self removeFormRowAtIndex:index];
        return;
    }
    index = [self.allRows indexOfObject:formRow];
    if (index != NSNotFound) {
        if (self.allRows.count > index) {
            [self removeObjectFromAllRowsAtIndex:index];
        }
    }
}

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndex toIndexPath:(NSIndexPath *)destinationIndex
{
    if ((sourceIndex.row < self.formRows.count) && (destinationIndex.row < self.formRows.count) && (sourceIndex.row != destinationIndex.row)) {
        JYFormRowDescriptor *row = [self objectInFormRowsAtIndex:sourceIndex.row];
        JYFormRowDescriptor *destRow = [self objectInAllRowsAtIndex:destinationIndex.row];
        
        [self.formRows removeObjectAtIndex:sourceIndex.row];
        [self.formRows insertObject:row atIndex:destinationIndex.row];

        [self.allRows removeObjectAtIndex:[self.allRows indexOfObject:row]];
        [self.allRows insertObject:row atIndex:[self.allRows indexOfObject:destRow]];
    }
}

- (void)dealloc
{
    @try {
        [self removeObserver:self forKeyPath:@"formRows"];
    }
    @catch (NSException * __unused exception) {}
}

#pragma mark - Show/Hide Rows

- (void)showFormRow:(JYFormRowDescriptor *)formRow
{
    NSUInteger formIndex = [self.formRows indexOfObject:formRow];
    if (formIndex != NSNotFound) {
        return;
    }
    NSUInteger index = [self.allRows indexOfObject:formRow];
    if (index != NSNotFound) {
        NSUInteger previousIndex = NSNotFound;
        while (index > 0 && previousIndex == NSNotFound) {
            JYFormRowDescriptor *previous = [self.allRows objectAtIndex:--index];
            previousIndex = [self.formRows indexOfObject:previous];
        }
        if (previousIndex == NSNotFound) {
            [self insertObject:formRow inFormRowsAtIndex:0];
        } else {
            [self insertObject:formRow inFormRowsAtIndex:previousIndex + 1];
        }
    }
}

- (void)hideFormRow:(JYFormRowDescriptor *)formRow
{
    NSUInteger index = [self.formRows indexOfObject:formRow];
    if (index != NSNotFound) {
        [self removeObjectFromFormRowsAtIndex:index];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (!self.formDescriptor.delegate) {
        return;
    }
    if ([keyPath isEqualToString:@"formRows"]) {
        if ([self.formDescriptor.formSections containsObject:self]) {
            
            if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)])
            {
                NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
                JYFormRowDescriptor *formRow = [((JYFormSectionDescriptor *)object).formRows objectAtIndex:indexSet.firstIndex];
                NSUInteger sectionIndex = [self.formDescriptor.formSections indexOfObject:object];
                [self.formDescriptor.delegate formRowHasBeenAdded:formRow atIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
            }
            else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)]) {
                //移除
                NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
                JYFormRowDescriptor *removedRow = [[change objectForKey:NSKeyValueChangeOldKey] objectAtIndex:0];
                NSUInteger sectionIndex = [self.formDescriptor.formSections indexOfObject:object];
                [self.formDescriptor.delegate formRowHasBeenRemoved:removedRow atIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
            }
        }
    }
}

#pragma mark - FormRows

- (id)objectInFormRowsAtIndex:(NSUInteger)index
{
    return [self.formRows objectAtIndex:index];
}

- (void)insertObject:(JYFormRowDescriptor *)formRow inFormRowsAtIndex:(NSUInteger)index
{
    formRow.sectionDescriptor = self;
    [self.formRows insertObject:formRow atIndex:index];
}

- (void)removeObjectFromFormRowsAtIndex:(NSUInteger)index
{
    [self.formRows removeObjectAtIndex:index];
}

#pragma mark - AllRows

- (id)objectInAllRowsAtIndex:(NSUInteger)index
{
    return [self.allRows objectAtIndex:index];
}

- (void)insertObject:(JYFormRowDescriptor *)row inAllRowsAtIndex:(NSUInteger)index
{
    row.sectionDescriptor = self;
    [self.formDescriptor addRowToTagCollection:row];
    [self.allRows insertObject:row atIndex:index];
    
    //If hidden is NO, add this row to formrows Array,else remove
    row.hidden = row.hidden;
}

- (void)removeObjectFromAllRowsAtIndex:(NSUInteger)index
{
    JYFormRowDescriptor *row = [self.allRows objectAtIndex:index];
    
    [self.formDescriptor removeRowFromTagCollection:row];
    [self.allRows removeObjectAtIndex:index];
}

#pragma mark - Hidden

- (BOOL)evaluateIsHidden
{
    if (_hidden) {
        JYFormBaseCell *cell = (JYFormBaseCell *)[((JYForm *)self.formDescriptor.delegate).tableView findFirstResponder];
        if ([cell isKindOfClass:[JYFormBaseCell class]]) {
            [cell resignFirstResponder];
        }
        [self.formDescriptor hideFormSection:self];
    } else {
        [self.formDescriptor showFormSection:self];
    }
    return _hidden;
}

- (void)setHidden:(BOOL)hidden
{
    if (_hidden != hidden) {
        _hidden = hidden;
    }
    [self evaluateIsHidden];
}

@end
