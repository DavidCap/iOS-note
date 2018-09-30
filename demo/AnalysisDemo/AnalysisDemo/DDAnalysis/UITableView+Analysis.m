//
//  UITableView+Analysis.m
//  YouMei
//
//  Created by 杨上尉 on 2018/9/17.
//  Copyright © 2018年 blank. All rights reserved.
//

#import "UITableView+Analysis.h"
#import "MethodSwizzingTool.h"
#import <objc/runtime.h>
#import "AnalysisDataManager.h"

@implementation UITableView (Analysis)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSelector = @selector(setDelegate:);
        SEL swizzingSelector = @selector(analysis_setDelegate:);
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:originSelector swizzingSel:swizzingSelector];
    });
}


- (void)analysis_setDelegate:(id)delegate
{
    [self analysis_setDelegate:delegate];
    if (delegate) {
        SEL originSelector = @selector(tableView:didSelectRowAtIndexPath:);
        SEL swizzingSelector = @selector(analysis_tableView:didSelectRowAtIndexPath:);

        BOOL addMethod = class_addMethod([delegate class],
                        swizzingSelector,
                        method_getImplementation(class_getInstanceMethod([self class], @selector(analysis_tableView:didSelectRowAtIndexPath:))),
                        nil);

        if (addMethod) {
            [MethodSwizzingTool swizzingForClass:[delegate class] originalSel:originSelector swizzingSel:swizzingSelector];
        }
    }

}

- (void)analysis_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self analysis_tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [[AnalysisDataManager sharedInstance] sendEventWithTarget:NSStringFromClass([self class]) action:@"didSelectRowAtIndexPath" index:tableView.tag];
}

@end
