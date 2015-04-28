//
//  MainViewController.m
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/8.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "MainViewController.h"

#import "Classroom.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //我念 3 年 2 班
    [Classroom shared].classID = @"三年二班";
    
    [[Classroom shared].strings addObjectsFromArray:@[@"123", @"456"]];
    
    //老師叫哈哈
    [Classroom shared].teacherName = @"哈哈";
    
    //我叫做 Daidouji
    Student *daidouji = [Student new];
    daidouji.name = @"Daidouji";
    
    //是班上的 1 號
    daidouji.studentID = @(1);
    
    //有一隻寵物叫小花
    Pet *daidoujiPet = [Pet new];
    daidoujiPet.name = @"小花";
    
    //小花年紀很大了
    daidoujiPet.birthday = [NSDate dateWithTimeIntervalSince1970:10000];
    
    [daidouji.pets addObject:daidoujiPet];
    [[Classroom shared].students addObject:daidouji];
    
    //我有一個朋友叫 jeff
    Student *jeff = [Student new];
    jeff.name = @"Jeff";
    
    //是二號, 但是他沒有養寵物
    jeff.studentID = @(2);
    [[Classroom shared].students addObject:jeff];
    
    //先檢查一下打的東西
    NSLog(@"--- %@", [Classroom shared].storeContents);
    
    //然後我要把我打的這些輸出
    [[Classroom shared] exportPath:[DaiStoragePath document]];
    
    //到路徑下檢查一下檔案
    NSLog(@"--- %@", [[DaiStoragePath document] path]);
    
    //然後把資料讀取回來
    [[Classroom shared] importPath:[DaiStoragePath document]];
    
    //驗證資料是不是有漏失
    NSLog(@"--- %@", [Classroom shared].storeContents);
    
}

@end
