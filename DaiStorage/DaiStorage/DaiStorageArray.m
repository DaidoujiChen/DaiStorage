//
//  DaiStorageArray.m
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/10.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiStorageArray.h"

@interface DaiStorageArray ()

@property (nonatomic, strong) NSMutableArray *internalArray;

@end

@implementation DaiStorageArray

#pragma mark - Methods to Override

#pragma mark * NSArray

- (NSUInteger)count {
    return self.internalArray.count;
}

- (id)objectAtIndex:(NSUInteger)index {
    return self.internalArray[index];
}

#pragma mark * NSMutableArray

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [self.internalArray insertObject:anObject atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [self.internalArray removeObjectAtIndex:index];
}

- (void)addObject:(id)anObject {
    [self.internalArray addObject:anObject];
}

- (void)removeLastObject {
    [self.internalArray removeLastObject];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [self.internalArray replaceObjectAtIndex:index withObject:anObject];
}

#pragma mark - life cycle

- (id)init {
    self = [super init];
    if (self) {
        self.internalArray = [NSMutableArray array];
    }
    return self;
}

@end
