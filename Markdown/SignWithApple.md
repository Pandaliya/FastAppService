#  Apple登录

[参考文件](https://segmentfault.com/a/1190000022739931)

一些细节：

1. 苹果只有一个AppleID，在同一个开发者账号下的所有应用，这个AppleID是一致的
2. 苹果的Oauth2 Code验证接口不返回用户信息，需要客户端上报给服务端
3. 苹果提供的OAuth2 Code的验证接口返回的是一个JWT Token，用户ID隐藏在JWT Token中，需要二次解析

### 时序图

```
APP客户端 ->> Apple : 1.请求auth code
Apple ->> APP客户端 : 2.返回auth code
APP客户端 ->> + APP服务端 : 3发送auth code
APP服务端 ->> Apple : 4.请求验证auth code
Apple -->> Apple : 5.验证auth code
Apple -->> APP服务端 : 6.返回用户AppleID
APP服务端 -->> - APP客户端 : 7.返回uid和sid给客户端
```

注意：
1. 慎用 ASAuthorizationPasswordRequest，当启用 ASAuthorizationPasswordRequest 且
 停止使用 Apple ID（真机-设置-账户-密码与安全性-使用您 Apple ID 的 App-App列表-停止使用 Apple ID）
 ,如果 KeyChain 里面没有登录信息且重新使用 苹果授权登录（Sign in with Apple） 会报未知错误
 
2. 使用苹果授权登录后，不能强制要求用户再使用手机号注册，否则会被拒。




