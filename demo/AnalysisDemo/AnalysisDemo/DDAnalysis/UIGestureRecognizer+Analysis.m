//
//  UIGestureRecognizer+Analysis.m
//  YouMei
//
//  Created by 杨上尉 on 2018/9/18.
//  Copyright © 2018年 blank. All rights reserved.
//

#import "UIGestureRecognizer+Analysis.h"
#import "MethodSwizzingTool.h"
#import <objc/runtime.h>
#import "AnalysisDataManager.h"

static int _actionName;

@implementation UIGestureRecognizer (Analysis)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSelector = @selector(initWithTarget:action:);
        SEL swizzingSelector = @selector(analysis_initWithTarget:action:);
        
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originSelector swizzingSel:swizzingSelector];
    });
}

- (instancetype)analysis_initWithTarget:(id)target action:(SEL)action
{
    UIGestureRecognizer *selfGestureRecognizer = [self analysis_initWithTarget:target action:action];
    if (!target && !action) {
        return selfGestureRecognizer;
    }
    
    if ([target isKindOfClass:[UIScrollView class]]) {
        return selfGestureRecognizer;
    }
    
    Class class = [target class];
    
    SEL originalSEL = action;
    
    NSString * sel_name = [NSString stringWithFormat:@"%s/%@", class_getName([target class]),NSStringFromSelector(action)];
    SEL swizzledSEL =  NSSelectorFromString(sel_name);
    
    BOOL addMethod = class_addMethod(class,
                                       swizzledSEL,
                                       method_getImplementation(class_getInstanceMethod([self class], @selector(analysis_gesture:))),
                                       nil);
    
    if (addMethod) {
        [MethodSwizzingTool swizzingForClass:class originalSel:originalSEL swizzingSel:swizzledSEL];
    }
    
    if (objc_getAssociatedObject(self, &_actionName) == nil) {
        objc_setAssociatedObject(self, &_actionName, NSStringFromSelector(action), OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return selfGestureRecognizer;
}

- (void)analysis_gesture:(UIGestureRecognizer *)gesture
{
    NSString * identifier = [NSString stringWithFormat:@"%s/%@", class_getName([self class]),objc_getAssociatedObject(gesture, &_actionName)];
    
    SEL sel = NSSelectorFromString(identifier);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id) = (void *)imp;
        func(self, sel,gesture);
    }
    
    if ([gesture isKindOfClass:[UIGestureRecognizer class]]) {
        [[AnalysisDataManager sharedInstance] sendEventWithTarget:NSStringFromClass([self class]) action:objc_getAssociatedObject(gesture, &_actionName) index:gesture.view.tag];
    }    
}

@end
