//
//  FMResultSetInitializable.h
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"
#import "TableModel.h"
#import "NSObject+NullToNil.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FMResultSetInitializable <NSObject>

@property (nonatomic) TableModel tableModel;
- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet;

@end

NS_ASSUME_NONNULL_END
