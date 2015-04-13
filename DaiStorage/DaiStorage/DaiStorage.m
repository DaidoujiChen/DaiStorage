//
//  DaiStorage.m
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/8.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiStorage.h"
#import <objc/runtime.h>

@implementation NSString (DaiStorage)

- (SEL)ds_selector {
    return NSSelectorFromString(self);
}

- (Class)ds_class {
    return NSClassFromString(self);
}

@end

@implementation DaiStorage

#pragma mark - readonly property

//回傳目前所含內容
- (NSDictionary *)storeContents {
	NSMutableDictionary *returnValues = [NSMutableDictionary dictionary];
	__weak id weakSelf = self;
	[[self listPropertys] enumerateObjectsUsingBlock: ^(NSDictionary *eachProperty, NSUInteger idx, BOOL *stop) {
        avoidPerformSelectorWarning(id currentProperty = [weakSelf performSelector:[eachProperty[DaiStoragePropertyName] ds_selector]];)
        
        //輸出的如果是 DaiStorage 的子類, 則由其 storeContents method 輸出
        if ([[currentProperty class] isSubclassOfClass:[DaiStorage class]]) {
            avoidPerformSelectorWarning(currentProperty = [currentProperty performSelector:@selector(storeContents)];)
        }
        //輸出的如果是 DaiStorageArray 類
        else if ([currentProperty isKindOfClass:[DaiStorageArray class]]) {
            DaiStorageArray *arrayProperty = currentProperty;
            NSMutableArray *newProperty = [NSMutableArray array];
            [currentProperty enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([[obj class] isSubclassOfClass:[DaiStorage class]]) {
                    avoidPerformSelectorWarning([newProperty addObject:[obj performSelector:@selector(storeContents)]];)
                }
                else {
                    [newProperty addObject:[weakSelf reworkByExportRule:@{ DaiStoragePropertyType:arrayProperty.allowClass } reworkItem:obj]];
                }
            }];
            if (newProperty.count) {
                currentProperty = newProperty;
            }
            else {
                currentProperty = nil;
            }
        }
        //反之則看需不需要經過處理
        else {
            currentProperty = [weakSelf reworkByExportRule:eachProperty reworkItem:currentProperty];
        }
        
        if (currentProperty) {
            returnValues[eachProperty[DaiStoragePropertyName]] = currentProperty;
        }
	}];
    
    if (returnValues.count) {
        return returnValues;
    }
    else {
        return nil;
    }
}

#pragma mark - class method

//共用同一個對象
+ (instancetype)shared {
	if (!objc_getAssociatedObject(self, _cmd)) {
		objc_setAssociatedObject(self, _cmd, [[self class] new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - instance method

//從 importpath 讀取資料, 不足的部分由 defaultpath 補齊
- (void)importPath:(DaiStoragePath *)importPath defaultPath:(DaiStoragePath *)defaultPath {
    NSDictionary *importContents = importPath ? [self jsonDataFromPath:importPath] : nil;
    NSDictionary *defaultContents = defaultPath ? [self jsonDataFromPath:defaultPath] : nil;
    [self restoreContents:importContents defaultContent:defaultContents];
}

//輸出至 exportpath
- (BOOL)exportPath:(DaiStoragePath *)exportPath {
    return [self jsonDataToPath:exportPath];
}

// handle 無法處理的型別
- (void)reworkRuleForClass:(__unsafe_unretained Class)aClass whenImport:(ImportRuleBlock)importRule whenExport:(ExportRuleBlock)exportRule {
    [self reworkRuleNamed:NSStringFromClass(aClass) whenImport:importRule whenExport:exportRule];
}

// handle 特定某一個名稱
- (void)reworkRuleForKeyPath:(NSString *)keyPath whenImport:(ImportRuleBlock)importRule whenExport:(ExportRuleBlock)exportRule {
    [self reworkRuleNamed:keyPath whenImport:importRule whenExport:exportRule];
}

#pragma mark - private instance method

- (void)restoreContents:(NSDictionary *)importContents defaultContent:(NSDictionary *)defaultContent {
    __weak id weakSelf = self;
    [[self listPropertys] enumerateObjectsUsingBlock:^(NSDictionary *eachProperty, NSUInteger idx, BOOL *stop) {
        id importItem = nil;
        if (importContents[eachProperty[DaiStoragePropertyName]]) {
            importItem = importContents[eachProperty[DaiStoragePropertyName]];
        }
        else if (defaultContent[eachProperty[DaiStoragePropertyName]]) {
            importItem = defaultContent[eachProperty[DaiStoragePropertyName]];
        }
        
        if (importItem) {
            avoidPerformSelectorWarning(id currentProperty = [weakSelf performSelector:[eachProperty[DaiStoragePropertyName] ds_selector]];)
            
            //如果是 DaiStorage 型別的物件, 則把 object 丟給他自己的 restoreContents method 去 handle
            if ([[currentProperty class] isSubclassOfClass:[DaiStorage class]]) {
                avoidPerformSelectorWarning([currentProperty performSelector:_cmd withObject:importItem withObject:nil];)
            }
            //如果是 DaiStorageArray 型別的物件, 則一個一個讀取回來
            else if ([currentProperty isKindOfClass:[DaiStorageArray class]]) {
                DaiStorageArray *arrayProperty = currentProperty;
                [arrayProperty removeAllObjects];
                [importItem enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([[arrayProperty.allowClass ds_class] isSubclassOfClass:[DaiStorage class]]) {
                        id newStorage = [[arrayProperty.allowClass ds_class] new];
                        avoidPerformSelectorWarning([newStorage performSelector:_cmd withObject:obj withObject:nil];)
                        [arrayProperty addObject:newStorage];
                    }
                    else {
                        [arrayProperty addObject:[weakSelf reworkByImportRule:@{DaiStoragePropertyType:arrayProperty.allowClass } reworkItem:obj]];
                    }
                }];
                avoidPerformSelectorWarning([weakSelf performSelector:[weakSelf setterSelectorFromGetter:eachProperty[DaiStoragePropertyName]] withObject:arrayProperty];)
            }
            else {
                importItem = [weakSelf reworkByImportRule:eachProperty reworkItem:importItem];
                avoidPerformSelectorWarning([weakSelf performSelector:[weakSelf setterSelectorFromGetter:eachProperty[DaiStoragePropertyName]] withObject:importItem];)
            }
        }
    }];
}

#pragma mark * rule import / export selector name

//用特定的名稱 runtime 建立 import / export methods
- (void)reworkRuleNamed:(NSString *)ruleNamed whenImport:(ImportRuleBlock)importRule whenExport:(ExportRuleBlock)exportRule {
    const char *blockEncoding = [[NSString stringWithFormat: @"%s%s%s%s", @encode(id), @encode(id), @encode(SEL), @encode(id)] UTF8String];
    
    //add import rule method
    ReworkRuleBlock reworkImport = ^id(id self, id importValue) {
        return importRule(importValue);
    };
    IMP importIMP = imp_implementationWithBlock(reworkImport);
    class_addMethod([self class], [self ruleImportSelector:ruleNamed], importIMP, blockEncoding);
    
    //add export rule method
    ReworkRuleBlock reworkExport = ^id(id self, id exportValue) {
        return exportRule(exportValue);
    };
    IMP exportIMP = imp_implementationWithBlock(reworkExport);
    class_addMethod([self class], [self ruleExportSelector:ruleNamed], exportIMP, blockEncoding);
}

//轉換 import 的物件
- (id)reworkByImportRule:(NSDictionary *)property reworkItem:(id)reworkItem {
    id newItem = reworkItem;
    if (newItem) {
        if ([self respondsToSelector:[self ruleImportSelector:property[DaiStoragePropertyType]]]) {
            avoidPerformSelectorWarning(newItem = [self performSelector:[self ruleImportSelector:property[DaiStoragePropertyType]] withObject:newItem];)
        }
        else if ([self respondsToSelector:[self ruleImportSelector:property[DaiStoragePropertyName]]]) {
            avoidPerformSelectorWarning(newItem = [self performSelector:[self ruleImportSelector:property[DaiStoragePropertyName]] withObject:newItem];)
        }
    }
    return newItem;
}

//轉換 export 的物件
- (id)reworkByExportRule:(NSDictionary *)property reworkItem:(id)reworkItem {
    id newItem = reworkItem;
    if (newItem) {
        if ([self respondsToSelector:[self ruleExportSelector:property[DaiStoragePropertyType]]]) {
            avoidPerformSelectorWarning(newItem = [self performSelector:[self ruleExportSelector:property[DaiStoragePropertyType]] withObject:newItem];)
        }
        else if ([self respondsToSelector:[self ruleExportSelector:property[DaiStoragePropertyName]]]) {
            avoidPerformSelectorWarning(newItem = [self performSelector:[self ruleExportSelector:property[DaiStoragePropertyName]] withObject:newItem];)
        }
    }
    return newItem;
}

- (SEL)ruleImportSelector:(NSString *)specialName {
    NSString *ruleImportSelectorName = [NSString stringWithFormat:@"daiStorage_ruleImport%@:", specialName];
    return [ruleImportSelectorName ds_selector];
}

- (SEL)ruleExportSelector:(NSString *)specialName {
    NSString *ruleExportSelectorName = [NSString stringWithFormat:@"daiStorage_ruleExport%@:", specialName];
    return [ruleExportSelectorName ds_selector];
}

#pragma mark * json data <-> dictionary

// json data 存入指定路徑
- (BOOL)jsonDataToPath:(DaiStoragePath *)path {
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [path path], NSStringFromClass([self class])];
    return [[self jsonDataByContents:self.storeContents] writeToFile:filePath atomically:YES];
}

// contents 轉為 json data
- (NSData *)jsonDataByContents:(NSDictionary *)contents {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contents options:NSJSONWritingPrettyPrinted error:&error];
    NSAssert(!error, error.description);
    return jsonData;
}

//從指定路徑讀取 json data
- (NSDictionary *)jsonDataFromPath:(DaiStoragePath *)path {
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [path path], NSStringFromClass([self class])];
    NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:filePath];
    return jsonData ? [self dictionaryByJsonData:jsonData] : nil;
}

// json data 轉換為 contents
- (NSDictionary *)dictionaryByJsonData:(NSData *)jsonData {
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSAssert(!error, error.description);
    return dictionary;
}

#pragma mark * list propertys in class
//http://stackoverflow.com/questions/754824/get-an-object-properties-list-in-objective-c

//列出當前 class 含有的 property 有哪些
- (NSArray *)listPropertys {
	NSMutableArray *propertyNames = [NSMutableArray array];
	unsigned int outCount, i;
	objc_property_t *properties = class_copyPropertyList([self class], &outCount);
	for (i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		const char *propName = property_getName(property);
		if (propName) {
			NSString *propertyName = [NSString stringWithCString:propName encoding:[NSString defaultCStringEncoding]];
			NSString *propertyType = [self readableTypeForEncoding:[self attributesDictionaryForProperty:property][@"T"]];
			[propertyNames addObject:@{ DaiStoragePropertyName:propertyName, DaiStoragePropertyType:propertyType }];
		}
	}
	free(properties);
	return propertyNames;
}

// from FLEX FLEXRuntimeUtility
- (NSDictionary *)attributesDictionaryForProperty:(objc_property_t)property {
    NSString *attributes = @(property_getAttributes(property));
    NSArray *attributePairs = [attributes componentsSeparatedByString:@","];
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionaryWithCapacity:[attributePairs count]];
    for (NSString *attributePair in attributePairs) {
        [attributesDictionary setObject:[attributePair substringFromIndex:1] forKey:[attributePair substringToIndex:1]];
    }
    return attributesDictionary;
}

// from FLEX FLEXRuntimeUtility
- (NSString *)readableTypeForEncoding:(NSString *)encodingString {
    if (!encodingString) {
        return nil;
    }
    
    const char *encodingCString = [encodingString UTF8String];
    if (encodingCString[0] == '@') {
        NSString *class = [encodingString substringFromIndex:1];
        class = [class stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if ([class length] == 0 || [class isEqual:@"?"]) {
            class = @"id";
        } else {
            class = [class stringByAppendingString:@""];
        }
        return class;
    }
    NSAssert(0, @"Only Support NSObject subclass");
    return encodingString;
}

#pragma mark * getter -> setter

- (SEL)setterSelectorFromGetter:(NSString *)getter {
    NSString *selectorName = [NSString stringWithFormat:@"set%@%@:", [[getter substringToIndex:1] uppercaseString], [getter substringFromIndex:1]];
    return [selectorName ds_selector];
}

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak id weakSelf = self;
        [[self listPropertys] enumerateObjectsUsingBlock: ^(NSDictionary *eachProperty, NSUInteger idx, BOOL *stop) {
            if ([[eachProperty[DaiStoragePropertyType] ds_class] isSubclassOfClass:[DaiStorage class]]) {
                avoidPerformSelectorWarning([weakSelf performSelector:[weakSelf setterSelectorFromGetter:eachProperty[DaiStoragePropertyName]] withObject:[[eachProperty[DaiStoragePropertyType] ds_class] new]];)
            }
            else if ([[eachProperty[DaiStoragePropertyType] ds_class] isSubclassOfClass:[DaiStorageArray class]]) {
                avoidPerformSelectorWarning([weakSelf performSelector:[weakSelf setterSelectorFromGetter:eachProperty[DaiStoragePropertyName]] withObject:[[eachProperty[DaiStoragePropertyType] ds_class] new]];)
            }
        }];
    }
    return self;
}

@end