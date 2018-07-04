//
//  PlainDAO.m
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/07/05.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "FMDatabaseQueue.h"
#import "PlainDAO.h"

@interface PlainDAO ()

@property (nonatomic) FMDatabase *fmdb;
@property (nonatomic) NSLock *lock;
@end

static NSString *const sqliteDBName = @"sample.sqlite3";
static NSString *const sqlitePlainDBName = @"plain.sqlite3";
static NSString *const sqliteDBKey = @"zaq12wsxcde34rfvbgt56yhnmju78ik,";

@implementation PlainDAO

#pragma mark - Singleton

+ (instancetype)shared {

    static PlainDAO *plainDAO = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        plainDAO = [[self alloc] init];
    });
    return plainDAO;
}

#pragma mark - Database path

+ (NSString *)dbPath {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES).firstObject;
    return [documentsDirectory stringByAppendingPathComponent:sqlitePlainDBName];
}

+ (NSString *)sqliteDBPATH {
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

#pragma mark - Encrypt a Plaintext Database

- (BOOL)encrypt {

    __block BOOL result = YES;

    // ロックする
    [self.lock lock];
    NSLog(@"ロック開始");

    NSLog(@"open開始");
    [self.fmdb open];
    NSLog(@"open終了");

    NSArray <NSString *> *sqlArray = @[
                                       [NSString stringWithFormat:@"ATTACH DATABASE '%@' AS encrypted KEY '%@';", [[self class] sqliteDBPATH], sqliteDBKey],
                                       @"SELECT sqlcipher_export('encrypted');",
                                       @"DETACH DATABASE encrypted;"
                                       ];

    for (NSString *sql in sqlArray) {

        result = [self.fmdb executeUpdate:sql withArgumentsInArray:@[]];

        BOOL hadError = [self.fmdb hadError];
        if (!result || hadError) {

            int lastErrorCode = [self.fmdb lastErrorCode];
            NSString *lastErrorMessage = [self.fmdb lastErrorMessage];
            NSLog(@"lastErrorCode: %d, lastErrorMessage: %@", lastErrorCode, lastErrorMessage);

            result = NO;
            break;
        }
    }

    NSLog(@"close開始");
    [self.fmdb close];
    NSLog(@"close終了");

    // ロックを解除する
    [self.lock unlock];
    NSLog(@"ロック解除");

    return result;
}

@end
