//
//  WCGGesturePasswordViewController.m
//  WCGGesturePassword
//
//  Created by 孟祥冬 on 2017/5/5.
//  Copyright © 2017年 organizationName. All rights reserved.
//

#import "WCGGesturePasswordViewController.h"
#import "WCGGesturePasswordMiniView.h"
#import "WCGGesturePasswordProView.h"

@interface WCGGesturePasswordViewController ()<WCGGesturePasswordProViewDelegate>

@property (nonatomic,strong) UIButton *btnSkip;//跳过
@property (nonatomic,strong) UILabel *lblTitle;//提示标题
@property (nonatomic,strong) UILabel *lblTip;//提示栏
@property (nonatomic,strong) UIButton *btnReset;//重新绘制
@property (nonatomic,strong) UIButton *btnForget;//忘记密码
@property (nonatomic,strong) UILabel *lblSetPwdTip;//首次设置密码提示

@property (nonatomic,strong) WCGGesturePasswordMiniView *miniView;//小九宫格
@property (nonatomic,strong) WCGGesturePasswordProView *proView;//大九宫格

@end

@implementation WCGGesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    [self createSubviews];
    //防止从其他APP编辑界面回到这个界面弹出键盘
    [self.view endEditing:YES];
}

- (void)createSubviews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //首次设置密码提示
    _lblSetPwdTip = [self buildLabelWithFrame:CGRectMake(0, KDeviceHeight - 85, kDeviceWidth, 50) backColor:[UIColor clearColor] content:@"设置手势密码，保护您的账户资产安全\n每次进入使用手势密码即可" textColor:ColorWithHex(0x333333, 1) font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter lines:0];
    [self.view addSubview:_lblSetPwdTip];
    
    //重新设置按钮
    _btnReset = [self buildButtonWithFrame:CGRectMake((kDeviceWidth - 100)/2, KDeviceHeight - 85, 100, 40) backColor:[UIColor clearColor] title:@"重新绘制" textColor:ColorWithHex(0x1999dd, 1) font:[UIFont systemFontOfSize:16]];
    _btnReset.hidden = YES;
    [_btnReset addTarget:self action:@selector(resetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnReset];
    
    //忘记手势密码
    _btnForget = [self buildButtonWithFrame:CGRectMake((kDeviceWidth - 100)/2, KDeviceHeight - 85, 100, 40) backColor:[UIColor clearColor] title:@"忘记手势密码" textColor:ColorWithHex(0x1999dd, 1) font:[UIFont systemFontOfSize:16]];
    _btnForget.hidden = YES;
    [_btnForget addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnForget];
    
    //九宫格大图
    _proView = [[WCGGesturePasswordProView alloc]initWithFrame:CGRectMake(kDeviceWidth/2 - 160, 150 + (KDeviceHeight - 480)/2, 320, 280)];
    _proView.isLoginVerify = self.isLoginVerify;
    _proView.delegate = self;
    _proView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_proView];
    
    //顶部标题
    _lblTitle = [self buildLabelWithFrame:CGRectMake(0, 65, kDeviceWidth, 16) backColor:[UIColor clearColor] content:@"绘制解锁图案" textColor:ColorWithHex(0x666666, 1) font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter];
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lblTitle];
    
    //九宫格小图
    _miniView = [[WCGGesturePasswordMiniView alloc]initWithFrame:CGRectMake((kDeviceWidth - MINIGESTUREVIEW_W)/2,  _lblTitle.frame.origin.y + 42, MINIGESTUREVIEW_W, 60)];
    [self.view addSubview:_miniView];
    
    //提示label
    _lblTip = [self buildLabelWithFrame:CGRectMake(0, _miniView.frame.origin.y + 51, kDeviceWidth, 12) backColor:[UIColor clearColor] content:nil textColor:ColorWithHex(0xff2b01, 1) font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter];
    _lblTip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lblTip];
    
    //跳过按钮
    _btnSkip = [self buildButtonWithFrame:CGRectMake(kDeviceWidth - 16 - 60, 30, 60, 25) backColor:[UIColor clearColor] title:@"跳过" textColor:ColorWithHex(0x999999, 1) font:[UIFont systemFontOfSize:14]];
    _btnSkip.layer.cornerRadius = 12.5f;
    _btnSkip.layer.borderColor = ColorWithHex(0x999999, 1).CGColor;
    _btnSkip.layer.borderWidth = 1.0f;
    [_btnSkip addTarget:self action:@selector(setSkip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSkip];
    
    if (_proView.isSetGesturePwd) {
        if (self.isLoginVerify) {
            _miniView.hidden = YES;
            _lblTitle.text = @"验证手势密码";
            _btnForget.hidden = NO;
            _btnSkip.hidden = YES;
            _lblSetPwdTip.hidden = YES;
        }else{
            _lblTitle.hidden = NO;
            _lblTitle.text = @"绘制解锁图案";
            _lblTip.text = @"";
        }
    }
}

#pragma mark ---buttonClickAction
//返回按钮
- (void)setSkip{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.buttonSkipBlock) {
        self.buttonSkipBlock();
        self.buttonSkipBlock = nil;
    }
}
//重新设置按钮
- (void)resetPasswordAction{
    NSLog(@"reset");
    [_miniView refreshWithArrInfo:@[]];
    _proView.isConfirm = NO;
    _btnReset.hidden = YES;
    for (UIButton *btn in _proView.selectBtnArr) {
        btn.selected = NO;
    }
    [_proView.selectBtnArr removeAllObjects];
     if (_proView.isSetGesturePwd) {
         if (!self.isLoginVerify) {
             _lblSetPwdTip.hidden = NO;
             _lblTitle.hidden = NO;
             _lblTitle.text = @"绘制解锁图案";
             _lblTip.text = @"";
         }
     }else{
         _lblTitle.text = @"绘制解锁图案";
         _lblTip.text = @"";
         _lblSetPwdTip.hidden = NO;
     }
    [_proView setNeedsDisplay];
}
//忘记密码
- (void)forgetPasswordAction{
    
}

#pragma mark - WCGGesturePasswordProViewDelegate
- (void)gestureLockSetResult:(NSString *)result gestureView:(WCGGesturePasswordProView *)gestureView{
    _lblTip.text = result;
    _lblTip.textColor = ColorWithHex(0xff2b01, 1);
    if ([result isEqualToString:SETGESPWDSUCCESS]) {
        _lblTip.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setObject:_proView.inputPassword forKey:GESTUREPASSWORDKEY];
        [self dismissViewControllerAnimated:YES completion:nil];
        if (self.setPasswordSuccessBlock) {
            self.setPasswordSuccessBlock();
            self.setPasswordSuccessBlock = nil;
        }
    }else if([result isEqualToString:CHANGEGESSUCCESS]){
        _lblTip.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setObject:_proView.inputPassword forKey:GESTUREPASSWORDKEY];
        [self dismissViewControllerAnimated:YES completion:nil];
        if (self.setPasswordSuccessBlock) {
            self.setPasswordSuccessBlock();
            self.setPasswordSuccessBlock = nil;
        }
    }else if ([result isEqualToString:GESVALIDATESUCCESS]){
        _lblTip.hidden = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
        if (self.verifySuccessBlock) {
            self.verifySuccessBlock();
            self.verifySuccessBlock = nil;
        }
    }else if([result isEqualToString:DRAWGESPWDAGAIN]){
        _btnReset.hidden = NO;
        _lblSetPwdTip.hidden = YES;
        _lblTitle.text = @"请再次绘制解锁图案";
        _lblTip.text = @"";
        [_miniView refreshWithArrInfo:_proView.selectBtnArr];
    }else if ([result isEqualToString:WORINGGESPWD]){
        if (_proView.indexTag < 5) {
            _lblTip.text = [NSString stringWithFormat:@"密码错误，您还有%ld次机会",5 - _proView.indexTag];
            [self shakeView:_lblTip];
            [self.view endEditing:YES];
        }else{
            _lblTip.hidden = YES;
        }
    }else if ([result isEqualToString:DIFFERENTGESPWD] || [result isEqualToString:ALERTFOURGESOWD]){
        [self shakeView:_lblTip];
    }
}

- (void)setGesturePasswordSuccess:(SetPasswordSuccessBlock)setPasswordSuccessBlock verifySkip:(ButtonSkipBlock)buttonSkipBlock{
    if (setPasswordSuccessBlock) {
        self.setPasswordSuccessBlock = setPasswordSuccessBlock;
    }
    
    if (buttonSkipBlock) {
        self.buttonSkipBlock = buttonSkipBlock;
    }
    
}

- (void)verifyGesturePasswordSuccess:(VerifySuccessBlock)verifySuccessBlock fogetPwd:(ButtonSkipBlock) forgetPwdBlock{
    if (verifySuccessBlock) {
        self.verifySuccessBlock = verifySuccessBlock;
    }
    if (forgetPwdBlock) {
        self.buttonSkipBlock = forgetPwdBlock;
    }
}

- (UILabel *)buildLabelWithFrame:(CGRect)frame backColor:(UIColor *)color content:(NSString *)text textColor:(UIColor *)tColor {
    UILabel *newLabel        = [[UILabel alloc] initWithFrame:frame];
    newLabel.backgroundColor = color==nil?[UIColor clearColor]:color;
    newLabel.text            = text;
    newLabel.textColor       = tColor;
    
    return newLabel;
}

- (UILabel *)buildLabelWithFrame:(CGRect)frame backColor:(UIColor *)color content:(NSString *)text textColor:(UIColor *)tColor font:(UIFont *)font {
    UILabel *newLabel = [self buildLabelWithFrame:frame backColor:color content:text textColor:tColor];
    newLabel.font     = font==nil?[UIFont systemFontOfSize:15]:font;
    
    return newLabel;
}

- (UILabel *)buildLabelWithFrame:(CGRect)frame backColor:(UIColor *)color content:(NSString *)text textColor:(UIColor *)tColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment {
    UILabel *newLabel      = [self buildLabelWithFrame:frame backColor:color content:text textColor:tColor font:font];
    newLabel.textAlignment = alignment;
    
    return newLabel;
}

- (UILabel *)buildLabelWithFrame:(CGRect)frame backColor:(UIColor *)color content:(NSString *)text textColor:(UIColor *)tColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment lines:(NSInteger)line {
    UILabel *newLabel      = [self buildLabelWithFrame:frame backColor:color content:text textColor:tColor font:font textAlignment:alignment];
    newLabel.numberOfLines = line;
    
    return newLabel;
}

- (UIButton *)buildButtonWithFrame:(CGRect)frame backColor:(UIColor *)color title:(NSString *)title textColor:(UIColor *)tColor font:(UIFont *)font {
    UIButton *newButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    newButton.frame           = frame;
    newButton.backgroundColor = color==nil?[UIColor clearColor]:color;
    newButton.titleLabel.font = font==nil?[UIFont systemFontOfSize:15]:font;
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton setTitleColor:tColor==nil?ColorWithHex(0x222222, 1):tColor forState:UIControlStateNormal];
    
    return newButton;
}

//摇晃view
-(void)shakeView:(UIView *)view {
    CALayer *layer = [view layer];
    CGPoint point  = [layer position];
    CGPoint y      = CGPointMake(point.x - 5, point.y);
    CGPoint x      = CGPointMake(point.x + 5, point.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [layer addAnimation:animation forKey:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
