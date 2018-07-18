//
//  ViewController.m
//  ios-objc-nslock-demo
//
//  Created by YukiOkudera on 2018/06/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

#import "Singleton.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self methodA];
    [self methodB];
    [self methodC];
    [self methodD];
    [self methodE];

    [self methodA];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Background operations
        [self methodB];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Main Thread
            [self methodC];
            [self methodD];
        });
        [self methodE];
    });
}

- (void)methodA {
    [[Singleton shared] lockStart];
    NSLog(@"%s ロック開始", __func__);
    [NSThread sleepForTimeInterval:1.0];
    NSLog(@"%s ロック終了", __func__);
    [[Singleton shared] lockEnd];
}

- (void)methodB {
    [[Singleton shared] lockStart];
    NSLog(@"%s ロック開始", __func__);
    [NSThread sleepForTimeInterval:1.5];
    NSLog(@"%s ロック終了", __func__);
    [[Singleton shared] lockEnd];
}

- (void)methodC {
    [[Singleton shared] lockStart];
    NSLog(@"%s ロック開始", __func__);
    [NSThread sleepForTimeInterval:0.5];
    NSLog(@"%s ロック終了", __func__);
    [[Singleton shared] lockEnd];
}

- (void)methodD {
    [[Singleton shared] lockStart];
    NSLog(@"%s ロック開始", __func__);
    [NSThread sleepForTimeInterval:1.5];
    NSLog(@"%s ロック終了", __func__);
    [[Singleton shared] lockEnd];
}

- (void)methodE {
    [[Singleton shared] lockStart];
    NSLog(@"%s ロック開始", __func__);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"%s ロック終了", __func__);
    [[Singleton shared] lockEnd];
}

@end
