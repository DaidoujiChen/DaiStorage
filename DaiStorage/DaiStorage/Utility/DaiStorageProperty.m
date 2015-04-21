//
//  DaiStorageProperty.m
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/21.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiStorageProperty.h"

@implementation DaiStorageProperty

@dynamic aClass, setter, getter;

#pragma mark - readonly

- (Class)aClass {
	return NSClassFromString(self.type);
}

- (SEL)setter {
	NSString *selectorName = [NSString stringWithFormat:@"set%@%@:", [[self.name substringToIndex:1] uppercaseString], [self.name substringFromIndex:1]];
	return NSSelectorFromString(selectorName);
}

- (SEL)getter {
	return NSSelectorFromString(self.name);
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

@end
