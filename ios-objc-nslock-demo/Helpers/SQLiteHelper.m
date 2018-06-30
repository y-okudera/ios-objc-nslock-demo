//
//  SQLiteHelper.m
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "SQLiteHelper.h"
#import "User.h"
#import "Job.h"

@interface SQLiteHelper ()

@property (nonatomic) FMDatabase *fmdb;
@property (nonatomic) NSLock *lock;
@end

static NSString *const sqliteDBName = @"sample.sqlite3";

@implementation SQLiteHelper

+ (instancetype)shared {

    static SQLiteHelper *sqliteHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqliteHelper = [[self alloc] init];
    });
    return sqliteHelper;
}

+ (NSString *)dbPath {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES).firstObject;
    return [documentsDirectory stringByAppendingPathComponent:sqliteDBName];
}

- (instancetype)init {

    self = [super init];
    if (self) {
        self.lock = [[NSLock alloc] init];
        self.fmdb = [[FMDatabase alloc] initWithPath:[[self class] dbPath]];
    }
    return self;
}

- (BOOL)open {

    NSLog(@"%s", __func__);

    // ロックする
    [self.lock lock];

    NSLog(@"open開始");
    BOOL openResult = [self.fmdb open];
    NSLog(@"open終了");
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

/**
 INSERT, UPDATE, DELETE

 @param requests (NSArray <SQLiteRequest *>*) query・parametersの配列
 @return YES: 成功, NO: 失敗
 */
- (BOOL)executeUpdate:(NSArray <SQLiteRequest *>*)requests {

    BOOL result = YES;

    [self open];
    [self.fmdb beginTransaction];

    for (SQLiteRequest *sqliteRequest in requests) {

        result = [self.fmdb executeUpdate:sqliteRequest.query withArgumentsInArray:sqliteRequest.parameters];

        BOOL hadError = [self.fmdb hadError];
        if (!result || hadError) {

            int lastErrorCode = [self.fmdb lastErrorCode];
            NSString *lastErrorMessage = [self.fmdb lastErrorMessage];
            NSLog(@"lastErrorCode: %d, lastErrorMessage: %@", lastErrorCode, lastErrorMessage);

            result = NO;
            break;
        }
    }

    if (result) {
        BOOL commitResult = [self.fmdb commit];
        if (!commitResult) {
            exit(0);
        }
    } else {
        BOOL rollbackResult = [self.fmdb rollback];
        if (!rollbackResult) {
            exit(0);
        }
    }

    [self close];

    return result;
}

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

    NSMutableArray < __kindof NSObject <FMResultSetInitializable> *> *resultArray = selectResult.resultArray;
    [resultArray removeAllObjects];

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
