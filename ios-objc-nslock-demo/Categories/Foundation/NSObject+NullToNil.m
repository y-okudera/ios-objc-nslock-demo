//
//  NSObject+NullToNil.m
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import "NSObject+NullToNil.h"

@implementation NSObject (NullToNil)

- (__kindof NSObject *)nullToNil {
    return [self isEqual:[NSNull null]] ? nil : self;
}
@end
