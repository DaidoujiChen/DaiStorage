//
//  Pet.m
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/22.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "Pet.h"

@implementation Pet

- (id)init {
    self = [super init];
    if (self) {
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        [self reworkRuleForClass:[NSDate class] whenImport:^NSDate*(NSString *importValue) {
            return [dateFormatter dateFromString:importValue];
        } whenExport:^NSString *(NSDate *exportValue) {
            return [dateFormatter stringFromDate:exportValue];
        }];
    }
    return self;
}

@end
