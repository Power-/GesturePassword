# GesturePassword
仿支付宝的轻便手势密码界面，手势解锁，九宫格手势密码<br>
样式自定义，可按需求添加自己的功能
## 如何使用
* 用图片直接替换按钮样式，方便快捷<br>
## 使用说明
* 设置手势密码成功与跳过的回调
```
- (void)setGesturePasswordSuccess:(SetPasswordSuccessBlock)setPasswordSuccessBlock verifySkip:(ButtonSkipBlock)buttonSkipBlock;<br>
```
* 验证手势密码成功与忘记密码的回调
```Objective-C 
- (void)verifyGesturePasswordSuccess:(VerifySuccessBlock)verifySuccessBlock fogetPwd:(ButtonSkipBlock)forgetPwdBlock;
```
大家可以根据自己的需求进行添加
