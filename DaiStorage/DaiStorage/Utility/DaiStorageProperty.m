//
//  DaiStorageProperty.m
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/21.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiStorageProperty.h"
#import <objc/runtime.h>

@interface SelectorCache : NSObject

@property Class cacheClass;
@property SEL cacheSelector;

@end

@implementation SelectorCache

@end

@interface DaiStorageProperty ()

@property Class class;
@property SEL setter;
@property SEL getter;
@property SEL importName;
@property SEL importType;
@property SEL exportName;
@property SEL exportType;

@end

@implementation DaiStorageProperty

- (Class)class {
    if (!_class) {
        _class = [self classFromCache:self.type];
    }
    return _class;
}

- (SEL)setter {
    if (!_setter) {
        _setter = [self setterFromCache:self.name];
    }
    return _setter;
}

- (SEL)getter {
    if (!_getter) {
        _getter = [self getterFromCache:self.name];
    }
    return _getter;
}

- (SEL)importName {
    if (!_importName) {
        _importName = [self importSelectorFromCache:self.name];
    }
    return _importName;
}

- (SEL)importType {
    if (!_importType) {
        _importType = [self importSelectorFromCache:self.type];
    }
    return _importType;
}

- (SEL)exportName {
    if (!_exportName) {
        _exportName = [self exportSelectorFromCache:self.name];
    }
    return _exportName;
}

- (SEL)exportType {
    if (!_exportType) {
        _exportType = [self exportSelectorFromCache:self.type];
    }
    return _exportType;
}

#pragma mark - private instance method

- (Class)classFromCache:(NSString *)className {
    if ([[DaiStorageProperty classCache] objectForKey:className]) {
        SelectorCache *selectorCache = [[DaiStorageProperty classCache] objectForKey:className];
        return selectorCache.cacheClass;
    }
    else {
        SelectorCache *selectorCacne = [SelectorCache new];
        selectorCacne.cacheClass = NSClassFromString(className);
        [[DaiStorageProperty classCache] setObject:selectorCacne forKey:className];
        return selectorCacne.cacheClass;
    }
}

- (SEL)setterFromCache:(NSString *)name {
    if ([[DaiStorageProperty setterCache] objectForKey:name]) {
        SelectorCache *selectorCache = [[DaiStorageProperty setterCache] objectForKey:name];
        return selectorCache.cacheSelector;
    }
    else {
        SelectorCache *selectorCacne = [SelectorCache new];
        NSString *selectorName = [NSString stringWithFormat:@"set%@%@:", [[name substringToIndex:1] uppercaseString], [name substringFromIndex:1]];
        selectorCacne.cacheSelector = NSSelectorFromString(selectorName);
        [[DaiStorageProperty setterCache] setObject:selectorCacne forKey:name];
        return selectorCacne.cacheSelector;
    }
}

- (SEL)getterFromCache:(NSString *)name {
    if ([[DaiStorageProperty getterCache] objectForKey:name]) {
        SelectorCache *selectorCache = [[DaiStorageProperty getterCache] objectForKey:name];
        return selectorCache.cacheSelector;
    }
    else {
        SelectorCache *selectorCacne = [SelectorCache new];
        selectorCacne.cacheSelector = NSSelectorFromString(name);
        [[DaiStorageProperty getterCache] setObject:selectorCacne forKey:name];
        return selectorCacne.cacheSelector;
    }
}

- (SEL)importSelectorFromCache:(NSString *)name {
    if ([[DaiStorageProperty importSelectorCache] objectForKey:name]) {
        SelectorCache *selectorCache = [[DaiStorageProperty importSelectorCache] objectForKey:name];
        return selectorCache.cacheSelector;
    }
    else {
        SelectorCache *selectorCacne = [SelectorCache new];
        NSString *selectorString = [NSString stringWithFormat:@"daiStorage_ruleImport%@:", name];
        selectorCacne.cacheSelector = NSSelectorFromString(selectorString);
        [[DaiStorageProperty importSelectorCache] setObject:selectorCacne forKey:name];
        return selectorCacne.cacheSelector;
    }
}

- (SEL)exportSelectorFromCache:(NSString *)name {
    if ([[DaiStorageProperty exportSelectorCache] objectForKey:name]) {
        SelectorCache *selectorCache = [[DaiStorageProperty exportSelectorCache] objectForKey:name];
        return selectorCache.cacheSelector;
    }
    else {
        SelectorCache *selectorCacne = [SelectorCache new];
        NSString *selectorString = [NSString stringWithFormat:@"daiStorage_ruleExport%@:", name];
        selectorCacne.cacheSelector = NSSelectorFromString(selectorString);
        [[DaiStorageProperty exportSelectorCache] setObject:selectorCacne forKey:name];
        return selectorCacne.cacheSelector;
    }
}

#pragma mark - class method

+ (DaiStorageProperty *)propertyName:(NSString *)name type:(NSString *)type {
	DaiStorageProperty *newProperty = [DaiStorageProperty new];
	newProperty.name = name;
	newProperty.type = type;
	return newProperty;
}

+ (DaiStorageProperty *)propertyName:(NSString *)name {
	return [self propertyName:name type:nil];
}

+ (DaiStorageProperty *)propertyType:(NSString *)type {
	return [self propertyName:nil type:type];
}

#pragma mark - private class method

+ (NSMutableDictionary *)importSelectorCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, _cmd, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, _cmd);
}

+ (NSMutableDictionary *)exportSelectorCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, _cmd, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, _cmd);
}

+ (NSMutableDictionary *)classCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, _cmd, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, _cmd);
}

+ (NSMutableDictionary *)setterCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, _cmd, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, _cmd);
}

+ (NSMutableDictionary *)getterCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, _cmd, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, _cmd);
}

@end
