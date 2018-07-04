//
//  PlainDAO.h
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/07/05.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSetInitializable.h"
#import "SelectResult.h"
#import "SQLiteRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlainDAO : NSObject

+ (instancetype)shared;
+ (NSString *)dbPath;

- (BOOL)encrypt;

@end

NS_ASSUME_NONNULL_END
