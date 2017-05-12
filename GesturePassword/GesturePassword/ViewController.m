//
//  ViewController.m
//  WCGGesturePassword
//
//  Created by 孟祥冬 on 2017/5/12.
//  Copyright © 2017年 organizationName. All rights reserved.
//

#import "ViewController.h"
#import "WCGGesturePasswordViewController.h"

@interface ViewController (){
    NSString *gesPwd;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, kDeviceWidth - 20, 40)];
    [button setTitle:@"设置手势密码" forState:UIControlStateNormal];
    [button setTag:10];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 200, kDeviceWidth - 20, 40)];
    [button1 setTitle:@"验证手势密码" forState:UIControlStateNormal];
    [button1 setTag:10];
    [button1 setBackgroundColor:[UIColor orangeColor]];
    [button1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, kDeviceWidth - 20, 40)];
    [button2 setTitle:@"修改手势密码" forState:UIControlStateNormal];
    [button2 setTag:10];
    [button2 setBackgroundColor:[UIColor greenColor]];
    [button2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(10, 400, kDeviceWidth - 20, 40)];
    [button3 setTitle:@"关闭手势密码" forState:UIControlStateNormal];
    [button3 setTag:10];
    [button3 setBackgroundColor:[UIColor blueColor]];
    [button3 addTarget:self action:@selector(click3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    gesPwd = [[NSUserDefaults standardUserDefaults] objectForKey:GESTUREPASSWORDKEY];
    
}

- (void)click{
    if (gesPwd.length != 0) {
        NSLog(@"已设置手势密码");
        return;
    }
    WCGGesturePasswordViewController *lockView = [[WCGGesturePasswordViewController alloc] init];
    [self presentViewController:lockView animated:YES completion:nil];
}

- (void)click1{
    if (gesPwd.length == 0) {
        NSLog(@"请先设置手势密码");
        return;
    }
    WCGGesturePasswordViewController *lockView = [[WCGGesturePasswordViewController alloc] init];
        lockView.isLoginVerify = YES;
    [self presentViewController:lockView animated:YES completion:nil];
}

- (void)click2{
    if (gesPwd.length == 0) {
        NSLog(@"请先设置手势密码");
        return;
    }
    WCGGesturePasswordViewController *lockView = [[WCGGesturePasswordViewController alloc] init];
        lockView.isLoginVerify = NO;
    [self presentViewController:lockView animated:YES completion:nil];
}

- (void)click3{
    gesPwd = @"";
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:GESTUREPASSWORDKEY];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
