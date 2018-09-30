//
//  AnalysisDataManager.m
//  YouMei
//
//  Created by 杨上尉 on 2018/9/20.
//  Copyright © 2018年 blank. All rights reserved.
//

#import "AnalysisDataManager.h"

@interface AnalysisDataManager()
@property (nonatomic, strong) NSDictionary *analysisDictonary;
@end

@implementation AnalysisDataManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

    - (void)sendEventWithTarget:(NSString *)target action:(NSString *)action index:(NSUInteger)index
    {
        if (target.length == 0 || action.length == 0) {
            return;
        }
        
        if (![[self.analysisDictonary objectForKey:target] isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        
        if (![[[self.analysisDictonary objectForKey:target] objectForKey:action] isKindOfClass:[NSArray class]]) {
            return;
        }
        
        NSArray *eventArray = [[self.analysisDictonary objectForKey:target] objectForKey:action];
        
        if (index < eventArray.count && [eventArray[index] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *event = eventArray[index];
            if ([[event objectForKey:@"eventID"] isKindOfClass:[NSString class]]) {
                NSString *eventID = [event objectForKey:@"eventID"];
                NSLog(@"===EventID %@===",eventID);
            }
        }
    }


#pragma mark - getter
- (NSDictionary *)analysisDictonary
{
    if (!_analysisDictonary)
    {
        //获取已有完整路径
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Analysis" ofType:@"json"];
        NSData * JSONData = [NSData dataWithContentsOfFile:path];
        _analysisDictonary = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    }
    return _analysisDictonary;
}

@end
