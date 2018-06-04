//
//  JYFormRowDescriptor.m
//  JYForm
//
//  Created by dqh on 2018/4/3.
//  Copyright © 2018年 juesheng. All rights reserved.
//

#import "JYFormRowDescriptor.h"
#import "JYFormDescriptor.h"
#import "JYFormSectionDescriptor.h"

#import "JYFormValidatorProtocol.h"

#import "JYFormBaseCell.h"
#import "JYForm.h"
#import "JYFormOptionsObject.h"

#import "JYFormValidationObject.h"


static const CGFloat JYFormRowInitialHeight = -2.0;
CGFloat const JYFormUnspecifiedCellHeight = -3.0;

@interface JYFormDescriptor (JYFormRowDescriptor)

@property (nonatomic, copy) NSDictionary *allRowsByTag;
@end


@interface JYFormSectionDescriptor (JYFormRowDescriptor)

- (void)showFormRow:(JYFormRowDescriptor *)formRow;
- (void)hideFormRow:(JYFormRowDescriptor *)formRow;
@end


@interface JYFormRowDescriptor()

@property (nonatomic, strong) JYFormBaseCell *cell;
@property (nonatomic, strong) NSMutableArray *validators;
@end



@implementation JYFormRowDescriptor

@synthesize hidden = _hidden;
@synthesize disabled = _disabled;
@synthesize height = _height;


#pragma mark - Initialize

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title must be used" userInfo:nil];
}

+ (instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType
{
    return [[self class] formRowDescriptorWithTag:tag rowType:rowType title:nil];
}

+ (instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title
{
    return [[[self class] alloc] initWithTag:tag rowType:rowType title:title];
}

- (instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title
{
    if (self = [super init]) {
        _tag = tag;
        _rowType = rowType;
        _title = title;
        
        _disabled = NO;
        _hidden = NO;
        _cellStyle = [rowType isEqualToString:JYFormRowDescriptorTypeButton] ? UITableViewCellStyleDefault : UITableViewCellStyleValue1;
        _validators = @[].mutableCopy;
        _cellConfigAfterUpdate = @{}.mutableCopy;
        _cellConfigIfDisabled = @{}.mutableCopy;
        _cellConfigAtConfigure = @{}.mutableCopy;
        _height = JYFormRowInitialHeight;
        
        [self addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (JYFormBaseCell *)cellForForm:(JYForm *)form
{
    if (!_cell) {
        id cellClass = self.cellClass ?: [JYForm cellClassesForRowDescriptorTypes][self.rowType];
        NSAssert(cellClass, @"not defined celltype like:%@",self.rowType ?: @"null");
        
        if ([cellClass isKindOfClass:[NSString class]]) {
            NSString *cellClassString = cellClass;
            _cell = [[NSClassFromString(cellClassString) alloc] initWithStyle:self.cellStyle reuseIdentifier:nil];
        } else {
            _cell = [[cellClass alloc] initWithStyle:self.cellStyle reuseIdentifier:nil];
        }
        _cell.rowDescriptor = self;
        NSAssert([_cell isKindOfClass:[JYFormBaseCell class]], @"UITableViewCell must extend from JYFormBaseCell");
        
        [self configureCellAtCreationTime];
    }
    return _cell;
}

- (void)configureCellAtCreationTime
{
    [self.cellConfigAtConfigure enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [_cell setValue:(obj == [NSNull null]) ? nil : obj forKeyPath:key];
    }];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"//////<| cellClass:%@ rowTag:%@ rowValue:%@ |<\\\\\\\\\\",NSStringFromClass([_cell class]), self.tag, self.value];
}

#pragma mark - Properties

- (JYFormAction *)action
{
    if (_action == nil) {
        _action = [[JYFormAction alloc] init];
    }
    return _action;
}

- (CGFloat)height
{
    if (_height == JYFormRowInitialHeight) {
        if ([[self.cell class] respondsToSelector:@selector(formDescriptorCellHeightForRowDescriptor:)]) {
            return [[self.cell class] formDescriptorCellHeightForRowDescriptor:self];
        } else {
            //没有指定高度
            return JYFormUnspecifiedCellHeight;
        }
    }
    return _height;
}

- (void)setHeight:(CGFloat)height
{
    _height = height;
}

#pragma mark - Public

- (NSString *)editTextValue
{
    if (self.value) {
        if (self.valueFormatter) {
            if (self.useValueFormatterDuringInput) {
                return [self displayTextValue];
            } else {
                return [self.value displayText];
            }
        } else {
            return [self.value displayText];
        }
    } else {
        return @"";
    }
}

- (NSString *)displayTextValue
{
    if (self.value) {
        if (self.valueFormatter) {
            return [self.valueFormatter stringForObjectValue:self.value];
        } else {
            return [self.value displayText];
        }
    } else {
        return self.noValueDisplayText;
    }
}


- (void)dealloc
{
    @try {
        [self removeObserver:self forKeyPath:@"value"];
    }
    @catch (NSException * __unused exception) {}
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.sectionDescriptor) return;
    
    if (object == self && [keyPath isEqualToString:@"value"]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]) {
            id newValue = [change objectForKey:NSKeyValueChangeNewKey];
            id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
            
            if ([keyPath isEqualToString:@"value"]) {
                if (self.onChangeBlock) {
                    __weak typeof(self) weakSelf = self;
                    self.onChangeBlock(oldValue, newValue, weakSelf);
                }
            }
        }
    }
}

#pragma mark - Disable

- (BOOL)disabled
{
    if (self.sectionDescriptor.formDescriptor.isDisabled) {
        return YES;
    }
    return _disabled;
}

- (void)setDisabled:(BOOL)disabled
{
    if (_disabled != disabled) {
        _disabled = disabled;
        [self evaluateIsDisabled];
    }
}

- (BOOL)evaluateIsDisabled
{
    if (_disabled) {
        [self.cell resignFirstResponder];
    }
    if (!self.sectionDescriptor.formDescriptor.delegate) {
        return _disabled;
    }
    [self.sectionDescriptor.formDescriptor.delegate formRowDescriptorDisableChanged:self];
    return _disabled;
}

#pragma mark - Hidden


-(BOOL)evaluateIsHidden
{
    if (!_hidden) {
        [self.sectionDescriptor showFormRow:self];
    } else {
        [self.cell resignFirstResponder];
        [self.sectionDescriptor hideFormRow:self];
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


#pragma mark - Validation

- (void)addValidator:(id<JYFormValidatorProtocol>)validator
{
    if (validator == nil || ![validator conformsToProtocol:@protocol(JYFormValidatorProtocol)]) {
        return;
    }
    
    if(![self.validators containsObject:validator]) {
        [self.validators addObject:validator];
    }
}

- (void)removeValidator:(id<JYFormValidatorProtocol>)validator
{
    if (validator == nil|| ![validator conformsToProtocol:@protocol(JYFormValidatorProtocol)]) {
        return;
    }
    
    if ([self.validators containsObject:validator]) {
        [self.validators removeObject:validator];
    }
}

- (BOOL)valueIsEmpty
{
    return self.value == nil || [self.value isKindOfClass:[NSNull class]] || ([self.value respondsToSelector:@selector(length)] && [self.value length]==0) ||
    ([self.value respondsToSelector:@selector(count)] && [self.value count]==0);
}

- (JYFormValidationObject *)doValidation
{
    JYFormValidationObject *valObject = nil;
    
    if (self.required) {
        if ([self valueIsEmpty]) {
            valObject = [JYFormValidationObject formValidationObjectWithMsg:@"" status:NO rowDescriptor:self];
            NSString *msg = nil;
            if (self.requireMsg != nil) {
                msg = self.requireMsg;
            } else {
                if (self.title != nil) {
                    msg = [NSString stringWithFormat:@"%@ %@",self.title,[NSString jy_localizedStringForKey:@"JYForm_Row_CantEmpty"]];
                } else {
                    msg = [NSString stringWithFormat:@"%@ %@",self.tag,[NSString jy_localizedStringForKey:@"JYForm_Row_CantEmpty"]];
                }
            }
            valObject.msg = msg;
            return valObject;
        }
    }
    
    for (id<JYFormValidatorProtocol> validatorObject in self.validators) {
        if ([validatorObject conformsToProtocol:@protocol(JYFormValidatorProtocol)]) {
            JYFormValidationObject *vObject = [validatorObject isValid:self];
            
            if (vObject != nil && !vObject.isValid) {
                return vObject;
            }
            valObject = vObject;
        } else {
            valObject = nil;
        }
    }
    return valObject;
}

@end

@implementation JYFormAction

- (instancetype)init
{
    if (self = [super init]) {
        _viewControllerPresentationMode = JYFormPresentationModeDefault;
    }
    return self;
}

- (void)setRowBlock:(void (^)(JYFormRowDescriptor * _Nonnull))rowBlock
{
    _rowBlock = rowBlock;
}
@end




