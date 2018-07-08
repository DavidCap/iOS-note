# OC消息转发

## 方法查找
如调用```[view aaa]```

1. 将方法转发为```msg_send(self,selector(aaa))```
2. 通过```view```的```isa```指针找到```view```的元类，然后再去```cache和method_list```中寻找该selector对应的实现IMP。（IMP相当于是方法指针，指向方法实现的内存地址）。
3. 如果找不到，通过```super_class```指针找到父类，然后通过```isa```指针找到元类，过程如上。
4. 都没有找到，就会调用消息转发。

### 消息转发
1. 动态方法解析(动态添加方法)```resolveInstanceMethod```
2. 备用接收者```forwardingTargetForSelector```
3. 消息转发```forwardInvocation```