//
//  Job.h
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSetInitializable.h"

NS_ASSUME_NONNULL_BEGIN

@interface Job : NSObject <FMResultSetInitializable>

@property (nonatomic) TableModel tableModel;
@property (nonatomic) NSUInteger jobId;
@property (nonatomic) NSString *jobName;
@property (nonatomic) NSString *workLocation;

- (instancetype)initWithJobId:(NSUInteger)jobId jobName:(NSString *)jobName workLocation:(NSString *)workLocation;
- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet;
@end

NS_ASSUME_NONNULL_END
