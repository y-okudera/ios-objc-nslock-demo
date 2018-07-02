//
//  SQLiteHelper.h
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSetInitializable.h"
#import "SelectResult.h"
#import "SQLiteRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQLiteHelper : NSObject

+ (instancetype)shared;
+ (NSString *)dbPath;

/**
 INSERT, UPDATE, DELETE

 @param requests (NSArray <SQLiteRequest *>*) queryとparametersの配列
 @param result (BOOL *) 結果 YES: 成功, NO: 失敗
 */
- (void)inTransaction:(NSArray <SQLiteRequest *> *)requests result:(BOOL *)result;

/**
 SELECT

 @param request (SQLiteRequest *) query・parameters
 @param selectResult (SelectResult *)結果を格納するオブジェクト
 */
- (void)executeQuery:(SQLiteRequest *)request result:(SelectResult *)selectResult;
@end

NS_ASSUME_NONNULL_END
