//
//  MainViewController.m
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/8.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "MainViewController.h"

#import "Misc.h"
#import "Account.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	[[Misc shared] reworkRuleForClass:[NSDate class] whenImport: ^NSDate * (NSString *importValue) {
	    NSDateFormatter *dateFormatter = [NSDateFormatter new];
	    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
	    return [dateFormatter dateFromString:importValue];
	} whenExport: ^NSString * (NSDate *exportValue) {
	    NSDateFormatter *dateFormatter = [NSDateFormatter new];
	    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
	    return [dateFormatter stringFromDate:exportValue];
	}];

	[[Misc shared] reworkRuleForKeyPath:@"myFirstPointValue" whenImport: ^NSValue *(NSString *importValue) {
        return [NSValue valueWithCGPoint:CGPointFromString(importValue)];
	} whenExport: ^NSString *(NSValue *exportValue) {
        return NSStringFromCGPoint([exportValue CGPointValue]);
	}];

	[[Misc shared] reworkRuleForKeyPath:@"mySecondPointValue" whenImport: ^NSValue *(NSString *importValue) {
        return [NSValue valueWithCGPoint:CGPointZero];
	} whenExport: ^NSString *(NSValue *exportValue) {
        return @"";
	}];
    
    [Misc shared].myFirstClassmetes.allowClass = NSStringFromClass([Account class]);
    [Misc shared].mySecondDates.allowClass = NSStringFromClass([NSDate class]);

	[[Misc shared] importPath:[DaiStoragePath document] defaultPath:nil];
    NSLog(@"%@", [Misc shared].storeContents);
    
	[Misc shared].myFirstString = @"daidouji";
	[Misc shared].mySecondString = [NSString stringWithFormat:@"daidouji%d", arc4random() % 10 + 1];
	[Misc shared].myFirstDate = [NSDate date];
	[Misc shared].myFirstPointValue = [NSValue valueWithCGPoint:CGPointMake(3, 4)];
	[Misc shared].mySecondPointValue = [NSValue valueWithCGPoint:CGPointMake(5, 8)];
    [Misc shared].myFirstAccount.userAccount = @"account";
    [Misc shared].myFirstAccount.userPassword = @"123";
    [Misc shared].myFirstAccount.otherAccount.userAccount = @"account2";
    [Misc shared].myFirstAccount.otherAccount.userPassword = @"456";
    
    Account *newAccount = [Account new];
    newAccount.userAccount = @"mary";
    newAccount.userPassword = @"hahaha";
    newAccount.otherAccount.userAccount = @"bill";
    newAccount.otherAccount.userPassword = @"jelly";
    [[Misc shared].myFirstClassmetes addObject:newAccount];
    
    [[Misc shared].mySecondDates addObject:[NSDate date]];
    [[Misc shared].mySecondDates addObject:[NSDate dateWithTimeIntervalSince1970:20000]];
    
	NSLog(@"%@", [Misc shared].storeContents);
	NSLog(@"%@", [[DaiStoragePath document] path]);
	[[Misc shared] exportPath:[DaiStoragePath document]];
}

@end
