//
//  NSObject+TestExtension.h
//  MJExtensionSimpleDemo
//
//  Created by 杨上尉 on 2018/6/29.
//  Copyright © 2018年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TestExtension)

+ (instancetype)test_JsonToModelWithDictionary:(NSDictionary *)dict;

@end
