//
//  JobDao.m
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import "JobDao.h"

@implementation JobDao

+ (SQLiteRequest *)createJobTable {
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS JOB(job_id INTEGER PRIMARY KEY AUTOINCREMENT, job_name TEXT, work_location TEXT);";
    return [[SQLiteRequest alloc] initWithQuery:sql parameters:nil];
}
@end
