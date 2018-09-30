//
//  AppDelegate+Analysis.m
//  YouMei
//
//  Created by 杨上尉 on 2018/9/20.
//  Copyright © 2018年 blank. All rights reserved.
//

#import "AppDelegate+Analysis.h"
#import "MethodSwizzingTool.h"
#import "AnalysisDataManager.h"

@implementation AppDelegate (Analysis)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSEL = @selector(application:didFinishLaunchingWithOptions:);
        SEL swizzingSEL = @selector(analysis_application:didFinishLaunchingWithOptions:);
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originSEL swizzingSel:swizzingSEL];
    });
}

- (BOOL)analysis_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AnalysisDataManager sharedInstance] sendEventWithTarget:@"Launch" action:@"didFinishLaunchingWithOptions" index:0];
    return [self analysis_application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
