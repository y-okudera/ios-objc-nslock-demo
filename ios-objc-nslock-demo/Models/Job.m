//
//  Job.m
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import "Job.h"

@implementation Job

- (instancetype)initWithJobId:(NSUInteger)jobId jobName:(NSString *)jobName workLocation:(NSString *)workLocation {

    self = [super init];
    if (self) {
        self.tableModel = TableModelJob;
        self.jobId = jobId;
        self.jobName = jobName;
        self.workLocation = workLocation;
    }
    return self;
}

- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet {

    NSUInteger jobId = [resultSet longForColumn:@"job_id"];
    NSString *jobName = [[resultSet stringForColumn:@"job_name"] nullToNil];
    NSString *workLocation = [[resultSet stringForColumn:@"work_location"] nullToNil];

    return [self initWithJobId:jobId jobName:jobName workLocation:workLocation];
}
@end
