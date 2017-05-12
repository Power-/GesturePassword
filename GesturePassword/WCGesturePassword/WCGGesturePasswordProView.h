//
//  WCGGesturePasswordProView.h
//  WCGGesturePassword
//
//  Created by 孟祥冬 on 2017/5/5.
//  Copyright © 2017年 organizationName. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCGGesturePasswordProView;
@protocol WCGGesturePasswordProViewDelegate <NSObject>

@optional
- (void)gestureLockSetResult:(NSString *)result gestureView:(WCGGesturePasswordProView *)gestureView;

@end

@interface WCGGesturePasswordProView : UIView

@property (nonatomic,strong ) NSMutableArray *selectBtnArr;//选中的btn数组
@property (nonatomic,strong ) NSMutableString *inputPassword;//绘制路径
@property (nonatomic,assign ) NSInteger indexTag;//验证次数

@property (nonatomic, assign) BOOL isSetGesturePwd;//有没有设置密码
@property (nonatomic,assign ) BOOL isConfirm;//第二次绘制为YES
@property (nonatomic,assign ) BOOL isLoginVerify;//是否密码验证进行登录

@property (nonatomic, assign) id<WCGGesturePasswordProViewDelegate> delegate;

@end
