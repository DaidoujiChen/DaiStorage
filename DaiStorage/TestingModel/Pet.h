//
//  Pet.h
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/22.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiStorage.h"

@interface Pet : DaiStorage

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *birthday;

@end
