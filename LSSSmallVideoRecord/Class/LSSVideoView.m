//
//  LSSVideoView.m
//  LSSSmallVideoRecord
//
//  Created by lss on 2017/9/4.
//  Copyright © 2017年 insight. All rights reserved.
//

#import "LSSVideoView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface LSSVideoView()<LSSVideoModelDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *timelabel;
@property (nonatomic, strong) UIButton *turnCamera;
@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, strong) FMRecordProgressView *progressView;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, assign) CGFloat recordTime;
@property (nonatomic, strong) LSSVideoModel *fmodel;
@property (nonatomic, assign) float statusBarHeight;
@end

@implementation LSSVideoView
- (instancetype)initWithFMVideoViewType:(FMVideoViewType)type WithPerPixel:(FMVideoViewBite)bitsPerPixel WithRecordMaxTime:(CGFloat)recordMaxTime StatusBarHeight:(CGFloat)statusBarHeight
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _bitsPerPixel = bitsPerPixel;
        _recordMaxTime = recordMaxTime;
        _statusBarHeight = statusBarHeight;
        [self BuildUIWithType:type];
    }
    return self;
}

-(UIColor*)colorWithRGB:(NSUInteger)hex alpha:(CGFloat)alpha
{
    float r, g, b, a;
    a = alpha;
    b = hex & 0x0000FF;
    hex = hex >> 8;
    g = hex & 0x0000FF;
    hex = hex >> 8;
    r = hex;
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

-(NSString *)getImagWithPath:(NSString *)name{
     NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"RecordSmallVideo.bundle/%@", name]];
    return imagePath;
}

#pragma mark - view
- (void)BuildUIWithType:(FMVideoViewType)type
{
    self.fmodel = [[LSSVideoModel alloc] initWithFMVideoViewType:type superView:self WithPerPixel:_bitsPerPixel WithRecordMaxTime:_recordMaxTime];
    self.fmodel.delegate = self;
    self.timeView = [[UIView alloc] init];
    self.timeView.hidden = YES;
    self.timeView.frame = CGRectMake((kScreenWidth - 100)/2, _statusBarHeight, 100, 34);
    self.timeView.backgroundColor = [self colorWithRGB:0x242424 alpha:0.7];
    self.timeView.layer.cornerRadius = 4;
    self.timeView.layer.masksToBounds = YES;
    [self addSubview:self.timeView];
    
    UIView *redPoint = [[UIView alloc] init];
    redPoint.frame = CGRectMake(0, 0, 6, 6);
    redPoint.layer.cornerRadius = 3;
    redPoint.layer.masksToBounds = YES;
    redPoint.center = CGPointMake(25, 17);
    redPoint.backgroundColor = [UIColor redColor];
    [self.timeView addSubview:redPoint];
    
    self.timelabel =[[UILabel alloc] init];
    self.timelabel.font = [UIFont systemFontOfSize:13];
    self.timelabel.textColor = [UIColor whiteColor];
    self.timelabel.frame = CGRectMake(40, 10, 40, 28);
    [self.timeView addSubview:self.timelabel];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake((kScreenWidth - 62)/2-120, kScreenHeight -32 -26-15, 75, 36);
    [self.cancelBtn setImage:[UIImage imageWithContentsOfFile:[self getImagWithPath:@"cancelVideo@2x.png"]] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    self.turnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    self.turnCamera.frame = CGRectMake(kScreenWidth - 60 - 28, _statusBarHeight, 28, 22);
    [self.turnCamera setImage:[UIImage imageWithContentsOfFile:[self getImagWithPath:@"listing_camera_lens@2x.png"]] forState:UIControlStateNormal];
    [self.turnCamera addTarget:self action:@selector(turnCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.turnCamera sizeToFit];
    [self addSubview:self.turnCamera];
    
    self.flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashBtn.frame = CGRectMake(kScreenWidth - 22 - 15, _statusBarHeight, 22, 22);
    [self.flashBtn setImage:[UIImage imageWithContentsOfFile:[self getImagWithPath:@"listing_flash_off@2x.png"]]forState:UIControlStateNormal];
    [self.flashBtn addTarget:self action:@selector(flashAction) forControlEvents:UIControlEventTouchUpInside];
    [self.flashBtn sizeToFit];
    [self addSubview:self.flashBtn];
    
    self.progressView = [[FMRecordProgressView alloc] initWithFrame:CGRectMake((kScreenWidth - 62)/2, kScreenHeight - 32 - 62, 62, 62)];
    self.progressView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.progressView];
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    self.recordBtn.frame = CGRectMake(5, 5, 52, 52);
    self.recordBtn.backgroundColor = [UIColor whiteColor];
    self.recordBtn.layer.cornerRadius = 26;
    self.recordBtn.layer.masksToBounds = YES;
    [self.progressView addSubview:self.recordBtn];
    [self.progressView resetProgress];
}

- (void)updateViewWithRecording
{
    self.timeView.hidden = NO;
    self.topView.hidden = YES;
    self.turnCamera.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.flashBtn.hidden = YES;
    [self changeToRecordStyle];
}

- (void)changeToRecordStyle
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
        rect.size = CGSizeMake(28, 28);
        self.recordBtn.frame = rect;
        self.recordBtn.layer.cornerRadius = 4;
        self.recordBtn.center = center;
    }];
}

- (void)updateViewWithStop
{
    self.timeView.hidden = YES;
    self.topView.hidden = NO;
    self.turnCamera.hidden = NO;
    self.cancelBtn.hidden = NO;
    self.flashBtn.hidden = NO;
    [self changeToStopStyle];
}

- (void)changeToStopStyle
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
        rect.size = CGSizeMake(52, 52);
        self.recordBtn.frame = rect;
        self.recordBtn.layer.cornerRadius = 26;
        self.recordBtn.center = center;
    }];
}

#pragma mark - action
- (void)dismissVC
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissVC)]) {
        [self.delegate dismissVC];
    }
}

- (void)turnCameraAction
{
    [self.fmodel turnCameraAction];
}

- (void)flashAction
{
    [self.fmodel switchflash];
}

- (void)startRecord
{
    if (self.fmodel.recordState == FMRecordStateInit) {
        [self.fmodel startRecord];
    } else if (self.fmodel.recordState == FMRecordStateRecording) {
        [self.fmodel stopRecord];
    } else {
        [self.fmodel reset];
    }
}

- (void)stopRecord
{
    [self.fmodel stopRecord];
}

- (void)reset
{
    [self.fmodel reset];
}

#pragma mark - FMFModelDelegate
- (void)updateFlashState:(FMFlashState)state
{
    if (state == FMFlashOpen) {
        [self.flashBtn setImage:[UIImage imageWithContentsOfFile:[self getImagWithPath:@"listing_flash_on@2x.png"]] forState:UIControlStateNormal];
    }
    if (state == FMFlashClose) {
        [self.flashBtn setImage:[UIImage imageWithContentsOfFile:[self getImagWithPath:@"listing_flash_off@2x.png"]] forState:UIControlStateNormal];
    }
    if (state == FMFlashAuto) {
        [self.flashBtn setImage:[UIImage imageWithContentsOfFile:[self getImagWithPath:@"listing_flash_auto@2x.png"]] forState:UIControlStateNormal];
    }
}

- (void)updateRecordState:(FMRecordState)recordState
{
    if (recordState == FMRecordStateInit) {
        [self updateViewWithStop];
        [self.progressView resetProgress];
    } else if (recordState == FMRecordStateRecording) {
        [self updateViewWithRecording];
    } else  if (recordState == FMRecordStateFinish) {
        [self updateViewWithStop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordFinishWithvideoUrl:)]) {
            [self.delegate recordFinishWithvideoUrl:self.fmodel.videoUrl];
        }
    }
}

- (void)updateRecordingProgress:(CGFloat)progress
{
    [self.progressView updateProgressWithValue:progress];
    self.timelabel.text = [self changeToVideotime:progress * _recordMaxTime];
    [self.timelabel sizeToFit];
}

- (NSString *)changeToVideotime:(CGFloat)videocurrent {
    return [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
}

@end

#pragma mark -FMRecordProgressView
@interface FMRecordProgressView ()
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic,strong ) CAShapeLayer *backLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@end

@implementation FMRecordProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)updateProgressWithValue:(CGFloat)progress
{
    _progress = progress;
    _progressLayer.opacity = 0;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self drawCycleProgress];
}

- (void)drawCycleProgress
{
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat radius = self.frame.size.width/2;
    CGFloat startA = - M_PI_2;
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;
    if (!_backLayer && self.frame.size.width > 0 && self.frame.size.height > 0) {
        _backLayer = [CAShapeLayer layer];
        _backLayer.frame = self.bounds;
        _backLayer.fillColor =  [[UIColor whiteColor] CGColor];
        _backLayer.strokeColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
        _backLayer.opacity = 1; //背景颜色的透明度
        _backLayer.lineCap = kCALineCapRound;
        _backLayer.lineWidth = 8;
        UIBezierPath *path0 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle: M_PI * 2 clockwise:YES];
        _backLayer.path =[path0 CGPath];
        [self.layer addSublayer:_backLayer];
    }
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor = [[UIColor  greenColor] CGColor];
    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineCap = kCALineCapButt;
    _progressLayer.lineWidth = 8;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    _progressLayer.path =[path CGPath];
    [self.layer addSublayer:_progressLayer];
}

-(void)resetProgress
{
    [self updateProgressWithValue:0];
}

@end
