//
//  UICollectionView+Analysis.m
//  YouMei
//
//  Created by 杨上尉 on 2018/9/17.
//  Copyright © 2018年 blank. All rights reserved.
//

#import "UICollectionView+Analysis.h"
#import "MethodSwizzingTool.h"
#import "AnalysisDataManager.h"
#import <objc/runtime.h>

@implementation UICollectionView (Analysis)

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
        SEL originSelector = @selector(collectionView:didSelectItemAtIndexPath:);
        SEL swizzingSelector = @selector(analysis_collectionView:didSelectItemAtIndexPath:);
        
        BOOL addMethod = class_addMethod([delegate class],
                        swizzingSelector,
                        method_getImplementation(class_getInstanceMethod([self class], @selector(analysis_collectionView:didSelectItemAtIndexPath:))),
                        nil);
        
        if (addMethod) {
            [MethodSwizzingTool swizzingForClass:[delegate class] originalSel:originSelector swizzingSel:swizzingSelector];
        }
    }
}

- (void)analysis_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self analysis_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    
    [[AnalysisDataManager sharedInstance] sendEventWithTarget:NSStringFromClass([self class]) action:@"didSelectItemAtIndexPath" index:collectionView.tag];
}


@end
