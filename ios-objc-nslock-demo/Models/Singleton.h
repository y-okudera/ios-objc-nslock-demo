//
//  Singleton.h
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/07/19.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Singleton : NSObject

+ (instancetype)shared;
- (void)lockStart;
- (void)lockEnd;
@end

NS_ASSUME_NONNULL_END
