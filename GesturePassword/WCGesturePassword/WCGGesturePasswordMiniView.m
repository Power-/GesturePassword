//
//  WCGGesturePasswordMiniView.m
//  WCGGesturePassword
//
//  Created by 孟祥冬 on 2017/5/5.
//  Copyright © 2017年 organizationName. All rights reserved.
//

#import "WCGGesturePasswordMiniView.h"
#import "WCGGesturePasswordHeader.h"

@implementation WCGGesturePasswordMiniView

- (id)initWithFrame:(CGRect)frame{
    //点的宽度
    CGFloat dot_w = 8;
    
    self = [super initWithFrame:frame];
    if (self) {
        _dots = [NSMutableArray arrayWithCapacity:9];
        for (NSInteger i = 0; i < 3; i ++) {
            for (NSInteger j = 0; j < 3; j ++) {
                UIImageView *dotImageView = [[UIImageView alloc]init];
                //设置点的tag值，为了和手势匹配
                if (j == 0) {
                    dotImageView.tag = i + j;
                }else if (j == 1){
                    dotImageView.tag = i + j + 2;
                }else if (j == 2){
                    dotImageView.tag = i + j + 4;
                }
                
                dotImageView.backgroundColor = [UIColor clearColor];
                dotImageView.layer.borderColor = ColorWithHex(0xaaaaaa, 1.0).CGColor;
                dotImageView.layer.cornerRadius = dot_w/2;
                dotImageView.layer.masksToBounds = YES;
                dotImageView.layer.borderWidth = 0.5;
                
                dotImageView.frame = CGRectMake(0, 0, dot_w, dot_w);
                dotImageView.center = CGPointMake((i * (dot_w + 5) + 4), (j * (dot_w + 4) + 4));
                
                [self addSubview:dotImageView];
                [self.dots addObject:dotImageView];
            }
        }
    }
    return self;
}

-(void)refreshWithArrInfo:(NSArray *)arrInfo{
    if (arrInfo.count <= 0) {
        for (UIImageView *imgV in _dots) {
            imgV.backgroundColor = [UIColor clearColor];
        }
        return;
    }else{
        for (UIImageView *imgV in _dots) {
            for (UIButton *btn in arrInfo) {
                if (imgV.tag == btn.tag) {
                    imgV.backgroundColor = ColorWithHex(0xFF8a50, 1);
                }
            }
        }
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
