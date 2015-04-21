//
//  Classroom.h
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/22.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiStorage.h"
#import "Student.h"

@interface Classroom : DaiStorage

@property (nonatomic, strong) NSString *classID;
@property (nonatomic, strong) NSString *teacherName;
@property (nonatomic, strong) DaiStorageArray *students;

@end
