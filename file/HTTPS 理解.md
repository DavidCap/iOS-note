# HTTPS 理解

## HTTPS和HTTP
因为HTTP使用明文传输，这就催生了HTTPS。HTTPS与HTTP的区别在于，HTTPS会在发起TCP握手之前进行一次SSL/TSL握手。TSL的目的在于协商加密方式，交换密钥。

![](https://raw.githubusercontent.com/DavidCap/iOS-note/master/resource/HTTP%E5%8C%BA%E5%88%ABHTTPS.png)

## TSL过程详解
![](https://raw.githubusercontent.com/DavidCap/iOS-note/master/resource/TSL%E8%BF%87%E7%A8%8B.jpg)

1. 客户端 发起HTTPS请求，报文中告诉服务端 我这边支持的SSL/TSL的版本 及加密方式。
2. 服务端 从上面的报文中选用一个加密方式及TSL版本，并与客户端协商
3. 服务端 返回CA证书，证书内包括一把对称加密的公钥，服务端自己持有私钥、
4. 服务端 Service Hello Done
5. 客户端 验证CA证书合法性，生产一把对称加密的密码，使用服务端的公钥加密自己的密钥。发送给服务端
6. 服务端 拿到客户端的密钥，使用自己的私钥解密。并用客户端密钥进行加密发送给客户端验证。
7. 服务端 Finish

> 总结
>> 服务端使用对称加密，在传输过程中只有自己能够解密。这样就能安全的拿到客户端的密钥。<br>
>> 客户端使用非对称加密，生成一把钥匙即可。<br>
>> 始终保证自己端发送加密数据使用对面的公钥，解密使用自己的私钥。
>> TSL可以总结分为2个步骤。<br>
>> 1. 交换密钥
>> 2. 测试连接

## TSL握手之后
在TSL握手之后，客户端和服务端分别得到了什么呢？<br>
S --> Service , C --> Client<br>
客户端：S的公钥，C的临时密钥<br>
服务端：C的临时密钥，S的公钥，S的私钥<br>

那么在TSL握手之后的请求其实与HTTP无异。**只是**<br>
客户端：将报文使用 S的公钥加密发送<br>
服务端：将报文使用 C的密钥加密发送<br>



