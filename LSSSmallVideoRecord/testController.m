//
//  testController.m
//  LSSSmallVideoRecord
//
//  Created by lss on 2017/9/4.
//  Copyright © 2017年 insight. All rights reserved.
//

#import "testController.h"
#import "LSSVideoView.h"
#import "LSSPlayController.h"
#import "AppDelegate.h"
@interface testController ()<LSSVideoViewDelegate,LSSPlayDelegate>
@property (nonatomic, strong)LSSVideoView *videoView;
@end

@implementation testController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _videoView  =[[LSSVideoView alloc] initWithFMVideoViewType:TypeFullScreen WithPerPixel:FMVideoViewBiteHeight WithRecordMaxTime:30 StatusBarHeight:[UIApplication sharedApplication].statusBarFrame.size.height];
    _videoView.delegate = self;
    [self.view addSubview:_videoView];
    self.view.backgroundColor = [UIColor blackColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_videoView.fmodel.recordState == FMRecordStateFinish) {
        [_videoView.fmodel reset];
    }
}

#pragma mark - LSSVideoViewDelegate
- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl
{
    LSSPlayController *playVC = [[LSSPlayController alloc] init];
    playVC.videoUrl =  videoUrl;
    playVC.delegate = self;
    playVC.statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [self presentViewController:playVC animated:NO completion:nil];

}
#pragma mark -LSSPlayDelegate
-(void)dismissPlayVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)haveDoneWith:(NSDictionary *)dict
{
    NSInteger size =[[dict objectForKey:@"size"] integerValue];
    NSLog(@"视频总大小:%.02f kb",((float)size/1024.0));
}
@end
