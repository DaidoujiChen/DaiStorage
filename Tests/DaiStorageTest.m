//
//  DaiStorageTest.m
//
#import <GHUnit/GHUnit.h>

#import "Misc.h"

@interface DaiStorageTest : GHTestCase
@end

@implementation DaiStorageTest

- (void)testStoreContents {
    [Misc shared].myFirstString = @"daidouji";
    GHAssertTrue([Misc shared].storeContents.count == 1, @"數量應該只會有一個");
}

@end
