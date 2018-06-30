//
//  UserDao.m
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import "UserDao.h"

@implementation UserDao

+ (SQLiteRequest *)createUserTable {
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS USER(user_id TEXT PRIMARY KEY, user_name TEXT);";
    return [[SQLiteRequest alloc] initWithQuery:sql parameters:nil];
}
@end
