//
//  Student.m
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/22.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "Student.h"

@implementation Student

- (id)init {
    self = [super init];
    if (self) {
        [self reworkRuleForClass:[NSNumber class] whenImport:^NSNumber*(NSString *importValue) {
            NSArray *split = [importValue componentsSeparatedByString:@" "];
            return @([[split lastObject] integerValue]);
        } whenExport:^NSString *(NSNumber *exportValue) {
            return [NSString stringWithFormat:@"ID is : %@", exportValue];
        }];
        
        [self.pets setAllowClass:[Pet class]];
    }
    return self;
}

@end
