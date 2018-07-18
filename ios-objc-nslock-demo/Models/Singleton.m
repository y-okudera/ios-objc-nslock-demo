//
//  Singleton.m
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/07/19.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import "Singleton.h"

@interface Singleton ()
@property (nonatomic) NSLock *lock;
@end

@implementation Singleton

#pragma mark - シングルトンパターン

static Singleton *singleton = nil;

+ (instancetype)shared {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init {

    self = [super init];
    if (self) {
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

/**
 外部からallocされた時のためにallocWithZoneをオーバーライドして、
 一度しかインスタンスを返さないようにする
 */
+ (id)allocWithZone:(NSZone *)zone {

    __block id ret = nil;

    static dispatch_once_t once;
    dispatch_once( &once, ^{
        singleton = [super allocWithZone:zone];
        ret = singleton;
    });

    return ret;
}

/**
 copyで別インスタンスが返されないようにするためにcopyWithZoneをオーバーライドして、
 自身のインスタンスを返すようにする。
 */
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Lock

- (void)lockStart {
    [[Singleton shared].lock lock];
    NSLog(@"%s", __func__);
}

- (void)lockEnd {
    NSLog(@"%s", __func__);
    [[Singleton shared].lock unlock];
}

@end
