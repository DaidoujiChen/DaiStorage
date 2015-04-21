//
//  Classroom.m
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/22.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "Classroom.h"

@implementation Classroom

- (id)init {
    self = [super init];
    if (self) {
        [self.students setAllowClass:[Student class]];
    }
    return self;
}

@end
