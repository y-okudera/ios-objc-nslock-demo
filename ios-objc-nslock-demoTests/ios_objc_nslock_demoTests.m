//
//  ios_objc_nslock_demoTests.m
//  ios-objc-nslock-demoTests
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SQLiteHelper.h"
#import "UserDao.h"
#import "JobDao.h"
#import "Job.h"

@interface ios_objc_nslock_demoTests : XCTestCase

@end

@implementation ios_objc_nslock_demoTests

- (void)setUp {
    [super setUp];

    [self createAllTable];
}

- (void)testAsyncInsert {

    NSMutableArray <SQLiteRequest *> *insertRequests = [@[] mutableCopy];

    for (int i = 0; i < 1000; i++) {
        
        NSLog(@"i = %d", i);
        NSString *jobName = [NSString stringWithFormat:@"JOB%05d", i];
        NSString *workLocation = @"東京都台東区浅草１丁目";
        SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:@"INSERT INTO JOB(job_name, work_location) VALUES(?, ?);"
                                                           parameters:@[jobName, workLocation]];
        [insertRequests addObject:request];

        NSMutableArray <SQLiteRequest *> *subthreadInsertRequests = [@[] mutableCopy];
        // サブスレッドで実行する処理
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            NSString *jobName = [NSString stringWithFormat:@"SUBTHREAD-JOB%05d", i];
            NSString *workLocation = @"東京都台東区浅草２丁目";
            SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:@"INSERT INTO JOB(job_name, work_location) VALUES(?, ?);"
                                                               parameters:@[jobName, workLocation]];
            [subthreadInsertRequests addObject:request];

            BOOL subthreadInsertResult = [[SQLiteHelper shared] executeUpdate:subthreadInsertRequests];
            if (!subthreadInsertResult) {
                NSLog(@"[%d] サブスレッドのINSERT処理成功", i);
                XCTFail(@"サブスレッドのINSERT処理失敗");
            } else {
                NSLog(@"[%d] サブスレッドのINSERT処理成功", i);
            }
        });

        BOOL insertResult = [[SQLiteHelper shared] executeUpdate:insertRequests];
        if (!insertResult) {
            NSLog(@"[%d] メインスレッドのINSERT処理成功", i);
            XCTFail(@"メインスレッドのINSERT処理失敗");
        } else {
            NSLog(@"[%d] メインスレッドのINSERT処理成功", i);
        }
    }
}

- (void)testSelect {

    SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:@"SELECT job_id, job_name, work_location FROM JOB WHERE job_id = ?"
                                                       parameters:@[@(100)]
                                                       tableModel:TableModelJob];
    SelectResult <Job *>*result = [[SelectResult alloc] initWithTableModel:TableModelJob resultType:Job.new];

    [[SQLiteHelper shared] executeQuery:request result:result];

    XCTAssertEqual(result.resultArray.count, 1);

    Job *j1 = result.resultArray.firstObject;
    NSLog(@"%@", j1);
    NSLog(@"%ld", j1.jobId);
    NSLog(@"%@", j1.jobName);
    NSLog(@"%@", j1.workLocation);
}

- (void)testSelectTableModelError {

    SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:@"SELECT job_id, job_name, work_location FROM JOB WHERE job_id = ?"
                                                       parameters:@[@(100)]
                                                       tableModel:TableModelJob];
    SelectResult <Job *>*result = [[SelectResult alloc] initWithTableModel:TableModelUser resultType:Job.new];

    [[SQLiteHelper shared] executeQuery:request result:result];

    XCTAssertEqual(result.resultArray.count, 0);
}

#pragma mark - Private
- (BOOL)createAllTable {

    NSMutableArray <SQLiteRequest *> *requests = [@[] mutableCopy];
    [requests addObject:[UserDao createUserTable]];
    [requests addObject:[JobDao createJobTable]];

    return [[SQLiteHelper shared] executeUpdate:requests];
}

@end
