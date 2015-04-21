//
//  DaiStorageTest.m
//
#import <GHUnit/GHUnit.h>

#import "Classroom.h"

@interface DaiStorageTest : GHTestCase
@end

@implementation DaiStorageTest

- (void)testStoreContents {
    [Classroom shared].teacherName = @"哈哈";
    GHAssertTrue([Classroom shared].storeContents.count == 1, @"數量應該只會有一個");
}

@end
