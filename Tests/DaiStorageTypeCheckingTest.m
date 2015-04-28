//
//  DaiStorageTypeCheckingTest.m
//
#import <GHUnit/GHUnit.h>

#import "DaiStorageTypeChecking.h"
#import "Classroom.h"

@interface DaiStorageTypeCheckingTest : GHTestCase
@end

@implementation DaiStorageTypeCheckingTest

- (void)testDaiStorageTypeChecking {
    GHAssertTrue([DaiStorageTypeChecking on:[Classroom shared]] == DaiStorageTypeDaiStorage, @"判斷格式錯誤");
    GHAssertTrue([DaiStorageTypeChecking on:[Classroom shared].students] == DaiStorageTypeDaiStorageArray, @"判斷格式錯誤");
    GHAssertTrue([DaiStorageTypeChecking on:[Classroom shared].strings] == DaiStorageTypeDaiStorageArray, @"判斷格式錯誤");
    
    NSString *myString = [NSString new];
    GHAssertTrue([DaiStorageTypeChecking on:myString] == DaiStorageTypeOthers, @"判斷格式錯誤");
}

@end
