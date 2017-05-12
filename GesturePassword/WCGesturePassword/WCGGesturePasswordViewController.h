//
//  WCGGesturePasswordViewController.h
//  WCGGesturePassword
//
//  Created by 孟祥冬 on 2017/5/5.
//  Copyright © 2017年 organizationName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCGGesturePasswordHeader.h"

typedef void(^ButtonSkipBlock)();//跳过/忘记密码
typedef void(^VerifySuccessBlock)();//验证密码成功
typedef void(^SetPasswordSuccessBlock)();//设置登录密码成功

@interface WCGGesturePasswordViewController : UIViewController
@property(nonatomic,assign)BOOL isLoginVerify;//是否密码验证进行登录

@property (nonatomic, copy) ButtonSkipBlock buttonSkipBlock;
@property (nonatomic, copy) VerifySuccessBlock verifySuccessBlock;
@property (nonatomic, copy) SetPasswordSuccessBlock setPasswordSuccessBlock;

//设置手势密码成功与跳过的回调
- (void)setGesturePasswordSuccess:(SetPasswordSuccessBlock)setPasswordSuccessBlock verifySkip:(ButtonSkipBlock)buttonSkipBlock;

//验证手势密码成功与忘记密码的回调
- (void)verifyGesturePasswordSuccess:(VerifySuccessBlock)verifySuccessBlock fogetPwd:(ButtonSkipBlock)forgetPwdBlock;



@end
