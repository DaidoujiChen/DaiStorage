//
//  DaiStoragePath.h
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/9.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaiStoragePath : NSObject

+ (DaiStoragePath *)document;
+ (DaiStoragePath *)resource;
- (DaiStoragePath *)fcd:(NSString *)directory;
- (NSString *)path;

@end
