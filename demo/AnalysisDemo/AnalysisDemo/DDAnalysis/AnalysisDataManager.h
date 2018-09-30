//
//  AnalysisDataManager.h
//  YouMei
//
//  Created by 杨上尉 on 2018/9/20.
//  Copyright © 2018年 blank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalysisDataManager : NSObject
+ (instancetype)sharedInstance;

- (void)sendEventWithTarget:(NSString *)target action:(NSString *)action index:(NSUInteger)index;
@end
