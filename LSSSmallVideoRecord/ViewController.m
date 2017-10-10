//
//  ViewController.m
//  LSSSmallVideoRecord
//
//  Created by lss on 2017/9/4.
//  Copyright © 2017年 insight. All rights reserved.
//

#import "ViewController.h"
#import "testController.h"
#import "test2Controller.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 140, 40)];
    [btn setTitle:@"大屏幕录制视频" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(180, 100, 140, 40)];
    [btn2 setTitle:@"小屏幕录制视频" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
  
}
- (void)btnClick
{
    testController *p= [[testController alloc] init];
    [self presentViewController:p animated:YES completion:nil];
}
-(void)btnClick1
{
    test2Controller *p= [[test2Controller alloc] init];
    [self presentViewController:p animated:YES completion:nil];
}
@end
