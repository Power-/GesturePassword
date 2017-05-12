//
//  WCGGesturePasswordProView.m
//  WCGGesturePassword
//
//  Created by 孟祥冬 on 2017/5/5.
//  Copyright © 2017年 organizationName. All rights reserved.
//

#import "WCGGesturePasswordProView.h"
#import "WCGGesturePasswordHeader.h"

@interface WCGGesturePasswordProView ()

@property (nonatomic, strong) NSArray *buttons;//9个button数组
@property (nonatomic, copy) NSString *confirmPassword;//第一次绘制图案
@property (assign, nonatomic) CGPoint currentPoint;//当前点

@end

@implementation WCGGesturePasswordProView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *gesPwd = [[NSUserDefaults standardUserDefaults] objectForKey:GESTUREPASSWORDKEY];
        if (gesPwd.length != 0) {
            _isSetGesturePwd = YES;
        }else{
            _isSetGesturePwd = NO;
        }
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor blueColor].CGColor;
        _selectBtnArr = [[NSMutableArray alloc]initWithCapacity:0];
        _isConfirm = NO;
        _indexTag = 0;
    }
    return self;
}

- (NSArray *)buttons{
    if (_buttons == nil) {
        //创建9个按钮
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 9; i++) {
            UIButton *btn = [[UIButton alloc]init];
            btn.tag = i;
            btn.userInteractionEnabled = NO;
            [btn setBackgroundImage:[UIImage imageNamed:@"button_normal"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"button_highlighted"] forState:UIControlStateSelected];
            
            [self addSubview:btn];
            [tempArr addObject:btn];
        }
        _buttons = tempArr;
    }
    return _buttons;
}

//布局9个按钮
- (void)layoutSubviews{
    [super layoutSubviews];
    //设置每个按钮的frame
    CGFloat btn_w = 50;
    CGFloat btn_h = 50;
    //3行 3列
    NSInteger num = 3;
    //水平方向和垂直方向的间距
    CGFloat marginX = (PROVIEWWIDTH - num * btn_w) / (num + 1);
    CGFloat marginY = (PROVIEWWIDTH-40 - num * btn_h) / (num + 1);
    //计算每个按钮的x、y
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        int row = i/num;
        int col = i%num;
        
        CGFloat x = marginX + col * (btn_w + marginX);
        CGFloat y = marginY + row * (btn_h + marginY);
        btn.frame = CGRectMake(x, y, btn_w, btn_h);
    }
}

//视图恢复原样
- (void)resetView{
    for (UIButton *oneSelectBtn in _selectBtnArr) {
        oneSelectBtn.selected = NO;
    }
    [_selectBtnArr removeAllObjects];
    [self setNeedsDisplay];
}

//错误时绘成别的颜色
- (void)drawWoringPicture{
    for (UIButton *btn in _selectBtnArr) {
        [btn setBackgroundImage:[UIImage imageNamed:@"button_error"] forState:UIControlStateSelected];
    }
    [self performSelector:@selector(wrongRevert:) withObject:[NSArray arrayWithArray:_selectBtnArr] afterDelay:.5];
    self.userInteractionEnabled = NO;
    [self setNeedsDisplay];
}

//输入错误回到原始状态
- (void)wrongRevert:(NSArray *)arr{
    self.userInteractionEnabled = YES;
    for (UIButton *btn in arr) {
        [btn setBackgroundImage:[UIImage imageNamed:@"button_highlighted"] forState:UIControlStateSelected];
    }
    [self resetView];
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *oneTouch = [touches anyObject];
    CGPoint point = [oneTouch locationInView:self];
    for (UIButton *oneBtn in self.subviews) {
        if (CGRectContainsPoint(oneBtn.frame, point)) {
            oneBtn.selected = YES;
            if (![_selectBtnArr containsObject:oneBtn]) {
                [_selectBtnArr addObject:oneBtn];
            }
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *oneTouch = [touches anyObject];
    CGPoint point     = [oneTouch locationInView:self];
    _currentPoint     = point;
    for (UIButton *oneBtn in self.subviews) {
        if (CGRectContainsPoint(oneBtn.frame, point)) {
            oneBtn.selected = YES;
            if (![_selectBtnArr containsObject:oneBtn]) {
                [_selectBtnArr addObject:oneBtn];
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_selectBtnArr.count == 0) {
        return;
    }
    UIButton *lastBtn =[_selectBtnArr lastObject];
    _currentPoint = lastBtn.center;
    if (_selectBtnArr.count < 4) {
        [self.delegate gestureLockSetResult:ALERTFOURGESOWD gestureView:self];
        [self drawWoringPicture];
        if (_isSetGesturePwd&&_isLoginVerify) {
            //登录验证时不需要判断“至少4个点”
        }else{
            return;
        }
    }
    //获得绘制路径
    _inputPassword = [[NSMutableString alloc]initWithCapacity:0];
    for (NSInteger i = 0; i < _selectBtnArr.count; i++) {
        UIButton *btn = (UIButton *)_selectBtnArr[i];
        [_inputPassword appendFormat:@"%d",(int)btn.tag];
    }
    //设置逻辑
    if (!_isSetGesturePwd) {
        if (!_isConfirm) {
            //第一次绘制
            [self.delegate gestureLockSetResult:DRAWGESPWDAGAIN gestureView:self];
            _isConfirm = YES;
            _confirmPassword = _inputPassword;
            [self resetView];
        }else{
            //第二次绘制
            if ([_confirmPassword isEqualToString:_inputPassword]) {
                [self.delegate gestureLockSetResult:SETGESPWDSUCCESS gestureView:self];
                [self resetView];
            }else{
                [self.delegate gestureLockSetResult:DIFFERENTGESPWD gestureView:self];
                [self drawWoringPicture];
            }
        }
    }else{
        if (!_isLoginVerify) {
            //修改密码逻辑
            if (!_isConfirm) {
                [self.delegate gestureLockSetResult:DRAWGESPWDAGAIN gestureView:self];
                _isConfirm = YES;
                _confirmPassword = _inputPassword;
                [self resetView];
            }else{
                if ([_confirmPassword isEqualToString:_inputPassword]) {
                    [self.delegate gestureLockSetResult:CHANGEGESSUCCESS gestureView:self];
                    [self resetView];
                }else{
                    [self.delegate gestureLockSetResult:DIFFERENTGESPWD gestureView:self];
                    [self drawWoringPicture];
                }
            }
        }else{
            //验证密码逻辑
            NSString *localPwd = [[NSUserDefaults standardUserDefaults] objectForKey:GESTUREPASSWORDKEY];
            NSLog(@"本地密码为：%@",localPwd);
            if ([localPwd isEqualToString:_inputPassword]) {
                [self.delegate gestureLockSetResult:GESVALIDATESUCCESS gestureView:self];
            }else{
                _indexTag ++;
                [self.delegate gestureLockSetResult:WORINGGESPWD gestureView:self];
                [self drawWoringPicture];
            }
        }
    }
}

//绘制连线
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path;
    if (_selectBtnArr.count == 0) {
        return;
    }
    path = [UIBezierPath bezierPath];
    path.lineWidth     = 2;
    path.lineJoinStyle = kCGLineCapRound;
    path.lineCapStyle  = kCGLineCapRound;
    if (self.userInteractionEnabled) {
        [ColorWithHex(0xFF8a50, 1) set];
    }else{
        
        [[UIColor clearColor] set];
    }
    for (int i = 0; i < _selectBtnArr.count; i ++) {
        UIButton *btn = _selectBtnArr[i];
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:_currentPoint];
    [path stroke];
}


@end
