//
//  DaiStorageTest.m
//
#import <GHUnit/GHUnit.h>

#import "Misc.h"

@interface DaiStorageTest : GHTestCase
@end

@implementation DaiStorageTest

- (void)testStoreContents {
    dispatch_async(dispatch_get_main_queue(), ^{
        [Misc shared].myFirstString = @"daidouji";
        NSLog(@"%@", [Misc shared].storeContents);
    });
}

@end
