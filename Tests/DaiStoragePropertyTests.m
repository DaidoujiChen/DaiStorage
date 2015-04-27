//
//  DaiStoragePropertyTests.m
//
#import <GHUnit/GHUnit.h>
#import "DaiStorageProperty.h"

@interface DaiStoragePropertyTests : GHTestCase
@end

@implementation DaiStoragePropertyTests

- (void)testDaiStorageProperty {
    DaiStorageProperty *testProperty = [DaiStorageProperty propertyName:@"hello" type:@"NSString"];
    
    GHAssertTrue([testProperty isKindOfClass:[DaiStorageProperty class]], @"型別錯誤");
    GHAssertTrue([testProperty.name isEqualToString:@"hello"], @"名稱錯誤");
    GHAssertTrue([testProperty.type isEqualToString:@"NSString"], @"型別錯誤");
    GHAssertTrue([testProperty.propertyClass isSubclassOfClass:[NSString class]], @"型別錯誤");
    GHAssertTrue([NSStringFromSelector(testProperty.setter) isEqualToString:@"setHello:"], @"selector 錯誤");
    GHAssertTrue([NSStringFromSelector(testProperty.getter) isEqualToString:@"hello"], @"selector 錯誤");
    GHAssertTrue([NSStringFromSelector(testProperty.importName) isEqualToString:@"daiStorage_ruleImport_hello:"], @"selector 錯誤");
    GHAssertTrue([NSStringFromSelector(testProperty.importType) isEqualToString:@"daiStorage_ruleImport_NSString:"], @"selector 錯誤");
    GHAssertTrue([NSStringFromSelector(testProperty.exportName) isEqualToString:@"daiStorage_ruleExport_hello:"], @"selector 錯誤");
    GHAssertTrue([NSStringFromSelector(testProperty.exportType) isEqualToString:@"daiStorage_ruleExport_NSString:"], @"selector 錯誤");
}

@end
