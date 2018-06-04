//
//  JYForm.m
//  JYForm
//
//  Created by dqh on 2018/4/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYForm.h"

#import "JYFormRowNavigationAccessoryView.h"

#import "JYFormTextFieldCell.h"
#import "JYFormTextViewCell.h"
#import "JYFormSelectorCell.h"
#import "JYFormDateCell.h"
#import "JYFormDatePickerCell.h"
#import "JYFormSwitchCell.h"
#import "JYFormCheckCell.h"
#import "JYFormStepCounterCell.h"
#import "JYFormSegmentedCell.h"
#import "JYFormSliderCell.h"
#import "JYFormButtonCell.h"


#define JY_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define JY_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define JY_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define JY_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define JY_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending

NSString *const JYFormRowDescriptorTypeText = @"text";
NSString *const JYFormRowDescriptorTypeName = @"name";
NSString *const JYFormRowDescriptorTypeEmail = @"email";
NSString *const JYFormRowDescriptorTypeNumber = @"number";
NSString *const JYFormRowDescriptorTypeInteger = @"integer";
NSString *const JYFormRowDescriptorTypeDecimal = @"decimal";
NSString *const JYFormRowDescriptorTypePassword = @"password";
NSString *const JYFormRowDescriptorTypePhone = @"phone";
NSString *const JYFormRowDescriptorTypeURL = @"url";
NSString *const JYFormRowDescriptorTypeTextView = @"textView";

NSString *const JYFormRowDescriptorTypeSelectorPush = @"selectorPush";
NSString *const JYFormRowDescriptorTypeMultipleSelector = @"multipleSelector";
NSString *const JYFormRowDescriptorTypeSelectorActionSheet = @"selectorActionSheet";
NSString *const JYFormRowDescriptorTypeSelectorAlertView = @"selectorAlertView";
NSString *const JYFormRowDescriptorTypeSelectorPickerView = @"selectorPickerView";
NSString *const JYFormRowDescriptorTypeInfo = @"info";

NSString *const JYFormRowDescriptorTypeDate = @"date";
NSString *const JYFormRowDescriptorTypeTime = @"time";
NSString *const JYFormRowDescriptorTypeDateTime = @"datetime";
NSString *const JYFormRowDescriptorTypeCountDownTimer = @"countDownTimer";
NSString *const JYFormRowDescriptorTypeDateInline = @"dateInline";

NSString *const JYFormRowDescriptorTypeDatePicker = @"datePicker";


NSString *const JYFormRowDescriptorTypeSwitch = @"switch";
NSString *const JYFormRowDescriptorTypeCheck = @"check";
NSString *const JYFormRowDescriptorTypeStepCounter = @"stepCounter";
NSString *const JYFormRowDescriptorTypeSelectorSegmentedControl = @"selectorSegmentedControl";
NSString *const JYFormRowDescriptorTypeSlider = @"slider";
NSString *const JYFormRowDescriptorTypeButton = @"button";

static const CGFloat kCellestimatedRowHeight = 55.0;

@interface JYFormRowDescriptor(JYForm)
- (BOOL)evaluateIsDisabled;
- (BOOL)evaluateIsHidden;
@end


@interface JYFormSectionDescriptor(JYForm)
- (BOOL)evaluateIsHidden;
@end


@interface JYFormDescriptor (JYForm)
@property (nonatomic, strong) NSMutableDictionary *rowObservers;
@end


@interface JYForm() <UITableViewDelegate,UITableViewDataSource,JYFormDescriptorDelegate>
///|< Default is UITableViewStyleGrouped.
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) JYFormRowNavigationAccessoryView *navigationAccessoryView;

@property (nonatomic, strong) NSNumber *oldBottomTableMargin;
@property (nonatomic, strong) NSNumber *oldTopTableInset;
@end

@implementation JYForm

#pragma mark - 初始化方法

+ (instancetype)formWithFormDescriptor:(JYFormDescriptor *)form autoLayoutSuperView:(UIView *)superView
{
    return [[[self class] alloc] initWithFormDescriptor:form autoLayoutSuperView:superView];
}

+ (instancetype)formWithFormDescriptor:(JYFormDescriptor *)form frame:(CGRect)frame
{
    return [[[self class] alloc] initWithFormDescriptor:form frame:frame];
}

- (instancetype)initWithFormDescriptor:(JYFormDescriptor *)form autoLayoutSuperView:(UIView *)superView
{
    if (self = [super init]) {
        if (!superView || ![superView isKindOfClass:[UIView class]]) {
            return nil;
        }
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.formDescriptor = form;
        _tableViewStyle = UITableViewStyleGrouped;
        
        [superView addSubview:self];
        [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[form]-0-|" options:0 metrics:nil views:@{@"form" : self}]];
        [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[form]-0-|" options:0 metrics:nil views:@{@"form" : self}]];
    }
    return self;
}

- (instancetype)initWithFormDescriptor:(JYFormDescriptor *)form
{
    return [self initWithFormDescriptor:form frame:CGRectZero];
}

- (instancetype)initWithFormDescriptor:(JYFormDescriptor *)form frame:(CGRect)frame
{
    return [self initWithFormDescriptor:form frame:frame style:UITableViewStyleGrouped];
}

- (instancetype)initWithFormDescriptor:(JYFormDescriptor *)form frame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame]){
        _tableViewStyle = style;
        self.formDescriptor = form;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        _formDescriptor = nil;
        _tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)beginLoading
{
    if (!self.superview) {
        return;
    }
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:self.tableViewStyle];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if ([self.tableView respondsToSelector:@selector(cellLayoutMarginsFollowReadableWidth)]) {
            //ios9.0以后出现的特性
            self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
    }
    if (!self.tableView.superview) {
        [self addSubview:self.tableView];
    }
    if (!self.tableView.delegate){
        self.tableView.delegate = self;
    }
    if (!self.tableView.dataSource){
        self.tableView.dataSource = self;
    }
    if (JY_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = kCellestimatedRowHeight;
    }
    self.tableView.allowsSelectionDuringEditing = YES;
    self.formDescriptor.delegate = self;
    [self.tableView reloadData];
    
    [self addNotificationObserver];
}

- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Cell Classes

+ (NSMutableDictionary *)cellClassesForRowDescriptorTypes
{
    static NSMutableDictionary * _cellClassesForRowDescriptorTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellClassesForRowDescriptorTypes = @{
                                              JYFormRowDescriptorTypeText                : [JYFormTextFieldCell class],
                                              JYFormRowDescriptorTypeName                : [JYFormTextFieldCell class],
                                              JYFormRowDescriptorTypeEmail               : [JYFormTextFieldCell class],
                                              JYFormRowDescriptorTypeNumber              : [JYFormTextFieldCell class],
                                              JYFormRowDescriptorTypeInteger             : [JYFormTextFieldCell class],
                                              JYFormRowDescriptorTypeDecimal             : [JYFormTextFieldCell class],
                                              JYFormRowDescriptorTypePassword            : [JYFormTextFieldCell class],
                                              JYFormRowDescriptorTypePhone               : [JYFormTextFieldCell class],
                                              JYFormRowDescriptorTypeURL                 : [JYFormTextFieldCell class],
                                              JYFormRowDescriptorTypeTextView            : [JYFormTextViewCell class],

                                              JYFormRowDescriptorTypeSelectorPush        : [JYFormSelectorCell class],
                                              JYFormRowDescriptorTypeMultipleSelector    : [JYFormSelectorCell class],
                                              JYFormRowDescriptorTypeSelectorActionSheet : [JYFormSelectorCell class],
                                              JYFormRowDescriptorTypeSelectorAlertView   : [JYFormSelectorCell class],
                                              JYFormRowDescriptorTypeSelectorPickerView  : [JYFormSelectorCell class],
                                              JYFormRowDescriptorTypeInfo                : [JYFormSelectorCell class],
                                              
                                              JYFormRowDescriptorTypeDate                : [JYFormDateCell class],
                                              JYFormRowDescriptorTypeTime                : [JYFormDateCell class],
                                              JYFormRowDescriptorTypeDateTime            : [JYFormDateCell class],
                                              JYFormRowDescriptorTypeCountDownTimer      : [JYFormDateCell class],
                                              JYFormRowDescriptorTypeDateInline          : [JYFormDateCell class],
                                              JYFormRowDescriptorTypeDatePicker          : [JYFormDatePickerCell class],
                                              
                                              JYFormRowDescriptorTypeSwitch              : [JYFormSwitchCell class],
                                              JYFormRowDescriptorTypeCheck               : [JYFormCheckCell class],
                                              JYFormRowDescriptorTypeStepCounter         : [JYFormStepCounterCell class],
                                              JYFormRowDescriptorTypeSelectorSegmentedControl : [JYFormSegmentedCell class],
                                              JYFormRowDescriptorTypeSlider              : [JYFormSliderCell class],
                                              JYFormRowDescriptorTypeButton              : [JYFormButtonCell class]
                                              }.mutableCopy;
    });
    return _cellClassesForRowDescriptorTypes;
}

#pragma mark - inlineRowDescriptorTypes

+ (NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes
{
    static NSMutableDictionary *_inlineRowDescriptorTypesForRowDescriptorTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inlineRowDescriptorTypesForRowDescriptorTypes = @{
                                                           JYFormRowDescriptorTypeDateInline : JYFormRowDescriptorTypeDatePicker
                                                           }.mutableCopy;
    });
    return _inlineRowDescriptorTypesForRowDescriptorTypes;
}

#pragma mark - JYFormDescriptorDelegate

- (void)formSectionHasBeenRemoved:(JYFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:[self deleteRowAnimationForSection:formSection]];
    [self.tableView endUpdates];
}

- (void)formSectionHasBeenAdded:(JYFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:[self insertRowAnimationForSection:formSection]];
    [self.tableView endUpdates];
}

- (void)formRowHasBeenAdded:(JYFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:[self insertRowAnimationForRow:formRow]];
    [self.tableView endUpdates];
}

- (void)formRowHasBeenRemoved:(JYFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:[self deleteRowAnimationForRow:formRow]];
    [self.tableView endUpdates];
}

- (void)formRowDescriptorDisableChanged:(JYFormRowDescriptor *)formRow
{
    JYFormBaseCell *cell = [formRow cellForForm:self];
    [cell update];
}

- (void)formRowDescriptorValueHasChanged:(JYFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    if (self.delegate) {
        [self.delegate formRowDescriptorValueHasChanged:self formRow:formRow oldValue:oldValue newValue:newValue];
    }
}

#pragma mark - JYFormViewDelegate

- (NSDictionary *)formValues
{
    return self.formDescriptor.formValues;
}

- (NSDictionary *)httpParameters
{
    return [self.formDescriptor httpParameters:self];
}

- (UIView *)inputAccessoryViewForRowDescriptor:(JYFormRowDescriptor *)rowDescriptor
{
    if ([[JYForm inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:rowDescriptor.rowType]) {
        return nil;
    }
    UITableViewCell<JYFormDescriptorCell> *cell = [rowDescriptor cellForForm:self];
    if (![cell formDescriptorCellCanBecomeFirstResponder]) {
        return  nil;
    }
    JYFormRowDescriptor *previousRow = [self nextRowDescriptorForRow:rowDescriptor withDirection:JYFormRowNavigationDirectionPrevious];
    JYFormRowDescriptor *nextRow = [self nextRowDescriptorForRow:rowDescriptor withDirection:JYFormRowNavigationDirectionNext];
    
    [self.navigationAccessoryView.previousButton setEnabled:previousRow != nil];
    [self.navigationAccessoryView.nextButton setEnabled:nextRow != nil];
    
    return self.navigationAccessoryView;
}

- (void)didSelectFormRow:(JYFormRowDescriptor *)formRow
{
    if ([[formRow cellForForm:self] respondsToSelector:@selector(formDescriptorCellDidSelectedWithForm:)]){
        [[formRow cellForForm:self] formDescriptorCellDidSelectedWithForm:self];
    }
}

- (void)reloadFormRow:(JYFormRowDescriptor *)formRow
{
    NSIndexPath *indexPath = [self.formDescriptor indexPathOfFormRow:formRow];
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)deselectFormRow:(JYFormRowDescriptor *)formRow
{
    NSIndexPath *rowIndex = [self.formDescriptor indexPathOfFormRow:formRow];
    if (rowIndex) {
        [self.tableView deleteRowsAtIndexPaths:@[rowIndex] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (JYFormBaseCell *)updateFormRow:(JYFormRowDescriptor *)formRow
{
    JYFormBaseCell *cell = [formRow cellForForm:self];
    [self configureCell:cell];
    return cell;
}

- (void)beginEditing:(JYFormRowDescriptor *)rowDescriptor
{
    [[rowDescriptor cellForForm:self] highlight];
}

- (void)endEditing:(JYFormRowDescriptor *)rowDescriptor
{
    [[rowDescriptor cellForForm:self] unhighlight];
}

- (void)ensureRowIsVisible:(JYFormRowDescriptor *)inlineRowDescriptor
{
    JYFormBaseCell *inlineCell = [inlineRowDescriptor cellForForm:self];
    NSIndexPath *rowIndex = [self.formDescriptor indexPathOfFormRow:inlineRowDescriptor];
    
    if (!inlineCell.window || (self.tableView.contentOffset.y + self.tableView.frame.size.height <= inlineCell.frame.origin.y + inlineCell.frame.size.height)) {
        [self.tableView scrollToRowAtIndexPath:rowIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Notification

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    UIView *firstResponderView = [self.tableView findFirstResponder];
    UITableViewCell<JYFormDescriptorCell> *cell = [firstResponderView formDescriptorCell];
    
    if (cell) {
        //转换坐标
        NSDictionary *keyboardInfo = notification.userInfo;
        CGRect keybordFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect convertTableFrame = [self.tableView.superview convertRect:self.tableView.frame toView:self.tableView.window];
        CGFloat nowBottomMargin = CGRectGetMaxY(convertTableFrame) - CGRectGetMinY(keybordFrame) + (_oldBottomTableMargin ? _oldBottomTableMargin.doubleValue : 0);
        UIEdgeInsets tableContentInset = self.tableView.contentInset;
        UIEdgeInsets tableScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
        _oldTopTableInset = _oldTopTableInset ?: @(tableContentInset.top);

        if (nowBottomMargin > 0) {
            _oldBottomTableMargin = @(nowBottomMargin);
            tableContentInset.top = nowBottomMargin;
            tableScrollIndicatorInsets.top = nowBottomMargin;
            
            self.tableView.contentInset = tableContentInset;
            self.tableView.scrollIndicatorInsets = tableContentInset;
        
            [UIView animateWithDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
                self.transform = CGAffineTransformIdentity;
                self.transform = CGAffineTransformMakeTranslation(0, -nowBottomMargin);

                NSIndexPath *selectRow = [self.tableView indexPathForCell:cell];
                [self.tableView scrollToRowAtIndexPath:selectRow atScrollPosition:UITableViewScrollPositionNone animated:NO];
            } completion:nil];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets tableContentInset = self.tableView.contentInset;
    UIEdgeInsets tableScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
    
    tableContentInset.top = [_oldTopTableInset floatValue];
    tableScrollIndicatorInsets.top = [_oldTopTableInset floatValue];
    _oldTopTableInset = nil;
    _oldBottomTableMargin = nil;

    self.tableView.contentInset = tableContentInset;
    self.tableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
    
    self.transform = CGAffineTransformIdentity;
}

#pragma mark - Public

- (NSArray *)formValidationErrors
{
    return self.formDescriptor.localValidationErrors;
}

- (void)showFormValidationError:(NSError *)error
{
    if (!error) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString jy_localizedStringForKey:@"JYForm_Form_ErrorTitle"]
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:[NSString jy_localizedStringForKey:@"JYForm_Form_ErrorOk"] style:UIAlertActionStyleDefault handler:nil]];
    [self.formController presentViewController:alertController animated:YES completion:nil];
}

- (void)showFormValidationError:(NSError *)error withTitle:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:[NSString jy_localizedStringForKey:@"JYForm_Form_ErrorOk"] style:UIAlertActionStyleDefault handler:nil]];
    [self.formController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Navigation Between Fields

- (void)rowNavigationAction:(UIBarButtonItem *)sender
{
    [self navigateToDirection:sender==self.navigationAccessoryView.nextButton ? JYFormRowNavigationDirectionNext : JYFormRowNavigationDirectionPrevious];
}

- (void)rowNavigationDone:(UIBarButtonItem *)sender
{
    [self.tableView endEditing:YES];
}

- (void)navigateToDirection:(JYFormRowNavigationDirection)direction
{
    UIView *firstResponder = [self.tableView findFirstResponder];
    UITableViewCell<JYFormDescriptorCell> *currentCell = [firstResponder formDescriptorCell];
    NSIndexPath *currentIndexPath = [self.tableView indexPathForCell:currentCell];
    JYFormRowDescriptor *currentRow = [self.formDescriptor formRowAtIndex:currentIndexPath];
    JYFormRowDescriptor *nextRow = [self nextRowDescriptorForRow:currentRow withDirection:direction];
    
    if (nextRow) {
        UITableViewCell<JYFormDescriptorCell> *cell = (UITableViewCell<JYFormDescriptorCell> *)[nextRow cellForForm:self];
        if ([cell formDescriptorCellCanBecomeFirstResponder]){
            NSIndexPath *indexPath = [self.formDescriptor indexPathOfFormRow:nextRow];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [cell formDescriptorCellBecomeFirstResponder];
        }
    }
}

- (JYFormRowDescriptor *)nextRowDescriptorForRow:(JYFormRowDescriptor *)currentRow withDirection:(JYFormRowNavigationDirection)direction
{
    if (!currentRow) {
        return nil;
    }
    JYFormRowDescriptor *nextRow = (direction==JYFormRowNavigationDirectionNext) ? [self.formDescriptor nextRowDescriptorForRow:currentRow] : [self.formDescriptor previousRowDescriptorForRow:currentRow];
    if (!nextRow) {
        return nil;
    }
    UITableViewCell<JYFormDescriptorCell> *cell = [nextRow cellForForm:self];
    if (!nextRow.disabled && [cell formDescriptorCellCanBecomeFirstResponder]) {
        return nextRow;
    }
    return [self nextRowDescriptorForRow:nextRow withDirection:direction];
}

#pragma mark - Helper

- (UITableViewRowAnimation)insertRowAnimationForRow:(JYFormRowDescriptor *)formRow
{
    return UITableViewRowAnimationFade;
}

- (UITableViewRowAnimation)deleteRowAnimationForRow:(JYFormRowDescriptor *)formRow
{
    return UITableViewRowAnimationFade;
}

- (UITableViewRowAnimation)insertRowAnimationForSection:(JYFormSectionDescriptor *)formSection
{
    return UITableViewRowAnimationFade;
}

- (UITableViewRowAnimation)deleteRowAnimationForSection:(JYFormSectionDescriptor *)formSection
{
    return UITableViewRowAnimationFade;
}

- (void)configureCell:(JYFormBaseCell *)cell
{
    [cell update];
    [cell.rowDescriptor.cellConfigAfterUpdate enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [cell setValue:obj == [NSNull null] ? nil : obj forKeyPath:key];
    }];
    if (cell.rowDescriptor.disabled) {
        [cell.rowDescriptor.cellConfigIfDisabled enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [cell setValue:(obj == [NSNull null] ? nil : obj) forKeyPath:key];
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.formDescriptor.formSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= self.formDescriptor.formSections.count) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"超出最大section"] userInfo:nil];
    }
    return [self.formDescriptor.formSections[section] formRows].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYFormRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    return [self updateFormRow:rowDescriptor];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYFormRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    if (rowDescriptor.disabled) {
        return NO;
    }
    JYFormBaseCell *baseCell = [rowDescriptor cellForForm:self];
    if ([baseCell conformsToProtocol:@protocol(JYFormInlineRowDescriptorCell)] && ((id<JYFormInlineRowDescriptorCell>)baseCell).inlineRowDescriptor) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JYFormRowDescriptor *row = [self.formDescriptor formRowAtIndex:indexPath];
        UIView *firstResponder = [[row cellForForm:self] findFirstResponder];
        
        if (firstResponder) {
            [self.tableView endEditing:YES];
        }
        [row.sectionDescriptor removeFormRowAtIndex:indexPath.row];
    }
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.formDescriptor.formSections[section] headerTitle];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [self.formDescriptor.formSections[section] footerTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYFormRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    CGFloat height = rowDescriptor.height;
    if (height != JYFormUnspecifiedCellHeight) {
        return height;
    }
    return kCellestimatedRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYFormRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    CGFloat height = rowDescriptor.height;
    if (height != JYFormUnspecifiedCellHeight) {
        return height;
    }
    if (JY_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        return self.tableView.estimatedRowHeight;
    }
    return kCellestimatedRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYFormRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    if (rowDescriptor.disabled) {
        return;
    }
    UITableViewCell<JYFormDescriptorCell> *cell = [rowDescriptor cellForForm:self];
    if (!([cell formDescriptorCellCanBecomeFirstResponder] && [cell formDescriptorCellBecomeFirstResponder])) {
        [self.tableView endEditing:YES];
    }
    [self didSelectFormRow:rowDescriptor];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYFormSectionDescriptor *section = [self.formDescriptor formSectionAtIndex:indexPath.section];
    if (section.sectionOptions & JYFormSectionOptionCanDelete) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle editStyle = [self tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    if (editStyle == UITableViewCellEditingStyleNone) {
        return NO;
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    JYFormSectionDescriptor *sectionDescriptor = [self.formDescriptor formSectionAtIndex:section];
    return sectionDescriptor.headerHieght;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    JYFormSectionDescriptor *sectionDescriptor = [self.formDescriptor formSectionAtIndex:section];
    return sectionDescriptor.footerHieght;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    JYFormSectionDescriptor *sectionDescriptor = [self.formDescriptor formSectionAtIndex:section];
    return sectionDescriptor.headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    JYFormSectionDescriptor *sectionDescriptor = [self.formDescriptor formSectionAtIndex:section];
    return sectionDescriptor.footerView;
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // called when 'return' key pressed. return NO to ignore.
    UITableViewCell<JYFormDescriptorCell> * cell = [textField formDescriptorCell];
    JYFormRowDescriptor *currentRow = cell.rowDescriptor;
    JYFormRowDescriptor *nextRow = [self nextRowDescriptorForRow:currentRow withDirection:JYFormRowNavigationDirectionNext];
    
    if (nextRow){
        UITableViewCell<JYFormDescriptorCell> *nextCell = (UITableViewCell<JYFormDescriptorCell> *)[nextRow cellForForm:self];
        if ([nextCell formDescriptorCellCanBecomeFirstResponder]){
            [nextCell formDescriptorCellBecomeFirstResponder];
            return YES;
        }
    }
    [self.tableView endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITableViewCell<JYFormDescriptorCell> *cell = [textField formDescriptorCell];
    JYFormRowDescriptor *currentRow = cell.rowDescriptor;
    JYFormRowDescriptor *nextRow = [self nextRowDescriptorForRow:currentRow withDirection:JYFormRowNavigationDirectionNext];

    if ([cell conformsToProtocol:@protocol(JYFormReturnKeyProtocol)]) {
        textField.returnKeyType = nextRow ? ((id<JYFormReturnKeyProtocol>)cell).nextReturnKeyType : ((id<JYFormReturnKeyProtocol>)cell).returnKeyType;
    } else {
        textField.returnKeyType = nextRow ? UIReturnKeyNext : UIReturnKeyDefault;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.formDescriptor.endEditingTableViewOnScroll == NO) {
        return;
    }
    UIView *firstResponder = [self.tableView findFirstResponder];
    if ([firstResponder conformsToProtocol:@protocol(JYFormDescriptorCell)]) {
        id<JYFormDescriptorCell> cell = (id<JYFormDescriptorCell>)firstResponder;
        if ([[JYForm inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:cell.rowDescriptor.rowType]) {
            return;
        }
    }
    [self.tableView endEditing:YES];
}

#pragma mark - properties

- (void)setFormDescriptor:(JYFormDescriptor *)formDescriptor
{
    if (_formDescriptor != formDescriptor) {
        _formDescriptor.delegate = nil;
        [self.tableView endEditing:YES];
        
        _formDescriptor = formDescriptor;
        _formDescriptor.delegate = self;
        [_formDescriptor forceEvaluate];
    }
}

- (JYFormRowNavigationAccessoryView *)navigationAccessoryView
{
    if (_navigationAccessoryView == nil) {
        _navigationAccessoryView = [JYFormRowNavigationAccessoryView new];
        _navigationAccessoryView.previousButton.target = self;
        _navigationAccessoryView.previousButton.action = @selector(rowNavigationAction:);
        _navigationAccessoryView.nextButton.target = self;
        _navigationAccessoryView.nextButton.action = @selector(rowNavigationAction:);
        _navigationAccessoryView.doneButton.target = self;
        _navigationAccessoryView.doneButton.action = @selector(rowNavigationDone:);
        _navigationAccessoryView.tintColor = self.tintColor;
    }
    return _navigationAccessoryView;
}
@end
