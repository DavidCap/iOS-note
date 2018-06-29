# MJExtension 源码浅析

MJExtension 基本上所有的iOS开发都用过，Json <---> Model。
主要的机制是采用了Runtime的反射机制，有兴趣学习Runtime的同学可以看看。

## 整理思路
如果你想要写一个 Json转Model的第三方，该怎么入手。

已知：

* 包含key value 的 dictionary
* model类

那么也就是，我们需要找出model里面的所有的property，然后把dictionary里面的value赋值给对应的property。

```
伪代码
+ (id)JsonToModel:(NSDictionary *)dictionary {
	TestModel *model = [[TestModel alloc] init];
	for(propertyName in TestModel){
		[model setValue:dictionary[propertyName] forKey: propertyName];
	}
}

```

## 说干就干
### 方法入口
调用：入口方法 mj\_objectWithKeyValues最终会调用mj\_setKeyValues


```
+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    return [self mj_objectWithKeyValues:keyValues context:nil];
}

+ (instancetype)mj_objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context
{
    return [[[self alloc] init] mj_setKeyValues:keyValues];
}

- (instancetype)mj_setKeyValues:(id)keyValues
{
    return [self mj_setKeyValues:keyValues context:nil];
}

```
### 核心方法 
```
/**
 核心代码：
 */
- (instancetype)mj_setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context
{
    // 获得JSON对象
    keyValues = [keyValues mj_JSONObject];
    
    Class clazz = [self class];
    
    //通过封装的方法回调一个通过运行时编写的，用于返回属性列表的方法。
    [clazz mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        @try {            
            // 1.取出属性值
            id value;
            NSArray *propertyKeyses = [property propertyKeysForClass:clazz];
            for (NSArray *propertyKeys in propertyKeyses) {
                value = keyValues;
                for (MJPropertyKey *propertyKey in propertyKeys) {
                    value = [propertyKey valueInObject:value];
                }
                if (value) break;
            }
            
			...
			...
			安全判断代码
			...
			...
            
            // 3.赋值
            [property setValue:value forObject:self];
        } @catch (NSException *exception) {

        }
    }];
    
    return self;
}
```

上面代码做了一定程度的简化，当然其实可以看的出来和前面的伪代码有点类似了。主要的逻辑就是：

1. 获取Dictionary
2. 从类里面拿到所有的propertyName
3. 找到dictionary里面的value赋值给model

### 反射获取类中的属性
```
+ (void)mj_enumerateProperties:(MJPropertiesEnumeration)enumeration
{
    // 获得成员变量
    NSArray *cachedProperties = [self properties];
    
    // 遍历成员变量
    BOOL stop = NO;
    for (MJProperty *property in cachedProperties) {
        enumeration(property, &stop);
        if (stop) break;
    }
}

#pragma mark - 公共方法
+ (NSMutableArray *)properties
{
    NSMutableArray *cachedProperties = [NSMutableArray array];
    
    [self mj_enumerateClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        // 1.获得所有的成员变量
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList(c, &outCount);
        
        // 2.遍历每一个成员变量
        for (unsigned int i = 0; i<outCount; i++) {
            MJProperty *property = [MJProperty cachedPropertyWithProperty:properties[i]];
            // 过滤掉Foundation框架类里面的属性
            if ([MJFoundation isClassFromFoundation:property.srcClass]) continue;
            property.srcClass = c;
            [property setOriginKey:[self propertyKey:property.name] forClass:self];
            [property setObjectClassInArray:[self propertyObjectClassInArray:property.name] forClass:self];
            [cachedProperties addObject:property];
        }
        
        // 3.释放内存
        free(properties);
    }];
       
    return cachedProperties;
}
```

通过**objc\_property_t *properties = class\_copyPropertyList(c, &outCount)**这个方法获取所有的property，然后mj\_enumerateClasses是遍历SuperClass，最后是把拿到的信息封装成一个MJProperty。

### PS
其中代码进行了相应的简化，其中有一些Property的缓存，类型的安全判断都暂时忽略，只进行思路的理解。

### 纸上谈来终觉浅
写了一个Dome，大大简化了MJExtension，目的是为了浅尝Runtime的魅力。基本思路如最上面的伪代码。其中很多安全判断，省略了些许。
这里有一个Property Attribute，苹果文档比较详细参考：[文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html)

Demo 地址：[我是Demo](https://github.com/DavidCap/iOS-note/tree/master/demo/MJExtensionSimpleDemo)

