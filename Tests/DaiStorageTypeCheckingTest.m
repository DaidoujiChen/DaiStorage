//
//  DaiStorageTypeCheckingTest.m
//
#import <GHUnit/GHUnit.h>

#import "DaiStorageTypeChecking.h"
#import "DaiStorage.h"

@interface DaiStorageTypeCheckingTest : GHTestCase
@end

@implementation DaiStorageTypeCheckingTest

- (void)testDaiStorageTypeChecking {
    
    //testing for DaiStorage class
    GHAssertTrue([DaiStorageTypeChecking on:NSClassFromString(@"DaiStorage")] == DaiStorageTypeDaiStorage, @"回傳值錯誤");
    GHAssertTrue([DaiStorageTypeChecking on:[DaiStorage new]] == DaiStorageTypeDaiStorage, @"回傳值錯誤");
    
    //testing for DaiStorageArray class
    GHAssertTrue([DaiStorageTypeChecking on:NSClassFromString(@"DaiStorageArray")] == DaiStorageTypeDaiStorageArray, @"回傳值錯誤");
    GHAssertTrue([DaiStorageTypeChecking on:[DaiStorageArray new]] == DaiStorageTypeDaiStorageArray, @"回傳值錯誤");
    
    //testing for NSObject class
    GHAssertTrue([DaiStorageTypeChecking on:NSClassFromString(@"NSObject")] == DaiStorageTypeOthers, @"回傳值錯誤");
    GHAssertTrue([DaiStorageTypeChecking on:[NSObject new]] == DaiStorageTypeOthers, @"回傳值錯誤");
}

@end
