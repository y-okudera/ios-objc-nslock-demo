//
//  JobDao.h
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface JobDao : NSObject

+ (SQLiteRequest *)createJobTable;
@end

NS_ASSUME_NONNULL_END
