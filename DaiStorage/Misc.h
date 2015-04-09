//
//  Misc.h
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/8.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiStorage.h"
#import <UIKit/UIKit.h>
#import "Account.h"

@interface Misc : DaiStorage

@property (nonatomic, strong) NSString *myFirstString;
@property (nonatomic, strong) NSString *mySecondString;
@property (nonatomic, strong) NSDate *myFirstDate;
@property (nonatomic, strong) NSValue *myFirstPointValue;
@property (nonatomic, strong) NSValue *mySecondPointValue;
@property (nonatomic, strong) Account *myFirstAccount;
@property (nonatomic, strong) DaiStorageArray *myFirstClassmetes;
@property (nonatomic, strong) DaiStorageArray *mySecondDates;

@end
