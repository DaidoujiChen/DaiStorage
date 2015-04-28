//
//  Student.h
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/22.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiStorage.h"
#import "Pet.h"

DaiStorageArrayConverter(Pet)

@interface Student : DaiStorage

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *studentID;
@property (nonatomic, strong) PetArray *pets;

@end