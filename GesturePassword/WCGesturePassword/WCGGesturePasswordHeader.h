//
//  WCGGesturePasswordHeader.h
//  WCGGesturePassword
//
//  Created by 孟祥冬 on 2017/5/5.
//  Copyright © 2017年 organizationName. All rights reserved.
//

#ifndef WCGGesturePasswordHeader_h
#define WCGGesturePasswordHeader_h

// rgb颜色转换（16进制->10进制）
#define ColorWithHex(hex,alph)  [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:(alph)]

#define kDeviceWidth           [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight          [UIScreen mainScreen].bounds.size.height
#define PROVIEWWIDTH 320
#define MINIGESTUREVIEW_W 34

#define GESTUREPASSWORDKEY @"gesturepasswordkey"

#define WORINGGESPWD       @"密码错误"//
#define DIFFERENTGESPWD    @"两次绘制的手势不一致，请重新绘制"//两次密码不一致
#define DRAWGESPWDAGAIN    @"请再次绘制解锁图案"//再次设置
#define SETGESPWDSUCCESS   @"设置成功"//
#define CHANGEGESSUCCESS   @"修改成功"
#define ALERTFOURGESOWD  @"至少连接4个点"
#define GESVALIDATESUCCESS @"验证成功"


#endif /* WCGGesturePasswordHeader_h */
