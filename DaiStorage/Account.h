//
//  Account.h
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/9.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiStorage.h"
#import "Account2.h"

@interface Account : DaiStorage

@property (nonatomic, strong) NSString *userAccount;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, strong) Account2 *otherAccount;

@end
