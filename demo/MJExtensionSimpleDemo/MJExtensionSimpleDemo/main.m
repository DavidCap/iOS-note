//
//  main.m
//  MJExtensionSimpleDemo
//
//  Created by 杨上尉 on 2018/6/29.
//  Copyright © 2018年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MJExtensionDemo/NSObject+TestExtension.h"
#import "MJStatus.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        // 1.定义一个字典
        NSDictionary *dict = @{
                               @"text" : @"是啊，今天天气确实不错！",
                               
                               @"user" : @{
                                       @"name" : @"Jack",
                                       @"icon" : @"lufy.png"
                                       },
                               
                               @"retweetedStatus" : @{
                                       @"text" : @"今天天气真不错！",
                                       
                                       @"user" : @{
                                               @"name" : @"Rose",
                                               @"icon" : @"nami.png"
                                               }
                                       }
                               };
        
        MJStatus *status = [MJStatus test_JsonToModelWithDictionary:dict];
        
        
        // 2.将字典转为Status模型
//        MJStatus *status = [MJStatus mj_objectWithKeyValues:dict];
//
//        // 3.打印status的属性
//        NSString *text = status.text;
//        NSString *name = status.user.name;
//        NSString *icon = status.user.icon;
//        MJExtensionLog(@"text=%@, name=%@, icon=%@", text, name, icon);
//
//        // 4.打印status.retweetedStatus的属性
//        NSString *text2 = status.retweetedStatus.text;
//        NSString *name2 = status.retweetedStatus.user.name;
//        NSString *icon2 = status.retweetedStatus.user.icon;
//        MJExtensionLog(@"text2=%@, name2=%@, icon2=%@", text2, name2, icon2);
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
