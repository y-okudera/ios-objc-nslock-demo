//
//  User.m
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithUserId:(NSString *)userId userName:(NSString *)userName {

    self = [super init];
    if (self) {
        self.tableModel = TableModelUser;
        self.userId = userId;
        self.userName = userName;
    }
    return self;
}

- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet {

    NSString *userId = [[resultSet stringForColumn:@"user_id"] nullToNil];
    NSString *userName = [[resultSet stringForColumn:@"user_name"] nullToNil];
    
    return [self initWithUserId:userId userName:userName];
}
@end
