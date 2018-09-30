//
//  UIViewController+Analysis.m
//  YouMei
//
//  Created by 杨上尉 on 2018/9/20.
//  Copyright © 2018年 blank. All rights reserved.
//

#import "UIViewController+Analysis.h"
#import "MethodSwizzingTool.h"
#import "AnalysisDataManager.h"

@implementation UIViewController (Analysis)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSEL = @selector(viewDidAppear:);
        SEL swizzingSEL = @selector(analysis_viewDidAppear:);
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originSEL swizzingSel:swizzingSEL];
    });
}

- (void)analysis_viewDidAppear:(BOOL)animation
{
    [self analysis_viewDidAppear:animation];
    [[AnalysisDataManager sharedInstance] sendEventWithTarget:NSStringFromClass([self class]) action:@"viewDidLoad" index:self.view.tag];
}

@end
