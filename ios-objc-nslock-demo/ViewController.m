//
//  ViewController.m
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import "ViewController.h"
#import "JOb.h"
#import "JobDao.h"
#import "UserDao.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    BOOL createTableResult = [self createAllTable];
//    createTableResult ? NSLog(@"Table作成成功") : NSLog(@"Table作成失敗");
//
//    [self insert];


    NSString *sql = @"SELECT * FROM company_master;";
    SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:sql parameters:nil tableModel:TableModelJob];

    SelectResult <Job *>*result = [[SelectResult alloc] initWithTableModel:TableModelJob resultType:Job.new];
    [[SQLiteHelper shared] executeQuery:request result:result];

}

#pragma mark - Private methods

- (BOOL)createAllTable {

    NSMutableArray <SQLiteRequest *> *requests = [@[] mutableCopy];
    [requests addObject:[UserDao createUserTable]];
    [requests addObject:[JobDao createJobTable]];

    BOOL result = YES;
    [[SQLiteHelper shared] inTransaction:requests result:&result];
    return result;
}

- (void)insert {

    NSMutableArray <SQLiteRequest *> *insertRequests = [@[] mutableCopy];

    for (int i = 0; i < 10000; i++) {

        NSLog(@"i = %d", i);
        NSString *jobName = [NSString stringWithFormat:@"JOB%05d", i];
        NSString *workLocation = @"東京都台東区浅草１丁目";
        SQLiteRequest *request = [[SQLiteRequest alloc] initWithQuery:@"INSERT INTO JOB(job_name, work_location) VALUES(?, ?);"
                                                           parameters:@[jobName, workLocation]];
        [insertRequests addObject:request];
    }

    BOOL insertResult = YES;
    [[SQLiteHelper shared] inTransaction:insertRequests result:&insertResult];
    insertResult ? NSLog(@"INSERT処理成功") : NSLog(@"INSERT処理失敗");
}


@end
