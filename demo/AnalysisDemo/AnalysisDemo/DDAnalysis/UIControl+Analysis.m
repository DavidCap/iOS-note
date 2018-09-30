//
//  UIControl+Analysis.m
//  YouMei
//
//  Created by 杨上尉 on 2018/9/18.
//  Copyright © 2018年 blank. All rights reserved.
//

#import "UIControl+Analysis.h"
#import "MethodSwizzingTool.h"
#import "AnalysisDataManager.h"

@implementation UIControl (Analysis)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSelector = @selector(sendAction:to:forEvent:);
        SEL swizzingSelector = @selector(analysis_sendAction:to:forEvent:);
        
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originSelector swizzingSel:swizzingSelector];
    });
}

- (void)analysis_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [self analysis_sendAction:action to:target forEvent:event];
    
    [[AnalysisDataManager sharedInstance] sendEventWithTarget:NSStringFromClass([target class]) action:NSStringFromSelector(action) index:self.tag];
}

@end
