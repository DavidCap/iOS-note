//
//  NSObject+TestExtension.m
//  MJExtensionSimpleDemo
//
//  Created by 杨上尉 on 2018/6/29.
//  Copyright © 2018年 David. All rights reserved.
//

#import "NSObject+TestExtension.h"
#import <objc/runtime.h>

static NSSet *foundationClasses_;

@implementation NSObject (TestExtension)
+ (instancetype)test_JsonToModelWithDictionary:(NSDictionary *)dict
{
    Class clazz = [self class];
    id model = [[clazz alloc] init];
    
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList(clazz, &count);
    
    //1. 遍历Class中的Property
    for (int i = 0; i < count; i++) {
        NSString *propertyName = @(property_getName(propertys[i]));
        NSString *propertyAttribute =@(property_getAttributes(propertys[i]));
        
        
        // 2. 获取Value
        id value = [dict objectForKey:propertyName];
        if (!value || [value isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        // 3. 如果是其他类，递归调用
        Class propertyClazz = [self getClassFromAttrs:propertyAttribute];
        if (propertyClazz) {
            value = [propertyClazz test_JsonToModelWithDictionary:value];
        }
        
        [model setValue:value forKey:propertyName];
        
    }
    
    return model;
}

+ (Class)getClassFromAttrs:(NSString *)attrs
{
    NSUInteger dotLoc = [attrs rangeOfString:@","].location;
    NSString *code = nil;
    NSUInteger loc = 1;
    if (dotLoc == NSNotFound) { // 没有,
        code = [attrs substringFromIndex:loc];
    } else {
        code = [attrs substringWithRange:NSMakeRange(loc, dotLoc - loc)];
    }
    
    if(code.length > 3 && [code hasPrefix:@"@\""])
    {
        // 去掉@"和"，截取中间的类型名称
        code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        Class clazz = NSClassFromString(code);
        if (![self isClassFromFoundation:clazz]) {
            return clazz;
        }
    }
    
    return nil;
}

+ (BOOL)isClassFromFoundation:(Class)c
{
    if (foundationClasses_ == nil) {
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSError class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    
    if (c == [NSObject class]) return YES;
    
    __block BOOL result = NO;
    [foundationClasses_ enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}


@end
