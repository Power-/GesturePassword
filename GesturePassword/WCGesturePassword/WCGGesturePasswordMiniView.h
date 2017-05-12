//
//  WCGGesturePasswordMiniView.h
//  WCGGesturePassword
//
//  Created by 孟祥冬 on 2017/5/5.
//  Copyright © 2017年 organizationName. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCGGesturePasswordMiniView : UIView{
    NSInteger tag;
}
@property (nonatomic, strong) NSMutableArray * dots;

-(void)refreshWithArrInfo:(NSArray *)arrInfo;
@end
