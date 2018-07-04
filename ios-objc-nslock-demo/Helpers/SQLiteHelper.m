//
//  SQLiteHelper.m
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "FMDatabaseQueue.h"
#import "SQLiteHelper.h"

@interface SQLiteHelper ()

@property (nonatomic) FMDatabase *fmdb;
@property (nonatomic) NSLock *lock;
@end

static NSString *const sqliteDBName = @"sample.sqlite3";
static NSString *const sqliteDBKey = @"zaq12wsxcde34rfvbgt56yhnmju78ik,";

@implementation SQLiteHelper

#pragma mark - Singleton


+ (instancetype)shared {

    static SQLiteHelper *sqliteHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqliteHelper = [[self alloc] init];
    });
    return sqliteHelper;
}

#pragma mark - Database path

+ (NSString *)dbPath {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES).firstObject;
    return [documentsDirectory stringByAppendingPathComponent:sqliteDBName];
}

#pragma mark - Init

- (instancetype)init {

    self = [super init];
    if (self) {
        self.lock = [[NSLock alloc] init];
        self.fmdb = [[FMDatabase alloc] initWithPath:[[self class] dbPath]];
    }
    return self;
}

#pragma mark - Open and close database

- (BOOL)open {

    NSLog(@"%s", __func__);

    // ロックする
    [self.lock lock];

    NSLog(@"open開始");
    BOOL openResult = [self.fmdb open];
    NSLog(@"open終了");

    if (openResult) {
        openResult = [self.fmdb setKey:sqliteDBKey];
    }

    return openResult;
}

- (BOOL)close {

    NSLog(@"%s", __func__);

    NSLog(@"close開始");
    BOOL closeResult = [self.fmdb close];
    NSLog(@"close終了");

    // ロックを解除する
    [self.lock unlock];
    NSLog(@"ロック解除");

    return closeResult;
}

#pragma mark - FMDatabaseQueue

/**
 INSERT, UPDATE, DELETE

 @param requests (NSArray <SQLiteRequest *>*) queryとparametersの配列
 @param result (BOOL *) 結果 YES: 成功, NO: 失敗
 */
- (void)inTransaction:(NSArray <SQLiteRequest *> *)requests result:(BOOL *)result {

    [self open];

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[[self class] dbPath]];
    [queue inDatabase:^(FMDatabase *db) {
        [db setKey:sqliteDBKey];
    }];

    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {

        *result = YES;

        for (SQLiteRequest *sqliteRequest in requests) {

            *result = [db executeUpdate:sqliteRequest.query withArgumentsInArray:sqliteRequest.parameters];

            BOOL hadError = [self.fmdb hadError];
            if (!*result || hadError) {

                int lastErrorCode = [self.fmdb lastErrorCode];
                NSString *lastErrorMessage = [self.fmdb lastErrorMessage];
                NSLog(@"lastErrorCode: %d, lastErrorMessage: %@", lastErrorCode, lastErrorMessage);

                *rollback = YES;
                break;
            }
        }
    }];

    [self close];
}

#pragma mark - Execute queries

/**
 SELECT

 @param request (SQLiteRequest *) query・parameters
 @param selectResult (SelectResult *)結果を格納するオブジェクト
 */
- (void)executeQuery:(SQLiteRequest *)request result:(SelectResult *)selectResult {

    if (request.tableModel != selectResult.tableModel) {
        NSLog(@"結果を格納するオブジェクトのTableModel不正");
        return;
    }
    
    [selectResult.resultArray removeAllObjects];

    [self open];

    FMResultSet *executeResults = [self.fmdb executeQuery:request.query withArgumentsInArray:request.parameters];
    while ([executeResults next]) {
        @autoreleasepool {
            [selectResult.resultArray addObject:[[selectResult.resultType.class alloc] initWithFMResultSet:executeResults]];
        }
    }
    [executeResults close];

    [self close];
}

@end
