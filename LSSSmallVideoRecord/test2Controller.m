//
//  test2Controller.m
//  LSSSmallVideoRecord
//
//  Created by lss on 2017/9/5.
//  Copyright © 2017年 insight. All rights reserved.
//

#import "test2Controller.h"
#import "LSSVideoView.h"
#import "LSSPlayController.h"

@interface test2Controller ()<LSSVideoViewDelegate,LSSPlayDelegate>
@property (nonatomic, strong)LSSVideoView *videoView;

@end

@implementation test2Controller

- (void)viewDidLoad {
    [super viewDidLoad];

    _videoView  =[[LSSVideoView alloc] initWithFMVideoViewType:TypeFullScreen WithPerPixel:FMVideoViewBiteLow WithRecordMaxTime:15 StatusBarHeight:44];
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
     [self presentViewController:playVC animated:true completion:nil];
}
#pragma mark -LSSPlayDelegate
-(void)dismissVCWith:(NSDictionary *)dict
{
    NSInteger size =[[dict objectForKey:@"size"] integerValue];
    NSLog(@"视频总大小:%.02f kb",((float)size/1024.0));
//    [self.navigationController  popToRootViewControllerAnimated:YES];
}
@end
