# iOS 信号量实践
需求：app启动的时候总是会显示许许多多的弹窗，那么有一个需求就是让这种弹窗 一个个的显示，点掉一个显示下一个。碰到这样的需求该如何搞定呢。 --- 信号量

## 信号量
这个相信大家都比较熟悉，这里我简单的讲述一下我的理解。理解思路，代码就比较Easy了。<br>
举例：比如有一个大厅，能容纳N个人，那么如果小于N个人的时候 顺便进入，如果大于N个人那么就是必须要有人出去才能有新的人进来。<br>
弹窗：如果大厅只能容纳一个弹窗，那么是不是要一个弹窗“出去”，才能有新的弹窗“进来”。

## 实现
创建一个BaseAlertView，所有的弹窗继承于它，自定义。
```
@implementation BaseAlertView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {

    }
    return self;
}

#pragma mark - public
- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
}
@end
```

那么怎么给BaseAlertView 添加信号量呢？？<br>
思路：
1. 创建全局只容纳1个单位的信号量
2. Show的时候 Lock
3. Dismiss的时候 Release Lock

注意看注释
```
//全局信号量
dispatch_semaphore_t _globalInstancesLock;
//执行QUEUE的Name
char *QUEUE_NAME = "com.alert.queue";

//初始化 -- 借鉴YYWebImage的写法
static void _AlertViewInitGlobal() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _globalInstancesLock = dispatch_semaphore_create(1);
    });
}

@implementation BaseAlertView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        _AlertViewInitGlobal();
    }
    return self;
}

#pragma mark - public
- (void)show
{
    //位于非主线程 不阻塞 
    dispatch_async(dispatch_queue_create(QUEUE_NAME, DISPATCH_QUEUE_SERIAL), ^{
        //Lock
        dispatch_semaphore_wait(_globalInstancesLock, DISPATCH_TIME_FOREVER);
        //保证主线程UI操作
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        });
    });
}

- (void)dismiss
{
    dispatch_async(dispatch_queue_create(QUEUE_NAME, DISPATCH_QUEUE_SERIAL), ^{
        //Release Lock
        dispatch_semaphore_signal(_globalInstancesLock);

        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    });
}
```

是不是很简单，如果有更好的办法也欢迎讨论。